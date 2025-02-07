import os
from datetime import datetime, timezone

# Database
from app.database.mongodb import db
from app.database.supabase import supabase

# Kafka
from app.config.kafka_config import producer

class SosVideoService:
    UPLOAD_FOLDER = 'uploads'
 
    # 1. Asynchronous method that runs tasks sequentially
    @staticmethod
    def async_video_tasks(user_id):
        # Step 1:
        result_of_boilerplate_report_generation = SosVideoService.generate_boilerplate_report(user_id)
        
        if not result_of_boilerplate_report_generation['success']:
            print("ERROR: Boilerplate generation failed")
            return
        
        report_id = result_of_boilerplate_report_generation["id"]

        # Step 2:
        result_after_supabase_video_upload = SosVideoService.upload_video_to_supabase(user_id, report_id)
        
        if not result_after_supabase_video_upload['success']:
            print("ERROR: Supabase Video Upload Failed")
            return
        
        # Step 3:   
        result_after_sending_to_kafka = SosVideoService.send_to_kafka(report_id)

        if not result_after_sending_to_kafka['success']:
            print("ERROR: Could not produce to Kafka")
            return

        # Step 4:
        result_after_deleting_local_video = SosVideoService.delete_video_from_local(user_id)

        if not result_after_deleting_local_video['success']:
            print("ERROR: Could not delete local video")
            return
        
        print("Sequential tasks completed successfully")


    # 2.1 Generate Boilerplate report and get Id
    @staticmethod
    def generate_boilerplate_report(user_id):
        print(f"\n\nGenerating boilerplate report for user {user_id}")
        
        report = {
            "userID": user_id,
            "ai_generated": True,
            "inserted_at": datetime.utcnow()
        }

        try:
            result = db.incident_reports.insert_one(report)
            return_result = {"success":True, "id": str(result.inserted_id)}
            print(return_result)
            return return_result
        except Exception as e:
            print("Error while inserting boilerplate report in incident_reports collection")
            print(f"Report to be inserted: {report}")
            print(f"Error: {str(e)}")
            return { "success": False, "error_message":f"{str(e)}" }
    

    # 2.2 Upload Video to Supabase Report
    @staticmethod
    def upload_video_to_supabase(user_id, report_id):
        print(f"Uploading video to Supabase for report_id {report_id}")
        new_filename = report_id + ".mp4"
        locally_stored_video_file_path = os.path.join(SosVideoService.UPLOAD_FOLDER, f"video_{user_id}.mp4")
        
        if not os.path.exists(locally_stored_video_file_path):
            print("Error: File not found")
            return {"success": False, "error_message": "File not found"}

        print(f"new_filename : {new_filename}")
        print(f"video_file_path : {locally_stored_video_file_path}")
        
        bucket_name = "video_bucket"

        try:
            response = supabase.storage.from_(bucket_name).upload(new_filename, locally_stored_video_file_path)
            print(response)
            return {"success": True}
        except Exception as e:
            print("Error occurred while uploading to supabase")
            print(f"Error: {str(e)}")
            return {"success": False}

    # 2.3 Send Event as Producer to Kafka
    @staticmethod
    def send_to_kafka(report_id):
        try:
            print(f"Send to Kafka for {report_id}")
            producer.send(
                topic="reports",
                value=report_id
            ).get(timeout=10)

            print(f"report_id {report_id} sent to kafka")
            return {"success":True}
        except Exception as e:
            print("Error occurred while sending to kafka")
            print(f"Error {str(e)}")
            return {"success":False}


    # 2.4 Delete Video from Local Storage
    @staticmethod
    def delete_video_from_local(user_id):
        try:
            print(f"Deleting video from local storage for user {user_id}")
            locally_stored_video_file_path = os.path.join(SosVideoService.UPLOAD_FOLDER, f"video_{user_id}.mp4")
            os.remove(
                path=locally_stored_video_file_path
            )
            print("Deleted video successfully")
            return {"success":True}
        except Exception as e:
            print("Error while deleting local video")
            print(f"Error {str(e)}")
            return {"success":False}

