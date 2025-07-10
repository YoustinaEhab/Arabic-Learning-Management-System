from fastapi import UploadFile
from datetime import datetime
from pathlib import Path
from models.pdf_model import PDFModel

UPLOAD_DIR = Path("uploads")
UPLOAD_DIR.mkdir(parents=True, exist_ok=True)

async def save_pdf(file: UploadFile , filename:str):
    file_path = UPLOAD_DIR / file.filename
    with open(file_path, "wb") as f:
        f.write(await file.read())

    pdf_doc = PDFModel(filename=file.filename, upload_date=datetime.utcnow())
    await pdf_doc.insert()
    return pdf_doc

async def get_pdf_by_name(pdf_name: str):
    return await PDFModel.find_one(PDFModel.filename == pdf_name)

async def get_all_pdfs():
    pdfs = await PDFModel.find_all().to_list()
    return pdfs

async def delete_pdf_by_name(pdf_name: str):
    pdf = await PDFModel.find_one(PDFModel.filename == pdf_name)
    if not pdf:
        return 0
    await pdf.delete()
    return 1