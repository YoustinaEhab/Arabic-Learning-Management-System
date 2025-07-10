# routes/profile_route.py
from fastapi import APIRouter, Header, Depends
from controllers import profile_controller
from schemas.user_schema import ProfileUpdate
from typing import Optional

router = APIRouter()

@router.get("/me")
async def get_current_user_profile(authorization: Optional[str] = Header(None)):
    """Get the current user's profile information."""
    return await profile_controller.get_current_user_profile(authorization)

@router.put("/me")
async def update_current_user_profile(profile_data: ProfileUpdate, authorization: Optional[str] = Header(None)):
    """Update the current user's profile information."""
    return await profile_controller.update_current_user_profile(profile_data, authorization) 