import threading
import queue
import time
from flask import Flask, request, jsonify, make_response
from flask_socketio import SocketIO

# Since the server is running as a THREAD rather than as a seperate process, we can use the fact that it "SHARES" memory
# So i can just import a queue from one of the services and poll from it

# Queues
from services.sms_service import sms_queue

app = Flask(__name__)
socketio = SocketIO(app, cors_allowed_origins="*")

def process_sms_queue():
    while True:
        if not sms_queue.empty():
            sms_data = sms_queue.get()
            recipient = sms_data['recipient']
            message = sms_data['message']
            event_type = sms_data['event_type']

            # Log the sending of the event
            print(f"Sending SMS event to WebSocket: {sms_data}")

            # Emit event
            try:
                socketio.emit('sms_event', {'recipient': recipient, 'message': message, 'event_type': event_type})
            except Exception as e:
                print(f"Error emitting event: {e}")
        
        time.sleep(1)


threading.Thread(target=process_sms_queue, daemon=True).start()

@app.route('/')
def index():
    return 'Hello World!'

@app.route('/receive_sms', methods=['POST'])
def receive_sms():
    body = request.get_json()
    print(f"Received sms: {body}")
    return make_response(jsonify({"message":"sms received successfully"}, 201))

if __name__ == '__main__':
    socketio.run(app, host="0.0.0.0", port=3000, debug=True)