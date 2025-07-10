from pydantic import BaseModel
from datetime import datetime

class PDFResponse(BaseModel):
    id: str
    filename: str
    upload_date: datetime

    class Config:
        orm_mode = True
