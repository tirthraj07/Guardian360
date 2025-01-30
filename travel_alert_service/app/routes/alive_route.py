from fastapi import APIRouter
from app.services.location_service import LocationService
from app.models.location_models import UserLocationData

router = APIRouter(
    tags=['alive routes'],
    prefix=''
)

@router.get("/keep-alive")
def keep_alive():
    return {"message": "I am Alive"}
