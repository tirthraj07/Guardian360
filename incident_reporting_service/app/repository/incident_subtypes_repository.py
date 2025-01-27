from app.database.supabase import supabase

class IncidentSubTypesRepository:
    @staticmethod
    def get_all_by_type(typeID):
        response = supabase.table("incident_sub_types").select("*").eq("typeID", typeID).execute()
        return response.data if response.data else []
