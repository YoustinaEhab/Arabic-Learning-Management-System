from beanie import Document
from pydantic import BaseModel
from datetime import datetime

class PDFModel(Document):
    filename: str
    upload_date: datetime
    class Settings:
        name = "pdfs" # MongoDB collection name
