from fastapi import FastAPI, APIRouter, File, UploadFile, HTTPException
from langchain_chroma import Chroma
from langchain_huggingface import HuggingFaceEmbeddings
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.document_loaders import PyPDFLoader
import tempfile
import os
import chromadb

router = APIRouter()

embedding_function = HuggingFaceEmbeddings(
    model_name='sentence-transformers/all-MiniLM-L6-v2', 
    model_kwargs={"device": "cpu"}
)

persist_directory = './chroma_db_nccn'
vectorstore = Chroma(persist_directory=persist_directory, embedding_function=embedding_function)

@router.post("/upload-pdf")
async def upload_pdf(files: list[UploadFile] = File(...)):

    if not files:
        raise HTTPException(status_code=400, detail="No files uploaded.")
    
    successful_uploads = 0

    for file in files:
        if file.content_type != "application/pdf":
            raise HTTPException(status_code=400, detail=f"Invalid file type for {file.filename}. Please upload PDF files only.")

        with tempfile.NamedTemporaryFile(delete=False, suffix=".pdf") as temp_pdf:
            temp_pdf.write(await file.read())
            temp_pdf_path = temp_pdf.name

        try:
        # Load the PDF using the temp file's path
            loader = PyPDFLoader(temp_pdf_path)
            docs = loader.load()

            text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=100)
            split_docs = text_splitter.split_documents(docs)


            vectorstore.add_documents(split_docs)
            successful_uploads += 1

        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))
    
        finally:
            os.remove(temp_pdf_path)

    return {
        "message": "PDF processed and added to the vector store successfully.",
        "vector_store_count": vectorstore._collection.count(),
        "successful uploads" : f"{successful_uploads}"
    }

