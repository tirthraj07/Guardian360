from app.database.supabase import supabase

class FriendRelationsRepository:
    @staticmethod
    def get_friends(user_id):
        friends = supabase.table("friend_relations").select("friendID").eq("userID", user_id).execute()
        return [friend["friendID"] for friend in friends.data] if friends.data else []

    @staticmethod
    def add_friend(user_id, friend_id):

        print(f"Amey : {friend_id}")
        print(f"Advait : {user_id}")
        
        response = supabase.table("friend_relations").insert({
            "userID": user_id, 
            "friendID": friend_id
        }).execute()

        # Remove from pending friend requests after adding as a friend
        supabase.table("pending_friend_relations").delete().eq("senderID", user_id).eq("receiverID", friend_id).execute()

        return {"valid": True, "message": "Friend added successfully"} if response.data else {"valid": False, "message": "Failed to add friend"}
