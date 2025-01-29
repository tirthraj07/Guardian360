from dotenv import load_dotenv
load_dotenv()
import os
# if os.getenv("MONGO_URL"):
#     print("MongoDB uri found")
# else:
#     print("Error: MongoDB URI not found")
#     exit(1)

from fastapi import FastAPI
from app.routes.incident_routes import router as incident_router

app = FastAPI()

app.include_router(incident_router)


# uvicorn app.main:app --reload --port 8001 --host 0.0.0.0