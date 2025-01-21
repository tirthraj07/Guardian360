from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel, EmailStr
from app.services.login import router as login_router


app = FastAPI()

app.include_router(login_router)