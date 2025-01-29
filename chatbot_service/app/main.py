from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

from app.db_init import save_conversation_history, fetch_user_conversations, init_db
from .generate_embeddings import router as pdf_router
from .rag import generate_answer, get_relavant_context_from_db, generate_rag_prompt

app = FastAPI()
app.include_router(pdf_router, prefix="/pdf", tags=["PDF Processing"])
init_db()

class QueryRequest(BaseModel):
    query: str
    user_id: int

@app.post("/query")
async def handle_query(request: QueryRequest):
    user_id = request.user_id
    query = request.query
    print("QUERY RECIEVED")
    context = get_relavant_context_from_db(query)
    print("CONTEXT GENERATED")
    print("HISTORY FETCHED")
    history = fetch_user_conversations(user_id, limit=5)  # Get the last 5 interactions

    prompt = generate_rag_prompt(query, context, history=history)
    print("PROMPT GENERATED")
    
    try:
        answer = generate_answer(prompt)
        print("ANSWER GENERATED")
        save_conversation_history(user_id, query, answer)
        print("CHAT HISTORY SAVED")
        
        return {"answer": answer}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

#uvicorn app.main:app --reload --port 8003 --host 0.0.0.0