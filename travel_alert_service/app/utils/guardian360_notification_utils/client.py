import requests         # import pip._vendor.requests 
from pydantic import ValidationError
import json
import logging
import uuid
from dataclasses import asdict
from datetime import datetime

# Exceptions
from .exceptions import (
    NotificationNotInitializedError,
    NotificationIncorrectlyInitializedError,
    IncorrectMetadataFormat
)
# Models
from .models import NotificationModel, EventTypes, EventMetadata

# Logging Configuration
logging.basicConfig(
    format="%(asctime)s [%(levelname)s] %(message)s",
    level=logging.INFO
)

class Guardian360NotificationClient:
    # Public APIs
    def __init__(self, base_url, api_key=None, debug_mode=False):
        self.base_url = base_url
        self.api_key = api_key
        self.debug_mode = debug_mode
        self.__notification = None 
        if self.debug_mode:
            logging.getLogger().setLevel(logging.DEBUG)

        logging.debug("DEBUG MODE ON")

    def send_sos_notification(
            self, 
            user_id: int, 
            message: str, 
            email_message:str = None, sms_message:str = None, 
            inapp_message:str = None, push_message: str = None
        ):
        """Sends an SOS notification."""
        self.send_notification(
            event_type=EventTypes.SOS,
            event_from="guardian.sos_service",
            metadata={"userID": user_id},
            message=message,
            email_message=email_message, sms_message=sms_message,
            inapp_message=inapp_message, push_message=push_message
        )

    def send_travel_alert_notification(
            self, 
            user_id: int, 
            message: str, 
            email_message:str = None, sms_message:str = None, 
            inapp_message:str = None, push_message: str = None
        ):
        """Sends a travel alert notification."""
        self.send_notification(
            event_type=EventTypes.TRAVEL_ALERT,
            event_from="guardian.travel_service",
            metadata={"userID": user_id},
            message=message,
            email_message=email_message, sms_message=sms_message,
            inapp_message=inapp_message, push_message=push_message
        )

    def send_adaptive_location_alert_notification(
            self, 
            user_id: int, 
            message: str, 
            email_message:str = None, sms_message:str = None, 
            inapp_message:str = None, push_message: str = None
        ):
        """Sends an adaptive location alert notification."""
        self.send_notification(
            event_type=EventTypes.ADAPTIVE_LOCATION_ALERT,
            event_from="guardian.adaptive_location_service",
            metadata={"userID": user_id},
            message=message,
            email_message=email_message, sms_message=sms_message,
            inapp_message=inapp_message, push_message=push_message
        )

    def send_generic_notification(
            self, 
            event_from: str, 
            recipient_ids: list, 
            message: str, 
            email_message:str = None, sms_message:str = None, 
            inapp_message:str = None, push_message: str = None
        ):
        """Sends a generic notification."""
        self.send_notification(
            event_type=EventTypes.GENERIC,
            event_from=event_from,
            metadata={"recipient_ids": recipient_ids},
            message=message,
            email_message=email_message, sms_message=sms_message,
            inapp_message=inapp_message, push_message=push_message
        )

    def send_notification(
            self, 
            event_type, event_from, 
            metadata, message, 
            email_message:str = None, sms_message:str = None, 
            inapp_message:str = None, push_message: str = None
        ):
        """Handles the common notification sending logic."""
        try:
            # metadata_obj = metadata
            metadata_obj = EventMetadata(**metadata)
            logging.debug("metadata_obj:")
            logging.debug(metadata_obj)
            # metadata_dict = asdict(metadata_obj)
        except ValidationError as e:
            logging.debug("Invalid format: EventMetadata")
            logging.debug(f"Error: {str(e)}")
            raise IncorrectMetadataFormat()

        self.__generate_notification(
            event_type=event_type,
            event_from=event_from,
            message=message,
            metadata=metadata_obj.dict(),
            email_message=email_message, sms_message=sms_message,
            inapp_message=inapp_message, push_message=push_message
        )
        self.__send_notifications()

    def __generate_notification(self, event_type, event_from, message, metadata, **kwargs):
        """Generates notification payload."""
        self.__notification = {
            "event_id": str(uuid.uuid4()),
            "event_type": str(event_type.value),
            "event_from": event_from,
            "message": message,
            "metadata": metadata,
            "timestamp": datetime.now().isoformat()
        }

        optional_fields = ["email_message", "sms_message", "inapp_message", "push_message"]
        for field in optional_fields:
            if kwargs.get(field):
                self.__notification[field] = kwargs[field]

    def __send_notifications(self):
        """Sends the notification request to the server."""
        if not self.__notification:
            raise NotificationNotInitializedError()

        try:
            logging.debug(self.__notification)
            request_body = NotificationModel(**self.__notification)        # This is where the error is happening

            url = f"{self.base_url}/api/notification"
            if self.api_key:
                url += f"?api_key={self.api_key}"

            headers = {
                "Content-Type": "application/json",
                "Accept": "application/json"
            }

            logging.debug("Sending request to Notification Service..")
            logging.debug(f"POST {url}")
            logging.debug(f"Headers: {headers}")
            
            logging.debug(f"Body: {json.dumps(request_body.dict(), allow_nan=False)}")
            
            response = requests.post(url, json=request_body.dict(), headers=headers)
            logging.debug("Response received from server:")
            logging.debug(response.json())

            response.raise_for_status()

            logging.info(f"Notification sent to Notification Service successfully")
            
        except ValidationError:
            logging.error("Notification initialization failed due to invalid data.")
            raise NotificationIncorrectlyInitializedError()

        except requests.exceptions.RequestException as e:
            logging.error(f"RequestException: {str(e)}")
            raise Exception(f"Notification sending failed: {str(e)}")

        except Exception as e:
            logging.error(f"Notification sending failed: {str(e)}")
            raise e

        finally:
            self.__notification = None 
