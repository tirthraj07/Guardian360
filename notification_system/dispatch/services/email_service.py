from models.notification_types_model import NotificationTypesEnum
from utils.mailer import send_email_to_recipient
from repository.user_repository import UserRepository

def send_email(recipient_id, message, event_type):
    try:
        notification_type = NotificationTypesEnum[event_type].name
        notification_type_id = NotificationTypesEnum[event_type].value
        recipient:dict = UserRepository.get_user_by_id(recipient_id)
        recipient_email = recipient.get("email")
        send_email_to_recipient(to=recipient_email, subject="Guardian360 Notification Alert", body=message)
        print(f"Email Sent! Recipient {recipient} Message {message}")
    except Exception as e:
        print(f"Error while sending email to recipient {recipient_id}")
        print(f"Error: {e}")