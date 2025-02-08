import os
import threading
import asyncio
from flask import Blueprint, jsonify, request, make_response, current_app
from pydantic import ValidationError

# Models
from app.models.mobile_app_sos_model import MobileAppSos
from app.models.button_sos_data import ButtonSosData
from app.models.sos_video_receive_model import SosVideoReceive

# Services
from app.services.sos_receive_service import SosReceiveService
from app.services.sos_video_service import SosVideoService
from app.services.poker_service import PokerService


api = Blueprint('api', __name__)

UPLOAD_FOLDER = 'uploads'

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
    
    
@api.route('/sos/<int:userID>/video', methods=['POST'])
def sos_signal_video_receive(userID: int):
    if 'video' not in request.files:
        return jsonify({"error": "No video file found"}), 400
    
    video = request.files['video']  
    user_id = userID

    if video.filename == '':
        return jsonify({"error": "No selected file"}), 400

    # Save the video file
    file_path = os.path.join(UPLOAD_FOLDER, f"video_{user_id}.mp4")
    video.save(file_path)
    
    threading.Thread(target=SosVideoService.async_video_tasks, args=(userID,)).start()
    
    # asyncio.run(SosVideoService.async_video_tasks(user_id))

    return jsonify({"message": "Video uploaded successfully"}), 200


@api.route("/poke/<int:receiver_id>", methods=["POST"])
def create_poke_request(receiver_id):
    data = request.get_json()
    sender_poker_id = data.get("sender_poker_id")
    
    if not sender_poker_id:
        return jsonify({"success": False, "message": "Sender ID is required."}), 400
    
    
    return jsonify(PokerService.poke_friend(sender_poker_id, receiver_id))

@api.route("/poke/status/<int:receiver_id>", methods=["POST"])
def get_poke_status(receiver_id):
    data = request.get_json()
    sender_poker_id = data.get("sender_poker_id")
    
    if not sender_poker_id:
        return jsonify({"success": False, "message": "Sender ID is required."}), 400
    
    
    return jsonify(PokerService.get_poke_status(sender_poker_id, receiver_id))

@api.route("/poke/acknowledge/<int:receiver_id>", methods=["POST"])
def acknowledge_poke_request(receiver_id):

    return jsonify(PokerService.acknowledge_poke_request(receiver_id))