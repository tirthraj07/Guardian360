import os
from supabase import create_client, Client

if os.getenv('SUPABASE_URL') and os.getenv('SUPABASE_KEY'):
    print("SUPABASE Credentials defined")
else:
    print("Error")
    exit(1)


url: str = os.environ['SUPABASE_URL']
key: str = os.environ['SUPABASE_KEY']
supabase: Client = create_client(url, key)
