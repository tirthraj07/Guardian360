from fastapi import FastAPI
from pydantic import BaseModel
import datetime

app = FastAPI()

class Message(BaseModel):
    device_id: str
    trigger: int

@app.post("/postjson")
async def receive_message(data: Message):
    print(data.trigger)  # Print received data for debugging
    print(datetime.datetime.now())
    return {
        "message": "Message received successfully",
        "received_data": data.trigger
    }





# Run with: uvicorn app.main:app --reload --port 8001 --host 0.0.0.0
