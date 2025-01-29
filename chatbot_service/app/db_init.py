import sqlite3
import json

def init_db():
    conn = sqlite3.connect("database/conversations.db")
    cursor = conn.cursor()
    cursor.execute("""
            CREATE TABLE IF NOT EXISTS conversation_history (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id TEXT NOT NULL,
                query TEXT NOT NULL,
                answer TEXT,
                timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        """)
    conn.commit()
    conn.close()
    print("Database Started")

def save_conversation_history(user_id, query, answer):
    # Convert answer list to JSON string
    answer_json = json.dumps(answer)

    conn = sqlite3.connect("database/conversations.db")
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO conversation_history (user_id, query, answer)
        VALUES (?, ?, ?)
    """, (user_id, query, answer_json))
    conn.commit()
    conn.close()

def fetch_user_conversations(user_id, limit=10):
    conn = sqlite3.connect("database/conversations.db")
    cursor = conn.cursor()
    cursor.execute("""
        SELECT query, answer FROM conversation_history
        WHERE user_id = ? ORDER BY timestamp DESC LIMIT ?
    """, (user_id, limit))
    results = cursor.fetchall()
    conn.close()

    # Convert JSON string back to list for each answer
    formatted_results = []
    for query, answer in results:
        try:
            answer_list = json.loads(answer)  # Convert JSON string back to list
        except json.JSONDecodeError:
            answer_list = [answer]  # Fallback if answer isn't in JSON format
        formatted_results.append({"query": query, "answer": answer_list}) 
        
        
    print("\n\nCONVERSATION HISTORY")
    print(formatted_results)
    return formatted_results
