from dotenv import load_dotenv
load_dotenv()
import os
from datetime import datetime, timedelta
from bson import ObjectId
from pymongo import MongoClient
from repository.incident_reports import IncidentReports
from loguru import logger
from supabase import create_client
from supabase import Client

'''
for id in police_regions:
    if police_regions.low > threshold (same for med, high):
    [] = SELECT userId WHERE police_region_id = id
    for userId in []:
        notification_client = AdaptiveNotif.adaptive_notif(userId, "")    
'''

class PoliceRegions:

    def __init__(self):
        self.client = MongoClient("mongodb+srv://guardian_admin:GuardianAdmin123@guardian360cluster.s2tkr.mongodb.net/", tls=True, tlsAllowInvalidCertificates=True)
        self.db = self.client["guardian360db"]
        self.collection = self.db["police_regions"]
        self.supabase: Client = create_client(os.getenv('SUPABASE_URL'), os.getenv('SUPABASE_KEY'))

    # async def send_police_regions_report(self):


    async def add_severity_score(self):
        incident_reports = IncidentReports()
        documents = self.collection.find({}, {"_id": 1, "reports": 1})
        regionwise_reports = [{"_id": str(doc["_id"]), "reports": [str(report_id) for report_id in doc.get("reports", [])]} for doc in documents]

        for region in regionwise_reports:


            logger.info(region)

            _id: str = region["_id"]
            reports = region["reports"]

            low_val = self.collection.find_one({"_id": ObjectId(_id)}, {"_id": 0, "low": 1})
            moderate_val = self.collection.find_one({"_id": ObjectId(_id)}, {"_id": 0, "moderate": 1})
            high_val = self.collection.find_one({"_id": ObjectId(_id)}, {"_id": 0, "high": 1})

            logger.info(low_val)
            logger.info(moderate_val)
            logger.info(high_val)

            if low_val.get("low") is not None:
                low = int(low_val.get("low"))
            else:
                low = 0

            if moderate_val.get("moderate") is not None:
                moderate = int(moderate_val.get("moderate"))
            else:
                moderate = 0

            if high_val.get("high") is not None:
                high = int(high_val.get("high"))
            else:
                high = 0

            if high>0:
                response = self.supabase.table("users").select("userID").eq("police_region_id", _id).execute()
                if response.data:
                    user_ids = [row["userID"] for row in response.data]
                    print(user_ids)
                else:
                    print("No users found for the given police_region_id")

            for report in reports:

                one_hour_ago = datetime.utcnow() - timedelta(hours=1)

                severity_score = incident_reports.collection.find_one(
                    {"_id": ObjectId(str(report)), "inserted_at": {"$gte": one_hour_ago}},
                    {"_id": 0, "severity_score": 1}
                )

                if severity_score is not None:

                    logger.info("NEW RECORD FOUND")

                    score = 2

                    if severity_score.get("severity_score") is not None:
                        score = int(severity_score.get("severity_score"))

                    if score <= 1:
                        low += 1
                    elif score >= 4:
                        high += 1
                    else:
                        moderate += 1

                    self.collection.update_one(
                        {"_id": ObjectId(_id)},
                        {"$set": {"low": low, "moderate": moderate, "high": high}}
                    )
                else:
                    logger.warning("OLD RECORD")

# reg = PoliceRegions()
# reg.add_severity_score()