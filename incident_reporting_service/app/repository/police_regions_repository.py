import json

from bson import ObjectId
from app.database.supabase import supabase
from app.database.mongodb import db

police_regions_collection = db['police_regions']

class PoliceRegionsRepository:

    @staticmethod
    def find_police_region(longitude, latitude):
        query = {
            "geometry": {
                "$geoIntersects": {
                    "$geometry": {
                        "type": "Point",
                        "coordinates": [longitude, latitude]
                    }
                }
            }
        }
    
        result = police_regions_collection.find_one(query)

        result = police_regions_collection.find_one(query)

        if result:
            result["_id"] = str(result["_id"])
            
            # Convert the result to JSON
            return json.dumps(result, indent=4)  
        else:
            return json.dumps({"message": "No region found"}, indent=4)

    @staticmethod
    def add_report_to_police_region_by_id(_id: str, report_id:str):

        print(_id)
        print(report_id)

        try:
            region_object_id = ObjectId(_id)
            report_object_id = ObjectId(report_id)
        except:
            return {"error": "Invalid ObjectId format"}

        print(f"Object Id : {region_object_id}")
        print(f"Report Object Id : {report_object_id}")
        update_query = {
            "$addToSet": {"reports": report_object_id}  # Adds report_id to the array if not already present
        }

        try:
            # Perform update
            result = police_regions_collection.update_one({"_id": region_object_id}, update_query)

            # Return result
            if result.matched_count == 0:
                return {"error": "Region not found"}
            elif result.modified_count == 0:
                return {"message": "Report ID already exists in the region"}
            else:
                return {"message": "Report added successfully"}
        except Exception as e:
            print(f"Error {e}")
            return {"error": "Internal server error"}


   
