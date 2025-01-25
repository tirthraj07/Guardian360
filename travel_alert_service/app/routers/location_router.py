from fastapi import APIRouter, HTTPException, status

from app.schemas.location_schemas import FriendLocation, KnownPlaceCreate, TrackLocation
from app.database.crud import add_current_location, add_known_place, get_friends_location

router = APIRouter(
    tags=['location routes'],
    prefix='/location'
)

@router.post('/{userID}')
def track_location(userID: int, request: TrackLocation):

    latitude = request.latitude
    longitude = request.longitude
    timestamp = request.timestamp

    print(request)

    response = add_current_location(userID, latitude, longitude, timestamp)

@router.get('/{userID}/friends')
def track_location(userID: int):


    response = get_friends_location(userID)


    return {"friends" : response}
