import datetime
from supabase import create_client, Client

url: str = "https://fwodfpsgrfizmaeonqdk.supabase.co"
key: str = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ3b2RmcHNncmZpem1hZW9ucWRrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzczOTA1MzgsImV4cCI6MjA1Mjk2NjUzOH0.7aBLYaFHrSVLT11ROS-q8sxHheH8iV0wnD8rWxEgkEI"
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

    friends_of_user = supabase.table("pending_friend_relations") \
    .select("receiverID")\
    .eq("senderID", userID) \
    .execute()

    friend_ids = [entry['receiverID'] for entry in friends_of_user.data]

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

