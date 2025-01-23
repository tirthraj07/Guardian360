from fastapi import FastAPI

from app.routers.friend_routers import router as friend_routers
from app.routers.location_router import router as loc_routers

app = FastAPI()

app.include_router(friend_routers)
app.include_router(loc_routers)

