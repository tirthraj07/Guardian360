from dotenv import load_dotenv
load_dotenv()
import asyncio
from loguru import logger
from repository.police_regions import PoliceRegions



class Aggregator:

    def __init__(self):
        self.repository = PoliceRegions()

    async def scheduled_processing(self):
        """Main aggregation loop that runs every hour"""
        while True:
            logger.info("Starting aggregation")
            try:
                await self.repository.add_severity_score()
            except Exception as e:
                logger.error(f"Error in aggregation: {str(e)}")

            logger.warning("WAITING")
            # Wait for 1 hour before next run
            await asyncio.sleep(3600)  # 3600 seconds = 1 hour


async def main():
    service = Aggregator()
    logger.info("Aggregation Service started")
    await service.scheduled_processing()


if __name__ == "__main__":
    asyncio.run(main())