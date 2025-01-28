import os
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

EMAIL_USER = os.getenv("EMAIL_USER")
EMAIL_PASS = os.getenv("EMAIL_PASS")

if not EMAIL_USER or not EMAIL_PASS:
    print("FATAL ERROR: EMAIL_USER or EMAIL_PASS is not defined.")
    exit(1)
else:
    print("EMAIL_USER and EMAIL_PASS are defined")

def send_email_to_recipient(to, subject, body):
    try:
        msg = MIMEMultipart()
        msg["From"] = EMAIL_USER
        msg["To"] = to
        msg["Subject"] = subject

        msg.attach(MIMEText(body, "html"))

        with smtplib.SMTP("smtp.gmail.com", 587) as server:
            server.starttls()  
            server.login(EMAIL_USER, EMAIL_PASS)
            server.sendmail(EMAIL_USER, to, msg.as_string())

        print(f"Email sent to {to} with subject: {subject}")
    except Exception as error:
        print(f"Error sending email: {error}")
        return error