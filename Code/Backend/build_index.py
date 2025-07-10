import json
import torch
import torch.nn.functional as F
from transformers import AutoTokenizer, AutoModel
import numpy as np
import faiss
import pickle
import os
import time
import requests
import zipfile
import io

def average_pool(last_hidden_states: torch.Tensor, attention_mask: torch.Tensor) -> torch.Tensor:
    last_hidden = last_hidden_states.masked_fill(~attention_mask.unsqueeze(-1).bool(), 0.0)
    return last_hidden.sum(dim=1) / attention_mask.sum(dim=1, keepdim=True)

def build_index():
    """
    Clones the data repository, generates embeddings, builds a FAISS index,
    and saves the index and data to the 'faiss_index' directory.
    """
    # --- 1. Download and Load Data ---
    print("Step 1: Downloading and extracting data...")
    repo_zip_url = 'https://github.com/YoustinaEhab/Arabic-Dataset/archive/refs/heads/main.zip'
    # The zip file will extract to a directory like 'Arabic-Dataset-main'
    extracted_dir_name = 'Arabic-Dataset-main'
    json_file_path = os.path.join(extracted_dir_name, 'all_data.json')

    if not os.path.exists(json_file_path):
        print(f"Dataset not found. Downloading from {repo_zip_url}...")
        try:
            r = requests.get(repo_zip_url)
            r.raise_for_status()  # Raises an exception for bad status codes
            z = zipfile.ZipFile(io.BytesIO(r.content))
            z.extractall(".")
            print("Dataset extracted successfully.")
        except requests.exceptions.RequestException as e:
            print(f"Error downloading dataset: {e}")
            return
    else:
        print(f"Dataset already exists in '{extracted_dir_name}'. Skipping download.")


    print("Loading data from JSON file...")
    with open(json_file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    paragraphs = [entry['paragraph'] for entry in data if 'paragraph' in entry]
    metadata = [{'topic': entry['topic']} for entry in data if 'topic' in entry]
    paragraphs_id = np.array([i for i in range(len(paragraphs))])

    print(f"Loaded {len(paragraphs)} paragraphs.")

    # --- 2. Generate Embeddings ---
    print("\nStep 2: Generating text embeddings...")
    start_time = time.time()
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    model_id = 'intfloat/multilingual-e5-large-instruct'
    tokenizer = AutoTokenizer.from_pretrained(model_id)
    model = AutoModel.from_pretrained(model_id).to(device)
    model.eval()

    batch_size = 16
    encoded_paragraphs = []

    for i in range(0, len(paragraphs), batch_size):
        batch = paragraphs[i:i+batch_size]
        batch_encoding = tokenizer(batch, max_length=512, padding=True, truncation=True, return_tensors='pt').to(device)
        with torch.no_grad():
            outputs = model(**batch_encoding)
            embeddings = average_pool(outputs.last_hidden_state, batch_encoding['attention_mask'])
            embeddings = F.normalize(embeddings, p=2, dim=1)
        encoded_paragraphs.append(embeddings.cpu().numpy())
        print(f"  - Processed batch {i//batch_size + 1}/{(len(paragraphs) + batch_size - 1)//batch_size}")

    encoded_paragraphs = np.vstack(encoded_paragraphs).astype(np.float32)
    embedding_time = time.time() - start_time
    print(f"Embedding generation took: {embedding_time:.2f} seconds.")

    # --- 3. Build and Save FAISS Index ---
    print("\nStep 3: Building and saving FAISS index...")
    start_time = time.time()
    dim = encoded_paragraphs.shape[1]
    faiss_index = faiss.IndexIDMap(faiss.IndexFlatIP(dim))
    faiss_index.add_with_ids(encoded_paragraphs, paragraphs_id)

    # Create directory to save index
    save_dir = 'faiss_index'
    os.makedirs(save_dir, exist_ok=True)

    # Save index
    index_path = os.path.join(save_dir, 'index.pickle')
    with open(index_path, 'wb') as handle:
        pickle.dump(faiss_index, handle, protocol=pickle.HIGHEST_PROTOCOL)

    # Save corresponding data
    data_path = os.path.join(save_dir, 'data.pickle')
    with open(data_path, 'wb') as handle:
        pickle.dump(
            {"data": paragraphs, "ids": [str(i) for i in range(len(paragraphs))], "metadata": metadata},
            handle,
            protocol=pickle.HIGHEST_PROTOCOL
        )
    
    indexing_time = time.time() - start_time
    print(f"FAISS index built and saved to '{save_dir}'. Took {indexing_time:.2f} seconds.")
    print("\nSetup complete!")

if __name__ == "__main__":
    build_index() 