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
        escaped_context = "I don't have the information to answer this question."

    # Construct the prompt with query, context, and conversation history
    prompt = f"""
    I am providing you with three inputs:

        1. history: This is the user's recent conversation history, which can provide additional context to improve response relevance and continuity.
        2. context: This is the retrieved information from a Women & Child Safety PDF, specifically tailored to answer the user's query.
        3. query: This is the user's current question related to the Women and Child Safety PDF content.

    You are a chatbot specifically designed to answer queries related to women and child safety. The user will ask questions, and you will respond based on the provided information in the context or from your own knowledge.

    If the query is related to women and child safety and the information is available in the provided context, give a concise answer. Do not refer to the text directly, and do not mention that the answer is being based on the provided PDF. Provide the answer from your own understanding as if you know the answer.

    If you don't have the information to answer a query or if the query is not related to women and child safety, respond with something like: "I don't know" or "I don't have enough information to answer that" or "This is not something I can help with." Do not mention that there is no relevant information or the text does not provide an answer.

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

    Your answer should be in plain text, concise, clear, and free of any formatting like bold, italics.

    Format the response in JSON as follows:
    
    {{
      "query": "<restate or summarize the user's query here>",
      "answer": [
        "<Provide extracted key points or a concise explanation here>"
      ]
    }}
    """
    return prompt


