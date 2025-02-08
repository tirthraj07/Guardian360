# Utils
from app.utils.guardian360_notification_utils.client import Guardian360NotificationClient

notification_client = Guardian360NotificationClient(
    base_url="http://143.110.183.53/notification-service"
)


def handle_adaptive_location_alert(user_id, region_id, region_name, low, moderate, high):
    message = ""

    if high >= 3:
        message += f"\nHigh Severity Incidents: {high}"
    
    if moderate >= 5:
        message += f"\nModerate Severity Incidents: {moderate}"

    if low >= 10:
        message += f"\nLow Severity Incidents: {low}"

    if message == "":
        return

    danger_score = ((10*high + 5*moderate + 3*low)/(high + moderate + low))*10

    message = f"\nGuardian 360's Adpative Service has flagged {region_name} based on recent reports \n" + message + f"\nDanger Score = {danger_score}%\nPlease be aware of your surroundings"
    print("Sending Adaptive Notification")
    notification_client.send_adaptive_location_alert_notification(
        user_id=user_id,
        message=message
    )