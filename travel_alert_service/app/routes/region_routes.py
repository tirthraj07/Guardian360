from fastapi import APIRouter, HTTPException
from app.services.police_regions_service import PoliceRegionService
from app.models.user_id_model import UserIDModel
from app.methods.adaptive_location_alert import handle_adaptive_location_alert

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
    
    region_name = result_after_fetching["result"]['region_name']
    high = result_after_fetching["result"]['high']
    moderate = result_after_fetching["result"]['moderate']
    low = result_after_fetching["result"]['low']

    if low is not None and moderate is not None and high is not None:
        print(f"Report Aggregation for Region\nregion_id: {region_id}\nregion_name: {region_name}\nhigh = {high}\nmoderate = {moderate}\nlow = {low}")
        handle_adaptive_location_alert(user_id, region_id, region_name, low, moderate, high)
    
    return result_after_fetching["result"]
