from datetime import datetime
from pydantic import BaseModel

class TrackLocation(BaseModel):
    userID: int
    latitude: float
    longitude: float
    timestamp: datetime
