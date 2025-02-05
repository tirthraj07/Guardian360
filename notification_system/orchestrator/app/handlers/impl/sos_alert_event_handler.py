from app.handlers.event_handler import EventHandler

from app.services.notification_service import NotificationService
from app.services.user_service import UserService
from app.models.notification_model import NotificationModel

class SOSAlertEventHandler(EventHandler):
    def __init__(self, notification: NotificationModel):
        super().__init__(notification)

    def process_recipients(self):
        user_id = self.metadata.get('userID', None)
        location:dict = self.metadata.get('location', None)
        latitude = location.get('lat', None) if location else None
        longitude = location.get('long', None) if location else None

        if user_id is None:
            raise Exception("Metadata required. metadata : {userID (MANDATORY), location: {lat, long} (OPTIONAL)}")
        
        friend_ids = UserService.get_friend_ids(user_id)
    
        # TODO: Add authorities user_ids in recipients as well
        self.recipients = friend_ids

    def set_priority(self):
        self.priority = 1

    def set_partition(self):
        self.partition_key = 0

    def set_notification_channels(self):
        self.recipients_data = []  # To store the final list of recipients with their channels
        
        for user_id in self.recipients:
            # Fetch user preferences for notifications
            user_preferences = NotificationService.get_user_notification_preferences(user_id)
            
            # Filter preferences for the current event type
            channels = []
            for preference in user_preferences:
                if preference["notification_type_id"] == self.partition_key:  
                    for service in preference["services"]:
                        if service["is_enabled"]:
                            channels.append(service["service_name"])
            
            # Add the processed data for the user
            if len(channels) > 0:
                self.recipients_data.append({
                    "user_id": user_id,
                    "channels": channels
                })

    def create_notification_event(self):
        self.kafka_message = {
            "event_id": self.event_id,
            "event_type": self.event_type,
            "priority": self.priority,
            "message": self.message,
            "recipients": self.recipients_data,
            "email_message" : self.email_message,
            "sms_message" : self.sms_message,
            "inapp_message" : self.inapp_message,
            "push_message" : self.push_message
        }
