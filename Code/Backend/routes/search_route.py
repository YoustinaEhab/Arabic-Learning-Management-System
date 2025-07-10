from fastapi import APIRouter, Body, HTTPException
from pydantic import BaseModel
from typing import List, Dict, Any, Optional
from core.search_service import search_faiss

router = APIRouter()

# --- API Models ---
class SearchRequest(BaseModel):
    query: str
    top_k: Optional[int] = None

class SearchResult(BaseModel):
    id: str
    score: float
    paragraph: str
    metadata: Dict[str, Any]

@router.post("/faiss-search", response_model=List[SearchResult], tags=["Search"])
def search(request: SearchRequest = Body(...)):
    """
    Performs a semantic search using the local FAISS index.
    If top_k is not provided, it will return all documents.
    """
    try:
        results = search_faiss(request.query, request.top_k)
        return results
    except Exception as e:
        # Log the exception for debugging
        print(f"An error occurred during search: {e}")
        raise HTTPException(status_code=500, detail=f"An internal error occurred: {e}") 