from abc import ABC, abstractmethod
from app.models.notification_model import NotificationModel
from app.config.kafka_config import producer
from pydantic import ValidationError
from app.models.kafka_event import KafkaEvent

class EventHandler(ABC):
    def __init__(self, notification: NotificationModel):
        self.event_id = notification.event_id
        self.event_type = notification.event_type
        self.event_from = notification.event_from
        self.message = notification.message
        self.timestamp = notification.timestamp
        self.metadata = notification.metadata
        self.kafka_message = None

    @abstractmethod
    def process_recipients(self):
        pass
    
    @abstractmethod
    def set_priority(self):
        pass    

    @abstractmethod
    def set_partition(self):
        pass

    @abstractmethod
    def set_notification_channels(self):
        pass

    @abstractmethod
    def create_notification_event(self):
        pass

    def send_to_kafka(self):
        try:
            if self.kafka_message is None:
                raise Exception("No message to send to Kafka")

            kafka_event = KafkaEvent(**self.kafka_message)
            producer.send(
                topic='notifications',
                partition=self.partition_key if self.partition_key is not None else 0,
                value=kafka_event.dict()
            )
            producer.flush()
        except ValidationError as e:
            print(f"Failed to send message to Kafka: {str(e)}")
            print(f"Incorrect message format: {self.kafka_message}")

        except Exception as e:
            print(f"Failed to send message to Kafka: {str(e)}")

    def handle_event(self):
        self.process_recipients()
        self.set_partition()
        self.set_priority()
        self.set_notification_channels()
        self.create_notification_event()
        self.send_to_kafka()
        return self.kafka_message

    
    