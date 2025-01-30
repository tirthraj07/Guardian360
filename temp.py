import requests
import json

# Firebase HTTP v1 API URL
FCM_URL = "https://fcm.googleapis.com/v1/projects/guardians-notifications/messages:send"

# Your Firebase OAuth2 token
token = "ya29.c.c0ASRK0GaSkpGD2zBZGlIgMVH16wrVDvgbI1ipw5IUy1XSYNSSLcnJLA-dV0WPDZ15MhL9gRf0Bxt1HMTa4P2KW1Xf2iaX-YelpB8dSYahrjFVBlURbngQx_qlyuH1x1kPrkZzgAnO7yRmXXy0pL143u3mdn2H16SsRVGlozaEnE4QgkfU__P-5_HyYzt-x3nJ88JABnFU9bCADFKGsv4y9xypEl8Prd5Cq6DK6U6JbRlmJ4klQzeMR0FKEi1xHg4DWQAiGZflGSMWWBwH7fXNk8zdCUtI6k9WJqN5J8ZgVfNcnG9OAbF-LmXqXQ9Jg_wFgxO1w77Tiqp4NvcNYgzoOncFBbGgvkDtO2UzSij9t1DIVKWkwtDvMGsT384CWB_dhFB4-rmpiw7geg63048pWv6__lgWYX7h1sf0WfbI4nws1bQhxkMbnaW-usji14V5w07pp0uqzV0MaMymyVFkdv69bz6YvUzwYpVUvV-sW7z4nh9vBr7qV9MWQY3vcJIaix18kJ_q2beOhbWR8pOO15BbeFBYZSx75Qlkncet5Jscncr4djFg4dXly9zgJ1Wypjbze6iy_iStFFt4-zadz1XcxQ-Sfz4ekM4fuhm33yzat3b4F99QZ3IUn47iBlV0Wwypflys8chy47xUliWvJyWiSz8ej1dWjkcUxMXOpb9atqjsUrpVdU5tz-7d1SZbke7I86j6y_bXle2ohIgOk2pibtYjX2f5I7qslbhUW-t634cbpuUsqkxq43yXBcBtsulB_dYIpzIt8y5nc-59Ztor9we-632OJ6aq8F8F5UuBMSfJo0zz5S0i52b6bj5Ia_kvq2j1bo8BI00h5Rbs-zwdb_WeXF7Fr6r9mh9vZQ649fj_W6kS-6nvxBv8qaX6yWtcJMnxvaVpte2Fzlln-lg9StVs2liZm7RJ0mzfqJmYO2smjl5mspualn5MJXtrUe1v9Zs5zSSMB_MBjB0b-Yk84suq0R7wri5Y_X8YYRJfSBjSWz53_k3"

# Notification payload
payload = {
  "message": {
    "token": "cxL59h9uTlaetus3a0o9Yd:APA91bHszaFUcDW078a1QwihF6r7OLz3CXAExQO5t4DYAcXSfenSHT8O-3QiZEWwJjctTYD1m62esCaEEqhW4yfxJ_olLji3TttHLLIhlJID5W3qtLZC_QI",
    "notification": {
      "title": "SOS Alert",
      "body": "SOS Alert from Amey"
    },
    "data": {
      "screen": "SOSScreen",
      "notif_type": "SOS"
    }
  }
}

# Headers with Authorization Bearer token
headers = {
    "Authorization": f"Bearer {token}",
    "Content-Type": "application/json"
}

# Send the POST request to Firebase Cloud Messaging API
response = requests.post(FCM_URL, headers=headers, data=json.dumps(payload))

# Print the response from Firebase
if response.status_code == 200:
    print("Notification sent successfully!")
else:
    print(f"Failed to send notification: {response.status_code}, {response.text}")