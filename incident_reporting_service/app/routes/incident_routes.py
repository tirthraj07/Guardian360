from fastapi import APIRouter, status
from app.services.incident_service import IncidentService
from app.models.inicident_reporting_model import IncidentCreate

router = APIRouter(
    tags=['incident reporting routes'],
    prefix='/incident'
)

@router.get('/types')
def get_all_types():
    types = IncidentService.get_all_types()
    return {"types": types}

@router.get('/{typeID}/subtypes')
def get_all_subtypes(typeID: int):
    subtypes = IncidentService.get_all_subtypes(typeID)
    return {"sub_types": subtypes}

@router.post('/report', status_code=status.HTTP_201_CREATED)
def create_incident(request: IncidentCreate):
    userID = request.userID
    typeID = request.typeID
    subtypeID = request.subtypeID
    description = request.description
    latitude = request.latitude
    longitude = request.longitude
    place_name = request.place_name

    incident = IncidentService.create_incident_report(userID, typeID, subtypeID, description, latitude, longitude, place_name)

    return {"status": "Incident report created successfully", "incident": incident}
