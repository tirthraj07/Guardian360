import os
from pymongo import MongoClient

if os.getenv('MONGO_URL'):
    print("MONGO_URL defined")
else:
    print("MONGO_URL not defined in environment variables")
    exit(1)

MONGO_URI=os.environ['MONGO_URL']

client = MongoClient(MONGO_URI, tlsAllowInvalidCertificates=True)

db = client["guardian360db"] 