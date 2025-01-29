import datetime
from datetime import datetime, timezone
from fastapi import HTTPException, status

from app.repository.current_location_repository import CurrentLocationRepository
from app.repository.travel_mode_repository import TravelModeDetailsRepository
from app.repository.police_regions_repository import PoliceRegionsRepository
from app.models.location_models import UserLocationData

class LocationService:
    
    @staticmethod
    def track_location(userID: int, request: UserLocationData):
        latitude = request.latitude
        longitude = request.longitude
        timestamp = request.timestamp
        travel_details = request.travel_details

        CurrentLocationRepository.update_location(userID, latitude, longitude, timestamp)
        print(f"Location updated: UserID {userID}, Lat {latitude}, Long {longitude}, Time {timestamp}")

        police_region = PoliceRegionsRepository.find_police_region(latitude, longitude)

        if travel_details is not None:
            source_latitude = travel_details.location_details.source.latitude
            source_longitude = travel_details.location_details.source.longitude
            destination_latitude = travel_details.location_details.destination.latitude
            destination_longitude = travel_details.location_details.destination.longitude
            notification_frequency = travel_details.location_details.notification_frequency

            vehicle_number = travel_details.vehicle_details.vehicle_number
            mode_of_travel = travel_details.vehicle_details.mode_of_travel

            send_first_notification = not TravelModeDetailsRepository.check_if_details_exists(userID)
            interval = notification_frequency * 60

            print(f"Travel details received: Source({source_latitude}, {source_longitude}) → Destination({destination_latitude}, {destination_longitude}), Mode: {mode_of_travel}, Vehicle: {vehicle_number}, Frequency: {notification_frequency} mins")

            if send_first_notification:
                TravelModeDetailsRepository.add_location_details(
                    userID, source_latitude, source_longitude, 
                    destination_latitude, destination_longitude, 
                    notification_frequency, timestamp.isoformat()
                )
                print("\n\nFirst Notification Sent.")
            else:
                current_timestamp = timestamp
                last_message_timestamp_str = TravelModeDetailsRepository.check_last_message_timestamp(userID)

                if last_message_timestamp_str:
                    try:
                        last_message_timestamp = datetime.fromisoformat(last_message_timestamp_str)
                        time_difference = (current_timestamp - last_message_timestamp).total_seconds()
                        print(f"Time since last notification: {time_difference} seconds")

                        if time_difference >= interval:
                            print("\n\nNotification sent.")
                            TravelModeDetailsRepository.add_location_details(
                                userID, source_latitude, source_longitude, 
                                destination_latitude, destination_longitude, 
                                notification_frequency, current_timestamp.isoformat()
                            )

                    except ValueError as e:
                        print(f"Error parsing last_notification_timestamp: {last_message_timestamp_str}")
                        print(f"Exception: {e}")
        else:
            print("Travel Mode Off")

        return {"message" : "Location Received", "police_region_id" :  police_region['_id']}
        
        

    @staticmethod
    def get_friends_location(userID: int):
        response = CurrentLocationRepository.get_friends_location(userID)
        print(f"Fetching friends' locations for UserID: {userID}")
        return response
