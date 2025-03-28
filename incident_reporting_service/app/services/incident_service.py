from fastapi import HTTPException, status
from app.repository.incident_types_repository import IncidentTypesRepository
from app.repository.incident_subtypes_repository import IncidentSubTypesRepository
from app.repository.incident_reports_repository import IncidentReportsRepository

class IncidentService:
    @staticmethod
    def get_all_types():
        try:
            types = IncidentTypesRepository.get_all()
            return types
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"An unexpected error occurred while fetching types: {str(e)}"
            )

    @staticmethod
    def get_all_subtypes(typeID: int):
        try:
            subtypes = IncidentSubTypesRepository.get_all_by_type(typeID)
            return subtypes
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"An unexpected error occurred while fetching subtypes: {str(e)}"
            )

    @staticmethod
    def create_incident_report(userID, typeID, subtypeID, description, latitude, longitude, place_name):
        try:

            typeName = IncidentTypesRepository.get_type_by_id(typeID)
            print(f"TypeName : {typeName[0]['type']}")
            subtypeName = IncidentSubTypesRepository.get_sub_type_by_id(subtypeID)
            print(f"subTypeName : {subtypeName[0]['sub_type']}")

            incident = IncidentReportsRepository.create(userID, str(typeName[0]['type']), str(subtypeName[0]['sub_type']), description, latitude, longitude, place_name)
            return incident
        except Exception as e:
            print(f"{str(e)}")
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"An unexpected error occurred while creating the incident report: {str(e)}"
            )
