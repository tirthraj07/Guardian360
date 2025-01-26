from app.database.supabase import supabase

class PendingFriendRequestsRepository:
    @staticmethod
    def get_pending_requests(user_id):
        response = supabase.table("pending_friend_relations").select("senderID").eq("receiverID", user_id).execute()
        return [entry["senderID"] for entry in response.data] if response.data else []

    @staticmethod
    def add_friend_request(sender_id, receiver_id):
        response = supabase.table("pending_friend_relations").insert({
            "senderID": sender_id, 
            "receiverID": receiver_id
        }).execute()
        return {"valid": True, "message": "Request sent"} if response.data else {"valid": False, "message": "Failed to send request"}
