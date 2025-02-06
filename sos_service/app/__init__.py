import os
from flask import Flask, jsonify


def create_app():
    app = Flask(__name__)
    
    app.config['UPLOAD_FOLDER'] = 'uploads'
    os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

    @app.route('/keep-alive')
    def keep_alive():
        return jsonify({'status':'Sos service is up and running'})

    from app.routes.api import api
    app.register_blueprint(api, url_prefix='/api')

    return app