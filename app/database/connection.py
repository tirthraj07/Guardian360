from sqlalchemy import Integer, create_engine, Column, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from datetime import datetime

# Database URL for PostgreSQL (adjust this to your settings)
DATABASE_URL = "postgresql://postgres:Amey1234@localhost/guardians"

# Setup SQLAlchemy database engine and session
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

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

def create_database():
    Base.metadata.create_all(bind=engine)

# Dependency to get the database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Run this function once to create the tables in the database
create_database()
