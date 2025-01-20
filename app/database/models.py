from sqlalchemy import Integer, create_engine, Column, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime

# Setup SQLAlchemy database engine and session
DATABASE_URL = "postgresql://postgres:Amey1234@localhost/guardians"

engine = create_engine(DATABASE_URL)

Base = declarative_base()

# Model for VerificationCode
class VerificationCode(Base):
    __tablename__ = "verification_codes"
    
    email = Column(String, primary_key=True, index=True)
    code = Column(String, index=True)
    expiry = Column(DateTime)

class Users(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, autoincrement=True, index=True)
    first_name = Column(String, nullable=False)
    last_name = Column(String, nullable=False)
    phone_no = Column(String, nullable=False, unique=True)
    email = Column(String, nullable=False, unique=True, index=True)
