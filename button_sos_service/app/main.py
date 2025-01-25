from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.responses import JSONResponse

app = FastAPI()

# Simulated button-user mapping (In reality, use a database or persistent storage)
button_user_map = {}

class ConfigureRequest(BaseModel):
    button_id: int
    user_id: int

class PostRequest(BaseModel):
    button_id: int  # Button ID from the microcontroller

class Message(BaseModel):
    trigger: int
    user_id: int

@app.post("/configure-button")
async def configure_button(config: ConfigureRequest):
    """
    This route configures the button with a user_id.
    It saves the user_id with the button_id sent from the mobile app.
    """
    print(f"Configuration request received with button_id: {config.button_id} and user_id: {config.user_id}")
    
    # Save the user_id for the button
    button_user_map[config.button_id] = config.user_id

    # Return confirmation response
    print(f"Assigned user_id: {config.user_id} to button_id: {config.button_id}")  # Debugging message
    return JSONResponse(content={"message": "Configuration successful", "status": "success"}, status_code=200)

@app.post("/configure")
async def get_user_for_button(post_request: PostRequest):
    """
    This route processes the request from the microcontroller to get the user_id for a button.
    It returns the user_id associated with the button_id.
    """
    print(f"Received request for button_id: {post_request.button_id}")
    
    user_id = button_user_map.get(post_request.button_id)
    
    print(f"Returning user_id: {user_id} for button_id: {post_request.button_id}")  # Debugging message
    return JSONResponse(content={"user_id": user_id}, status_code=200)

@app.post("/postjson")
async def push_button(request: Message):

    print(f"Received request from user_id: {request.user_id} that Tigger is pressed")
    
    return {"message" : "received data"}

