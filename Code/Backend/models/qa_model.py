from beanie import Document
from typing import List, Optional
from datetime import datetime

class QADocument(Document):
    question: str
    answer: str
    context: Optional[str] = None
    created_at: datetime = datetime.now()
    
    class Settings:
        name = "qa_documents" 