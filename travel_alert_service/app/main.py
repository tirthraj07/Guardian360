from fastapi import FastAPI

from app.routers.friend_routers import router as friend_routers
from app.routers.location_router import router as loc_routers
from app.routers.safe_place_router import router as safe_place_routers

app = FastAPI()

app.include_router(friend_routers)
app.include_router(loc_routers)
app.include_router(safe_place_routers)


#uvicorn app.main:app --reload --port 8000 --host 0.0.0.0