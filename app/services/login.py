from datetime import datetime, timedelta
import random
from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from app.schemas.login_schemas import EmailRequest, VerifyCodeRequest
from app.services.email_service import send_email
from app.database import connection, crud
from jose import jwt

router = APIRouter(
    tags=['Auth']
)

JWT_SECRET = "ktk2_DRrkXXdXTW7swdmwNK6oc7KT2H7d0VgSzsLoas"
JWT_ALGORITHM = "HS256"
VERIFICATION_CODE_EXPIRY_MINUTES = 10

# Dependency to get the DB session
def get_db():
    db = connection.SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/send-code")
async def send_verification_code(request: EmailRequest, db: Session = Depends(get_db)):
    email = request.email
    code = str(random.randint(100000, 999999))
    expiry = datetime.utcnow() + timedelta(minutes=VERIFICATION_CODE_EXPIRY_MINUTES)

    # Store the verification code in the database
    crud.create_verification_code(db, email=email, code=code, expiry=expiry)

    email_subject = "Guardians Email Verification"
    email_body = f"""
<html>
  <head>
    <style>
      body {{
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
        margin: 0;
        padding: 0;
        text-align: center;
      }}
      .container {{
        max-width: 500px;
        background: white;
        padding: 20px;
        margin: 20px auto;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      }}
      .header {{
        background-color: #23234F;
        color: white;
        padding: 15px;
        font-size: 20px;
        font-weight: bold;
        border-radius: 8px 8px 0 0;
      }}
      .otp-container {{
        display: flex;
        justify-content: center;
        gap: 15px; /* Increased space between boxes */
        margin: 20px 0;
      }}
      .otp-box {{
        width: 50px;
        height: 50px;
        font-size: 24px;
        font-weight: bold;
        text-align: center;
        border: 2px solid #FFA722;
        border-radius: 5px;
        line-height: 50px;
        color: #23234F;
      }}
      .button {{
        background-color: #FFA722;
        color: white;
        text-decoration: none;
        padding: 12px 25px;
        border-radius: 5px;
        display: inline-block;
        font-weight: bold;
        margin-top: 20px;
        font-size: 16px;
      }}
      .footer {{
        margin-top: 20px;
        font-size: 14px;
        color: #777;
      }}
    </style>
  </head>
  <body>
    <div class="container">
      <div class="header">Guardians Email Verification</div>
      <p>Hello,</p>
      <p>Thank you for registering with <strong>Guardians</strong>, the app dedicated to ensuring women's safety.</p>
      <p>Your verification code is:</p>
      <div class="otp-container">
        {"".join(f'<div class="otp-box">{digit}</div>' for digit in str(code))}
      </div>
      <p>Please enter this code in the app to complete your registration process. The code will expire in <strong>{VERIFICATION_CODE_EXPIRY_MINUTES} minutes</strong>.</p>
      <p>If you did not request this, please ignore this email.</p>
      <a href="#" class="button">Verify Email</a>
      <p class="footer">Stay safe,<br><strong>Guardians Team</strong></p>
    </div>
  </body>
</html>
"""



    await send_email(email_subject, email, email_body)

    
    return {"message": "Verification code sent to your email."}

@router.post("/verify-code")
def verify_code(request: VerifyCodeRequest, db: Session = Depends(get_db)):
    email = request.email
    code = request.code
    
    # Retrieve the stored verification code from the database
    stored_code = crud.get_verification_code(db, email=email)
    if not stored_code:
        raise HTTPException(status_code=400, detail="Verification code not requested.")
    
    # Check if the code is expired
    if stored_code.expiry < datetime.utcnow():
        crud.delete_verification_code(db, email=email)
        raise HTTPException(status_code=400, detail="Verification code expired.")
    
    # Validate the code
    if stored_code.code != code:
        raise HTTPException(status_code=400, detail="Invalid verification code.")
    
    # Generate JWT token
    token = jwt.encode(
        {"sub": email, "exp": datetime.utcnow() + timedelta(hours=1)},
        JWT_SECRET,
        algorithm=JWT_ALGORITHM
    )
    
    # Clean up the used verification code
    crud.delete_verification_code(db, email=email)
    
    return {"access_token": token, "token_type": "bearer"}
