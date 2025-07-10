from fastapi import FastAPI
from routes.qa_route import router as qa_router
from routes.auth_route import router as auth_router
from routes.pfd_route import router as pfd_router
from routes.quiz_attempt_route import router as quiz_attempt_router
from routes.profile_route import router as profile_router
from routes.search_route import router as search_router
from config.mongo_config import initialize_db
from fastapi.middleware.cors import CORSMiddleware
from huggingface_hub import login
login(token="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")
app = FastAPI()
# Allow CORS for development
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)



@app.on_event("startup")
async def startup_db_client():
    await initialize_db()  # This initializes Beanie



app.include_router(qa_router)
app.include_router(auth_router)
app.include_router(pfd_router)
app.include_router(quiz_attempt_router)
app.include_router(profile_router, prefix="/profile", tags=["profile"])
app.include_router(search_router)
@app.get("/")
async def root():
    return {"message": "QA Generator API"}



