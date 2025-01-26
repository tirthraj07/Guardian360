import datetime
from fastapi import APIRouter, HTTPException, status

from app.schemas.location_schemas import FriendLocation, KnownPlaceCreate, TrackLocation, UserLocationData
from app.database.crud import add_current_location, add_known_place, add_location_details, check_if_details_exists, check_lastMessagetimestamp, get_friends_location

router = APIRouter(
    tags=['location routes'],
    prefix='/location'
)

from datetime import datetime, timezone

import datetime
from datetime import datetime, timezone

@router.post('/{userID}')
def track_location(userID: int, request: UserLocationData):
    latitude = request.latitude
    longitude = request.longitude
    timestamp = request.timestamp

    travel_details = request.travel_details

    add_current_location(userID, latitude, longitude, timestamp)

    if travel_details is not None:
        source_latitude = travel_details.location_details.source.latitude
        source_longitude = travel_details.location_details.source.longitude

        destination_latitude = travel_details.location_details.destination.latitude
        destination_longitude = travel_details.location_details.destination.longitude

        notification_frequency = travel_details.location_details.notification_frequency

        vehicle_number = travel_details.vehicle_details.vehicle_number
        mode_of_travel = travel_details.vehicle_details.mode_of_travel

        send_first_notification = not check_if_details_exists(userID) # check if isValid

        interval = notification_frequency * 60

        if send_first_notification:
            add_location_details(
                userID, source_latitude, source_longitude, destination_latitude, destination_longitude, notification_frequency, timestamp.isoformat()
            )

        else:
            current_timestamp = timestamp

            last_message_timestamp_str = check_lastMessagetimestamp(userID)

            if last_message_timestamp_str:
                try:
                    last_message_timestamp = datetime.fromisoformat(last_message_timestamp_str)
            
                    time_difference = (current_timestamp - last_message_timestamp).total_seconds()
                    print(f"Time since last notification: {time_difference} seconds")

                    if time_difference >= interval:
                        print("\n\nNotification sent.")
                        response = add_location_details(
                userID, source_latitude, source_longitude, destination_latitude, destination_longitude, notification_frequency, current_timestamp.isoformat()
            )

                except ValueError as e:
                    print(f"Error parsing last_notification_timestamp: {last_message_timestamp_str}")
                    print(f"Exception: {e}")
    else:
        print("Travel Mode Off")
        #Update is Valid or delete row


@router.get('/{userID}/friends')
def track_location(userID: int):


    response = get_friends_location(userID)


    return {"friends" : response}
