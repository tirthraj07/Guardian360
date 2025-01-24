from fastapi import FastAPI

from app.routers.incident_router import router as incident_router

app = FastAPI()

app.include_router(incident_router)


# uvicorn app.main:app --reload --port 8001 --host 0.0.0.0