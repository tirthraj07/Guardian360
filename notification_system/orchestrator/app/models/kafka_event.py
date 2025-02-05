from pydantic import BaseModel, ValidationError
from typing import Optional, Dict, List, Any

class KafkaEvent(BaseModel):
    event_id: str
    event_type: str
    priority: int
    message: str
    recipients: list
    email_message: Optional[str] = None
    sms_message: Optional[str] = None
    inapp_message: Optional[str] = None
    push_message: Optional[str] = None