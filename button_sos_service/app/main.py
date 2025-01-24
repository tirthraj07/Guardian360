from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class Message(BaseModel):
    device_id: str
    trigger: int

@app.post("/postjson")
async def receive_message(data: Message):
    print(f"Received message: {data.trigger}")
    return {"message": "Message received successfully"}

# uvicorn app.main:app --reload --port 8002 --host 0.0.0.0