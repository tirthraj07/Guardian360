from app.database import supabase

class IncidentTypesRepository:
    @staticmethod
    def get_all():
        response = supabase.table("incident_types").select("*").execute()
        return response.data if response.data else []
