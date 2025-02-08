from app.repository.police_regions_repository import PoliceRegionsRepository


class PoliceRegionService:
    
    @staticmethod
    def fetch_authorities_details_by_region_id(region_id):
        return PoliceRegionsRepository.get_authorities_details(region_id)
        