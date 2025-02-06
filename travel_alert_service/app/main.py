from dotenv import load_dotenv
load_dotenv()
from fastapi import FastAPI

from app.routes.friend_routes import router as friend_router
from app.routes.location_routes import router as location_router
from app.routes.safe_place_routes import router as safe_place_router
from app.routes.alive_route import router as keep_alive_router
from app.routes.region_routes import router as region_router

app = FastAPI()

app.include_router(friend_router)
app.include_router(location_router)
app.include_router(safe_place_router)
app.include_router(keep_alive_router)
app.include_router(region_router)

#uvicorn app.main:app --reload --port 8000 --host 0.0.0.0