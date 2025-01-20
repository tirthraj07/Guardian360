import datetime
from supabase import create_client, Client

url: str = "https://fwodfpsgrfizmaeonqdk.supabase.co"
key: str = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ3b2RmcHNncmZpem1hZW9ucWRrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzczOTA1MzgsImV4cCI6MjA1Mjk2NjUzOH0.7aBLYaFHrSVLT11ROS-q8sxHheH8iV0wnD8rWxEgkEI"
supabase: Client = create_client(url, key)

def create_verification_code(email: str, code: str):
    expiry_time = datetime.datetime.now() + datetime.timedelta(minutes=10)
    expiry_str = expiry_time.isoformat()

    verification_code_data = {
        "email": email,
        "code": code,
        "expiry": expiry_str
    }
    response = supabase.table("verification_codes").insert(verification_code_data).execute()
    
    return response.data[0] if response.data else None

def get_verification_code(email: str):
    response = supabase.table("verification_codes").select("*").eq("email", email).execute()
    return response.data[0] if response.data else None

def delete_verification_code(email: str):
    response = supabase.table("verification_codes").delete().eq("email", email).execute()
    return response.data[0] if response.data else None

def create_user(first_name: str, last_name: str, email: str, phone_no: str, aadhar_no: str, 
                profile_pic_location: str = "", aadhar_location: str = "", 
                public_key: str = "", private_key: str = "", code: str = ""):
    user_data = {
        "first_name": first_name,
        "last_name": last_name,
        "email": email,
        "phone_no": phone_no,
        "aadhar_no": aadhar_no,
        "profile_pic_location": profile_pic_location,
        "aadhar_location": aadhar_location,
        "public_key": public_key,
        "private_key": private_key,
    }
    response = supabase.table("users").insert(user_data).execute()
    return response.data[0] if response.data else None


def get_all_users():
    response = supabase.table("users").select("*").execute()
    return response.data if response.data else []

def get_user_by_email(email: str):
    response = supabase.table("users").select("*").eq("email", email).execute()
    return response.data[0] if response.data else None