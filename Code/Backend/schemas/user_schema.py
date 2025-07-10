from pydantic import BaseModel, ConfigDict, Field
from typing import Optional

class UserSignup(BaseModel):
    name: str
    email: str
    password: str = Field(min_length=6)
    role: str = "student"  # Default value
    phone: str | None = None  # Optional field
    profile_img: str | None = None  # Optional field

    model_config = ConfigDict(
        json_schema_extra={
            "example": {
                "name": "John Doe",
                "email": "john@example.com",
                "password": "password123",
                "role": "student"
            }
        }
    )

class UserLogin(BaseModel):
    email: str
    password: str

class ProfileUpdate(BaseModel):
    name: Optional[str] = None
    phone: Optional[str] = None
    profile_img: Optional[str] = None
    password: Optional[str] = Field(None, min_length=6)

    model_config = ConfigDict(
        json_schema_extra={
            "example": {
                "name": "John Doe Updated",
                "phone": "+1234567890",
                "profile_img": "https://example.com/new-profile.jpg",
                "password": "newpassword123"
            }
        }
    )