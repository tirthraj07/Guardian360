from fastapi import FastAPI, UploadFile, File
# import uvicorn
import cv2
import numpy as np
from typing import List
import tempfile
import os
from datetime import datetime
from processor import SOSAnalyzer
from repository.incident_reports import IncidentReports
from loguru import logger
# Initialize FastAPI app
app = FastAPI()

# Create frames directory if it doesn't exist
FRAMES_DIR = "frames"
os.makedirs(FRAMES_DIR, exist_ok=True)


def create_session_directory() -> str:
    """Create a unique directory for each video session"""
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    session_dir = os.path.join(FRAMES_DIR, f"session_{timestamp}")
    os.makedirs(session_dir, exist_ok=True)
    return session_dir


def extract_frames(video_path: str, num_frames: int = 1) -> List[str]:
    """
    Extract evenly spaced frames from a video file
    Returns paths to saved frame images
    """
    cap = cv2.VideoCapture(video_path)
    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    frame_indices = np.linspace(0, total_frames - 1, num_frames, dtype=int)

    session_dir = create_session_directory()
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


@app.post("/video/process/")
async def process_video(
        video: UploadFile = File(...)):
    incident_report_repo = IncidentReports()
    # Save uploaded video to temporary file
    temp_video = tempfile.NamedTemporaryFile(delete=False, suffix=".mp4")
    temp_video.write(await video.read())
    temp_video.close()

    try:
        # Extract frames
        frame_paths = extract_frames(temp_video.name)
        analyzer = SOSAnalyzer()
        report = analyzer.analyze_frames(frame_paths)
        logger.info(report.model_dump())
        incident_report_repo.insert_report(report, "6799d32d028602e6d64a4b41")
        return report.model_dump()
    except Exception as e:
        return {"error": str(e)}
    finally:
        os.unlink(temp_video.name)


if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
