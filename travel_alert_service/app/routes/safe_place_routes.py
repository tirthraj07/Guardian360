from fastapi import APIRouter, status
from app.services.safe_place_service import SafePlaceService
from app.models.location_models import KnownPlaceCreate

router = APIRouter(
    tags=['safe place routes'],
    prefix='/safe-places'
)

@router.post('/create', status_code=status.HTTP_201_CREATED)
def create_safe_place(request: KnownPlaceCreate):
    return SafePlaceService.create_safe_place(request)

@router.get('/{userID}', status_code=status.HTTP_200_OK)
def get_all_safe_places(userID: int):
    return SafePlaceService.get_all_safe_places(userID)
