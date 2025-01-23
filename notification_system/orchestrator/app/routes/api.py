from flask import Blueprint, jsonify, request, make_response
from pydantic import ValidationError

# Models
from app.models.notification_model import NotificationModel, EventType

# Services
from app.services.user_service import UserService
from app.services.notification_service import NotificationService


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
    

@api.route('/<user_id>/notification_preferences', methods=['GET'])
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