from app.repository.inapp_notifications_repository import InAppNotificationsRepository
from app.models.notification_model import NotificationTypesEnum

class InAppNotificationService:
    
    @staticmethod
    def get_notification_by_notification_id(notification_id):
        return InAppNotificationsRepository.get_notifications_by_notification_id(
            notification_id=notification_id
        )
    
    @staticmethod
    def get_all_notifications(user_id):
        return InAppNotificationsRepository.get_notifications_by_user_id(
            user_id=user_id, 
            only_unread=False
        )

    @staticmethod
    def get_all_unread_notifications(user_id):
        return InAppNotificationsRepository.get_notifications_by_user_id(
            user_id=user_id, 
            only_unread=True
        )

    @staticmethod
    def get_sos_notifications(user_id):
        return InAppNotificationsRepository.get_user_notifications_by_notification_type(
            user_id=user_id, 
            notification_type_id=NotificationTypesEnum.SOS.value, 
            only_unread=False
        )

    @staticmethod
    def get_unread_sos_notifications(user_id):
        return InAppNotificationsRepository.get_user_notifications_by_notification_type(
            user_id=user_id, 
            notification_type_id=NotificationTypesEnum.SOS.value, 
            only_unread=True
        )

    @staticmethod
    def get_adaptive_location_notifications(user_id):
        return InAppNotificationsRepository.get_user_notifications_by_notification_type(
            user_id=user_id, 
            notification_type_id=NotificationTypesEnum.ADAPTIVE_LOCATION_ALERT.value, 
            only_unread=False
        )

    @staticmethod
    def get_unread_adaptive_location_notifications(user_id):
        return InAppNotificationsRepository.get_user_notifications_by_notification_type(
            user_id=user_id, 
            notification_type_id=NotificationTypesEnum.ADAPTIVE_LOCATION_ALERT.value, 
            only_unread=True
        )

    @staticmethod
    def get_travel_alert_notifications(user_id):
        return InAppNotificationsRepository.get_user_notifications_by_notification_type(
            user_id=user_id, 
            notification_type_id=NotificationTypesEnum.TRAVEL_ALERT.value, 
            only_unread=False
        )

    @staticmethod
    def get_unread_travel_alert_notifications(user_id):
        return InAppNotificationsRepository.get_user_notifications_by_notification_type(
            user_id=user_id,
            notification_type_id=NotificationTypesEnum.TRAVEL_ALERT.value,
            only_unread=True
        )

    @staticmethod
    def get_generic_notifications(user_id):
        return InAppNotificationsRepository.get_user_notifications_by_notification_type(
            user_id=user_id,
            notification_type_id=NotificationTypesEnum.GENERIC.value,
            only_unread=False
        )

    @staticmethod
    def get_unread_generic_notifications(user_id):
        return InAppNotificationsRepository.get_user_notifications_by_notification_type(
            user_id=user_id,
            notification_type_id=NotificationTypesEnum.GENERIC.value,
            only_unread=True
        )
    
    @staticmethod
    def mark_all_notifications_as_read(user_id):
        return InAppNotificationsRepository.mark_all_notifications_as_read(user_id=user_id)

