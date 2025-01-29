from repository.user_repository import UserRepository
from utils.fcm import FirebaseCloudMessaging


def send_push(recipient, message, event_type):
    try:
        user:dict = UserRepository.get_user_by_id(recipient)
        fcm_token = user.get("device_token")
        print(user)
        print(fcm_token)
        message="Hello Message From Tirthraj Mahajan"
        res = FirebaseCloudMessaging.send_push_notification(device_token=fcm_token,title=event_type, body=message,alert_type=event_type)
        print(f"Response: {res}")
        print(f"Push Notification Sent! Recipient {recipient} Message {message}")
        
    except Exception as e:
        print(f"There was an error while sending push notification to {recipient} : error {e}")