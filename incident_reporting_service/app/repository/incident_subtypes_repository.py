from app.database.supabase import supabase

class IncidentSubTypesRepository:
    @staticmethod
    def get_all_by_type(typeID):
        response = supabase.table("incident_sub_types").select("*").eq("typeID", typeID).execute()
        return response.data if response.data else []
    
    @staticmethod
    def get_sub_type_by_id(subtypeID):
        response = supabase.table("incident_sub_types").select("sub_type").eq("subtypeID", subtypeID).execute()
        print(response.data)
        return response.data if response.data else []
