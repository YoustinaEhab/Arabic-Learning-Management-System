from beanie import Document
from pydantic import BaseModel, Field
from datetime import datetime
from typing import List, Optional
from bson import ObjectId

class QuestionResponse(BaseModel):
    question: str
    selected_answer: str
    is_correct: bool = False
    correct_answer: str

class QuizAttempt(Document):
    user_id: str
    quiz_name: str
    attempt_date: datetime = datetime.utcnow()
    total_questions: int
    correct_answers: int
    score_percentage: float
    time_taken_seconds: Optional[float] = None
    responses: List[dict]
    youtube_resources: Optional[dict] = None

    class Settings:
        name = "quiz_attempts"
        indexes = [
            "user_id",
            "quiz_name",
            "attempt_date"
        ]

    class Config:
        json_encoders = {
            datetime: lambda v: v.isoformat(),
            ObjectId: str
        }
        allow_population_by_field_name = True 