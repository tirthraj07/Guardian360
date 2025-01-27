from app.database.supabase import supabase

class IncidentTypesRepository:
    @staticmethod
    def get_all():
        response = supabase.table("incident_types").select("*").execute()
        print(response.data)
        return response.data if response.data else []
