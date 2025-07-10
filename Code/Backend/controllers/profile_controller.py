# controllers/profile_controller.py
from fastapi import HTTPException, status, Header
from models.user import User
from schemas.user_schema import ProfileUpdate
from core.security import get_password_hash, decode_token
from typing import Dict, Optional
from bson import ObjectId
import logging

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

async def get_current_user_profile(authorization: Optional[str] = Header(None)) -> Dict:
    """Get the current user's profile information."""
    if not authorization:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing authorization header"
        )
    
    # Decode and validate token (token comes directly without Bearer prefix)
    payload = decode_token(authorization)
    
    try:
        # Get user ID from token
        user_id = payload.get("sub")
        if not user_id:
            logger.error("Token payload missing 'sub' field")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token format"
            )
            
        # Try to find user by ID
        try:
            # First try with string ID
            user = await User.find_one({"_id": ObjectId(user_id)})
        except Exception as e:
            logger.error(f"Error converting user_id to ObjectId: {e}")
            # If that fails, try direct string comparison
            user = await User.find_one(User.id == user_id)
        
        if not user:
            logger.error(f"No user found with ID: {user_id}")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="User not found"
            )
        
        return {
            "id": str(user.id),
            "name": user.name,
            "email": user.email,
            "role": user.role,
            "phone": user.phone,
            "profile_img": user.profile_img
        }
        
    except Exception as e:
        logger.error(f"Error in get_current_user_profile: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate user"
        )

async def update_current_user_profile(profile_data: ProfileUpdate, authorization: Optional[str] = Header(None)) -> Dict:
    """Update the current user's profile information."""
    if not authorization:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing authorization header"
        )
    
    # Decode and validate token (token comes directly without Bearer prefix)
    payload = decode_token(authorization)
    
    try:
        # Get user ID from token
        user_id = payload.get("sub")
        if not user_id:
            logger.error("Token payload missing 'sub' field")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token format"
            )
            
        # Try to find user by ID
        try:
            # First try with string ID
            user = await User.find_one({"_id": ObjectId(user_id)})
        except Exception as e:
            logger.error(f"Error converting user_id to ObjectId: {e}")
            # If that fails, try direct string comparison
            user = await User.find_one(User.id == user_id)
        
        if not user:
            logger.error(f"No user found with ID: {user_id}")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="User not found"
            )
        
        # Update only provided fields
        update_data = {}
        if profile_data.name is not None:
            update_data["name"] = profile_data.name
        if profile_data.phone is not None:
            update_data["phone"] = profile_data.phone
        if profile_data.profile_img is not None:
            update_data["profile_img"] = profile_data.profile_img
        if profile_data.password is not None:
            update_data["password"] = get_password_hash(profile_data.password)
        
        # Update the user
        if update_data:
            await user.update({"$set": update_data})
            # Refresh user data
            user = await User.find_one({"_id": user.id})
        
        return {
            "id": str(user.id),
            "name": user.name,
            "email": user.email,
            "role": user.role,
            "phone": user.phone,
            "profile_img": user.profile_img
        }
        
    except Exception as e:
        logger.error(f"Error in update_current_user_profile: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Could not update profile"
        ) 