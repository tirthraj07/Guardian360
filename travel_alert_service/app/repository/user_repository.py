from app.database.supabase import supabase

class UsersRepository:
    @staticmethod
    def get_all_users():
        users = supabase.table("users").select("*").execute()
        return users.data if users.data else []

    @staticmethod
    def get_user_by_id(user_id):
        user = supabase.table("users").select("*").eq("userID", user_id).execute()
        return user.data[0] if user.data else None
    
    @staticmethod
    def get_available_friends(userID):
        friends_of_user = supabase.table("friend_relations") \
            .select("friendID") \
            .eq("userID", userID) \
            .execute()

        friend_ids = [entry['friendID'] for entry in friends_of_user.data]

        pending_friends_of_user = supabase.table("pending_friend_relations") \
            .select("receiverID") \
            .eq("senderID", userID) \
            .execute()

        pending_friend_ids = [entry['receiverID'] for entry in pending_friends_of_user.data]

        all_friend_ids = friend_ids + pending_friend_ids

        response = supabase.table("users") \
            .select("*") \
            .neq('userID', userID) \
            .execute()

        available_users = [
            user for user in response.data if user['userID'] not in all_friend_ids
        ]

        return available_users
    
    
    @staticmethod
    def get_friends_details(userID):
        
        friends_of_user = supabase.table("friend_relations") \
            .select("friendID") \
            .eq("userID", userID) \
            .execute()

        # Debugging: Print the friends_of_user data
        print(f"Friends of user {userID}: {friends_of_user.data}")

        friend_ids = [friend['friendID'] for friend in friends_of_user.data]
        
            # Query user details for each friend
        users = []
        for friend_id in friend_ids:
                user = supabase.table("users").select("*").eq("userID", friend_id).execute()
                users.append(user.data[0])  # Assuming one user per friend_id
        
        # Debugging: Print the users data

        return users
    
