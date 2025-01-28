import queue

# Define a queue for communication (this can be a global variable or passed around as needed)
sms_queue = queue.Queue()

# TODO: get phone number from recipient_id and then send it via websocket

def send_sms(recipient, message, event_type):
    # Create an object to hold the SMS data
    sms_data = {
        'recipient': recipient,
        'message': message,
        'event_type': event_type
    }
    # Add the data to the queue
    sms_queue.put(sms_data)
    print(f"SMS data added to queue: {sms_data}")
