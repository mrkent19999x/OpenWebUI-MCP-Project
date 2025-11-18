"""
Gmail Tool - Quản lý email
"""

import os
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from typing import Dict, Any, List
import imaplib
import email
from email.header import decode_header

async def send_email(parameters: Dict[str, Any]) -> Dict[str, Any]:
    """Gửi email qua Gmail"""
    try:
        gmail_user = os.getenv("GMAIL_USER")
        gmail_password = os.getenv("GMAIL_APP_PASSWORD")
        
        if not gmail_user or not gmail_password:
            raise ValueError("Gmail credentials not configured")
        
        to = parameters.get("to")
        subject = parameters.get("subject")
        body = parameters.get("body")
        
        if not all([to, subject, body]):
            raise ValueError("Missing required parameters: to, subject, body")
        
        # Create message
        msg = MIMEMultipart()
        msg['From'] = gmail_user
        msg['To'] = to
        msg['Subject'] = subject
        msg.attach(MIMEText(body, 'plain'))
        
        # Send email
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login(gmail_user, gmail_password)
        text = msg.as_string()
        server.sendmail(gmail_user, to, text)
        server.quit()
        
        return {
            "success": True,
            "message": f"Email sent successfully to {to}",
            "subject": subject
        }
    except Exception as e:
        raise Exception(f"Failed to send email: {str(e)}")

async def read_emails(parameters: Dict[str, Any]) -> Dict[str, Any]:
    """Đọc email từ Gmail"""
    try:
        gmail_user = os.getenv("GMAIL_USER")
        gmail_password = os.getenv("GMAIL_APP_PASSWORD")
        
        if not gmail_user or not gmail_password:
            raise ValueError("Gmail credentials not configured")
        
        limit = parameters.get("limit", 10)
        
        # Connect to Gmail
        mail = imaplib.IMAP4_SSL("imap.gmail.com")
        mail.login(gmail_user, gmail_password)
        mail.select("inbox")
        
        # Search for emails
        status, messages = mail.search(None, "ALL")
        email_ids = messages[0].split()
        
        emails = []
        for email_id in email_ids[-limit:]:
            status, msg_data = mail.fetch(email_id, "(RFC822)")
            email_body = msg_data[0][1]
            email_message = email.message_from_bytes(email_body)
            
            # Decode subject
            subject = decode_header(email_message["Subject"])[0][0]
            if isinstance(subject, bytes):
                subject = subject.decode()
            
            # Get sender
            sender = email_message["From"]
            
            emails.append({
                "id": email_id.decode(),
                "subject": subject,
                "sender": sender,
                "date": email_message["Date"]
            })
        
        mail.close()
        mail.logout()
        
        return {
            "success": True,
            "count": len(emails),
            "emails": emails
        }
    except Exception as e:
        raise Exception(f"Failed to read emails: {str(e)}")
