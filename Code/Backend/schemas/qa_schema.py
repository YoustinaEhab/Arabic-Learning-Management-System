from pydantic import BaseModel
from typing import Optional

class QARequest(BaseModel):
    paragraph: str
    num_questions: Optional[int] = 3
    num_answers_per_question: Optional[int] = 1

