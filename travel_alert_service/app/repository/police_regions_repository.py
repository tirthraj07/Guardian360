import json

from bson import ObjectId
from app.database.supabase import supabase
from app.database.mongodb import db

police_regions_collection = db['police_regions']

class PoliceRegionsRepository:

    @staticmethod
    def find_police_region(longitude, latitude):
        print(latitude)
        print(longitude)
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

        if result:
            result["_id"] = str(result["_id"])
            
            # Convert the result to JSON
            print(result)
            return result
        else:
            return json.dumps({"message": "No region found"}, indent=4)