from fastapi import FastAPI
from app.routers.friend_routers import router as friend_routers

app = FastAPI()

app.include_router(friend_routers)