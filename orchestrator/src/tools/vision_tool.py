"""
Vision Tool - Phân tích hình ảnh với Gemini
"""

import os
import httpx
from typing import Dict, Any

async def analyze(parameters: Dict[str, Any]) -> Dict[str, Any]:
    """Phân tích hình ảnh"""
    try:
        api_key = os.getenv("GEMINI_API_KEY")
        if not api_key:
            raise ValueError("GEMINI_API_KEY not configured")
        
        image_url = parameters.get("image_url")
        prompt = parameters.get("prompt", "Describe this image in detail")
        
        if not image_url:
            raise ValueError("image_url is required")
        
        # Call Gemini Vision API
        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent?key={api_key}",
                json={
                    "contents": [{
                        "parts": [
                            {"text": prompt},
                            {
                                "inline_data": {
                                    "mime_type": "image/jpeg",
                                    "data": image_url  # Should be base64 encoded
                                }
                            }
                        ]
                    }]
                },
                timeout=30.0
            )
            
            if response.status_code != 200:
                raise Exception(f"Gemini API error: {response.status_code}")
            
            data = response.json()
            result = data.get("candidates", [{}])[0].get("content", {}).get("parts", [{}])[0].get("text", "")
            
            return {
                "success": True,
                "image_url": image_url,
                "analysis": result
            }
    except Exception as e:
        raise Exception(f"Vision analysis failed: {str(e)}")
