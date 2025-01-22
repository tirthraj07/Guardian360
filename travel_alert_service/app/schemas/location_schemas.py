from datetime import datetime
from pydantic import BaseModel

class TrackLocation(BaseModel):
    latitude: float
    longitude: float
    timestamp: datetime

class FriendLocation(BaseModel):
    userID: int
