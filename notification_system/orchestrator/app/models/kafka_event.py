from pydantic import BaseModel, ValidationError

class KafkaEvent(BaseModel):
    event_id: str
    event_type: str
    priority: int
    message: str
    recipients: list