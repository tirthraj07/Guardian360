from guardian360_notification_utils.client import Guardian360NotificationClient

notification_client = Guardian360NotificationClient(
    base_url="http://143.110.183.53/notification-service",
    debug_mode=True
)

notification_client.send_travel_alert_notification(
    user_id=27,
    message="This is the default message for any channel not otherwise specified.",
    email_message="This message is specific to email",
    sms_message="This message is specific to sms",
    inapp_message=None,
    push_message=None
)