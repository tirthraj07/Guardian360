import json
from app.database.supabase import supabase
from app.database.mongodb import db
from pymongo import errors

police_regions_collection = db['police_regions']

class PoliceRegionsRepository:

    @staticmethod
    def find_police_region(latitude, longitude):
        print(f"Latitude: {latitude}")
        print(f"Longitude: {longitude}")
        
        query = {
            "geometry": {
                "$geoIntersects": {
                    "$geometry": {
                        "type": "Point",
                        "coordinates": [latitude, longitude]
                    }
                }
            }
        }

        try:
            # Perform the query
            result = police_regions_collection.find_one(query)
            
            # Check if the result is found
            if result:
                result["_id"] = str(result["_id"])  # Convert _id to string for JSON compatibility
                print("\n\n\n\n\n\n")
                print(result)
                return result
            else:
                # If no region is found, return a custom error message
                return {"message": "Place not found"}
            
        except errors.PyMongoError as e:
            # Handle any database-related errors
            print(f"Database error: {e}")
            return {"message": "An error occurred while querying the database"}
        except Exception as e:
            # Handle any other exceptions
            print(f"Unexpected error: {e}")
            return {"message": "An unexpected error occurred"}