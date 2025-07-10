from motor.motor_asyncio import AsyncIOMotorClient
from beanie import init_beanie
from models.user import User  # Import your document models
from models.pdf_model import PDFModel
from models.qaList_model import ParagraphsQADocument
from models.quiz_attempt import QuizAttempt
from pymongo.server_api import ServerApi 
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

MONGO_URI = "mongodb+srv://admin-user:1234@cluster0.aihll.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"
DB_NAME = "LMS"

async def initialize_db():
    # Create async motor client
    client = AsyncIOMotorClient(
        "mongodb+srv://admin-user:1234@cluster0.aihll.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0",
        tls=True,
        server_api=ServerApi('1')
    )
    
    # Initialize Beanie
    await init_beanie(
        database=client[DB_NAME],
        document_models=[User, PDFModel, ParagraphsQADocument, QuizAttempt]  # Add all your models here
    )
    
    # Test connection
    try:
        await client.admin.command('ping')
        print("Successfully connected to MongoDB Atlas with Beanie!")
    except Exception as e:
        print("Atlas connection failed:", e)
        raise
    
    return client