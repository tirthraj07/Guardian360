# notification_service -> notification_types_reposiroty -> notification_types table
#                         -> message_services_repository -> message_services table
#                         -> user_notification_preferences_repository -> user_notification_preferences table

from app.repository.notification_types_repository import NotificationTypesRepository
from app.repository.message_services_repository import MessageServicesRepository
from app.repository.user_notification_preferences_repository import UserNotificationPreferencesRepository

class NotificationService:
    @staticmethod
    def get_user_notification_preferences(user_id):
        # Query 1: Fetch all notification types
        notification_types = NotificationTypesRepository.get_all_notification_types()

        # Query 2: Fetch all message services
        message_services = MessageServicesRepository.get_all_message_services()

        # Query 3: Fetch user preferences
        user_preferences = UserNotificationPreferencesRepository.get_user_notification_preferences(user_id)

        # Structure the output
        result = []
        for notification_type in notification_types:
            notification_type_id = notification_type["notification_type_id"]
            notification_name = notification_type["notification_name"]

            services = []
            for service in message_services:
                service_id = service["service_id"]
                service_name = service["service_name"]

                # Find if the user has preferences for this notification type and service
                is_enabled = next(
                    (
                        pref["is_enabled"]
                        for pref in user_preferences
                        if pref["notification_type_id"] == notification_type_id and pref["service_id"] == service_id
                    ),
                    False,  # Default to False if not found
                )
                services.append(
                    {
                        "service_id": service_id,
                        "service_name": service_name,
                        "is_enabled": is_enabled,
                    }
                )

            result.append(
                {
                    "notification_type_id": notification_type_id,
                    "notification_name": notification_name,
                    "services": services,
                }
            )

        return result