import threading
import queue
import time
from flask import Flask
from flask_socketio import SocketIO

# Since the server is running as a THREAD rather than as a seperate process, we can use the fact that it "SHARES" memory
# So i can just import a queue from one of the services and poll from it

# Queues
from services.sms_service import sms_queue

app = Flask(__name__)
socketio = SocketIO(app)

def process_sms_queue():
    while True:
        if not sms_queue.empty():
            sms_data = sms_queue.get()  
            recipient = sms_data['recipient']
            message = sms_data['message']
            event_type = sms_data['event_type']
            
            socketio.emit('sms_event', {'recipient': recipient, 'message': message, 'event_type': event_type})
            print(f"Sent SMS data over WebSocket: {sms_data}")
        
        time.sleep(1)

threading.Thread(target=process_sms_queue, daemon=True).start()

@app.route('/')
def index():
    return 'Hello World!'

if __name__ == '__main__':
    # Start Flask server
    socketio.run(app, host="0.0.0.0", port=3000)