from fastapi import Depends, HTTPException, status, Security, Header
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from controllers.auth_controller import get_current_user
from typing import Optional, List
from models.user import Role

async def get_token_header(authorization: str = Header(None)) -> str:
    """Get token from Authorization header."""
    if not authorization:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing authentication token"
        )
    return authorization

async def get_current_user_data(user: dict = Depends(get_current_user)):
    """Get current user data from token."""
    return user

def check_role(allowed_roles: List[Role]):
    """Check if the user has one of the allowed roles."""
    async def role_checker(user: dict = Depends(get_current_user_data)):
        try:
            user_role = Role.from_str(user["role"])
            if user_role not in allowed_roles:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail=f"Operation not permitted for role: {user_role}"
                )
            return user
        except ValueError as e:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Invalid role: {str(e)}"
            )
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Permission denied"
            )
    return role_checker

# Commonly used role checks
require_teacher = check_role([Role.TEACHER])
require_student = check_role([Role.STUDENT])
require_any_role = check_role([Role.TEACHER, Role.STUDENT])
