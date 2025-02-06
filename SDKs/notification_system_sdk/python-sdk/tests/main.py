from guardian360_notification_utils.client import Guardian360NotificationClient

notification_client = Guardian360NotificationClient(
    base_url="http://143.110.183.53/notification-service",
    # base_url="http://localhost:9000",
<<<<<<< Updated upstream
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
user_details = {
    'first_name' : 'Amey',
}

source_location = "https://www.google.com/maps?q=18.4690213,73.8640944"
destination_location = "https://www.google.com/maps?q=18.4690213,73.8640944"

notification_client.send_travel_alert_notification(
            user_id=36,
            message= f"{user_details['first_name']} is traveling. You'll be notified again in 8 mins.",
            email_message=f"""{user_details['first_name']} has started traveling. You can track their journey in real time via our app.<br><br>Stay updated with live location and notifications.<hr>Location Details : Click to view<br><br><a href =\"{source_location}\">Source Location</a><br><br><a href =\"{destination_location}\">Destination Location</a>"""
=======
    debug_mode=False
)

notification_client.send_sos_notification(
    user_id=36,
    message="This is the default message for any channel not otherwise specified.",
    email_message="This message is specific to email",
    sms_message="This message is specific to sms",
    inapp_message=None,
    push_message=None
>>>>>>> Stashed changes
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