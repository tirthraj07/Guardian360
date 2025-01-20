from fastapi_mail import FastMail, MessageSchema, ConnectionConfig

# Email configuration (update with your SMTP details)
conf = ConnectionConfig(
    MAIL_USERNAME="sn2204amey@gmail.com",
    MAIL_PASSWORD="mwec nfzc cemy likd",
    MAIL_FROM="sn2204amey@gmail.com",
    MAIL_PORT=587,
    MAIL_SERVER="smtp.gmail.com",
    MAIL_FROM_NAME="guardians",
    MAIL_STARTTLS=True,         # Replaces MAIL_TLS
    MAIL_SSL_TLS=False          # Replaces MAIL_SSL
)
async def send_email(subject: str, recipient: str, body: str):
    """
    Sends an email using the configured SMTP settings.

    Args:
        subject (str): Subject of the email.
        recipient (str): Recipient's email address.
        body (str): The content of the email.
    """
    message = MessageSchema(
        subject=subject,
        recipients=[recipient],
        body=body,
        subtype="html"
    )
    fm = FastMail(conf)
    await fm.send_message(message)
