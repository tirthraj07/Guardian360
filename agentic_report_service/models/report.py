from pydantic import BaseModel
from models.emergency_description import EmergencyDescription


class Report(BaseModel):
    description: EmergencyDescription
    severity_score: int

