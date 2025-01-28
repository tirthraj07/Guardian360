from confluent_kafka import Consumer, TopicPartition
import json
from queue_manager import PriorityQueueManager

class BaseConsumer:
    def __init__(self, group_id, partition):
        self.group_id = group_id
        self.partition = partition
        self.topic = "notifications"
        self.consumer = Consumer({
            'bootstrap.servers': 'localhost:9092',
            'group.id': group_id,
            'auto.offset.reset': 'earliest'
        })

    def start(self):
        self.consumer.assign([TopicPartition(self.topic, self.partition)])
        print(f"Consumer for {self.group_id} started.")

        try:
            while True:
                msg = self.consumer.poll(timeout=1.0)
                if msg is None:
                    # print(f"Consumer in Consumer Group {self.group_id} Waiting for messages ...")
                    continue
                if msg.error():
                    print(f"Consumer error: {msg.error()}")
                    continue

                key = msg.key().decode('utf-8') if msg.key() else None
                value = msg.value().decode('utf-8') if msg.value() else None
                partition = msg.partition()
                
                if value is None:
                    print(f"Received a message with no value. Key={key}")
                    continue

                print(f"Consumed event from topic {msg.topic()}, partition={partition}, key={key}, value={value}")
                self.process_message(value)
                
        except KeyboardInterrupt:
            print(f"Stopping {self.group_id} consumer...")
        finally:
            self.consumer.close()

    def process_message(self, message):
        try:
            msg_data = json.loads(message)
            PriorityQueueManager.add_message(msg_data["priority"], msg_data)
            print(f"Added to priority queue: {msg_data}")
        except Exception as e:
            print(f"Failed to process message: {e}")
