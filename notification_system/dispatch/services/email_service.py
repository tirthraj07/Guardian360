from models.notification_types_model import NotificationTypesEnum
from repository.user_repository import UserRepository
from utils.mailer import send_email_to_recipient
from templates.email.email_template import EmailTemplate

def send_email(recipient_id, message, event_type):
    try:
        print(f"Processing send_email request for: \n\trecipient_id: {recipient_id}\n\tmessage: {message}\n\tevent_type: {event_type}")
        notification_type = NotificationTypesEnum[event_type].name
        notification_type_id = NotificationTypesEnum[event_type].value
        recipient:dict = UserRepository.get_user_by_id(recipient_id)
        recipient_full_name = recipient.get("first_name") + " " + recipient.get("last_name")
        recipient_email = recipient.get("email")

        html_body = EmailTemplate.get_email_template(notification_type_id, recipient_full_name, message)

        send_email_to_recipient(to=recipient_email, subject="Guardian360 Notification Alert", body=html_body)
        print(f"Email Sent! Recipient {recipient} Message {message}")
    except Exception as e:
        print(f"Error while sending email to recipient {recipient_id}")
        print(f"Error: {e}")