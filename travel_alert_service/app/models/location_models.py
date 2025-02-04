from dataclasses import Field
from datetime import datetime
from typing import Optional
from pydantic import BaseModel

class TrackLocation(BaseModel):
    latitude: float
    longitude: float
    timestamp: datetime
    travel_mode: Optional[str] = None 


class Coordinates(BaseModel):
    latitude: float
    longitude: float


class LocationDetails(BaseModel):
    source: Coordinates
    destination: Coordinates
    notification_frequency: int


class VehicleDetails(BaseModel):
    mode_of_travel: str
    vehicle_number: str


class TravelDetails(BaseModel):
    location_details: LocationDetails
    vehicle_details: VehicleDetails
    distance_to_destination: float


class UserLocationData(BaseModel):
    latitude: float
    longitude: float
    timestamp: datetime
    travel_details: Optional[TravelDetails] = None 

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