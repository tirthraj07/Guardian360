from dotenv import load_dotenv

load_dotenv()

import asyncio
import cv2
import numpy as np
import os
import shutil
from datetime import datetime, timedelta
from loguru import logger
from supabase import create_client

# Types
from supabase import Client
from typing import List

# Repositories
from repository.incident_reports import IncidentReports

from module import process_video, initialize_models
# Modules
from database.supabase import supabase

# Services
from services.sos_analyzer import SOSAnalyzer

class VideoProcessingService:
    def __init__(self):
        self.frames_dir = "frames"
        self.videos_dir = "video_store"
        self.supabase: Client = create_client(os.getenv('SUPABASE_URL'), os.getenv('SUPABASE_KEY'))
        os.makedirs(self.frames_dir, exist_ok=True)
        os.makedirs(self.videos_dir, exist_ok=True)
        self.incident_report_repo = IncidentReports()
        self.analyzer = SOSAnalyzer()
       

    async def process_video_from_id(self, id: str):
        try:
            video_path = os.path.join(self.videos_dir, id + ".mp4")
            logger.info(id)
            response = self.supabase.storage.from_('video_bucket').download(id + ".mp4")
            if response:
                logger.info("RECEIVED")
                with open(video_path, 'wb') as f:
                    f.write(response)
                    print(f'File downloaded successfully: {video_path}')
                    await self.process_video(video_path, id)
            else:
                print("Failed!")

            # self.cleanup_directory(self.videos_dir)
            # self.cleanup_directory(self.frames_dir)
    

        except Exception as e:
            logger.error(f"Error in video processing: {e}")
    def is_recent_video(self, created_at: str, hours: int = 4) -> bool:
        video_time = datetime.fromisoformat(created_at.replace('Z', '+00:00'))
        time_threshold = datetime.now(video_time.tzinfo) - timedelta(hours=hours)
        logger.info("age"+str(video_time - time_threshold))
        return video_time > time_threshold

    async def process_videos_in_directory(self):
        try:
            response = self.supabase.storage.from_('video_bucket').list()
            recent_videos = [file for file in response if self.is_recent_video(file['created_at'])]

            logger.info("FETCHED RECENT")

            for vid in recent_videos:
                video_path = os.path.join(self.videos_dir, vid['name'])
                object_id = vid['name'].strip(".mp4")
                logger.info(object_id)
                response = self.supabase.storage.from_('video_bucket').download(vid['name'])
                if response:
                    with open(video_path, 'wb') as f:
                        f.write(response)
                        print(f'File downloaded successfully: {video_path}')
                        await self.process_video(video_path, object_id)
                else:
                    print("Failed!")

                # self.cleanup_directory(self.videos_dir)
                # self.cleanup_directory(self.frames_dir)

        except Exception as e:
            logger.error(f"Error in video processing: {e}")

    async def process_video(self, video_path: str, object_id: str):
        try:
            initialize_models()
            # Generate transcript before processing the video
            transcript_path = process_video(video_path)
            
            if not transcript_path:
                raise ValueError("Transcript path is None")
            
            frame_paths = self.extract_frames(video_path)
            
            transcript = ""
            try:
                # Read the transcript file
                with open(transcript_path, "r", encoding="utf-8") as f:
                    transcript = f.read()
            except Exception as e:
                logger.error(f"Error reading transcript file: {str(e)}")
            
            # Analyze frames with transcript
            frame_data = self.analyzer.analyze_frames(frame_paths, transcript)
            self.analyzer.generate_pdf_report(frame_data, "final_report.pdf")
           
            self.incident_report_repo.insert_report(frame_data, object_id)
            return frame_data
        except Exception as e:
            logger.error(f"Error processing video: {str(e)}")
            return {"error": str(e)}

    def extract_frames(self, video_path: str, num_frames: int = 4) -> List[str]:
        cap = cv2.VideoCapture(video_path)
        total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
        frame_indices = np.linspace(0, total_frames - 1, num_frames, dtype=int)

        session_dir = self.create_session_directory()
        frame_paths = []

        for idx, frame_idx in enumerate(frame_indices):
            cap.set(cv2.CAP_PROP_POS_FRAMES, frame_idx)
            ret, frame = cap.read()
            if ret:
                frame_path = os.path.join(session_dir, f"frame_{idx}.jpg")
                cv2.imwrite(frame_path, frame)
                frame_paths.append(frame_path)

        cap.release()
        return frame_paths

    def create_session_directory(self) -> str:
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        session_dir = os.path.join(self.frames_dir, f"session_{timestamp}")
        os.makedirs(session_dir, exist_ok=True)
        return session_dir

    def cleanup_directory(self, directory: str):
        """Remove all files from specified directory"""
        for filename in os.listdir(directory):
            file_path = os.path.join(directory, filename)
            try:
                if os.path.isfile(file_path):
                    os.unlink(file_path)
                elif os.path.isdir(file_path):
                    shutil.rmtree(file_path)
            except Exception as e:
                logger.error(f"Error deleting {file_path}: {e}")

    async def scheduled_processing(self):
        """Main processing loop that runs every hour"""
        while True:
            logger.info("Starting scheduled video processing")
            try:
                await self.process_videos_in_directory()
            except Exception as e:
                logger.error(f"Error in scheduled processing: {str(e)}")

            # Wait for 1 hour before next run
            await asyncio.sleep(3600)  # 3600 seconds = 1 hour



async def main():
    service = VideoProcessingService()
    logger.info("Video Processing Service started")
    await service.scheduled_processing()
