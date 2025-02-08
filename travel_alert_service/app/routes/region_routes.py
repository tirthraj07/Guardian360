from fastapi import APIRouter, HTTPException
from app.services.police_regions_service import PoliceRegionService
from app.models.user_id_model import UserIDModel
from app.methods.adaptive_location_alert import handle_adaptive_location_alert
from app.repository.current_location_repository import CurrentLocationRepository

router = APIRouter(
    tags=['location routes'],
    prefix='/police-regions'
)

@router.post('/region-data/{region_id}')
def get_region_specific_data(region_id: str, request: UserIDModel):
    user_id = request.userID

    print(f"New Region Contact Route : userID: {user_id} and region_id: {region_id}")

    result_after_fetching = PoliceRegionService.fetch_authorities_details_by_region_id(region_id)

    # If out of region or invalid region_id
    if result_after_fetching['status'] != "success":
        print("Fetching authorities failed")
        print(result_after_fetching["message"])
        raise HTTPException(status_code=404, detail={"message": result_after_fetching["message"]})
        
    return result_after_fetching["result"]


@router.get('/user_id/{user_id}')
def get_region_data_by_id(user_id:int):
    print(f"Fetching new region contacts of user_id {user_id}")
    location = CurrentLocationRepository.get_location_by_user_id(user_id)
    print(location)
    if not location:
        return HTTPException(status_code=401, detail={"message":"failed to fetch user location details"})
    
    region_id = location['police_region_id']
    result_after_fetching = PoliceRegionService.fetch_authorities_details_by_region_id(region_id)

    # If out of region or invalid region_id
    if result_after_fetching['status'] != "success":
        print("Fetching authorities failed")
        print(result_after_fetching["message"])
        raise HTTPException(status_code=404, detail={"message": result_after_fetching["message"]})
        
    return result_after_fetching["result"]