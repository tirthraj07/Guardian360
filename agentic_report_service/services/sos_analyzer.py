import json
from typing import List
from fpdf import FPDF
import prompts
import ollama
from langchain_openai import ChatOpenAI
from models.report import Report
from loguru import logger
from langchain_core.pydantic_v1 import BaseModel, Field

class Description(BaseModel):
    summary: str = Field("", description="Provide a concise 2-3 sentence overview that captures the primary events, actions, and context observed throughout the video.")
    threat_assessment: str = Field("", description="Detail any potential hazards, unusual behaviors, or concerning elements observed across the frames. If none are evident, state 'No apparent threats detected.'")
    emergency_response: str = Field("", description="Indicate any relevant authorities or services that should be notified if an emergency is indicated. If not, state 'No emergency response required.'")
    location_details: str = Field("", description="Summarize notable environmental context and location characteristics, including indoor/outdoor settings, landmarks, or visible shop names.")
    critical_information: str = Field("", description="Highlight key details that warrant follow-up or further attention (e.g., individuals handling phones, guns, knives, or other significant objects). If no such details are present, state 'No critical information to report.'")

class CombinedAnalysis(BaseModel):
    description: Description
    severity_score: int = Field(0, description="Severity score ranging from 1 to 5, indicating the level of urgency.")


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
        logger.info(response['message']['content'])
        return response['message']['content']

    def analyze_frames(self, frame_paths: List[str], transcript: str) -> dict:
        """Process all frames and return analysis data"""
        frame_descriptions = ""
        description = ""
        for frame_path in frame_paths:
            description = self.analyze_single_frame(frame_path, description)
            frame_descriptions += f"\n{description}"

        combined_input = f"{frame_descriptions}\n\nTranscript:\n{transcript}"
        logger.info(f"Combined input: {combined_input}")
        response = ollama.chat(
            model='llama3.2',
            messages=[{
                'role': 'system',
                'content': prompts.COMBINED_ANALYSIS_PROMPT
            },
            {
                'role': 'user',
                'content': combined_input
            }]
        )

        text = response['message']['content']
        logger.info(f"Raw response: {text}")

        if not text:
            logger.error("Received empty response from the model")
            raise ValueError("Received empty response from the model")

        text = text[text.find("</think>") + len("</think>"):] if "</think>" in text else text
        json_data = text.split("```json", 1)[-1].split("```", 1)[0].strip()
        logger.info(f"JSON: {json_data}")

        llm = ChatOpenAI(model="gpt-4o-mini")
        structured_llm = llm.with_structured_output(CombinedAnalysis)
        prompt_structured = f"""
        You are given text input, please return in proper json format. 
        {json_data}
"""
        final_output = structured_llm.invoke(prompt_structured) 
        
        if not final_output:
            logger.error("Extracted JSON data is empty")
            raise ValueError("Extracted JSON data is empty")

        try:
            json_format = final_output.dict()  # Use dict() method to dump the model's data
            # Ensure severity_score is always present
            if 'severity_score' not in json_format:
                json_format['severity_score'] = 0
        except json.JSONDecodeError as e:
            logger.error(f"Error decoding JSON: {e}")
            raise

        return json_format

    def generate_pdf_report(self, report_data: dict, filename: str = "analysis_report.pdf") -> None:
        """Generate PDF report from analysis data"""
        pdf = FPDF()
        pdf.add_page()
        pdf.set_auto_page_break(auto=True, margin=15)
        
        # Add title
        pdf.set_font("Arial", 'B', 16)
        pdf.cell(0, 10, "Video Analysis Report", ln=True, align='C')
        pdf.ln(10)

        # Add report data
        pdf.set_font("Arial", '', 12)
        pdf.multi_cell(0, 10, json.dumps(report_data, indent=4))

        # Save PDF
        pdf.output(filename)
        logger.info(f"PDF report generated: {filename}")