from fastapi import APIRouter, HTTPException
from app.services.police_regions_service import PoliceRegionService
router = APIRouter(
    tags=['location routes'],
    prefix='/police-regions'
)

@router.get('/region-data/{region_id}')
def get_region_specific_data(region_id: str):
    
    print(region_id)
    
    PoliceRegionService.fetch_authorities_details_by_region_id(region_id)
    
