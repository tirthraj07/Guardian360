from app.repository.current_location_repository import CurrentLocationRepository

class CurrentLocationService:
    @staticmethod
    def get_location_details_by_userid(userID):
        return CurrentLocationRepository.get_location_details_by_userid(userID=userID)

    @staticmethod
    def get_user_ids_by_police_region_id(police_region_id):
        return CurrentLocationRepository.get_user_ids_by_police_region_id(police_region_id)

    @staticmethod
    def get_user_ids_near_user_id(user_id):
        location_details = CurrentLocationService.get_location_details_by_userid(userID=user_id)
        if not location_details:
            print(f"User ID {user_id} not found in the database.")
            return []
        
        police_region_id = location_details.get("police_region_id")
        if police_region_id is None:  # Explicitly handle null regions
            print(f"User ID {user_id} has no police_region_id assigned.")
            return []

        try:
            user_ids = CurrentLocationService.get_user_ids_by_police_region_id(police_region_id)
            return [uid for uid in user_ids if uid != user_id]  # Avoid ValueError
        except Exception as e:
            print(f"Error fetching users near User ID {user_id}: {e}")
            return []
