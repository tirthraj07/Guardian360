# app/models/incident_report.py

from app.database.supabase import supabase

class IncidentReportsRepository:
    @staticmethod
    def create(userID, typeID, subtypeID, description, latitude, longitude, place_name):
        data = {
            "userID": userID,
            "typeID": typeID,
            "subtypeID": subtypeID,
            "description": description,
            "latitude": latitude,
            "longitude": longitude,
            "place_name": place_name,
        }

        response = supabase.table("incident_reports").insert(data).execute()
        return response.data if response.data else []
