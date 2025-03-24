from loguru import logger
import json
from bson import ObjectId
from database.mongodb import client, db


class IncidentReports:

    def __init__(self):
        self.client = client
        self.db = db
        self.collection = self.db["incident_reports"]

    def insert_report(self, json_data: dict, object_id: str) -> bool:
        """
        Insert a report into MongoDB with proper error handling.

        Args:
            report (Report): Pydantic model containing report data
            object_id (str): MongoDB document ID to update

        Returns:
            bool: True if update successful, False otherwise
            :param object_id:
            :param json_data:
        """
        try:
            # Log the entire report for debugging
            # logger.info(f"Attempting to insert report: {json_data}")

            logger.info(json_data["description"])

            logger.info(json_data["severity_score"])

            # Convert Pydantic model to dict
            # json_data = report.__dict__
            # data = json_data

            # Prepare update document
            update_data = {
                "$set": {
                    "description": json_data["description"],
                    "severity_score": json_data["severity_score"],
                    "ai_generated": True
                }
            }

            # Perform update with result checking
            result = self.collection.update_one(
                {"_id": ObjectId(object_id)},
                update_data
            )

            if result.modified_count == 0:
                logger.warning(f"No document was updated for object_id: {object_id}")
                return False

            logger.info(f"Successfully updated document {object_id}")
            return True

        except KeyError as e:
            logger.error(f"Missing required field in report: {e}")
            raise
        except Exception as e:
            logger.error(f"Failed to update report: {e}")
            raise


        # self.collection.insert_one(
        #     json.loads(report.json())
        # )


# Original document query (filter based on _id)
#         query = {"_id": {"$oid": "6799d32d028602e6d64a4b41"}}  # Ensure this matches your document in MongoDB
#
#         # Update operation
#         update_data = {
#             "$set": {
#                 "description": {
#                     "summary": "",
#                     "threat_assessment": "",
#                     "emergency_response": "",
#                     "location_details": "Poona Institute of Management Sciences and Entrepreneurship (Lat: 18.4575421, Lon: 73.8508336)",
#                     "critical_information": ""
#                 },
#                 "severity_score": 0
#             }
#         }
#
#         # Perform the update
#         result = self.collection.update_one(query, update_data)
#
#         # Check if the document was updated
#         if result.matched_count > 0:
#             print("Document updated successfully.")
#         else:
#             print("No matching document found.")
