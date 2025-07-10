import os

os.environ["KMP_DUPLICATE_LIB_OK"] = "TRUE"

import pickle
import torch
import torch.nn.functional as F
from transformers import AutoTokenizer, AutoModel
import numpy as np
import faiss

# --- Config ---
INDEX_DIR = "faiss_index"
INDEX_PATH = os.path.join(INDEX_DIR, "index.pickle")
DATA_PATH = os.path.join(INDEX_DIR, "data.pickle")
MODEL_ID = "intfloat/multilingual-e5-large-instruct"
QUERY = "الحملة الفرنسية"
TOP_K = 3

# --- Helper functions ---
def average_pool(last_hidden_states: torch.Tensor, attention_mask: torch.Tensor) -> torch.Tensor:
    last_hidden = last_hidden_states.masked_fill(~attention_mask.unsqueeze(-1).bool(), 0.0)
    return last_hidden.sum(dim=1) / attention_mask.sum(dim=1, keepdim=True)

def embed_query(query: str, model, tokenizer, device) -> np.ndarray:
    query = "query: " + query
    inputs = tokenizer([query], return_tensors="pt", truncation=True, padding=True).to(device)
    with torch.no_grad():
        outputs = model(**inputs)
        embeddings = average_pool(outputs.last_hidden_state, inputs["attention_mask"])
        embeddings = F.normalize(embeddings, p=2, dim=1)
    return embeddings.cpu().numpy().astype(np.float32)

# --- Load model ---
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print(f"[INFO] Using device: {device}")
tokenizer = AutoTokenizer.from_pretrained(MODEL_ID)
model = AutoModel.from_pretrained(MODEL_ID).to(device)
model.eval()

# --- Load FAISS index ---
with open(INDEX_PATH, "rb") as f:
    index = pickle.load(f)

# --- Load data ---
with open(DATA_PATH, "rb") as f:
    loaded_data = pickle.load(f)
id_to_data = dict(zip(loaded_data["ids"], zip(loaded_data["data"], loaded_data["metadata"])))

# --- Embed query and search ---
query_emb = embed_query(QUERY, model, tokenizer, device)
D, I = index.search(query_emb, TOP_K)

print("\n=== Results ===")
for i, idx in enumerate(I[0]):
    str_id = str(idx)
    if str_id in id_to_data:
        paragraph, meta = id_to_data[str_id]
        print(f"\nResult #{i+1}")
        print(f"Score: {D[0][i]:.4f}")
        print(f"Paragraph: {paragraph}")
        print(f"Metadata: {meta}")
    else:
        print(f"Warning: ID {str_id} not found in metadata")
