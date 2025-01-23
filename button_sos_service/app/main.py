from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class Message(BaseModel):
    message: str

@app.post("/pushbutton")
async def receive_message(data: Message):
    print(f"Received message: {data.message}")
    return {"message": "Message received successfully"}

# uvicorn app.main:app --reload --port 8001 --host 0.0.0.0