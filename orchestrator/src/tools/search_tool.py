"""
Search Tool - Tìm kiếm web với Perplexity
"""

import os
import httpx
from typing import Dict, Any

async def search(parameters: Dict[str, Any]) -> Dict[str, Any]:
    """Tìm kiếm trên web"""
    try:
        api_key = os.getenv("PERPLEXITY_API_KEY")
        if not api_key:
            raise ValueError("PERPLEXITY_API_KEY not configured")
        
        query = parameters.get("query")
        if not query:
            raise ValueError("Search query is required")
        
        # Call Perplexity API
        async with httpx.AsyncClient() as client:
            response = await client.post(
                "https://api.perplexity.ai/chat/completions",
                headers={
                    "Authorization": f"Bearer {api_key}",
                    "Content-Type": "application/json"
                },
                json={
                    "model": "llama-3.1-sonar-large-128k-online",
                    "messages": [
                        {
                            "role": "user",
                            "content": query
                        }
                    ]
                },
                timeout=30.0
            )
            
            if response.status_code != 200:
                raise Exception(f"Perplexity API error: {response.status_code}")
            
            data = response.json()
            result = data.get("choices", [{}])[0].get("message", {}).get("content", "")
            
            return {
                "success": True,
                "query": query,
                "result": result
            }
    except Exception as e:
        raise Exception(f"Search failed: {str(e)}")
