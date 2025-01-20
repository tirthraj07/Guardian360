from supabase import create_client, Client

url: str = "https://fwodfpsgrfizmaeonqdk.supabase.co"
key: str = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ3b2RmcHNncmZpem1hZW9ucWRrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzczOTA1MzgsImV4cCI6MjA1Mjk2NjUzOH0.7aBLYaFHrSVLT11ROS-q8sxHheH8iV0wnD8rWxEgkEI"
supabase: Client = create_client(url, key)

response = supabase.table("users").select("*").execute()
print(response)