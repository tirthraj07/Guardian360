from fastapi import APIRouter, HTTPException
from app.services.location_service import LocationService
from app.models.location_models import TurnOffTravelMode, UserLocationData

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

@router.get('/travel-mode-off/{userID}')
def turn_off_travel_mode(userID: int):

    print("REQUEST RECIEVED")

    try:
        if userID <= 0:
            raise HTTPException(status_code=400, detail="Invalid user ID. It must be a positive integer.")

        success = LocationService.turn_off_travel_mode(userID)

        if success is None:
            raise HTTPException(status_code=404, detail="User not found.")
        elif success is False:
            raise HTTPException(status_code=409, detail="Travel mode is already off.")
        
        return {"message": "Travel mode turned off successfully."}

    except HTTPException as http_err:
        raise http_err  # Re-raise known HTTP exceptions
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An unexpected error occurred: {str(e)}")

