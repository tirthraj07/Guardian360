from pydantic import BaseModel, EmailStr


class UserCreate(BaseModel):
    first_name: str
    last_name: str
    phone_no: str
    email: EmailStr

class UserRequest(BaseModel):
    email: EmailStr

class VerifyCodeRequest(BaseModel):
    email: EmailStr
    first_name: str
    last_name: str
    phone_no: str
    code: str
