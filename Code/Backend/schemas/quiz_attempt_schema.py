from pydantic import BaseModel, Field, ConfigDict
from typing import List, Optional
from datetime import datetime
from bson import ObjectId

class PyObjectId(ObjectId):
    @classmethod
    def __get_validators__(cls):
        yield cls.validate

    @classmethod
    def validate(cls, v):
        if not ObjectId.is_valid(v):
            raise ValueError("Invalid ObjectId")
        return ObjectId(v)

    @classmethod
    def __modify_schema__(cls, field_schema):
        field_schema.update(type="string")

class QuestionResponseSchema(BaseModel):
    question: str
    selected_answer: str
    is_correct: bool = False
    correct_answer: str

class QuizAttemptRequest(BaseModel):
    quiz_name: str
    time_taken_seconds: Optional[float] = None
    responses: List[dict]

class QuizAttemptResponse(BaseModel):
    id: str
    user_id: str
    quiz_name: str
    attempt_date: datetime
    total_questions: int
    correct_answers: int
    score_percentage: float
    time_taken_seconds: Optional[float] = None
    responses: List[dict]
    youtube_resources: Optional[dict] = None

    model_config = ConfigDict(
        json_encoders={
            datetime: lambda v: v.isoformat()
        }
    )

class QuizStatistics(BaseModel):
    total_attempts: int
    average_score: float
    highest_score: float
    lowest_score: float
    average_time: Optional[float] = None

class StudentScoreResponse(BaseModel):
    student_name: str
    total_attempts: int
    best_score: float

    model_config = ConfigDict(
        json_schema_extra={
            "example": {
                "student_name": "John Doe",
                "total_attempts": 3,
                "best_score": 95.0
            }
        }
    ) 