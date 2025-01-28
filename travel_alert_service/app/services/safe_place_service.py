from app.models.location_models import KnownPlaceCreate
from app.repository.travel_locations_repository import TravelLocationsRepository

class SafePlaceService:

    @staticmethod
    def create_safe_place(request: KnownPlaceCreate):
        userID = request.userID
        location = request.location
        latitude = location.latitude
        longitude = location.longitude
        place_nick_name = request.place_nick_name
        location_name = request.location_name

        response = TravelLocationsRepository.add_known_place(userID, latitude, longitude, location_name, place_nick_name)
        
        print(f"Safe place added: UserID {userID}, Name: {location_name}, Nickname: {place_nick_name}, Location: ({latitude}, {longitude})")
        
        return {"message": "Created Successfully"}

    @staticmethod
    def get_all_safe_places(userID: int):
        response = TravelLocationsRepository.get_known_places(userID)
        print(f"Fetching safe places for UserID: {userID}")
        return response
