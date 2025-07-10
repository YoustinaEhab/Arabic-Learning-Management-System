import os
import pickle
import torch
import torch.nn.functional as F
from transformers import AutoTokenizer, AutoModel
import numpy as np
import faiss
from typing import Optional

# --- Threading & Environment Configuration ---
# This is crucial for preventing deadlocks and crashes when serving models
os.environ["KMP_DUPLICATE_LIB_OK"] = "TRUE"
torch.set_num_threads(1)

# --- Configuration & Model Loading ---
INDEX_DIR = "faiss_index"
INDEX_PATH = os.path.join(INDEX_DIR, "index.pickle")
DATA_PATH = os.path.join(INDEX_DIR, "data.pickle")
MODEL_ID = "intfloat/multilingual-e5-large-instruct"

print("--- Loading FAISS Search Service ---")

# --- Load Models and Data ---
# These are loaded into memory when the application starts
try:
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    tokenizer = AutoTokenizer.from_pretrained(MODEL_ID)
    model = AutoModel.from_pretrained(MODEL_ID).to(device)
    model.eval()

    with open(INDEX_PATH, "rb") as f:
        index = pickle.load(f)

    with open(DATA_PATH, "rb") as f:
        loaded_data = pickle.load(f)
    id_to_data = dict(zip(loaded_data["ids"], zip(loaded_data["data"], loaded_data["metadata"])))
    print("--- FAISS Service Loaded Successfully ---")
except FileNotFoundError:
    print("\n--- FATAL ERROR ---")
    print(f"Could not find index files in '{INDEX_DIR}'.")
    print("Please make sure you have run 'build_index.py' and the 'faiss_index' directory exists.")
    print("-------------------\n")
    # In a real app, you might want a more graceful way to handle this
    index = None
    id_to_data = None


# --- Helper Functions ---
def _average_pool(last_hidden_states: torch.Tensor, attention_mask: torch.Tensor) -> torch.Tensor:
    last_hidden = last_hidden_states.masked_fill(~attention_mask.unsqueeze(-1).bool(), 0.0)
    return last_hidden.sum(dim=1) / attention_mask.sum(dim=1, keepdim=True)

def _embed_query(query: str) -> np.ndarray:
    query = "query: " + query
    inputs = tokenizer([query], return_tensors="pt", truncation=True, padding=True).to(device)
    with torch.no_grad():
        outputs = model(**inputs)
        embeddings = _average_pool(outputs.last_hidden_state, inputs["attention_mask"])
        embeddings = F.normalize(embeddings, p=2, dim=1)
    return embeddings.cpu().numpy().astype(np.float32)

# --- Main Search Function ---
def search_faiss(query: str, top_k: Optional[int] = 5):
    if index is None or id_to_data is None:
        raise ConnectionError("FAISS index is not loaded. Check server logs for errors.")

    # If top_k is not provided, search for all documents in the index
    k = top_k if top_k is not None else index.ntotal

    query_emb = _embed_query(query)
    distances, indices = index.search(query_emb, k)

    results = []
    for i, idx in enumerate(indices[0]):
        str_id = str(idx)
        if str_id in id_to_data:
            paragraph, meta = id_to_data[str_id]
            results.append({
                "id": str_id,
                "score": float(distances[0][i]),
                "paragraph": paragraph,
                "metadata": meta
            })
    return results 