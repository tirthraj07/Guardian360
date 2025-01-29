import json
import google.generativeai as genai

# Set your API Key here
GEMINI_API_KEY = "AIzaSyAUjUSsjkVREO5DQWuXrmmEfJ2zOSmNvMg"

try:
    # Configure the Gemini API with your API key
    genai.configure(api_key=GEMINI_API_KEY)
    
    # List available models from Gemini
    models = genai.list_models()
    
    # Print each model's details
    for model in models:
        print(model)
    
except Exception as e:
    raise Exception(f"Error generating answer: {str(e)}")
