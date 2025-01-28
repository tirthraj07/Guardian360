# notification_types_repository -> notification_types table
from database.supabase import supabase


class NotificationTypesRepository:
    @staticmethod
    def get_all_notification_types():
        notification_types = supabase.table("notification_types").select("*").execute()
        return notification_types.data if notification_types.data else []
    
    @staticmethod
    def get_notification_type_by_id(notification_type_id):
        notification_type = supabase.table("notification_types").select("*").eq("notification_type_id", notification_type_id).execute()
        return notification_type.data[0] if notification_type.data else None
    
    @staticmethod
    def get_notification_type_by_name(notification_name):
        notification_type = supabase.table("notification_types").select("*").eq("notification_name", notification_name).execute()
        return notification_type.data[0] if notification_type.data else None

    @staticmethod
    def create_notification_type(notification_name):
        response = supabase.table("notification_types").insert({
            "notification_name": notification_name
        }).execute()
        return {"valid":True, "message":"Created successfully"} if response.data else {"valid":False, "message": response.message if response.message else "An unexpected error occurred!"}
    
    @staticmethod
    def update_notification_type(notification_type_id, notification_name):
        response = supabase.table("notification_types").update({
            "notification_name": notification_name
        }).eq("notification_type_id", notification_type_id).execute()
        return {"valid":True, "message":"Updated successfully"} if response.data else {"valid":False, "message": response.message if response.message else "An unexpected error occurred!"}
    
    @staticmethod
    def delete_notification_type(notification_type_id):
        response = supabase.table("notification_types").delete().eq("notification_type_id", notification_type_id).execute()
        return {"valid":True, "message":"Deleted successfully"} if response.data else {"valid":False, "message": response.message if response.message else "An unexpected error occurred!"}
    