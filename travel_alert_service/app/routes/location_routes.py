from fastapi import APIRouter
from app.services.location_service import LocationService
from app.models.location_models import UserLocationData

router = APIRouter(
    tags=['location routes'],
    prefix='/location'
)

@router.post('/{userID}')
def track_location(userID: int, request: UserLocationData):
    return LocationService.track_location(userID, request)

@router.get('/{userID}/friends')
def get_friends_location(userID: int):
    return {"friends": LocationService.get_friends_location(userID)}
