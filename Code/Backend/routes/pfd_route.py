from fastapi import APIRouter, UploadFile, HTTPException ,File,Form
from fastapi.responses import FileResponse
from controllers.pdf_controller import save_pdf, get_pdf_by_name ,get_all_pdfs,delete_pdf_by_name
from schemas.pdf_schema import PDFResponse
from models.pdf_model import PDFModel
router = APIRouter(prefix="/pdfs")

@router.post("/", response_model=PDFResponse)
async def upload_pdf(file: UploadFile = File(...),filename:str = Form(...)): 
    if not file.filename.endswith(".pdf"):
        raise HTTPException(status_code=400, detail="Only PDF files are allowed.")
    pdf_doc = await save_pdf(file,file.filename)
    return PDFResponse(
        id=str(pdf_doc.id),
        filename=file.filename,
        upload_date=pdf_doc.upload_date,
    )

@router.get("/{pdf_name}")
async def download_pdf(pdf_name: str):
    pdf_doc = await get_pdf_by_name(pdf_name)
    if not pdf_doc:
        raise HTTPException(status_code=404, detail="PDF not found.")

    file_path = f"uploads/{pdf_name}"
    return FileResponse(path=file_path, media_type='application/pdf', filename=pdf_doc.filename)

@router.get("/", response_model=list[PDFModel])
async def fetch_all_pdfs():
    return await get_all_pdfs()

@router.delete("/{pdf_name}")
async def delete_pdf(pdf_name: str):
    deleted_count = await delete_pdf_by_name(pdf_name)
    if deleted_count:
        return {"message": f"{pdf_name} deleted successfully."}
    raise HTTPException(status_code=404, detail=f"{pdf_name} not found.")