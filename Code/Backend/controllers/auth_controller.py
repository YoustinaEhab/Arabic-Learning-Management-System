# controllers/auth.py
from fastapi import HTTPException, status, Header
from models.user import User, Role
from core.security import get_password_hash, verify_password, create_access_token, decode_token
from schemas.user_schema import UserSignup, UserLogin
from typing import Dict, Optional
from bson import ObjectId
import logging

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

async def signup(user_data: UserSignup):
    # Check if user exists
    if await User.find_one({"email": user_data.email}):
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # Create new user
    user = User(
        name=user_data.name,
        email=user_data.email,
        password=get_password_hash(user_data.password),
        role=user_data.role,
        phone=user_data.phone,
        profile_img=user_data.profile_img
    )
    await user.insert()
    
    # Create access token
    token = create_access_token({"sub": str(user.id), "email": user.email, "role": user.role})
    
    return {
        "access_token": token,
        "token_type": "bearer",
        "user": {
            "id": str(user.id),
            "name": user.name,
            "email": user.email,
            "role": user.role
        }
    }

async def login(credentials: UserLogin):
    user = await User.find_one({"email": credentials.email})
    if not user or not verify_password(credentials.password, user.password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password"
        )
    
    # Create access token
    token = create_access_token({"sub": str(user.id), "email": user.email, "role": user.role})
    
    return {
        "access_token": token,
        "token_type": "bearer",
        "user": {
            "id": str(user.id),
            "name": user.name,
            "email": user.email,
            "role": user.role
        }
    }

async def get_current_user(authorization: str = Header(None)) -> Dict:
    if not authorization:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing authorization header"
        )
    
    # Decode and validate token
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
        logger.error(f"Error in get_current_user: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate user"
        )