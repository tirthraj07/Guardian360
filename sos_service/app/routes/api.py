import threading
from flask import Blueprint, jsonify, request, make_response
from pydantic import ValidationError

from app.models.mobile_app_sos_model import MobileAppSos
from app.models.button_sos_data import ButtonSosData

from app.services.sos_receive_service import SosReceiveService


api = Blueprint('api', __name__)

@api.route('/')
def index():
    return jsonify({
        'message': 'SOS Service API Route'
    })

@api.route('/sos', methods=['POST'])
def sos_signal():

    # STEP - 1 : Decoding X-Token from Header
    xToken = request.headers.get('x-Token')

    if not xToken:
        return {"error": "Missing x-Token"}, 400 

    # Validating Header
    valid_headers = ['MOBILE_APP', 'WIFI_BUTTON', 'SMS_GATEWAY']

    if xToken not in valid_headers:
        return {"error": "Invalid Header"}, 400 
    
    try:
        if xToken == "MOBILE_APP" or xToken == 'SMS_GATEWAY':
            body = request.get_json()
            sos_details = MobileAppSos(**body)

            # Start the background task in a separate thread
            thread = threading.Thread(target=SosReceiveService.handle_mobile_sos, args=(sos_details,))
            thread.start()

        elif xToken == "WIFI_BUTTON":
            body = request.get_json()
            sos_details = ButtonSosData(**body)

            thread = threading.Thread(target=SosReceiveService.handle_button_sos, args=(sos_details,))
            thread.start()

        return jsonify({
            'message': 'SOS message recieved Successfuly'
        })
    except ValidationError as e:
        return jsonify({"error": "Validation failed", "details": e.errors()}), 400

