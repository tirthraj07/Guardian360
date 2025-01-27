# user_repository -> users table
from app.database.supabase import supabase

class UserRepository:
    @staticmethod
    def get_all_users():
        response = supabase.table('users').select("*").execute()
        return response.data if response.data else []
    
    @staticmethod
    def get_user_by_id(user_id):
        response = supabase.table('users').select("userID, first_name, last_name, email, phone_no, device_token").eq('userID', user_id).execute()
        return response.data[0] if response.data else None
    
    @staticmethod
    def get_users_by_ids(user_ids):
        response = supabase.table('users').select("userID, first_name, last_name, email, phone_no, device_token").in_('userID', user_ids).execute()
        return response.data if response.data else []
