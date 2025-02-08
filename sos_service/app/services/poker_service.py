from app.repository.poke_user_requests_repository import PokeUserRequestsRepository

class PokerService:
    @staticmethod
    def poke_friend(sender_poker_id, receiver_poker_id):
        try:
            response = PokeUserRequestsRepository.send_poke_request(sender_poker_id, receiver_poker_id)
            if response:
                return {"success": True, "message": "Poke request sent successfully."}
            else:
                return {"success": False, "message": "Failed to send poke request."}
        except Exception as e:
            return {"success": False, "message": f"An error occurred: {str(e)}"}
        
    @staticmethod
    def get_poke_status(sender_poker_id, receiver_poker_id):
        try:
            response = PokeUserRequestsRepository.get_poke_status(sender_poker_id, receiver_poker_id)
            if response:
                return response[0]
            else:
                return {"success": False, "message": "No status found."}
        except Exception as e:
            return {"success": False, "message": f"An error occurred: {str(e)}"}
        
    @staticmethod
    def acknowledge_poke_request(receiver_poker_id):
        try:
            response = PokeUserRequestsRepository.acknowledge_poke_request(receiver_poker_id)
            if response:
                return {"success": True, "message": "Acknowledgement status updated"}
            else:
                return {"success": False, "message": "No status found."}
        except Exception as e:
            return {"success": False, "message": f"An error occurred: {str(e)}"}