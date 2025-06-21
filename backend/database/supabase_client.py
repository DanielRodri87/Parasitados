import os
from supabase import create_client, Client

url: str = os.environ.get("PUBLIC_SUPABASE_URL")
key: str = os.environ.get("PUBLIC_SUPABASE_ANON_KEY")
supabase: Client = create_client(url, key)

response = (    
    supabase.table("questions")    
    .select("*")    
    .execute()
)

print(response.data)
