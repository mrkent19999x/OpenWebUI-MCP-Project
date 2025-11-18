"""
Zalo OA Tool - Gửi tin nhắn qua Zalo
"""

import os
import httpx
from typing import Dict, Any

async def send_message(parameters: Dict[str, Any]) -> Dict[str, Any]:
    """Gửi tin nhắn qua Zalo OA"""
    try:
        access_token = os.getenv("ZALO_OA_ACCESS_TOKEN")
        if not access_token:
            raise ValueError("ZALO_OA_ACCESS_TOKEN not configured")
        
        user_id = parameters.get("user_id")
        message = parameters.get("message")
        
        if not user_id or not message:
            raise ValueError("user_id and message are required")
        
        # Call Zalo OA API
        async with httpx.AsyncClient() as client:
            response = await client.post(
                "https://openapi.zalo.me/v2.0/oa/message",
                headers={
                    "access_token": access_token,
                    "Content-Type": "application/json"
                },
                json={
                    "recipient": {
                        "user_id": user_id
                    },
                    "message": {
                        "text": message
                    }
                },
                timeout=30.0
            )
            
            if response.status_code != 200:
                raise Exception(f"Zalo API error: {response.status_code}")
            
            data = response.json()
            
            return {
                "success": True,
                "message": f"Message sent to user {user_id}",
                "zalo_response": data
            }
    except Exception as e:
        raise Exception(f"Failed to send Zalo message: {str(e)}")
