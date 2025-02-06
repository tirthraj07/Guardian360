
import asyncio
from app.models.mobile_app_sos_model import MobileAppSos


class SosReceiveService:

    INTERVEL_TO_SEND_SOS = 1 # 1 MINUTE
    SOS_TIME_PERIOD = 5 #5 MINUTE

    @staticmethod
    def handle_mobile_sos(sos_data: MobileAppSos):
        print("\n\nSOS RECEIVED FROM MOBILE")
        asyncio.run(SosReceiveService.send_sos_in_background())

    @staticmethod
    async def send_sos_in_background():
        print("\nSOS Service Initiated")
        
        for i in range(SosReceiveService.SOS_TIME_PERIOD):
            print(f"Notification sent, Time Elapsed {i+1} minute(s).")
            
            await asyncio.sleep(SosReceiveService.INTERVEL_TO_SEND_SOS * 60)
        
        print("Background task finished after 5 minutes.")








