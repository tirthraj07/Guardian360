from pydantic import BaseModel, Field
from typing import Optional, Dict, List, Any
from enum import Enum

class EventTypes(Enum):
    SOS = "SOS"
    ADAPTIVE_LOCATION_ALERT = "ADAPTIVE_LOCATION_ALERT"
    TRAVEL_ALERT = "TRAVEL_ALERT"
    GENERIC = "GENERIC"

class EventMetadata(BaseModel):
    userID: Optional[int] = None
    recipient_ids: Optional[List[int]] = []


class NotificationModel(BaseModel):
    event_id: str = Field(..., description="Unique identifier for the event")
    event_type: str = Field(..., description="Type of event")
    event_from: str = Field(..., description="Source of the event")
    message: str = Field(..., description="Main event message")
    
    email_message: Optional[str] = None
    sms_message: Optional[str] = None
    inapp_message: Optional[str] = None
    push_message: Optional[str] = None
    
    timestamp: str = Field(..., description="Event timestamp in ISO format")
    metadata: Optional[Dict[str, Any]] = None