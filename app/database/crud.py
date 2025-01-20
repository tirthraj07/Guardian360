from sqlalchemy.orm import Session
from datetime import datetime
from app.database.connection import VerificationCode, Users

# verification crud

def create_verification_code(db: Session, email: str, code: str, expiry: datetime):
    db_code = VerificationCode(email=email, code=code, expiry=expiry)
    db.add(db_code)
    db.commit()
    db.refresh(db_code)
    return db_code

def get_verification_code(db: Session, email: str):
    return db.query(VerificationCode).filter(VerificationCode.email == email).first()


def delete_verification_code(db: Session, email: str):
    db_code = db.query(VerificationCode).filter(VerificationCode.email == email).first()
    if db_code:
        db.delete(db_code)
        db.commit()
    return db_code


#user crud

def create_user(db: Session, first_name, last_name, email, phone_no):
    db_code = Users(first_name=first_name, last_name=last_name, email=email, phone_no=phone_no)
    db.add(db_code)
    db.commit()
    db.refresh(db_code)
    return db_code

def get_all_users(db: Session):
    return db.query(Users).all()

# Function to get a specific user by email
def get_user_by_email(db: Session, email: str):
    return db.query(Users).filter(Users.email == email).first()