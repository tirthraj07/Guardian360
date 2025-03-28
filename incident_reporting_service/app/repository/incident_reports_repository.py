# app/models/incident_report.py

# IncidentReportRepository -> incident_reports table
import json
from app.database.supabase import supabase
from app.database.mongodb import db
from app.repository.police_regions_repository import PoliceRegionsRepository

incident_report_collection = db['incident_reports']

class IncidentReportsRepository:
    @staticmethod
    def create(userID, typeName, subtypeName, description, latitude, longitude, place_name):
        data = {
            "userID": userID,
            "typeName": typeName,
            "subtypeName": subtypeName,
            "description": description,
            "latitude": latitude,
            "longitude": longitude,
            "place_name": place_name,
            "ai_generated" : False
        }

        print(data)

        # response = supabase.table("incident_reports").insert(data).execute()
        response = incident_report_collection.insert_one(data)
        print(str(response.inserted_id))

        police_station = PoliceRegionsRepository.find_police_region(latitude, longitude)

        print("Police Station Found")
    
        response = PoliceRegionsRepository.add_report_to_police_region_by_id(police_station['_id'], str(response.inserted_id))

        return response
        


    @staticmethod
    def get_incident_report_by_id(id: str):
        pass

   
