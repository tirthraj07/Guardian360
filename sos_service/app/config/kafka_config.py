import os
from kafka import KafkaProducer

KAFKA_IP = "143.110.183.53"
KAFKA_PORT = 9092


if KAFKA_IP or KAFKA_PORT:
    print("KAFKA_IP and KAFKA_PORT defined in evironment variables")
    print(f"KAFKA_IP: {KAFKA_IP}")
    print(f"KAFKA_PORT: {KAFKA_PORT}")
else:
    print(f"KAFKA_IP and KAFKA_PORT not defined in environment variables")
    exit(1)


producer = KafkaProducer(
    bootstrap_servers=[f'{KAFKA_IP}:{KAFKA_PORT}'],
    value_serializer = lambda v: v.encode('utf-8')
)