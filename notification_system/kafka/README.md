## How to start confluent Kafka container

#### Step 1: Start all services using Docker Compose

```bash
docker-compose up -d
```

#### Step 2: Verify all services are running

```bash
docker ps
```

#### Step 3: Create a Kafka topic named notifications with 4 partitions

```bash
docker exec -it kafka kafka-topics --create --topic notifications --bootstrap-server localhost:9092 --partitions 4 --replication-factor 1
```

#### Step 4: Verifying the Topic

```bash
docker exec -it kafka kafka-topics --describe --topic notifications --bootstrap-server localhost:9092
```

Output:

```bash
Topic: notifications    TopicId: m-IokoCiRjW-q5VLhcZ3rg PartitionCount: 4       ReplicationFactor: 1    Configs:
        Topic: notifications    Partition: 0    Leader: 1       Replicas: 1     Isr: 1
        Topic: notifications    Partition: 1    Leader: 1       Replicas: 1     Isr: 1
        Topic: notifications    Partition: 2    Leader: 1       Replicas: 1     Isr: 1
        Topic: notifications    Partition: 3    Leader: 1       Replicas: 1     Isr: 1
```

#### Step 5: Create a topic `reports` with 1 partition

```bash
docker exec -it kafka kafka-topics --create --topic reports --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
```


#### Send message using a programmatic producer

```python
from confluent_kafka import Producer

# Kafka producer configuration
producer_config = {
    'bootstrap.servers': 'localhost:9092'  # Kafka broker address
}

producer = Producer(producer_config)

# Delivery report callback to confirm successful message delivery
def delivery_report(err, msg):
    if err is not None:
        print(f"Message delivery failed: {err}")
    else:
        print(f"Message delivered to topic {msg.topic()} partition {msg.partition()} at offset {msg.offset()}")

# Send messages to specific partitions
try:
    producer.produce('notifications', key='SOS', value='SOS Alert message', partition=0, callback=delivery_report)
    producer.produce('notifications', key='Adaptive', value='Adaptive Location Alert message', partition=1, callback=delivery_report)
    producer.produce('notifications', key='Travel', value='Travel Alert message', partition=2, callback=delivery_report)
    producer.produce('notifications', key='Generic', value='Generic Alert message', partition=3, callback=delivery_report)

    # Flush the producer to ensure all messages are sent
    producer.flush()
    print("Messages sent to specific partitions.")

except Exception as e:
    print(f"Error producing messages: {e}")

```
