
import asyncio
from app.models.mobile_app_sos_model import MobileAppSos
from app.utils.guardian360_notification_utils.client import Guardian360NotificationClient

from app.repository.user_repository import UsersRepository

notification_client = Guardian360NotificationClient(
    base_url="http://143.110.183.53/notification-service"
)


class SosReceiveService:

    INTERVEL_TO_SEND_SOS = 0.1 # 1 MINUTE
    SOS_TIME_PERIOD = 2 #5 MINUTE

    @staticmethod
    def handle_mobile_sos(sos_data: MobileAppSos):
        asyncio.run(SosReceiveService.send_sos_in_background(sos_data))

    @staticmethod
    async def send_sos_in_background(sos_data: MobileAppSos):
        print("\nSOS Service Initiated")

        user_details = UsersRepository.get_user_by_id(user_id=sos_data.userID)

        curr_loc_url = f"https://www.google.com/maps?q={sos_data.location.latitude},{sos_data.location.longitude}"

        email_message=f"""{user_details['first_name']} has sent you an SOS message. Please check their current location and contact them to ensure their safety.<br><br>Stay updated with their live location via our app.<hr>Location Details: Click to view<br><br><a href =\"{curr_loc_url}\">Current Location</a>"""
        message = f"🚨 {user_details['first_name']} sent an SOS! Check location & contact for safety 📍"

        for i in range(SosReceiveService.SOS_TIME_PERIOD):
            notification_client.send_sos_notification(
                user_id=sos_data.userID,
                message=message,
                email_message=email_message
            )
            print(f"Notification sent, Time Elapsed {i+1} minute(s).")
            
            await asyncio.sleep(SosReceiveService.INTERVEL_TO_SEND_SOS * 60)
        
        print("Background task finished after 5 minutes.")








