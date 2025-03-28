
import asyncio
from datetime import datetime
from app.utils.guardian360_notification_utils.client import Guardian360NotificationClient

#Models
from app.models.mobile_app_sos_model import MobileAppSos
from app.models.button_sos_data import ButtonSosData

#Repositories
from app.repository.user_repository import UsersRepository
from app.repository.current_location_repository import CurrentLocationRepository
from app.repository.button_user_config_repository import ButtonUserConfigRepository
from app.database.mongodb import db



notification_client = Guardian360NotificationClient(
    base_url="http://143.110.183.53/notification-service"
)


class SosReceiveService:

    INTERVEL_TO_SEND_SOS = 2 # 2 MINUTE INTERVAL
    SOS_TIME_PERIOD = 10 # FOR 10 MINUTE 
    

    @staticmethod
    def handle_mobile_sos(sos_data: MobileAppSos):
        asyncio.run(SosReceiveService.send_sos_in_background(sos_data))

    @staticmethod
    def handle_button_sos(sos_data: ButtonSosData):

        button_mac = sos_data.button_mac
        user_id = ButtonUserConfigRepository.get_owner_of_button(button_mac)
        user_details = UsersRepository.get_user_by_id(user_id)

        location_details = CurrentLocationRepository.get_location_by_user_id(user_id)
        
        SosReceiveService.generate_boilerplate_report(user_id, location_details)

        asyncio.run(SosReceiveService.send_sos_in_background_by_button(user_details, location_details))

    @staticmethod
    async def send_sos_in_background(sos_data: MobileAppSos):
        print("\nSOS Service Initiated")

        user_details = UsersRepository.get_user_by_id(user_id=sos_data.userID)

        curr_loc_url = f"https://www.google.com/maps?q={sos_data.location.latitude},{sos_data.location.longitude}"

        email_message=f"""{user_details['first_name']} has sent you an SOS message. Please check their current location and contact them to ensure their safety.<br><br>Stay updated with their live location via our app.<hr>Location Details: Click to view<br><br><a href =\"{curr_loc_url}\">Current Location</a>"""
        message = f"🚨 {user_details['first_name']} sent an SOS! Check location & contact for safety 📍"

        sms_message = f"""Guardian360 [Automatic SOS Alert]\n{user_details['first_name']} triggered SOS signal via Guardian360 App.\nLatitude : {sos_data.location.latitude}\nLongitude: {sos_data.location.longitude}"""

        for i in range(SosReceiveService.SOS_TIME_PERIOD):
            notification_client.send_sos_notification(
                user_id=sos_data.userID,
                message=message,
                email_message=email_message,
                sms_message=sms_message
            )
            print(f"Notification sent, Time Elapsed {i+1} minute(s).")
            
            await asyncio.sleep(SosReceiveService.INTERVEL_TO_SEND_SOS * 60)
        
        print("Background task finished after 5 minutes.")


    @staticmethod
    async def send_sos_in_background_by_button(user_details, location_details):
        print("\nSOS Service Initiated by Button")

        last_fetched_location = f"https://www.google.com/maps?q={location_details['latitude']},{location_details['longitude']}"

        email_message=f"""{user_details['first_name']} has sent you an SOS message. Please check their current location and contact them to ensure their safety.<br><br><div style="border: 2px solid red; padding: 10px; background-color: #f8d7da; color: #721c24; font-weight: bold;"><span style="font-size: 20px;">⚠️</span> <b>Warning:</b> This SOS signal comes from the physical button, not the mobile app. Therefore, the location provided is the last fetched location, not live.</div><br>Stay updated with their journey via our app.<hr>Location Details: Click to view<br><br><a href =\"{last_fetched_location}\">Last Fetched Location</a>"""

        message = f"🚨 {user_details['first_name']} sent an SOS! Check location & contact for safety 📍"

        sms_message = f"""Guardian360 [Automatic SOS Alert]\n{user_details['first_name']} triggered SOS signal via SOS Button.\nLatitude : {location_details['latitude']}\nLongitude: {location_details['longitude']}."""

        for i in range(SosReceiveService.SOS_TIME_PERIOD):
            notification_client.send_sos_notification(
                user_id=user_details['userID'],
                message=message,
                email_message=email_message,
                sms_message=sms_message
            )
            print(f"Notification sent, Time Elapsed {i+1} minute(s).")
            
            await asyncio.sleep(SosReceiveService.INTERVEL_TO_SEND_SOS * 60)
        
        print("Background task finished after 5 minutes.")
        
        
    @staticmethod
    def generate_boilerplate_report(user_id, location_details):
        print(f"\n\nGenerating boilerplate report for user {user_id}")
        
        # location_name = SosReceiveService.get_addr_from_lat_lon(location_details['latitude'], location_details['longitude'])
        
        report = {
            "userID": user_id,
            "ai_generated": False,
            "latitude" : location_details['latitude'],
            "longitude" : location_details['longitude'],
            "description" : f"SOS Alert was generated by a User at Bharti Vidyapeet",
            "inserted_at": datetime.now()
        }

        try:
            result = db.incident_reports.insert_one(report)
            return_result = {"success":True, "id": str(result.inserted_id)}
            print(return_result)
            return return_result
        except Exception as e:
            print("Error while inserting boilerplate report in incident_reports collection")
            print(f"Report to be inserted: {report}")
            print(f"Error: {str(e)}")
            return { "success": False, "error_message":f"{str(e)}" }
