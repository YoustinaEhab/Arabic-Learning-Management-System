# models/user.py
from beanie import Document, Indexed
from pydantic import BaseModel
from enum import Enum
from typing import Optional
from bson import ObjectId

class Role(str, Enum):
    TEACHER = "teacher"
    STUDENT = "student"

    @classmethod
    def from_str(cls, value: str):
        try:
            return cls(value.lower())
        except ValueError:
            return cls.STUDENT

class User(Document):
    name: str
    email: Indexed(str, unique=True)  # Add index for faster lookups
    password: str
    role: str  # "student" or "teacher"
    phone: Optional[str] = None
    profile_img: Optional[str] = None

    class Settings:
        name = "users"
        use_state_management = True
        
    class Config:
        json_encoders = {
            ObjectId: str
        }
        
    @classmethod
    async def by_id(cls, id: str):
        """Helper method to find user by ID, handling both string and ObjectId."""
        try:
            # Try original ID
            user = await cls.find_one(cls.id == id)
            if user:
                return user
            
            # Try with ObjectId
            user = await cls.find_one(cls.id == str(ObjectId(id)))
            return user
        except:
            return None