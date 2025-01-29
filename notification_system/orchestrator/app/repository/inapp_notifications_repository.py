# inapp_notifications_repository -> inapp_notifications table

from app.database.supabase import supabase

class InAppNotificationsRepository:
    @staticmethod
    def get_notifications_by_user_id(user_id, only_unread=False):
        try:
            if only_unread:
                notification = supabase.table("inapp_notifications").select("*").eq("notifier_id", user_id).eq("is_read", False).execute()
            else:
                notification = supabase.table("inapp_notifications").select("*").eq("notifier_id", user_id).execute()
        
            return notification.data if notification.data else []
        except Exception as e:
            print("There was an error while fetching user notifications")
            print(f"notifier_id : {user_id} Error: {e}")
            raise
            

    @staticmethod
    def get_notifications_by_notification_id(notification_id):
        try:
            notification = supabase.table("inapp_notifications").select("*").eq("notification_id", notification_id).execute()
            return notification.data if notification.data else []
        except Exception as e:
            print("There was an error while fetching notification")
            print(f"notification_id : {notification_id} Error: {e}")
            raise

    @staticmethod
    def get_user_notifications_by_notification_type(user_id, notification_type_id, only_unread=False):
        try:
            if only_unread:
                notification = supabase.table("inapp_notifications").select("*").eq("notifier_id", user_id).eq("notification_type_id", notification_type_id).eq("is_read", False).execute()
            else:
                notification = supabase.table("inapp_notifications").select("*").eq("notifier_id", user_id).eq("notification_type_id", notification_type_id).execute()
            return notification.data if notification.data else []
        except Exception as e:
            print("There was an error while fetching user notifications")
            print(f"notifier_id : {user_id} Error: {e}")
            raise

    @staticmethod
    def add_notification(notifier_id, notification_type_id, message):
        try:
            notification = supabase.table("inapp_notifications").insert({"notifier_id": notifier_id, "notification_type_id": notification_type_id, "message": message}).execute()
            return {"valid":True, "message":"Notification stored successfully", "data": notification.data}
        except Exception as e:
            print("There was an error while inserting notification")
            print(f"Args: notifier_id: {notifier_id}, notification_type_id: {notification_type_id}, message: {message}")
            print(f"Error: {e}")
            raise

    @staticmethod
    def mark_all_notifications_as_read(user_id):
        try:
            result = supabase.table("inapp_notifications").update({"is_read":True}).eq("notifier_id", user_id).execute()
            return {"status":"success", "data": result.data} if result.data and len(result.data) != 0 else {"status":"fail", "message":f"no notifications found for user_id {user_id}"}
        except Exception as e:
            raise

