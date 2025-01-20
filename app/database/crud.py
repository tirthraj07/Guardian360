from sqlalchemy.orm import Session
from datetime import datetime
from app.database.connection import VerificationCode

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