from app.database.supabase import supabase

class CurrentLocationRepository:
    @staticmethod
    def get_location_details_by_userid(userID):
        try:
            location_detail = supabase.table("current_location").select("*").eq("userID", userID).execute()
            return location_detail.data[0] if location_detail.data else None
        except Exception as e:
            print(f"Error while fetching location of user with userID = {userID}: {e}")
            return None
    
    @staticmethod
    def get_user_ids_by_police_region_id(police_region_id):
        if not police_region_id:  # Explicitly handle None
            return []
        try:
            result = supabase.table("current_location").select("userID").eq("police_region_id", police_region_id).execute()
            return [entry["userID"] for entry in result.data] if result.data else []
        except Exception as e:
            print(f"There was an error fetching user IDs in police region {police_region_id}: {e}")
            return []
