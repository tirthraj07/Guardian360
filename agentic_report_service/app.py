import cv2
import numpy as np
from fastapi import FastAPI, UploadFile, File
from typing import List
import tempfile
import os

app = FastAPI()


def extract_frames(video_path: str, num_frames: int = 4) -> List[str]:
    """
    Extract evenly spaced frames from a video file
    Returns paths to saved frame images
    """
    cap = cv2.VideoCapture(video_path)
    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    frame_indices = np.linspace(0, total_frames - 1, num_frames, dtype=int)

    frame_paths = []
    temp_dir = tempfile.mkdtemp()

    for idx, frame_idx in enumerate(frame_indices):
        cap.set(cv2.CAP_PROP_POS_FRAMES, frame_idx)
        ret, frame = cap.read()
        if ret:
            frame_path = os.path.join(temp_dir, f"frame_{idx}.jpg")
            cv2.imwrite(frame_path, frame)
            frame_paths.append(frame_path)

    cap.release()
    return frame_paths


@app.post("/process-video")
async def process_video(video: UploadFile = File(...)):
    # Save uploaded video to temporary file
    temp_video = tempfile.NamedTemporaryFile(delete=False, suffix=".mp4")
    temp_video.write(await video.read())
    temp_video.close()

    # Extract frames
    frame_paths = extract_frames(temp_video.name)

    # Cleanup
    os.unlink(temp_video.name)

    return {"frame_paths": frame_paths}