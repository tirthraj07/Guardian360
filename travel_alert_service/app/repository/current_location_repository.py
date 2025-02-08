from app.database.supabase import supabase

class CurrentLocationRepository:
    @staticmethod
    def update_location(user_id, latitude, longitude, timestamp, police_region_id=None):
        response = supabase.table("current_location").upsert({
            "userID": user_id,
            "latitude": latitude,
            "longitude": longitude,
            "timestamp": timestamp,
            "police_region_id": police_region_id
        }).execute()
        return {"valid": True, "message": "Location updated"} if response.data else {"valid": False, "message": "Failed to update location"}

    @staticmethod
    def get_friend_ids(user_id):
        friends = supabase.table("friend_relations").select("userID").eq("friendID", user_id).execute()
        friend_ids = [friend["userID"] for friend in friends.data]
        return friend_ids if friend_ids else []
    
    @staticmethod
    def get_location_by_user_ids(user_ids):
        if not user_ids:
            return []
        locations = supabase.table("current_location").select("userID, latitude, longitude, timestamp").in_("userID", user_ids).execute()
        return locations.data if locations.data else []

    @staticmethod
    def get_friends_location(user_id):
        # Make it modular. Too much business logic in repository layer
        friends = supabase.table("friend_relations").select("friendID").eq("userID", user_id).execute()
        friend_ids = [friend["friendID"] for friend in friends.data]

        if not friend_ids:
            return []
        
        locations = supabase.table("current_location").select("userID, latitude, longitude, timestamp").in_("userID", friend_ids).execute()
        users = supabase.table("users").select("userID, first_name, last_name, email, phone_no").in_("userID", friend_ids).execute()

        location_map = {loc.pop("userID"): loc for loc in locations.data}

        response = []
        for user in users.data:
            user_info = user.copy()
            user_info["location"] = location_map.get(user["userID"])
            response.append(user_info)

        return response
