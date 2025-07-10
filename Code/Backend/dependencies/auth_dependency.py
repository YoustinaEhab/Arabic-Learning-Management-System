from fastapi import HTTPException, Header, Depends
from typing import Optional
from models.user import User
from core.security import decode_token
from bson import ObjectId
import logging

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

async def get_current_user(authorization: str = Header(...)) -> dict:
    """Get current user from token."""
    try:
        # Decode JWT token
        payload = decode_token(authorization)
        
        # Get user ID from token
        user_id = payload.get("sub")
        if not user_id:
            raise HTTPException(status_code=401, detail="Invalid token format")
            
        # Try to find user by ID
        try:
            # First try with string ID
            user = await User.find_one({"_id": ObjectId(user_id)})
        except Exception as e:
            logger.error(f"Error converting user_id to ObjectId: {e}")
            # If that fails, try direct string comparison
            user = await User.find_one(User.id == user_id)
        
        if not user:
            raise HTTPException(status_code=401, detail="User not found")
            
        return {
            "id": str(user.id),
            "name": user.name,
            "email": user.email,
            "role": user.role
        }
    except Exception as e:
        logger.error(f"Error in get_current_user: {str(e)}")
        raise HTTPException(status_code=401, detail="Invalid token")

async def get_teacher_user(current_user: dict = Depends(get_current_user)) -> dict:
    """Get current teacher user from token."""
    if current_user["role"] != "teacher":
        raise HTTPException(status_code=403, detail="Only teachers can access this endpoint")
    return current_user

async def get_student_user(current_user: dict = Depends(get_current_user)) -> dict:
    if current_user["role"] != "student":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only students can access this endpoint"
        )
    return current_user 