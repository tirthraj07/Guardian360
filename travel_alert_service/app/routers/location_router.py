from fastapi import APIRouter, HTTPException, status

from app.schemas.location_schemas import TrackLocation
from app.database.crud import add_current_location

router = APIRouter(
    tags=['location routes'],
    prefix='/location'
)

@router.post('/track-location')
def track_location(request: TrackLocation):

    userID = request.userID
    latitude = request.latitude
    longitude = request.longitude
    timestamp = request.timestamp

    response = add_current_location(userID, latitude, longitude, timestamp)



    return {"message" : "Location sent to friend successfully'"}
