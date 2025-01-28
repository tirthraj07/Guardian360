from queue import PriorityQueue

class PriorityQueueManager:
    priority_queue = PriorityQueue()

    @classmethod
    def add_message(cls, priority, message):
        cls.priority_queue.put((priority, message))

    @classmethod
    def process_queue(cls):
        while not cls.priority_queue.empty():
            _, message = cls.priority_queue.get()
            print(f"Processing message: {message}")
            for recipient in message['recipients']:
                for channel in recipient['channels']:
                    event_type = message['event_type']
                    cls.send_notification(channel, recipient, message, event_type)

    @staticmethod
    def send_notification(channel, recipient, message, event_type):
        # Route to specific services
        if channel == "Email":
            from services.email_service import send_email
            send_email(recipient["user_id"], message["message"], event_type)
        elif channel == "SMS":
            from services.sms_service import send_sms
            send_sms(recipient["user_id"], message["message"], event_type)
        elif channel == "Push Notifications":
            from services.push_service import send_push
            send_push(recipient["user_id"], message["message"], event_type)
        elif channel == "InApp":
            from services.inapp_service import send_inapp
            send_inapp(recipient["user_id"], message["message"], event_type)
