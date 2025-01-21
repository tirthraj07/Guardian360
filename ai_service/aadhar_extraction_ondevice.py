import ollama
from prompts import aadhar_prompt


def get_aadhar_details_local(image_path):

    response = ollama.chat(
        model='llava-phi3:3.8b',
        messages=[{
            'role': 'system',
            'content': aadhar_prompt.prompt,
            'images': [image_path]
        }]
    )

    return response['message']['content']

print(get_aadhar_details_local("test_images/aadhar-card.jpg"))