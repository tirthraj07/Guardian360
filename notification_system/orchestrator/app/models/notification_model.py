from pydantic import BaseModel, ValidationError
from enum import Enum
from typing import Optional, Dict, List, Any

class EventType(Enum):
    SOS = "SOS"
    ADAPTIVE_LOCATION_ALERT = "Adaptive Location Alert"
    TRAVEL_ALERT = "Travel Alert"
    GENERIC = "Generic"

class NotificationModel(BaseModel):
  event_id: str
  event_type: str
  event_from: str
  message: str
  timestamp: str
  metadata: dict
  email_message: Optional[str] = None
  sms_message: Optional[str] = None
  inapp_message: Optional[str] = None
  push_message: Optional[str] = None

class NotificationTypesEnum(Enum):
  SOS = 0
  ADAPTIVE_LOCATION_ALERT = 1
  TRAVEL_ALERT = 2
  GENERIC = 3

'''
Example Payload:
event_type : SOS | ADAPTIVE_LOCATION_ALERT | TRAVEL_ALERT | GENERIC

{
  "event_id": "12345",
  "event_type": "SOS",
  "event_from": "sos_service",
  "message": "Emergency alert triggered!",
  "timestamp": "2025-01-21T12:00:00Z",
  "metadata": {
    "user_id": "67890",
    "location": {"lat": 12.971598, "long": 77.594566}
  }
}
'''