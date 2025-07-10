from typing import List, Optional
from beanie import Document
from pydantic import BaseModel, Field


class QAPair(BaseModel):
    question: str
    answer: str
    options: List[str]




class ParagraphsQADocument(Document):
    quiz_name: str 
    paragraphs_qa_pairs: List[QAPair]
    topic: Optional[str] = None

    class Settings:
        name = "paragraphs_qa_pairs"  # MongoDB collection name
