import os
from supabase import create_client, Client

url: str = "https://zbiuahkpbjhknlgrgmwa.supabase.co"
key: str = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpiaXVhaGtwYmpoa25sZ3JnbXdhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc0NDU2ODMsImV4cCI6MjA1MzAyMTY4M30.NoUUFm21JjycyuY62zt-wf2R0T8R__sKTY3-0_7Zv_s"
supabase: Client = create_client(url, key)
