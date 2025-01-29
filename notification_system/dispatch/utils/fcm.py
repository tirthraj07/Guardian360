import requests
import json
import os
from google.oauth2 import service_account
from google.auth.transport.requests import Request


class FirebaseCloudMessaging:
    FCM_URL = os.getenv("FIREBASE_CLOUD_MESSAGING_URL")

    @staticmethod
    def _generate_oauth_token():
        SERVICE_ACCOUNT_FILE = os.path.abspath("./secrets/guardians-notifications-firebase-adminsdk.json")
        SCOPES = ["https://www.googleapis.com/auth/firebase.messaging"]
        credentials = service_account.Credentials.from_service_account_file(
            SERVICE_ACCOUNT_FILE, scopes=SCOPES
        )
        credentials.refresh(Request())
        token = credentials.token
        return token


    @staticmethod
    def send_push_notification(device_token, title, body, alert_type):
        if not FirebaseCloudMessaging.FCM_URL:
            raise ValueError("FCM_URL is not set. Check your environment variables.")
        
        token = FirebaseCloudMessaging._generate_oauth_token()
        
        headers = {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json"
        }
        
        payload = {
            "message": {
                "token": device_token,
                "notification": {
                    "title": title,
                    "body": body
                },
                "data": {
                    "screen": "SOSScreen",
                    "notif_type": alert_type
                }
            }
        }
        
        response = requests.post(FirebaseCloudMessaging.FCM_URL, headers=headers, json=payload)

        if response.status_code == 200:
            print("Notification sent successfully!")
            return response.json()
        else:
            print(f"Failed to send notification: {response.status_code}, {response.text}")
            return None
