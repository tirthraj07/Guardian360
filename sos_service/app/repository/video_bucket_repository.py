from app.database.supabase import supabase

#UPLOAD
def upload_file(file_path, file_name):
    bucket_name = "video_bucket"
    response = supabase.storage.from_(bucket_name).upload(file_name, file_path)
    print(response)