import datetime
from supabase import create_client, Client

url: str = "https://zbiuahkpbjhknlgrgmwa.supabase.co"
key: str = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpiaXVhaGtwYmpoa25sZ3JnbXdhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc0NDU2ODMsImV4cCI6MjA1MzAyMTY4M30.NoUUFm21JjycyuY62zt-wf2R0T8R__sKTY3-0_7Zv_s"
supabase: Client = create_client(url, key)

def get_all_users():
    response = supabase.table("users").select("*").execute()
    return response.data if response.data else []

def get_available_friends(userID):

    friends_of_user = supabase.table("friend_relations") \
    .select("friendID")\
    .eq("userID", userID) \
    .execute()

    friend_ids = [entry['friendID'] for entry in friends_of_user.data]

    print(f"Friends : {friends_of_user}")

    print(f"Friends of user id {userID}")

    friends_of_user = supabase.table("pending_friend_relations") \
    .select("receiverID")\
    .eq("senderID", userID) \
    .execute()

    print(f"Pending Friends : {friends_of_user}")

    friend_ids.append([entry['receiverID'] for entry in friends_of_user.data])

    response = supabase.table("users") \
    .select("*") \
    .neq('userID', userID) \
    .execute()

    available_users = [
    user for user in response.data if user['userID'] not in friend_ids
]
    return available_users

def add_friend_request(senderID, receiverID):
    response = (
    supabase.table("pending_friend_relations")
    .insert({"senderID": senderID, "receiverID": receiverID})
    .execute()
    )

    print(response.data)
    return response.data if response.data else []

def add_friend(userID, friendID):
    response = (
    supabase.table("friend_relations")
    .insert({"userID": userID, "friendID": friendID})
    .execute()
    )

    response = supabase.table('pending_friend_relations').delete().eq('senderID', userID).eq('receiverID', friendID).execute()

    print(response.data)
    return response.data if response.data else []

def get_pending_requests(userID):
    # Fetch pending friend requests for the given userID
    response = (
        supabase.table("pending_friend_relations")
        .select("senderID")
        .eq("receiverID", userID)
        .execute()
    )

    print(response)

    # Extract pending request user IDs
    pending_user_ids = [entry["senderID"] for entry in response.data] if response.data else []

    if not pending_user_ids:
        return []  # No pending requests

    # Fetch user details individually, selecting only required columns
    pending_users = []
    for user_id in pending_user_ids:
        user_response = (
            supabase.table("users")
            .select("userID, first_name, last_name, email, phone_no, profile_pic_location")
            .eq("userID", user_id)  # Fetch details for each pending friend ID
            .execute()
        )

        if user_response.data:
            pending_users.append(user_response.data[0])  # Append first result

    return pending_users

