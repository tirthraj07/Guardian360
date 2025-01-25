from datetime import datetime
from typing import Optional
from pydantic import BaseModel

class TrackLocation(BaseModel):
    latitude: float
    longitude: float
    timestamp: datetime
    travel_mode: Optional[str] = None 

class FriendLocation(BaseModel):
    userID: int

class Location(BaseModel):
    latitude: float
    longitude: float

class KnownPlaceCreate(BaseModel):
    userID: int
    location: Location
    location_name: str
    place_nick_name: str