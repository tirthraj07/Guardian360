import os

if os.getenv('MONGO_URL'):
    print("mongo url defined")
else:
    print("Error")
    exit(1)

MONGO_URI=os.environ['MONGO_URL']

from pymongo import MongoClient
client = MongoClient(MONGO_URI)

db = client["guardian360db"] 
