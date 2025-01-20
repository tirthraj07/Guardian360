from sqlalchemy import create_engine, Column, String, DateTime
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

# Function to create tables in the database
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
