from fastapi import FastAPI
from fastapi import HTTPException
from pydantic import BaseModel
from typing import List, Optional, Dict
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM
from models.qaList_model import ParagraphsQADocument
import torch
import random
import re
from PyPDF2 import PdfReader
from fastapi import FastAPI, File, UploadFile
import io

app = FastAPI()

# === Load QG model ===
qg_model_path = "Noureen-2/arat5-question-generation-model"
qg_tokenizer = AutoTokenizer.from_pretrained("Noureen-2/arat5-question-generation-model")
qg_model = AutoModelForSeq2SeqLM.from_pretrained("Noureen-2/arat5-question-generation-model")


# === Load QA model ===
qa_model_path = "Nouran30/qa_model"
qa_tokenizer = AutoTokenizer.from_pretrained("Nouran30/qa_model")
qa_model = AutoModelForSeq2SeqLM.from_pretrained("Nouran30/qa_model")


# === Load distractor model ===
options_model_path = "Nouran30/distractor-model"
options_tokenizer = AutoTokenizer.from_pretrained("Nouran30/distractor-model")
options_model = AutoModelForSeq2SeqLM.from_pretrained("Nouran30/distractor-model")


# === Helper: Generate Questions ===
def generate_questions(paragraph: str, num_questions: int = 3) -> List[str]:
    input_text = f"<context> {paragraph}"
    inputs = qg_tokenizer(
        input_text,
        return_tensors="pt",
        max_length=768,
        truncation=True,
        padding="max_length"
    ).to(qg_model.device)

    outputs = qg_model.generate(
        **inputs,
        max_new_tokens=64,
        do_sample=True,
        temperature=0.9,
        top_k=50,
        top_p=0.95,
        num_return_sequences=num_questions
    )

    return [
        qg_tokenizer.decode(output, skip_special_tokens=True).replace("<question>", "").strip()
        for output in outputs
    ]

# === Helper: Generate Answers ===
def generate_answers(context: str, questions: List[str]) -> Dict[str, str]:
    results = {}
    for question in questions:
        input_text = f"<context> {context} <question> {question}"
        inputs = qa_tokenizer(
            input_text,
            return_tensors="pt",
            max_length=768,
            truncation=True,
            padding="max_length"
        ).to(qa_model.device)

        outputs = qa_model.generate(
            **inputs,
            max_new_tokens=100,
            do_sample=True,
            temperature=0.9,
            top_k=50,
            top_p=0.95,
            num_return_sequences=1  # Force one answer regardless of param
        )

        answer = qa_tokenizer.decode(outputs[0], skip_special_tokens=True).replace("<answer>", "").strip()
        results[question] = answer

    return results


# === Helper: Generate Options ===
def generate_question_options(context: str, qa_pairs: Dict[str, str]) -> List[Dict[str, str]]:
    """
    Generates one distractor per question, then returns list of questions
    with their correct answer and options (correct + distractor).
    
    Args:
        context (str): The context paragraph
        qa_pairs (Dict[str, str]): Dict of {question: correct_answer}
    
    Returns:
        List[Dict]: List of dicts with 'question', 'answer', and 'options'
    """
    results = []

    for question, correct_answer in qa_pairs.items():
        input_text = f"<context> {context} <question> {question} <answer> {correct_answer}"

        inputs = options_tokenizer(
            input_text,
            return_tensors="pt",
            max_length=576,
            truncation=True,
            padding="max_length"
        ).to(options_model.device)

        outputs = options_model.generate(
            **inputs,
            max_new_tokens=576,
            do_sample=True,
            temperature=0.9,
            top_k=50,
            top_p=0.95,
            num_return_sequences=1
        )

       # Decode and clean the distractor string
        distractor_text = options_tokenizer.decode(outputs[0], skip_special_tokens=True).replace("<answer>", "").strip()

        # Split the distractor text based on < and > or periods
        distractors = re.split(r"[<>.]+", distractor_text)

        # Clean each distractor by stripping unnecessary spaces
        distractors = [d.strip() for d in distractors if d.strip()]

        # Remove any 'distractorX' tags or other undesired parts
        distractors = [d for d in distractors if not re.match(r"distractor\d*", d)]

        # Combine correct answer and distractors
        options = [correct_answer] + distractors
        random.shuffle(options)
        
        results.append({
            "question": question,
            "answer": correct_answer,
            "options": options
        })

    return results

