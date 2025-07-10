from fastapi import APIRouter, Depends, HTTPException, Header
from schemas.quiz_attempt_schema import QuizAttemptRequest, QuizAttemptResponse, QuizStatistics, StudentScoreResponse
from models.quiz_attempt import QuestionResponse
from controllers.quiz_attempt_controller import (
    validate_and_save_quiz_attempt,
    get_user_quiz_attempts,
    get_quiz_statistics,
    get_student_performance_report,
    get_all_student_scores
)
from dependencies.auth_dependency import get_current_user, get_teacher_user
from models.user import User
from typing import List, Dict, Optional

router = APIRouter(prefix="/quiz-attempts", tags=["quiz-attempts"])

@router.post("", response_model=QuizAttemptResponse)
async def create_quiz_attempt(
    attempt_data: QuizAttemptRequest,
    current_user: dict = Depends(get_current_user)
):
    """Create a new quiz attempt."""
    return await validate_and_save_quiz_attempt(current_user["id"], attempt_data)

@router.get("/my-attempts", response_model=List[QuizAttemptResponse])
async def get_my_quiz_attempts(
    current_user: dict = Depends(get_current_user)
):
    """Get all quiz attempts for the logged-in user."""
    return await get_user_quiz_attempts(current_user["id"])

# @router.get("/user/{user_id}", response_model=List[QuizAttemptResponse])
# async def read_user_attempts(
#     user_id: str,
#     quiz_name: str = None,
#     current_user: dict = Depends(get_current_user)
# ):
#     """Get all quiz attempts for a specific user."""
#     if current_user["id"] != user_id and current_user["role"] != "teacher":
#         raise HTTPException(status_code=403, detail="Not authorized to view these attempts")
#     return await get_user_quiz_attempts(user_id, quiz_name)

@router.get("/statistics/{quiz_name}", response_model=QuizStatistics)
async def get_statistics(
    quiz_name: str,
    current_user: dict = Depends(get_teacher_user)
):
    """Get statistics for a specific quiz."""
    return await get_quiz_statistics(quiz_name)

@router.get("/student-report/{quiz_name}/{student_id}")
async def get_student_report(
    quiz_name: str,
    student_id: str,
    current_user: dict = Depends(get_teacher_user)
):
    """Get detailed performance report for a student."""
    return await get_student_performance_report(quiz_name, student_id)

@router.get("/quiz-scores/{quiz_name}", response_model=List[StudentScoreResponse])
async def get_student_scores(
    quiz_name: str,
    current_user: dict = Depends(get_teacher_user)
):
    """Get scores of all students who attempted a specific quiz."""
    return await get_all_student_scores(quiz_name) 