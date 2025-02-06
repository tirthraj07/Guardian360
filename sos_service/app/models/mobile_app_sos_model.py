from datetime import datetime
from pydantic import BaseModel, Field, ValidationError
from typing import Optional, Dict, List, Any

from app.models.location_model import LocationUser

class MobileAppSos(BaseModel):
    userID: int
    location: LocationUser
    created_at : datetime = Field(default_factory=datetime.now)
    notify_regional_users : bool