# === Helper: Generate Quiz ===
async def handle_pdf_processing(file: UploadFile, quiz_name: str, total_questions_needed: int, topic: str = None) -> dict:
    try:
        contents = await file.read()
        reader = PdfReader(io.BytesIO(contents))

        raw_text = ""
        for page in reader.pages:
            page_text = page.extract_text()
            if page_text:
                raw_text += page_text + " "

        # Split into paragraphs (chunks of words)
        words = raw_text.split()
        chunk_size = 200
        paragraphs = [" ".join(words[i:i+chunk_size]).strip() for i in range(0, len(words), chunk_size) if words[i:i+chunk_size]]
        
        all_paragraph_qas = []
        num_questions_for_paragraph = 3  # fixed per paragraph
        total_generated = 0

        for paragraph in paragraphs:
            if total_generated >= total_questions_needed:
                break

            # Generate questions (up to the remaining number needed)
            remaining_questions = total_questions_needed - total_generated
            questions_to_generate = min(num_questions_for_paragraph, remaining_questions)

            questions = generate_questions(paragraph, questions_to_generate)
            answers = generate_answers(paragraph, questions)
            question_options = generate_question_options(paragraph, answers)

            all_paragraph_qas.extend(question_options)
            total_generated += len(question_options)

        # Save to DB
        qa_doc = ParagraphsQADocument(
            quiz_name=quiz_name,
            paragraphs_qa_pairs=all_paragraph_qas,
            topic=topic
        )
        await qa_doc.insert()

        formatted_questions = [format_mcq(q) for q in all_paragraph_qas]

        return formatted_questions 

    except Exception as e:
        return {"error": str(e)}

def format_mcq(question_dict):
    correct_answer = question_dict["answer"]
    return {
        "question": question_dict["question"],
        "options": [
            {
                "text": option,
                "is_correct": option == correct_answer
            }
            for option in question_dict["options"]
        ]
    }


# === Helper: Get Specific Quiz ===
async def get_quiz_by_name(quiz_name: str):
    quiz = await ParagraphsQADocument.find_one(ParagraphsQADocument.quiz_name == quiz_name)
    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz not found")
    return quiz

# === Helper: Get all Quizzes ===
async def get_quizzes():
    quizzes = await ParagraphsQADocument.find_all().to_list()
    return quizzes

# === Helper: Delete specific quiz ===
async def delete_quiz_by_name(quiz_name: str):
    quiz = await ParagraphsQADocument.find_one(ParagraphsQADocument.quiz_name == quiz_name)
    if not quiz:
        return 0
    await quiz.delete()
    return 1

# === Helper: Extract Quiz Questions and Answers ===
def extract_quiz_qa(quiz_json: dict) -> dict:
    """
    Extracts questions, options, and correct answers from quiz data.
    
    Args:
        quiz_json (dict): Quiz data in the format provided by the user
    
    Returns:
        dict: Dictionary with quiz_name, total_questions, and questions array
    """
    try:
        quiz_name = quiz_json.get("quiz_name", "")
        total_questions = quiz_json.get("total_questions", 0)
        all_questions = quiz_json.get("all", [])
        topic = quiz_json.get("topic", "")
        
        questions = []
        for question_data in all_questions:
            question_text = question_data.get("question", "")
            options_data = question_data.get("options", [])
            
            # Find the correct answer
            correct_answer = None
            for option in options_data:
                if option.get("is_correct", False):
                    correct_answer = option.get("text", "")
                    break
            
            questions.append({
                "question": question_text,
                "options": [opt.get("text", "") for opt in options_data],
                "correct_answer": correct_answer
            })
        
        return {
            "quiz_name": quiz_name,
            "total_questions": total_questions,
            "questions": questions,
            "topic": topic
        }
        
    except Exception as e:
        return {}