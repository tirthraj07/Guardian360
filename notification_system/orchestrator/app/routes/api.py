from flask import Blueprint, jsonify, request, make_response
from pydantic import ValidationError

# Models
from app.models.notification_model import NotificationModel, EventType

# Services
from app.services.user_service import UserService
from app.services.notification_service import NotificationService

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

        return make_response(jsonify({
            'success': True,
            'message': 'Notification received successfully!',
            'notification' : notification.model_dump()
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