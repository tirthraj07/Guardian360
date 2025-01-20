from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.database.models import VerificationCode, Users, Base  # Import models

# Database URL for PostgreSQL (adjust this to your settings)
DATABASE_URL = "postgresql://postgres:Amey1234@localhost/guardians"

# Setup SQLAlchemy database engine and session
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Dependency to get the database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def create_database():
    Base.metadata.create_all(bind=engine)

create_database()
