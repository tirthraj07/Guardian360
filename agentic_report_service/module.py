import os
import subprocess
from typing import List
import whisper
from pydub import AudioSegment
from pyannote.audio import Pipeline
import torch

###############################################################################
# CONFIGURATION
###############################################################################

# Initialize models once at startup
WHISPER_MODEL = None
PYANNOTE_PIPELINE = None

OUTPUT_DIR = "outputs"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# Model choices
WHISPER_MODEL_NAME = "medium"  # Whisper model size
DIARIZATION_MODEL = "pyannote/speaker-diarization-3.1"
HF_TOKEN = os.getenv("HF_TOKEN")  # Load HF token from environment variable

# Chunking configuration
USE_CHUNKING = False
CHUNK_SIZE_SEC = 15

###############################################################################
# MODEL INITIALIZATION (RUN ONCE)
###############################################################################

def initialize_models():
    """Load models once at program startup"""
    global WHISPER_MODEL, PYANNOTE_PIPELINE
    
    print("[INIT] Loading Whisper model...")
    WHISPER_MODEL = whisper.load_model(WHISPER_MODEL_NAME)
    
    print("[INIT] Loading pyannote diarization pipeline...")
    PYANNOTE_PIPELINE = Pipeline.from_pretrained(
        DIARIZATION_MODEL,
        use_auth_token=HF_TOKEN
    )
    
    # Verify GPU availability
    # if whisper.device == "cuda":
    #     print("[INIT] Using GPU acceleration")
    # else:
    #     print("[INIT] Using CPU (processing will be slower)")

###############################################################################
# PROCESSING FUNCTIONS (REUSE LOADED MODELS)
###############################################################################

def transcribe_audio_whisper(audio_path: str) -> dict:
    """Transcribe using pre-loaded Whisper model"""
    print(f"[PROCESS] Transcribing {os.path.basename(audio_path)}")
    return WHISPER_MODEL.transcribe(audio_path, verbose=False)

def diarize_audio_pyannote(audio_path: str) -> list:
    """Diarize using pre-loaded pipeline"""
    print(f"[PROCESS] Diarizing {os.path.basename(audio_path)}")
    diarization = PYANNOTE_PIPELINE(audio_path)
    return [(turn.start, turn.end, speaker) 
            for turn, _, speaker in diarization.itertracks(yield_label=True)]

###############################################################################
# REMAINING FUNCTIONS (UNCHANGED)
###############################################################################

def extract_audio_from_video(video_path: str, output_wav: str) -> None:
    """Extract audio using FFmpeg"""
    cmd = [
        "ffmpeg", "-y", "-i", video_path,
        "-vn", "-acodec", "pcm_s16le",
        "-ar", "16000", "-ac", "1", output_wav
    ]
    subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    print(f"[AUDIO] Extracted audio to {output_wav}")

def chunk_audio(input_wav: str, chunk_size_sec: int) -> List[str]:
    """Split audio into chunks"""
    audio = AudioSegment.from_wav(input_wav)
    chunk_size_ms = chunk_size_sec * 1000
    return [
        audio[i*chunk_size_ms:(i+1)*chunk_size_ms].export(
            os.path.join(OUTPUT_DIR, f"chunk_{i}.wav"), 
            format="wav"
        ).name
        for i in range(len(audio) // chunk_size_ms + 1)
    ]

def format_timestamp(seconds: float) -> str:
    """Convert seconds to HH:MM:SS format"""
    return f"{int(seconds//3600):02}:{int(seconds%3600//60):02}:{int(seconds%60):02}"

def merge_results(whisper_result: dict, diarization_segments: list) -> list:
    """Combine transcription and diarization results"""
    speaker_map = {}
    results = []
    
    for seg in whisper_result.get("segments", []):
        midpoint = (seg["start"] + seg["end"]) / 2
        speaker = next((spk for start, end, spk in diarization_segments 
                       if start <= midpoint <= end), "Unknown")
        
        if speaker not in speaker_map:
            speaker_map[speaker] = f"Person {chr(65 + len(speaker_map))}"
            
        results.append(f"{format_timestamp(seg['start'])} {speaker_map[speaker]} - {seg['text']}")
    
    return results

###############################################################################
# MAIN PROCESSING FLOW
###############################################################################

def process_video(video_path: str) -> str:
    """Process a single video file and return the path to the transcript"""
    # Ensure models are initialized
    if WHISPER_MODEL is None or PYANNOTE_PIPELINE is None:
        initialize_models()
    
    # Audio extraction
    audio_path = os.path.join(OUTPUT_DIR, "audio.wav")
    extract_audio_from_video(video_path, audio_path)
    
    # Audio chunking
    audio_files = [audio_path]
    if USE_CHUNKING:
        audio_files = chunk_audio(audio_path, CHUNK_SIZE_SEC)
    
    # Process chunks
    full_transcript = []
    for audio_file in audio_files:
        transcript = transcribe_audio_whisper(audio_file)
        diarization = diarize_audio_pyannote(audio_file)
        full_transcript.extend(merge_results(transcript, diarization))
    
    # Save results
    output_path = os.path.join(OUTPUT_DIR, f"{os.path.basename(video_path)}_transcript.txt")
    with open(output_path, "w") as f:
        f.write("\n".join(full_transcript))
    
    print(f"\n[RESULT] Transcript saved to {output_path}")
    print("Sample output:")
    print("\n".join(full_transcript[:5]))
    
    return output_path  # Return the path to the transcript file

if __name__ == "__main__":
    initialize_models()  # Load models once at startup
    # process_video(VIDEO_FILE)  # Commented out since we process videos in main.py