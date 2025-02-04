import redis
import os

REDIS_HOST = os.environ['REDIS_HOST']
REDIS_PORT = os.environ['REDIS_PORT']
REDIS_DB_INDEX = os.environ['REDIS_DB_INDEX']

if REDIS_HOST and REDIS_PORT and REDIS_DB_INDEX:
    print("Redis Credentials Found")
else:
    print("Redis Credentials Not Found. Enter : REDIS_HOST, REDIS_PORT, REDIS_DB_INDEX in .env file")
    exit(1)

redis_client = redis.Redis(host='localhost', port=6379, db=0, decode_responses=True)