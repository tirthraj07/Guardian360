from typing import List
from pydantic import BaseModel, EmailStr
from typing import Optional
from pydantic import BaseModel, EmailStr

class IncidentCreate(BaseModel):
    userID: int
    typeID: int
    subtypeID: int
    description: str
    latitude: float
    longitude: float
    place_name: str