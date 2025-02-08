from app.database.supabase import supabase

class PokeUserRequestsRepository:
    @staticmethod
    def send_poke_request(sender_poker_id, receiver_poker_id):
        try:
            response = supabase.table("poker_user_requests").upsert({
                "sender_poker_id": sender_poker_id,
                "receiver_poker_id": receiver_poker_id,
                "acknowledgement_status" : False
            }).execute()
            
            if response.data:
                return response.data
            else:
                return None
        except Exception as e:
            print(f"Database error: {str(e)}")
            return None
        
        
    @staticmethod
    def get_poke_status(sender_poker_id, receiver_poker_id):
        try:
            response = supabase.table("poker_user_requests").select("acknowledgement_status").eq("sender_poker_id", sender_poker_id).eq("receiver_poker_id", receiver_poker_id).execute()
            
            if response.data:
                return response.data
            else:
                return None
        except Exception as e:
            print(f"Database error: {str(e)}")
            return None
        
    
    @staticmethod
    def see_all_poke_requests(receiver_poker_id):
        try:
            response = supabase.table("poker_user_requests").select("*").eq("receiver_poker_id", receiver_poker_id).execute()
            
            if response.data:
                return response.data
            else:
                return None
        except Exception as e:
            print(f"Database error: {str(e)}")
            return None
        
    @staticmethod
    def acknowledge_poke_request(receiver_poker_id):
        try:
            
            available_poke_requests = PokeUserRequestsRepository.see_all_poke_requests(receiver_poker_id)
            
            print(available_poke_requests)
            
            if available_poke_requests:
                sender_ids = [req['sender_poker_id'] for req in available_poke_requests]  # Extract sender IDs

                response = supabase.table("poker_user_requests") \
                .update({"acknowledgement_status": True}) \
                .in_("sender_poker_id", sender_ids) \
                .execute()
        
                if response.data:
                    return response.data
                else:
                    return None
        except Exception as e:
            print(f"Database error: {str(e)}")
            return None
        