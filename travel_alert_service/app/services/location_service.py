import datetime
from datetime import datetime, timezone
from fastapi import HTTPException, status

# Repository
from app.repository.current_location_repository import CurrentLocationRepository
from app.repository.travel_mode_repository import TravelModeDetailsRepository
from app.repository.police_regions_repository import PoliceRegionsRepository
from app.repository.user_cache_repository import UserCacheRepository
from app.repository.user_repository import UsersRepository

# Models
from app.models.location_models import UserLocationData

# Utils
from app.utils.guardian360_notification_utils.client import Guardian360NotificationClient

notification_client = Guardian360NotificationClient(
    base_url="http://143.110.183.53/notification-service"
)


class LocationService:
    
    @staticmethod
    def track_location(userID: int, request: UserLocationData):
        # Note to Amey -> For future reference, handling of the request and extracting the information should be done at controller layer, not at the service layer.
        # The function `track_location` should take long, lat, timestamp and travel_details as arguments. Do not extract them at this level. BAD PRACTICE.
        latitude = request.latitude
        longitude = request.longitude
        timestamp = (request.timestamp).isoformat()
        
        travel_details = request.travel_details

        # Check if user exists and also check if we should update the db after timeout specified by UserCacheRepository.LOCATION_TTL
        if UserCacheRepository.should_update_db(user_id=userID):
            police_region = PoliceRegionsRepository.find_police_region(latitude, longitude)
            print(police_region)
            if police_region.get("status") != "success":
                print("Error while fetching police_regions")
                police_region["_id"] = None

            police_region_id = police_region['_id']

            # Update the location in Database
            CurrentLocationRepository.update_location(
                user_id=userID, 
                latitude=latitude, 
                longitude=longitude, 
                timestamp=timestamp,
                police_region_id=police_region_id
            )
            print(f"Location updated in DATABASE: UserID {userID}, Lat {latitude}, Long {longitude}, Time {timestamp}, Police Region ID {police_region_id}")

            # Update the police region in cache

            UserCacheRepository.set_police_region(
                user_id=userID, 
                police_region_id=police_region_id
            )

            # Set/Reset the TTL Flag.
            UserCacheRepository.set_update_flag(userID)


        # Always update Redis with the latest location
        UserCacheRepository.set_user_location(
            user_id=userID, 
            latitude=latitude, 
            longitude=longitude, 
            timestamp=timestamp
        )

        police_region_id = UserCacheRepository.get_police_region(userID)

        # If not found in cache, fetch from DB and update cache
        '''
        if not police_region_id:
            police_region = PoliceRegionsRepository.find_police_region(latitude, longitude)
            if police_region.get("status") != "success":
                print("Error while fetching police_regions")
                police_region["_id"] = None
            police_region_id = police_region["_id"]
            UserCacheRepository.set_police_region(
                user_id=userID, 
                police_region_id=police_region_id
            )
        '''

        # Handling travel mode cases seperately. Makes the code look cleaner
        travel_mode = LocationService.handle_travel_mode(
            userID=userID,
            travel_details=travel_details, 
            timestamp=timestamp,
            current_latitude=latitude,
            current_longitude=longitude
        )

        return {"message" : "Location Received", "police_region_id" :  police_region_id, "travel_mode" : travel_mode}
        
    @staticmethod
    def handle_travel_mode(userID, travel_details, timestamp, current_latitude, current_longitude):
        
        THRESHOLD_DISTANCE = 50  # in metres
        
        print(travel_details)
        if not travel_details:
            print("Travel Mode Off")
            return False
        
        location_details = travel_details.location_details
        vehicle_details = travel_details.vehicle_details

        source_lat, source_long = location_details.source.latitude, location_details.source.longitude
        dest_lat, dest_long = location_details.destination.latitude, location_details.destination.longitude
        notification_frequency = location_details.notification_frequency
        vehicle_number, mode_of_travel = vehicle_details.vehicle_number, vehicle_details.mode_of_travel
        distance_to_destination = travel_details.distance_to_destination

        

        # Log travel details
        print(f"Travel details received: \n"
              f"Source({source_lat}, {source_long}) → Destination({dest_lat}, {dest_long})\n"
              f"Mode: {mode_of_travel}, Vehicle: {vehicle_number}, Frequency: {notification_frequency} mins\n"
              f"Distance to Destination : {distance_to_destination}"
              )


        # Check if travel mode is ON and if the source and destination location are same. if they are different, user must have changed the travel mode.
        
        send_first_notification = not TravelModeDetailsRepository.check_if_details_exists(
            user_id=userID, 
            source_latitude=source_lat, source_longitude=source_long,
            destination_latitude=dest_lat, destination_longitude=dest_long
        )

        if send_first_notification:
            LocationService._send_first_travel_notification(
                userID, source_lat, source_long, dest_lat, dest_long, notification_frequency, timestamp
            )
            return
        
        # If not the first notification, check if enough time has passed
        LocationService._send_periodic_travel_notification(
            userID, source_lat, source_long, dest_lat, dest_long, notification_frequency, timestamp
        )

        if distance_to_destination < THRESHOLD_DISTANCE:
            print("\n\n\nTurning off Travel Mode Automatically")
            print("You have reached your destination !!!")
            # TravelModeDetailsRepository.turnOffTravelMode(userID)
            notification_client.send_generic_notification(
                event_from="guardian360.location_service",
                recipient_ids=[userID],
                message="You have reached your destination. You can now turn off travel mode"
            )
            return False
        return True

    @staticmethod
    def get_friends_location(userID: int):
        print(f"Fetching friends' locations for UserID: {userID}")
        # before:
        # response = CurrentLocationRepository.get_friends_location(userID)
        # we now cannot directly fetch from db. Instead check cache first for the most recent location update
        friend_ids = CurrentLocationRepository.get_friend_ids(user_id=userID)
        if not friend_ids:
            return []

        print(friend_ids)

        users = UsersRepository.get_users_by_ids(user_ids=friend_ids)
        user_map = {user["userID"]: user for user in users}
    
        # Check the cache for the friend's current location
        cached_locations = {}
        for friend_id in friend_ids:
            cached_location = UserCacheRepository.get_user_location(friend_id)
            if cached_location:
                cached_locations[friend_id] = cached_location


        travel_modes = {}
        for friend_id in friend_ids:
            travel_mode = TravelModeDetailsRepository.get_travel_mode(friend_id)
            print
            if travel_mode:
                travel_modes[friend_id] = travel_mode
            else:
                travel_modes[friend_id] = False

        # Find missing locations (not in cache)
        missing_friend_ids = [fid for fid in friend_ids if fid not in cached_locations]
        db_locations = CurrentLocationRepository.get_location_by_user_ids(user_ids=missing_friend_ids)

        for loc in db_locations:
            cached_locations[loc["userID"]] = loc

        response = []
        for friend_id in friend_ids:
            if friend_id in user_map:
                user_info = user_map[friend_id].copy()
                user_info["location"] = cached_locations.get(friend_id)
                user_info["travel_mode"] = travel_modes.get(friend_id)
                response.append(user_info)

        return response

    @staticmethod
    def _send_first_travel_notification(userID, source_lat, source_long, dest_lat, dest_long, frequency, timestamp):
        TravelModeDetailsRepository.add_location_details(
            userID, source_lat, source_long, dest_lat, dest_long, frequency, timestamp
        )
        print("\n\nFirst Notification Sent.")

        user_details = UsersRepository.get_user_by_id(userID)

        source_location = f"https://www.google.com/maps?q={source_lat},{source_long}"
        destination_location = f"https://www.google.com/maps?q={dest_lat},{dest_long}"

        notification_client.send_travel_alert_notification(
            user_id=userID,
            message= f"{user_details['first_name']} is traveling. You'll be notified again in {frequency} mins.",
            email_message=f"""{user_details['first_name']} has started traveling. You can track their journey in real time via our app.<br><br>Stay updated with live location and notifications.<hr>Location Details : Click to view<br><br><a href =\"{source_location}\">Source Location</a><br><br><a href =\"{destination_location}\">Destination Location</a>"""
)

    @staticmethod
    def _send_periodic_travel_notification(userID, source_lat, source_long, dest_lat, dest_long, frequency, timestamp):
        interval_seconds = frequency * 60
        last_timestamp_str = TravelModeDetailsRepository.check_last_message_timestamp(userID)

        if not last_timestamp_str:
            return  # No previous notification, so nothing to compare against

        try:
            last_timestamp = datetime.fromisoformat(last_timestamp_str)
            timestamp_iso = datetime.fromisoformat(timestamp)
            time_difference = (timestamp_iso - last_timestamp).total_seconds()
            print(f"Time since last notification: {time_difference} seconds")

            if time_difference >= interval_seconds:
                print("\n\nNotification sent.")
                TravelModeDetailsRepository.add_location_details(
                    userID, source_lat, source_long, dest_lat, dest_long, frequency, timestamp
                )
                user_details = UsersRepository.get_user_by_id(userID)

                source_location = f"https://www.google.com/maps?q={source_lat},{source_long}"
                destination_location = f"https://www.google.com/maps?q={dest_lat},{dest_long}"

                notification_client.send_travel_alert_notification(
                    user_id=userID,
                    message=f"{frequency} mins have passed. Check {user_details['first_name']}'s location for safety."
                )
        except ValueError as e:
            print(f"Error parsing last_notification_timestamp: {last_timestamp_str} | Exception: {e}")


    @staticmethod
    def turn_off_travel_mode(userID: int):
        try:
            result = TravelModeDetailsRepository.turnOffTravelMode(userID)

            if result is None:
                return None  # User not found
            elif result is False:
                return False  # Travel mode already off
            else:
                user = UsersRepository.get_user_by_id(user_id=userID)
                user_name = user['first_name'] + user['last_name']
                notification_client.send_travel_alert_notification(
                    user_id=userID,
                    message=f"{user_name} turned off travel mode"
                )
                return True  # Successfully turned off travel mode

        except Exception as e:
            print(f"Error in LocationService.turn_off_travel_mode: {e}")
            return None



