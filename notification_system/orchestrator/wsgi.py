'''
TODO:
- To Send messages
'''

from app import create_app
from flask_cors import CORS
from dotenv import load_dotenv
load_dotenv()
import os

app = create_app()
CORS(app)

ENV = os.getenv('ENV')
HOST = os.getenv('HOST')
PORT = os.getenv('PORT')

if __name__ == '__main__':
    print(f"Server running on {'http' if ENV == 'development' else 'https'}://{HOST}:{PORT}")
    print(f"Running in {ENV} mode")

    app.run(debug=(ENV == 'development'), host=HOST, port=PORT)