from models.notification_types_model import NotificationTypesEnum
from repository.user_repository import UserRepository
import requests

EXPRESS_SERVER_URL = "http://localhost:3000/queue_sms"


def send_sms(recipient_id, message, event_type):
    try:
        print(f"Processing send_sms request for: \n\trecipient_id: {recipient_id}\n\tmessage: {message}\n\tevent_type: {event_type}")
        notification_type = NotificationTypesEnum[event_type].name
        notification_type_id = NotificationTypesEnum[event_type].value
        recipient:dict = UserRepository.get_user_by_id(recipient_id)
        recipient_no = recipient.get("phone_no", "").strip() 

        # Remove spaces from phone number
        recipient_no = recipient_no.replace(" ", "")
            
        sms_data = {
            'recipient': recipient_no,
            'message': message,
            'event_type': event_type
        }
        response = requests.post(EXPRESS_SERVER_URL, json=sms_data)
        
        if response.status_code == 200:
            print(f"SMS data sent to Express server: {sms_data}")
        else:
            print(f"Failed to send SMS data. Status Code: {response.status_code}, Response: {response.text}")
    except Exception as e:
        print("Unable to add sms to sms queue")
        print(f"Args: \nrecipient_id : {recipient_id}\nmessage: {message}\nevent_type: {event_type}")
        print(f"Error: {e}")