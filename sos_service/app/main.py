import os
from flask import Flask, request, jsonify

app = Flask(__name__)

# Folder to save uploaded videos
UPLOAD_FOLDER = 'uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

import os
from flask import Flask, request, jsonify, send_from_directory

app = Flask(__name__)

# Configure the upload folder
UPLOAD_FOLDER = 'uploads'  # Folder to store uploaded videos
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/sos', methods=['POST'])
def upload_video():
    if 'video' not in request.files:
        return jsonify({"error": "No video file found"}), 400

    video = request.files['video']

    if video.filename == '':
        return jsonify({"error": "No selected file"}), 400

    # Save the video file
    file_path = os.path.join(app.config['UPLOAD_FOLDER'], "video.mp4")
    video.save(file_path)

    # Return the video file URL to the client
    video_url = f"/uploads/video.mp4"
    return jsonify({"message": "Video uploaded successfully", "file_url": video_url}), 200

@app.route('/videos/<filename>', methods=['GET'])
def serve_video(filename):
    try:
        # Ensure the file exists
        if os.path.exists(os.path.join(app.config['UPLOAD_FOLDER'], filename)):
            return send_from_directory(app.config['UPLOAD_FOLDER'], filename)
        else:
            return jsonify({"error": "File not found"}), 404
    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500




if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8004)



