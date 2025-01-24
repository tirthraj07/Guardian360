from fastapi import APIRouter, HTTPException, status

from app.database.crud import create_incident, get_all_incident_types, get_all_incident_sub_types
from app.schemas.incident_report_schema import IncidentCreate

router = APIRouter(
    tags=['incident reporting routes'],
    prefix='/incident'
)

@router.get('/types')
def get_all_types():

    types = get_all_incident_types()

    return {"types" : types}

@router.get('/{typeID}/subtypes')
def get_all_types(typeID: int):

    types = get_all_incident_sub_types(typeID)

    return {"sub_types" : types}


@router.post('/report', status_code=status.HTTP_201_CREATED)
def get_all_types(request: IncidentCreate):

    userID = request.userID
    typeID = request.typeID
    subtypeID = request.subtypeID
    description = request.description
    latitude = request.latitude
    longitude = request.longitude
    place_name = request.place_name

    response = create_incident(userID, typeID, subtypeID, description, latitude, longitude, place_name)

    return {"status": "Incident report created successfully", "incident": response}

