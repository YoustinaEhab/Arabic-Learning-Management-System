# routes/auth.py
from fastapi import APIRouter, HTTPException
from controllers import auth_controller
from schemas.user_schema import UserSignup , UserLogin
router = APIRouter()

# Signup with request body
@router.post("/signup")
async def signup(user_data: UserSignup):  # Uses Pydantic model
    return await auth_controller.signup(user_data)

# Login with request body  
@router.post("/login")
async def login(credentials: UserLogin):  # Uses Pydantic model
    return await auth_controller.login(credentials)