# friend_relation_repository -> friend_relations table
from app.database.supabase import supabase

class FriendRelationRepository:
    @staticmethod
    def get_friend_ids(userID):
        friends_of_user = supabase.table("friend_relations").select("friendID").eq("userID", userID).execute()
        friend_ids = [entry['friendID'] for entry in friends_of_user.data] if friends_of_user.data else []
        return friend_ids