from fastapi import APIRouter, HTTPException, status

from app.schemas.location_schemas import FriendLocation, KnownPlaceCreate, TrackLocation
from app.database.crud import add_current_location, add_known_place, get_friends_location, get_known_places

router = APIRouter(
    tags=['safe place routes'],
    prefix='/safe-places'
)

@router.post('/create', status_code=status.HTTP_201_CREATED)
def create_safe_place(request: KnownPlaceCreate):

    userID = request.userID
    location = request.location
    latitude = location.latitude
    longitude = location.longitude
    place_nick_name = request.place_nick_name
    location_name = request.location_name

    response = add_known_place(userID, latitude, longitude, location_name, place_nick_name)

    return {"message" : "Created Successfuly"}

@router.get('/{userID}', status_code=status.HTTP_200_OK)
def get_all_safe_place(userID:int):

    response = get_known_places(userID)

    return response
