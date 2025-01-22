# message_service_repository -> message_services table
from app.database.supabase import supabase

class MessageServicesRepository:
    @staticmethod
    def get_all_message_services():
        message_services = supabase.table("message_services").select("*").execute()
        return message_services.data if message_services.data else []
    
    @staticmethod
    def get_message_service_by_id(service_id):
        message_service = supabase.table("message_services").select("*").eq("service_id", service_id).execute()
        return message_service.data[0] if message_service.data else None
    
    @staticmethod
    def get_message_service_by_name(service_name):
        message_service = supabase.table("message_services").select("*").eq("service_name", service_name).execute()
        return message_service.data[0] if message_service.data else None
    
    @staticmethod
    def create_message_service(service_name):
        response = supabase.table("message_services").insert({
            "service_name": service_name
        }).execute()
        return {"valid":True, "message":"Created successfully"} if response.data else {"valid":False, "message": response.message if response.message else "An unexpected error occurred!"}
    
    @staticmethod
    def update_message_service(service_id, service_name):
        response = supabase.table("message_services").update({
            "service_name": service_name
        }).eq("service_id", service_id).execute()
        return {"valid":True, "message":"Updated successfully"} if response.data else {"valid":False, "message": response.message if response.message else "An unexpected error occurred!"}
    
    @staticmethod
    def delete_message_service(service_id):
        response = supabase.table("message_services").delete().eq("service_id", service_id).execute()
        return {"valid":True, "message":"Deleted successfully"} if response.data else {"valid":False, "message": response.message if response.message else "An unexpected error occurred!"}