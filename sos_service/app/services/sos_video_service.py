import asyncio
import time
import threading

class SosVideoService:
    
    # 1. Asynchronous method that runs asynchronous tasks
    @staticmethod
    def async_video_tasks(user_id):
        SosVideoService.generate_boilerplate_report(user_id)
        SosVideoService.upload_video_to_supabase(user_id)
        SosVideoService.delete_video_from_local(user_id)
        SosVideoService.send_to_kafka(user_id)

    # 2.1 Generate Boilerplate report and get Id
    @staticmethod
    def generate_boilerplate_report(user_id):
        print(f"\n\nGenerating boilerplate report for user {user_id}")

    # 2.2 Upload Video to Supabase Report
    @staticmethod
    def upload_video_to_supabase(user_id):
        print(f"Uploading video to Supabase for user {user_id}")
        time.sleep(10)

    # 2.3 Delete Video from Local Storage
    @staticmethod
    def delete_video_from_local(user_id):
        print(f"Deleting video from local storage for user {user_id}")

    # 2.4 Producer
    @staticmethod
    def send_to_kafka(user_id):
        print(f"Send to Kafka for {user_id}")
