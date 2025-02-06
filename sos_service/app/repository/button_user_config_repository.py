from app.database.supabase import supabase

class ButtonUserConfigRepository:

    @staticmethod
    def get_owner_of_button(button_mac):
        user_id = supabase.table("button_user_config").select("userID").eq("button_mac", button_mac).execute()
        return user_id.data[0]['userID'] if user_id.data else None