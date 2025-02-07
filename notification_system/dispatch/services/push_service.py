from repository.user_repository import UserRepository
from utils.fcm import FirebaseCloudMessaging


def send_push(recipient, message, event_type):
    try:
        print(f"Processing send_push request for: \n\trecipient_id: {recipient}\n\tmessage: {message}\n\tevent_type: {event_type}")
        user:dict = UserRepository.get_user_by_id(recipient)
        if user:
            fcm_token = user.get("device_token")
            # print(user)
            # print(fcm_token)
            res = FirebaseCloudMessaging.send_push_notification(device_token=fcm_token,title=event_type, body=message,alert_type=event_type)
            print(f"Response: {res}")
        
    except Exception as e:
        print(f"There was an error while sending push notification to {recipient} : error {e}")