from app.database.supabase import supabase

class TravelModeDetailsRepository:
    @staticmethod
    def add_location_details(user_id, source_lat, source_long, dest_lat, dest_long, notification_frequency, last_message_timestamp):
        response = supabase.table("travel_mode_details").upsert({
            "userID": user_id,
            "source_latitude": source_lat,
            "source_longitude": source_long,
            "destination_latitude": dest_lat,
            "destination_longitude": dest_long,
            "notification_frequency": notification_frequency,
            "isValid": True,
            "last_notification_timestamp": last_message_timestamp
        }).execute()

        return {"valid": True, "message": "Details updated"} if response.data else {"valid": False, "message": "Failed to update details"}

    @staticmethod
    def check_if_details_exists(user_id, source_latitude, source_longitude, destination_latitude, destination_longitude):
        response = supabase.table("travel_mode_details")\
                                .select("*")\
                                .eq("userID", user_id)\
                                .eq("isValid", True)\
                                .eq("source_latitude",source_latitude)\
                                .eq("source_longitude", source_longitude)\
                                .eq("destination_latitude", destination_latitude)\
                                .eq("destination_longitude",destination_longitude)\
                                .execute()
        return len(response.data) > 0

    @staticmethod
    def check_last_message_timestamp(user_id):
        response = supabase.table("travel_mode_details").select("last_notification_timestamp").eq("userID", user_id).execute()
        return response.data[0]["last_notification_timestamp"] if response.data else None
    
    @staticmethod
    def turnOffTravelMode(user_id):
        response = (supabase.table("travel_mode_details").update({"isValid" : False}).eq("userID", user_id).execute())
        print(response)
        return None

