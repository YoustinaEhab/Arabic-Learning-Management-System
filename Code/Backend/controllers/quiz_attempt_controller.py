from models.quiz_attempt import QuizAttempt, QuestionResponse
from schemas.quiz_attempt_schema import QuizAttemptRequest, QuizAttemptResponse, QuizStatistics, StudentScoreResponse
from models.qaList_model import ParagraphsQADocument
from models.user import User
from typing import List, Dict, Optional
from datetime import datetime
from statistics import mean
from fastapi import HTTPException
from beanie.odm.fields import PydanticObjectId
from core.youtube_recommender import recommend_youtube_resources

async def validate_and_save_quiz_attempt(user_id: str, attempt_data: QuizAttemptRequest) -> QuizAttemptResponse:
    """Validate answers against stored quiz and save the attempt."""
    # Get the quiz
    quiz = await ParagraphsQADocument.find_one(ParagraphsQADocument.quiz_name == attempt_data.quiz_name)
    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz not found")
    
    # Create a map of questions to answers
    correct_answers = {qa.question: qa.answer for qa in quiz.paragraphs_qa_pairs}
    
    # Validate responses
    validated_responses = []
    correct_count = 0
    
    for response in attempt_data.responses:
        question = response.get("question", "").strip()
        selected_answer = response.get("selected_answer", "").strip()
        
        if not question:
            raise HTTPException(status_code=400, detail="Question field is required")
            
        correct_answer = correct_answers.get(question)
        if not correct_answer:
            raise HTTPException(status_code=400, detail=f"Question not found in quiz: {question}")
        
        is_correct = selected_answer == correct_answer
        if is_correct:
            correct_count += 1
            
        validated_responses.append({
            "question": question,
            "selected_answer": selected_answer,
            "is_correct": is_correct,
            "correct_answer": correct_answer
        })
    
    # Calculate score
    total_questions = len(validated_responses)
    score_percentage = (correct_count / total_questions) * 100 if total_questions > 0 else 0

    # --- YouTube Recommendation Logic ---
    # Use the topic from the quiz document for recommendations
    topic = getattr(quiz, 'topic', None)
    weak_areas = []
    if total_questions > 0 and (correct_count / total_questions) <= 0.7 and topic:
        weak_areas = [topic]
    youtube_resources = recommend_youtube_resources(weak_areas) if weak_areas else {}
    # --- End YouTube Recommendation Logic ---

    # Create quiz attempt
    attempt = QuizAttempt(
        user_id=user_id,
        quiz_name=attempt_data.quiz_name,
        attempt_date=datetime.utcnow(),
        total_questions=total_questions,
        correct_answers=correct_count,
        score_percentage=score_percentage,
        time_taken_seconds=attempt_data.time_taken_seconds,
        responses=validated_responses,  # Pass the dictionary directly
        youtube_resources=youtube_resources
    )
    
    # Save attempt
    await attempt.insert()
    
    # Return response
    return QuizAttemptResponse(
        id=str(attempt.id),
        user_id=user_id,
        quiz_name=attempt_data.quiz_name,
        attempt_date=attempt.attempt_date,
        total_questions=total_questions,
        correct_answers=correct_count,
        score_percentage=score_percentage,
        time_taken_seconds=attempt_data.time_taken_seconds,
        responses=validated_responses,
        youtube_resources=youtube_resources
    )

async def get_user_quiz_attempts(user_id: str, quiz_name: Optional[str] = None) -> List[QuizAttemptResponse]:
    """Get all quiz attempts for a user."""
    query = {"user_id": user_id}
    if quiz_name:
        query["quiz_name"] = quiz_name
        
    attempts = await QuizAttempt.find(query).sort(-QuizAttempt.attempt_date).to_list()
    
    return [
        QuizAttemptResponse(
            id=str(attempt.id),
            user_id=attempt.user_id,
            quiz_name=attempt.quiz_name,
            attempt_date=attempt.attempt_date,
            total_questions=attempt.total_questions,
            correct_answers=attempt.correct_answers,
            score_percentage=attempt.score_percentage,
            time_taken_seconds=attempt.time_taken_seconds,
            responses=attempt.responses,  # Use the responses directly
            youtube_resources=attempt.youtube_resources
        ) for attempt in attempts
    ]

async def get_quiz_statistics(quiz_name: str) -> QuizStatistics:
    """Get statistics for a quiz."""
    attempts = await QuizAttempt.find({"quiz_name": quiz_name}).to_list()
    
    if not attempts:
        return QuizStatistics(
            total_attempts=0,
            average_score=0.0,
            highest_score=0.0,
            lowest_score=0.0,
            average_time=0.0
        )
    
    scores = [attempt.score_percentage for attempt in attempts]
    times = [attempt.time_taken_seconds for attempt in attempts if attempt.time_taken_seconds is not None]
    
    return QuizStatistics(
        total_attempts=len(attempts),
        average_score=mean(scores),
        highest_score=max(scores),
        lowest_score=min(scores),
        average_time=mean(times) if times else 0.0
    )

async def get_student_performance_report(quiz_name: str, student_id: str) -> Dict:
    """Get performance report for a student."""
    attempts = await QuizAttempt.find({
        "quiz_name": quiz_name,
        "user_id": student_id
    }).sort(-QuizAttempt.attempt_date).to_list()
    
    if not attempts:
        return {
            "total_attempts": 0,
            "best_score": 0.0,
            "average_score": 0.0,
            "latest_score": 0.0,
            "average_time": None
        }
    
    scores = [attempt.score_percentage for attempt in attempts]
    times = [attempt.time_taken_seconds for attempt in attempts if attempt.time_taken_seconds is not None]
    
    return {
        "total_attempts": len(attempts),
        "best_score": max(scores),
        "average_score": mean(scores),
        "latest_score": scores[0],
        "average_time": mean(times) if times else None
    }

async def get_all_student_scores(quiz_name: str) -> List[StudentScoreResponse]:
    """Get scores of all students who attempted a quiz."""
    attempts = await QuizAttempt.find({"quiz_name": quiz_name}).to_list()
    
    if not attempts:
        return []
    
    # Group attempts by student
    student_attempts = {}
    for attempt in attempts:
        if attempt.user_id not in student_attempts:
            student_attempts[attempt.user_id] = []
        student_attempts[attempt.user_id].append(attempt)
    
    # Get student information and calculate scores
    student_scores = []
    for student_id, student_attempts_list in student_attempts.items():
        try:
            student = await User.find_one(User.id == PydanticObjectId(student_id))
            if not student:
                continue
                
            scores = [attempt.score_percentage for attempt in student_attempts_list]
            student_scores.append(StudentScoreResponse(
                student_name=student.name,
                total_attempts=len(scores),
                best_score=max(scores)
            ))
        except Exception:
            continue
    
    return sorted(student_scores, key=lambda x: x.best_score, reverse=True) 