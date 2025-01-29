import json
import google.generativeai as genai
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_chroma import Chroma

GEMINI_API_KEY = "AIzaSyAUjUSsjkVREO5DQWuXrmmEfJ2zOSmNvMg"

def generate_answer(prompt):
    try:
        genai.configure(api_key=GEMINI_API_KEY)
        model = genai.GenerativeModel(model_name="gemini-1.5-flash")
        # model = genai.GenerativeModel(model_name="gemini-pro")
        answer = model.generate_content(prompt)

        generated_text = answer._result.candidates[0].content.parts[0].text
        print(generated_text.strip('\n').strip().strip('```').strip('json').strip('```'))
        formatted_response = json.loads(generated_text.strip('\n').strip().strip('```').strip('json').strip('```').strip('\n').strip())
        
        return formatted_response
    
    except Exception as e:
        raise Exception(f"Error generating answer: {str(e)}")

def get_relavant_context_from_db(query):
    context = ""
    embedding_function = HuggingFaceEmbeddings(
        model_name='sentence-transformers/all-MiniLM-L6-v2', 
        model_kwargs={"device": "cpu"}
    )
    vector_db = Chroma(persist_directory='./chroma_db_nccn', embedding_function=embedding_function)
    search_results = vector_db.similarity_search(query, k=6)

    for result in search_results:
        context += result.page_content + "\n"

    return context

def generate_rag_prompt(query, context, history):
    # Format history into a readable structure
    formatted_history = "\n".join(
        [f"USER: {entry['query']}\nAI: {entry['answer']['answer']}" for entry in history]
    )

    escaped_context = context.replace("'", "").replace('"', "").replace("\n", " ")
    if not context:
        escaped_context = "No relevant information found, but here is some general information related to the query."

    # Construct the prompt with query, context, and conversation history
    prompt = f"""
    I am providing you with three inputs:

        1. history: This is the user's recent conversation history, which can provide additional context to improve response relevance and continuity.
        2. context: This is the retrieved information from a Women & Child Safety PDF, specifically tailored to answer the user's query.
        3. query: This is the user's current question related to the SKODA PDF content.
    
    USER QUERY: {query}
    CONTEXT: {escaped_context}
    HISTORY: 
    {formatted_history}
    
    Please answer the user query by carefully extracting relevant information from both the context and history. Avoid simply copying text verbatim; instead, summarize and explain the relevant points to give the user a clear, complete, yet concise response.

    Ensure the response:

    - Provides key points in a list format where possible to improve readability.
    - Summarizes or describes important details from the context and history that directly address the query.
    - Is thorough enough to cover essential information but remains focused and concise (do not be overly brief or overly detailed).
    - Avoids returning an empty list or irrelevant data; always extract and present the most relevant information from the context and history.

    Format the response in JSON as follows:
    
    {{
      "query": "<restate or summarize the user's query here>",
      "answer": [
        "<Provide extracted key points or a concise explanation here. Use bullet points for list-based answers if applicable.>"
      ]
    }}
    """
    return prompt


