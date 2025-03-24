import os
from supabase import create_client, Client

url: str = os.environ.get("SUPABASE_URL")
key: str = os.environ.get("SUPABASE_KEY")

if url and key:
    print("SUPABASE_URL and SUPABASE_KEY found")
else:
    print(f"Please define SUPABASE_URL and SUPABASE_KEY in environment variables")
    exit(1)

supabase: Client = create_client(url, key)


