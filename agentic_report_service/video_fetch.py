from supabase import create_client

#UPLOAD

url = "https://zbiuahkpbjhknlgrgmwa.supabase.co"
key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpiaXVhaGtwYmpoa25sZ3JnbXdhIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczNzQ0NTY4MywiZXhwIjoyMDUzMDIxNjgzfQ.i73c_2tln2Y5SdHWWRQulwXCzpPBxOqQ_dNdwKCLcw0"
supabase = create_client(url, key)


def upload_file():

    bucket_name = "video_bucket"
    file_path = "/Users/advait/Downloads/8944325-hd_1920_1080_25fps.mp4"

    response = supabase.storage.from_(bucket_name).upload("video.mp4", file_path)

    print(response)


#DOWNLOAD

# Function to download a file
def download_file(bucket_name, file_name, download_path):
    response = supabase.storage.from_(bucket_name).download(file_name)

    if response:

        with open(download_path, 'wb') as f:
            f.write(response)
        print(f'File downloaded successfully: {download_path}')
    else:
        print("Failed!")


# Call the function to download the file
download_file('video_bucket', 'video.mp4', '/Users/advait/Downloads/down1.mp4')