from fastapi import APIRouter, Form, HTTPException, Depends
from schemas.qa_schema import QARequest
from controllers.question_controller import get_quiz_by_name, handle_pdf_processing, get_quizzes, delete_quiz_by_name, extract_quiz_qa
from fastapi import FastAPI, File, UploadFile
from core.dependencies import require_teacher, require_any_role

#prefix="/api/v1", tags=["QA"]
router = APIRouter()


# @router.post("/generate-qa")
# async def generate_qa(data: QARequest):
#     questions = generate_questions(data.paragraph, data.num_questions)
#     answers = generate_answers(data.paragraph, questions, data.num_answers_per_question)
#     all_questions = generate_question_options(data.paragraph,answers)
#     return {"qa_pairs": all_questions}


@router.post("/generate-quiz")
async def generate_quiz(
    file: UploadFile = File(...),
    quiz_name: str = Form(...),
    num_response_questions: int = Form(...),
    topic: str = Form(...),
    current_user: dict = Depends(require_teacher)  # Only teachers can generate quizzes
) -> dict:
    """Generate a new quiz from PDF file (teachers only)."""
    all_questions = await handle_pdf_processing(file, quiz_name, num_response_questions, topic)
    
    # Create the quiz data in the old format for extract_quiz_qa function
    quiz_data = {
        "quiz_name": quiz_name,
        "total_questions": len(all_questions),
        "all": all_questions,
        "topic": topic
    }
    
    # Extract and return in the correct format
    return extract_quiz_qa(quiz_data)

@router.get("/get-quiz/{quiz_name}")
async def get_quiz(quiz_name: str):
    """Get a specific quiz by name. Public endpoint - no authentication required."""
    return await get_quiz_by_name(quiz_name)

@router.get("/get-quizzes/")
async def get_all_quizzes():
    """Get all available quizzes. Public endpoint - no authentication required."""
    quizzes = await get_quizzes()
    return quizzes

@router.delete("/delete-quiz/{quiz_name}")
async def delete_quiz(
    quiz_name: str,
    current_user: dict = Depends(require_teacher)  # Only teachers can delete quizzes
):
    """Delete a quiz by name (teachers only)."""
    deleted_quiz = await delete_quiz_by_name(quiz_name)
    if deleted_quiz:
        return {"message": f"{quiz_name} deleted successfully."}
    raise HTTPException(status_code=404, detail=f"{quiz_name} not found.")