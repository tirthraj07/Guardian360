from pydantic import BaseModel, EmailStr

class UserRequest(BaseModel):
    email: EmailStr

class VerifyCodeRequest(BaseModel):
    email: EmailStr
    first_name: str
    last_name: str
    phone_no: str
    code: str
    aadhar_no: str
    profile_pic_location: str
    aadhar_location: str
    public_key: str
    private_key: str

