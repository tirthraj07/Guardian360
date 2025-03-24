from confluent_kafka import Consumer, TopicPartition
import os
from services.video_processing_service import VideoProcessingService

KAFKA_IP = os.environ["KAFKA_IP"]
KAFKA_PORT = os.environ["KAFKA_PORT"]


video_processor = VideoProcessingService()

if KAFKA_IP or KAFKA_PORT:
    print("KAFKA_IP and KAFKA_PORT defined in evironment variables")
else:
    print(f"KAFKA_IP and KAFKA_PORT not defined in environment variables")
    exit(1)


class BaseConsumer:
    def __init__(self):
        self.topic = "reports"
        self.consumer = Consumer({
            'bootstrap.servers': f"{KAFKA_IP}:{KAFKA_PORT}",
            'group.id': 'single-consumer-group',
            'enable.auto.commit': False 
        })

        self.consumer.assign([TopicPartition(self.topic, 0)])

    async def consume_messages(self):
        try:
            print(f"Starting Consumers")
            while True:
                msg = self.consumer.poll(timeout=1.0)  # Poll for messages
                if msg is None:
                    continue
                if msg.error():
                    print(f"Consumer error: {msg.error()}")
                    continue
                report_id = msg.value().decode('utf-8')
                print(report_id)
                await video_processor.process_video_from_id(report_id)
            # await video_processor.process_video_from_id("67a7b7fc8942ddf3265ddb03")
        except KeyboardInterrupt:
            print("Stopping consumer...")
        finally:
            self.consumer.close()