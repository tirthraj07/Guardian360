import json
from typing import List
import prompts
import ollama
from models.report import Report
from loguru import logger


class SOSAnalyzer:
    def __init__(self):
        self.model = "llava"

    def analyze_single_frame(self, image_path: str, description: str) -> str:
        """Process a single frame using LLaVA model"""
        with open(image_path, "rb") as img_file:
            image_data = img_file.read()

        response = ollama.chat(
            model='llava-phi3:3.8b',
            messages=[{
                'role': 'system',
                'content': prompts.SINGLE_FRAME_PROMPT,
                'history': description,
                'images': [image_data]
            }]
        )
        logger.info("LLAVA")
        return response['message']['content']

    def analyze_frames(self, frame_paths: List[str]) -> Report:
        """Process all frames in two stages"""
        # Stage 1: Individual frame analysis
        frame_descriptions = ""
        description = ""
        for frame_path in frame_paths:
            print(frame_path)
            description = self.analyze_single_frame(frame_path, description)
            print(description)
            frame_descriptions += "\n"
            frame_descriptions += description

        response = ollama.chat(
            model='deepseek-r1:1.5b',
            messages=[{
                'role': 'system',
                'content': prompts.COMBINED_ANALYSIS_PROMPT
            },
                {
                    'role': 'user',
                    'content': frame_descriptions
                }]
        )

        text = response['message']['content']

        # text_data = json.loads(text)
        #
        # logger.info(text_data)
        #
        # logger.info("LLAMA 3.2")
        #
        # return Report(**text_data)

        #ONLY FOR DEEPSEEK

        json_part = text.split("```json", 1)[-1].split("```", 1)[0].strip()

        print(json_part)

        frame_data = json.loads(json_part)
        return frame_data
        # return Report(**frame_data)

