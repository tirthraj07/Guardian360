# user_notification_preferences_repository -> user_notification_preferences table
from app.database.supabase import supabase

class UserNotificationPreferencesRepository:
    
    @staticmethod
    def get_user_notification_preferences(user_id):
        user_preferences = (
            supabase.table("user_notification_preferences")
            .select("notification_type_id, service_id, is_enabled")
            .eq("userID", user_id)
            .execute()
        )
        return user_preferences.data if user_preferences.data else []


    
    @staticmethod
    def update_user_notification_preference(user_id, notification_type_id, service_id, is_enabled):
        response = supabase.table("user_notification_preferences").upsert({
            "userID": user_id,
            "notification_type_id": notification_type_id,
            "service_id": service_id,
            "is_enabled": is_enabled
        }).execute()

        return {"valid":True, "message":"Updated successfully"} if response.data else {"valid":False, "message": response.message if response.message else "An unexpected error occurred!"}  
    
