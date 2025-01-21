import os

import anthropic
import base64
from dotenv import load_dotenv

def get_details(image_path):

    with open(image_path, "rb") as image_file:
        # Read the binary data and encode it in base64
        image_data = base64.standard_b64encode(image_file.read()).decode("utf-8")

    load_dotenv()
    client = anthropic.Anthropic(api_key = os.getenv('ANTHROPIC_API_KEY'))

    message = client.messages.create(
        model="claude-3-5-sonnet-20241022",
        max_tokens=500,
        temperature=0,
        system="""You are an intelligent AI vision system, with great OCR capabilities. You need to extract all the text "
                that is present in the image of AADHAR card.
                Return in JSON format: 
                    {
                        "AADHAR_number": "4444 3333 2222",
                        "first_name": "Nilesh",
                        "last_name": "Singh",
                        "dob": 07/01/2004,
                        "gender": "Male"
                    
                    }
                    """,
        messages=[
            {
                "role": "user",
                "content": [
                    {
                        "type": "image",
                        "source":{
                            "type": "base64",
                            "media_type": "image/jpeg",
                            "data":image_data
                        }
                    }
                ]
            }
        ]
    )
    print(message.content)


get_details("test_images/aadhar-card.jpg")