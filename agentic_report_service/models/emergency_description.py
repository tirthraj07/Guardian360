from pydantic import BaseModel


class EmergencyDescription(BaseModel):
    summary: str
    threat_assessment: str
    emergency_response: str
    location_details: str
    critical_information: str
