
def email_to_send(code, VERIFICATION_CODE_EXPIRY_MINUTES):
    email_body = f"""
<html>
  <head>
    <style>
      body {{
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
        margin: 0;
        padding: 0;
        text-align: center;
      }}
      .container {{
        max-width: 500px;
        background: white;
        padding: 20px;
        margin: 20px auto;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      }}
      .header {{
        background-color: #23234F;
        color: white;
        padding: 15px;
        font-size: 20px;
        font-weight: bold;
        border-radius: 8px 8px 0 0;
      }}
      .otp-container {{
        display: flex;
        justify-content: center;
        gap: 15px; /* Increased space between boxes */
        margin: 20px 0;
      }}
      .otp-box {{
        width: 50px;
        height: 50px;
        font-size: 24px;
        font-weight: bold;
        text-align: center;
        border: 2px solid #FFA722;
        border-radius: 5px;
        line-height: 50px;
        color: #23234F;
      }}
      .button {{
        background-color: #FFA722;
        color: white;
        text-decoration: none;
        padding: 12px 25px;
        border-radius: 5px;
        display: inline-block;
        font-weight: bold;
        margin-top: 20px;
        font-size: 16px;
      }}
      .footer {{
        margin-top: 20px;
        font-size: 14px;
        color: #777;
      }}
    </style>
  </head>
  <body>
    <div class="container">
      <div class="header">Guardians Email Verification</div>
      <p>Hello,</p>
      <p>Thank you for registering with <strong>Guardians</strong>, the app dedicated to ensuring women's safety.</p>
      <p>Your verification code is:</p>
      <div class="otp-container">
        {"".join(f'<div class="otp-box">{digit}</div>' for digit in str(code))}
      </div>
      <p>Please enter this code in the app to complete your registration process. The code will expire in <strong>{VERIFICATION_CODE_EXPIRY_MINUTES} minutes</strong>.</p>
      <p>If you did not request this, please ignore this email.</p>
      <a href="#" class="button">Verify Email</a>
      <p class="footer">Stay safe,<br><strong>Guardians Team</strong></p>
    </div>
  </body>
</html>
"""
    return email_body