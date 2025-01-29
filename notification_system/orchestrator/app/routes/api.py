from flask import Blueprint, jsonify, request, make_response
from pydantic import ValidationError

# Models
from app.models.notification_model import NotificationModel, EventType

# Services
from app.services.user_service import UserService
from app.services.notification_service import NotificationService
from app.services.inapp_notification_service import InAppNotificationService

# Event Handlers
from app.handlers.event_handler import EventHandler
from app.handlers.impl.sos_alert_event_handler import SOSAlertEventHandler
from app.handlers.impl.travel_alert_event_handler import TravelAlertEventHandler
from app.handlers.impl.adaptive_location_alert_event_handler import AdaptiveLocationAlertEventHandler   
from app.handlers.impl.generic_alert_event_handler import GenericAlertEventHandler


api = Blueprint('api', __name__)

@api.route('/')
def index():
    return jsonify({
        'message': 'Notification Service API Route'
    })

@api.route('/notification', methods=['POST'])
def notify():    
    try:
        body = request.get_json()
        notification = NotificationModel(**body)

        if(notification.event_type not in EventType.__members__):
            return make_response(jsonify({
                'success': False,
                'message': f'Invalid event type!. Valid event types are: {", ".join(EventType.__members__)}'
            }), 400)


        event_handler: EventHandler = None
        if notification.event_type.upper() == "SOS":
            event_handler = SOSAlertEventHandler(notification)
        elif notification.event_type.upper() == "TRAVEL_ALERT":
            event_handler = TravelAlertEventHandler(notification)
        elif notification.event_type.upper() == "ADAPTIVE_LOCATION_ALERT":
            event_handler = AdaptiveLocationAlertEventHandler(notification)
        elif notification.event_type.upper() == "GENERIC":
            event_handler = GenericAlertEventHandler(notification)
        else:
            raise Exception(f"Event type: {notification.event_type} not hanlded in handle_notifications")
        
        kafka_message = event_handler.handle_event()

        return make_response(jsonify({
            'success': True,
            'message': 'Notification received successfully!',
            'kafka_message' : kafka_message
        }), 200)

    except ValidationError as e:
        return make_response(jsonify({
            'success': False,
            'message': 'Invalid payload!',
            'errors': e.errors()
        }), 400)
    
    except Exception as e:
        return make_response(jsonify({
            'success': False,
            'message': 'An error occurred!',
            'error': str(e)
        }), 500)
    
@api.route('/<user_id>', methods=['GET'])
def get_user(user_id):
    try:
        user = UserService.get_user_by_id(user_id)
        if(user is None):
            return make_response(jsonify({
                'success': False,
                'message': 'User not found!'
            }), 404)

        return make_response(jsonify({
            'success': True,
            'message': 'User retrieved successfully!',
            'user': user
        }), 200)
    
    except Exception as e:
        return make_response(jsonify({
            'success': False,
            'message': 'An error occurred!',
            'error': str(e)
        }), 500)

@api.route('/<user_id>/friends', methods=['GET'])
def get_friends(user_id):
    try:
        friends = UserService.get_friends(user_id)
        return make_response(jsonify({
            'success': True,
            'message': 'Friends retrieved successfully!',
            'friends': friends
        }), 200)
    
    except Exception as e:
        return make_response(jsonify({
            'success': False,
            'message': 'An error occurred!',
            'error': str(e)
        }), 500)
    

@api.route('/<user_id>/notifications/preferences', methods=['GET'])
def get_notification_preferences(user_id):
    try:
        preferences = NotificationService.get_user_notification_preferences(user_id)
        return make_response(jsonify({
            'success': True,
            'message': 'Notification preferences retrieved successfully!',
            'preferences': preferences
        }), 200)
    
    except Exception as e:
        return make_response(jsonify({
            'success': False,
            'message': 'An error occurred!',
            'error': str(e)
        }), 500)
    
@api.route('/<user_id>/notifications/inapp', methods=['GET'])
def get_user_inapp_notifications(user_id):
    
    only_unread = request.args.get("only_unread", "false").lower() == "true"

    valid_types = ["sos", "adaptive_location_alert", "travel_alert", "generic", "all"]
    notif_type = request.args.get("type", "all").lower()

    if notif_type not in valid_types:
        notif_type = "all"

    try:
        if notif_type == "all":
            notifications = InAppNotificationService.get_all_notifications(user_id=user_id) if not only_unread else InAppNotificationService.get_all_unread_notifications(user_id=user_id)
    
        elif notif_type == "sos":
            notifications = InAppNotificationService.get_sos_notifications(user_id=user_id) if not only_unread else InAppNotificationService.get_unread_sos_notifications(user_id=user_id)
        
        elif notif_type == "adaptive_location_alert":
            notifications = InAppNotificationService.get_adaptive_location_notifications(user_id=user_id) if not only_unread else InAppNotificationService.get_unread_adaptive_location_notifications(user_id=user_id)
        
        elif notif_type == "travel_alert":
            notifications = InAppNotificationService.get_travel_alert_notifications(user_id=user_id) if not only_unread else InAppNotificationService.get_unread_travel_alert_notifications(user_id=user_id)
        
        elif notif_type == "generic":
            notifications = InAppNotificationService.get_generic_notifications(user_id=user_id) if not only_unread else InAppNotificationService.get_unread_generic_notifications(user_id=user_id)
        
        response = make_response(jsonify(
            {
                "status":"success", 
                "message":"notifications retrieved successfully", 
                "notifications":notifications
            }
        ))
        response.status_code = 200
        return response

    except Exception as e:
        print("There was an error while fetching inapp notifications")
        print(f"Args: \nuser_id : {user_id}\nonly_unread: {only_unread}\nnotif_type: {notif_type}")
        print(f"Error: {e}")
        response = make_response(jsonify(
            {
                "status":"error", 
                "message":"Internal Server Error"
                }
            ))
        response.status_code = 500
        return response

@api.route('<user_id>/notifications/inapp/read', methods=['PUT'])
def set_all_inapp_notifications_as_read(user_id):
    try:
        result = InAppNotificationService.mark_all_notifications_as_read(user_id=user_id)
        if result.get("status") == "success":
            return make_response(jsonify({"status":"success", "message":"marked all notifications as read"}), 200)
        else:
            print(result.get("message"))
            return make_response(jsonify({"status":"error", "message":"failed to mark notifications as read"}), 404)
    except Exception as e:
        print(f"Error while updating read status of inapp notifications for userID {user_id}")
        print(f"Error: {e}")
        return make_response(jsonify({"status":"error", "message":f"Error: {e}"}), 500)