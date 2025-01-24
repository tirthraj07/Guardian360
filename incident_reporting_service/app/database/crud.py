import datetime
from supabase import create_client, Client

url: str = "https://zbiuahkpbjhknlgrgmwa.supabase.co"
key: str = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpiaXVhaGtwYmpoa25sZ3JnbXdhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc0NDU2ODMsImV4cCI6MjA1MzAyMTY4M30.NoUUFm21JjycyuY62zt-wf2R0T8R__sKTY3-0_7Zv_s"
supabase: Client = create_client(url, key)

def get_all_incident_types():
    response = supabase.table("incident_types").select("*").execute()
    return response.data if response.data else []

def get_all_incident_sub_types(typeID):
    response = supabase.table("incident_sub_types").select("*").eq("typeID", typeID).execute()
    return response.data if response.data else []

def create_incident(userID, typeID, subtypeID, description, latitude, longitude, place_name):
    data = {
        "userID": userID,
        "typeID": typeID,
        "subtypeID": subtypeID,
        "description": description,
        "latitude": latitude,
        "longitude": longitude,
        "place_name": place_name,
    }
    
    response = supabase.table("incident_reports").insert(data).execute()

    return response.data if response.data else []