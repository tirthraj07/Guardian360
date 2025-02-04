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
from app.utils.notification_service import NotificationServiceUtils

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
            
            # Update the location in Database
            CurrentLocationRepository.update_location(
                user_id=userID, 
                latitude=latitude, 
                longitude=longitude, 
                timestamp=timestamp
            )
            print(f"Location updated in DATABASE: UserID {userID}, Lat {latitude}, Long {longitude}, Time {timestamp}")

            # Update the police region in cache
            police_region = PoliceRegionsRepository.find_police_region(latitude, longitude)
            print(police_region)
            if police_region.get("status") != "success":
                print("Error while fetching police_regions")
                police_region["_id"] = None

            police_region_id = police_region['_id']
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
        
        THRESHOLD_DISTANCE = 40  # in metres
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

        users = UsersRepository.get_users_by_ids(user_ids=friend_ids)
        user_map = {user["userID"]: user for user in users}
    
        # Check the cache for the friend's current location
        cached_locations = {}
        for friend_id in friend_ids:
            cached_location = UserCacheRepository.get_user_location(friend_id)
            if cached_location:
                cached_locations[friend_id] = cached_location

        # Find missing locations (not in cache)
        missing_friend_ids = [fid for fid in friend_ids if fid not in cached_locations]
        db_locations = CurrentLocationRepository.get_location_by_user_ids(user_ids=missing_friend_ids)

        for loc in db_locations:
            cached_locations[loc["userID"]] = loc

        response = []
        for friend_id in friend_ids:
            if friend_id in user_map:  # ✅ Ensure the user exists
                user_info = user_map[friend_id].copy()
                user_info["location"] = cached_locations.get(friend_id)
                response.append(user_info)

        return response

    @staticmethod
    def _send_first_travel_notification(userID, source_lat, source_long, dest_lat, dest_long, frequency, timestamp):
        TravelModeDetailsRepository.add_location_details(
            userID, source_lat, source_long, dest_lat, dest_long, frequency, timestamp
        )
        print("\n\nFirst Notification Sent.")
        NotificationServiceUtils.send_travel_alert_notification(
            user_id=userID, message=f"UserID: {userID} turned on travel mode"
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
        except ValueError as e:
            print(f"Error parsing last_notification_timestamp: {last_timestamp_str} | Exception: {e}")


