from app.repository.police_regions_repository import PoliceRegionsRepository


class PoliceRegionService:
    
    @staticmethod
    def fetch_authorities_details_by_region_id(id):
        result = PoliceRegionsRepository.get_authorities_details
        
        