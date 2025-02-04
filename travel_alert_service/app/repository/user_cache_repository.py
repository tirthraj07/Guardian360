import json
from app.database.redis import redis_client

class UserCacheRepository:
    LOCATION_TTL = 120  # 2 Minutes

    @staticmethod
    def set_user_location(user_id: int, latitude: float, longitude: float, timestamp: str):
        location_data = {
            "latitude": latitude,
            "longitude": longitude,
            "timestamp": timestamp
        }
        json_location_data = json.dumps(location_data)
        print(json_location_data)
        redis_client.set(f"user_location:{user_id}", json_location_data, ex=3600)

    @staticmethod
    def get_user_location(user_id: int):
        location_data = redis_client.get(f"user_location:{user_id}")
        return json.loads(location_data) if location_data else None

    @staticmethod
    def set_key_value(key: str, value: any, expiry: int = 3600):
        redis_client.set(key, json.dumps(value), ex=expiry)

    @staticmethod
    def get_key_value(key: str):
        value = redis_client.get(key)
        return json.loads(value) if value else None

    @staticmethod
    def delete_key(key: str):
        redis_client.delete(key)

    @staticmethod
    def should_update_db(user_id: int):
        """
        Checks if the TTL flag exists. If not, DB needs an update.
        """
        return not redis_client.exists(f"update_db_flag:{user_id}")
    
    @staticmethod
    def set_update_flag(user_id: int):
        """
        Sets a TTL-based flag to determine when DB should be updated next.
        """
        redis_client.setex(f"update_db_flag:{user_id}", UserCacheRepository.LOCATION_TTL, "1")

    @staticmethod
    def set_police_region(user_id: int, police_region_id: str):
        redis_client.set(f"police_region_id:{user_id}", police_region_id, ex=3600)  # Cache for 1 hour

    @staticmethod
    def get_police_region(user_id: int):
        return redis_client.get(f"police_region_id:{user_id}")