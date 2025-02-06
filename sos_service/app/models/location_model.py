from pydantic import BaseModel, ValidationError
from typing import Optional, Dict, List, Any


class LocationUser(BaseModel):
    latitude: float
    longitude: float