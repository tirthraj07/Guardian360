from queue import PriorityQueue
import itertools

class PriorityQueueManager:
    priority_queue = PriorityQueue()
    counter = itertools.count()

    @classmethod
    def add_message(cls, priority, message):
        count = next(cls.counter)  # Get a unique sequence number
        cls.priority_queue.put((priority, count, message))  # Add a tie-breaker

    @classmethod
    def process_queue(cls):
        while not cls.priority_queue.empty():
            _, _, message = cls.priority_queue.get()
            print(f"Processing message: {message}")

            event_type = message['event_type']

            msg = message['message']
            email_message = message['email_message'] if message['email_message'] else message["message"]
            sms_message = message['sms_message'] if message['sms_message'] else message["message"]
            inapp_message = message['inapp_message'] if message['inapp_message'] else message["message"]
            push_message = message['push_message'] if message['push_message'] else message["message"]
            
            for recipient in message['recipients']:
                for channel in recipient['channels']:
                    cls.send_notification(channel, recipient, msg, event_type, email_message, sms_message, inapp_message, push_message)

    @staticmethod
    def send_notification(channel, recipient, message, event_type, email_message, sms_message, inapp_message, push_message):
        # Route to specific services
        if channel == "Email":
            from services.email_service import send_email
            send_email(recipient["user_id"], email_message, event_type)
        elif channel == "SMS":
            from services.sms_service import send_sms
            send_sms(recipient["user_id"], sms_message, event_type)
        elif channel == "Push Notifications":
            from services.push_service import send_push
            send_push(recipient["user_id"], push_message, event_type)
        elif channel == "InApp":
            from services.inapp_service import send_inapp
            send_inapp(recipient["user_id"], inapp_message, event_type)
        else:
            print(f"No channel handler present for channel: {channel}")
            print(f"Message : {message} not delivered")
