"""
OCR Tool - Trích xuất text từ hình ảnh
"""

import os
import pytesseract
from PIL import Image
import httpx
from typing import Dict, Any

async def extract_text(parameters: Dict[str, Any]) -> Dict[str, Any]:
    """Trích xuất text từ hình ảnh"""
    try:
        image_url = parameters.get("image_url")
        if not image_url:
            raise ValueError("image_url is required")
        
        # Download image
        async with httpx.AsyncClient() as client:
            response = await client.get(image_url, timeout=30.0)
            if response.status_code != 200:
                raise Exception(f"Failed to download image: {response.status_code}")
            
            # Save temporarily
            with open("/tmp/ocr_image.jpg", "wb") as f:
                f.write(response.content)
        
        # Extract text using Tesseract
        image = Image.open("/tmp/ocr_image.jpg")
        text = pytesseract.image_to_string(image)
        
        # Clean up
        os.remove("/tmp/ocr_image.jpg")
        
        return {
            "success": True,
            "image_url": image_url,
            "extracted_text": text.strip()
        }
    except Exception as e:
        raise Exception(f"OCR extraction failed: {str(e)}")
