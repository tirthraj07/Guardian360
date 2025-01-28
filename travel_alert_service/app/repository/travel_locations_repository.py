from app.database.supabase import supabase

class TravelLocationsRepository:
    @staticmethod
    def add_known_place(user_id, latitude, longitude, location_name, place_nick_name):
        response = supabase.table("travel_locations").insert({
            "userID": user_id,
            "latitude": latitude,
            "longitude": longitude,
            "location_name": location_name,
            "place_nick_name": place_nick_name
        }).execute()

        return {"valid": True, "message": "Place added"} if response.data else {"valid": False, "message": "Failed to add place"}

    @staticmethod
    def get_known_places(user_id):
        response = supabase.table("travel_locations").select("*").eq("userID", user_id).execute()
        return response.data if response.data else []
