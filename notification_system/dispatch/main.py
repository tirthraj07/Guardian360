# Load environment variables
from dotenv import load_dotenv
load_dotenv()


import threading

# Import daemon server
# from daemon_server.server import app, socketio

# Import the Queue
from queue_manager import PriorityQueueManager

# Import Consumers
from consumers.base_consumer import BaseConsumer
from consumers.groups.sos_alert_consumer_group.sos_alert_consumer import SOSAlertConsumer
from consumers.groups.adaptive_location_alert_consumer_group.adaptive_location_alert_consumer import AdaptiveLocationAlertConsumer
from consumers.groups.travel_alert_consumer_group.travel_alert_consumer import TravelAlertConsumer
from consumers.groups.generic_alert_consumer_group.generic_alert_consumer import GenericAlertConsumer

def start_consumers():
    sos_alert_consumer = SOSAlertConsumer()
    adaptive_location_alert_consumer = AdaptiveLocationAlertConsumer()
    travel_alert_consumer = TravelAlertConsumer()
    generic_alert_consumer = GenericAlertConsumer()

    threading.Thread(target=sos_alert_consumer.start, daemon=True).start()
    threading.Thread(target=adaptive_location_alert_consumer.start, daemon=True).start()
    threading.Thread(target=travel_alert_consumer.start, daemon=True).start()
    threading.Thread(target=generic_alert_consumer.start, daemon=True).start()

# def start_flask():
#     print("Daemon Server running on Port 3000")
#     socketio.run(app, host="0.0.0.0", port=3000,)

if __name__ == "__main__":
    # Start consumers
    start_consumers()
    print("Consumers started. Processing messages...")

    # Start Flask app in a separate thread
    # flask_thread = threading.Thread(target=start_flask, daemon=True)
    # flask_thread.start()

    # Process the priority queue in the main thread
    try:
        while True:
            PriorityQueueManager.process_queue()
    except KeyboardInterrupt:
        print("Shutting down...")