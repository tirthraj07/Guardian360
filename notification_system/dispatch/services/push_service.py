from repository.user_repository import UserRepository
from utils.fcmutils import FCMUtils

def send_push(recipient, message, event_type):
    try:
        user:dict = UserRepository.get_user_by_id(recipient)
        fcm_token = user.get("device_token")
        print(user)
        print(fcm_token)
        message="Hello Message To Token"
        app = FCMUtils()
        res = app.push_notification_to_token(token=fcm_token, msg=message)
        print(f"Response: {res}")
        print(f"Push Notification Sent! Recipient {recipient} Message {message}")
        
    except Exception as e:
        print(f"There was an error while sending push notification to {recipient} : error {e}")