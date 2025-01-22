from flask import Flask, jsonify

def create_app():
    app = Flask(__name__)

    @app.route('/keep-alive')
    def keep_alive():
        return jsonify({'status':'Notification service is up and running'})

    from app.routes.api import api
    app.register_blueprint(api, url_prefix='/api')

    return app