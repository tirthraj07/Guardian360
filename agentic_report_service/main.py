from dotenv import load_dotenv

load_dotenv()
import asyncio
from config.kafka_config import BaseConsumer

consumer = BaseConsumer()


async def main():
    await consumer.consume_messages()


if __name__ == "__main__":
    asyncio.run(main())
