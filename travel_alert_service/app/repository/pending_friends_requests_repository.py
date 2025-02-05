from app.database.supabase import supabase
from app.repository.user_repository import UsersRepository

class PendingFriendRequestsRepository:
    @staticmethod
    def get_pending_requests(user_id):
        response = supabase.table("pending_friend_relations").select("senderID").eq("receiverID", user_id).execute()
        print(response)

        pending_ids =  [entry["senderID"] for entry in response.data] if response.data else []
        pending_requests = UsersRepository.get_users_by_ids(pending_ids)

        print(pending_requests)

        return pending_requests

    @staticmethod
    def add_friend_request(sender_id, receiver_id):
        response = supabase.table("pending_friend_relations").insert({
            "senderID": sender_id, 
            "receiverID": receiver_id
        }).execute()
        return {"valid": True, "message": "Request sent"} if response.data else {"valid": False, "message": "Failed to send request"}
