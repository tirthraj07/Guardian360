import os
import firebase_admin
from firebase_admin import credentials, messaging

class FCMUtils(object):

    def __init__(self):
        self.__cert_path = os.path.abspath("./secrets/guardians-notifications-firebase-adminsdk.json")
        self.__title = "Title"  # Change your title
        # Check if the app is already initialized
        if not firebase_admin._apps:  # _apps is a dictionary holding initialized apps
            self.__cred = credentials.Certificate(self.__cert_path)
            self.__app = firebase_admin.initialize_app(self.__cred)
        else:
            self.__app = firebase_admin.get_app()  # Reuse the existing app

    def push_notification_to_token(self,token,msg):
        notification = messaging.Notification(
            title=self.__title,
            body=msg,
        )
        message = messaging.Message(
            notification=notification,
            token=token
        )
        return messaging.send(message)
    
    def push_notification_to_topic(self, topic, msg):
        notification = messaging.Notification(
            title=self.__title,
            body=msg,
        )
        message = messaging.Message(
            notification=notification,
            topic=topic
        )
        return messaging.send(message)