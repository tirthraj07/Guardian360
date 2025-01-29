from repository.inapp_notifications_repository import InAppNotificationsRepository
from models.notification_types_model import NotificationTypesEnum

def send_inapp(recipient, message, event_type):
    try:
        notification_type = NotificationTypesEnum[event_type].name
        notification_type_id = NotificationTypesEnum[event_type].value
        InAppNotificationsRepository.add_notification(recipient, notification_type_id, message)

        print(f"In App Notification Sent! Recipient {recipient}, Notification Type {notification_type} ,Message {message}")
    except Exception as e:
        print("Unable to send inapp notification to recipient")
        print(f"Args: \nrecipient: {recipient}\nmessage: {message}\nevent_type: {event_type}")
        print(f"Error : {e}")