import os
from supabase import create_client, Client

url: str = os.environ.get("SUPABASE_URL", default=None)
key: str = os.environ.get("SUPABASE_KEY", default=None)

if url == None or key == None:
    print(f"CRITICAL ERROR: SUPABASE_KEY and/or SUPABASE_URL not defined in environment variable")
    exit(1)

supabase: Client = create_client(url, key)