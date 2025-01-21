from datetime import datetime, timedelta
import random
from fastapi import APIRouter, HTTPException
from app.schemas.login_schemas import UserRequest, VerifyCodeRequest
from app.services.email_service import send_email
from app.database import crud
from jose import jwt
from app.services.token_verification import verify_jwt_token
from app.utils.email_code import email_to_send

router = APIRouter(
    prefix='/auth',
    tags=['Auth']
)

JWT_SECRET = "ktk2_DRrkXXdXTW7swdmwNK6oc7KT2H7d0VgSzsLoas"
JWT_ALGORITHM = "HS256"
VERIFICATION_CODE_EXPIRY_MINUTES = 10

# Dependency to get the DB session

@router.post("/send-code")
async def send_verification_code(request: UserRequest):
    email = request.email
    code = str(random.randint(100000, 999999))
    expiry = datetime.utcnow() + timedelta(minutes=VERIFICATION_CODE_EXPIRY_MINUTES)

    crud.delete_verification_code(email=email)

    crud.create_verification_code(email=email, code=code)

    email_subject = "Email Verification"
    email_body = email_to_send(code, VERIFICATION_CODE_EXPIRY_MINUTES)
    
    await send_email(email_subject, email, email_body)

    
    return {"message": "Verification code sent to your email."}

@router.post("/verify-code")
def verify_code(request: VerifyCodeRequest):
    email = request.email
    first_name = request.first_name
    last_name = request.last_name
    phone_no = request.phone_no
    code = request.code
    aadhar_no = request.aadhar_no
    profile_pic_location = request.profile_pic_location
    aadhar_location = request.aadhar_location
    public_key = request.public_key
    private_key = request.private_key
    
    # Retrieve the stored verification code from the database
    stored_code = crud.get_verification_code(email=email)
    if not stored_code:
        raise HTTPException(status_code=400, detail="Verification code not requested.")
    
    # Validate the code
    if stored_code['code'] != code:
        raise HTTPException(status_code=400, detail="Invalid verification code.")
    
    token = jwt.encode(
        {"email": email, "exp": datetime.utcnow() + timedelta(hours=1)},
        JWT_SECRET,
        algorithm=JWT_ALGORITHM
    )
    
    crud.delete_verification_code(email=email)
    crud.create_user(
    first_name=first_name,
    last_name=last_name,
    email=email,
    phone_no=phone_no,
    aadhar_no=aadhar_no,
    profile_pic_location=profile_pic_location,
    aadhar_location=aadhar_location,
    public_key=public_key,
    private_key=private_key,
    code=code
)

    
    return {"access_token": token, "token_type": "bearer"}