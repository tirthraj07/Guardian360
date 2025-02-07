from guardian360_notification_utils.client import Guardian360NotificationClient

notification_client = Guardian360NotificationClient(
    base_url="http://143.110.183.53/notification-service",
    # base_url="http://localhost:9000",
    debug_mode=True
)

# notification_client.send_sos_notification(
#     user_id=35,
#     message="This is the default message for any channel not otherwise specified.",
#     email_message="This message is specific to email",
#     sms_message="This message is specific to sms",
#     inapp_message=None,
#     push_message=None
# )


notification_client.send_sos_notification(
    user_id=36,
    message="This is the default message for any channel not otherwise specified.",
    email_message="This message is specific to email",
    sms_message="This message is specific to sms. hello amu",
    inapp_message=None,
    push_message=None
)

# notification_client.send_travel_alert_notification(
#     user_id=27,
#     message="This is the default message for any channel not otherwise specified.",
#     email_message="This message is specific to email",
#     sms_message="This message is specific to sms",
#     inapp_message=None,
#     push_message=None
# )

# notification_client.send_adaptive_location_alert_notification(
#     user_id=27,
#     message="This is the default message for any channel not otherwise specified.",
#     email_message="This message is specific to email",
#     sms_message="This message is specific to sms",
#     inapp_message=None,
#     push_message=None
# )

# notification_client.send_generic_notification(
#     recipient_ids=[27],
#     event_from="guardian360.travel_service",
#     message="This is the default message for any channel not otherwise specified.",
#     email_message="This message is specific to email",
#     sms_message="This message is specific to sms",
#     inapp_message=None,
#     push_message=None
# )