"""
MCP Orchestrator - FastAPI Server
Trợ lý cấp cao toàn diện với tích hợp Gmail, GitHub, và các services khác
"""

from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional, Dict, Any
import os
from dotenv import load_dotenv

load_dotenv()

app = FastAPI(
    title="MCP Orchestrator",
    description="Trợ lý cấp cao toàn diện - Gmail, GitHub, Search, Vision, OCR, Zalo OA",
    version="1.0.0"
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Models
class ToolCallRequest(BaseModel):
    tool: str
    parameters: Dict[str, Any]

class ToolCallResponse(BaseModel):
    success: bool
    result: Any
    error: Optional[str] = None

class ToolInfo(BaseModel):
    id: str
    name: str
    description: str
    parameters: Dict[str, Any]

# MCP Tools Registry
MCP_TOOLS = {
    "gmail_send": {
        "id": "gmail_send",
        "name": "Gmail Send",
        "description": "Gửi email qua Gmail",
        "parameters": {
            "to": {"type": "string", "required": True},
            "subject": {"type": "string", "required": True},
            "body": {"type": "string", "required": True}
        }
    },
    "gmail_read": {
        "id": "gmail_read",
        "name": "Gmail Read",
        "description": "Đọc email từ Gmail",
        "parameters": {
            "limit": {"type": "number", "required": False, "default": 10}
        }
    },
    "github_create_repo": {
        "id": "github_create_repo",
        "name": "GitHub Create Repo",
        "description": "Tạo repository trên GitHub",
        "parameters": {
            "name": {"type": "string", "required": True},
            "description": {"type": "string", "required": False},
            "private": {"type": "boolean", "required": False, "default": False}
        }
    },
    "github_list_repos": {
        "id": "github_list_repos",
        "name": "GitHub List Repos",
        "description": "Liệt kê repositories trên GitHub",
        "parameters": {}
    },
    "search_web": {
        "id": "search_web",
        "name": "Web Search",
        "description": "Tìm kiếm trên web",
        "parameters": {
            "query": {"type": "string", "required": True}
        }
    },
    "vision_analyze": {
        "id": "vision_analyze",
        "name": "Vision Analyze",
        "description": "Phân tích hình ảnh",
        "parameters": {
            "image_url": {"type": "string", "required": True},
            "prompt": {"type": "string", "required": False}
        }
    },
    "ocr_extract": {
        "id": "ocr_extract",
        "name": "OCR Extract",
        "description": "Trích xuất text từ hình ảnh",
        "parameters": {
            "image_url": {"type": "string", "required": True}
        }
    },
    "zalo_send_message": {
        "id": "zalo_send_message",
        "name": "Zalo Send Message",
        "description": "Gửi tin nhắn qua Zalo OA",
        "parameters": {
            "user_id": {"type": "string", "required": True},
            "message": {"type": "string", "required": True}
        }
    }
}

@app.get("/")
async def root():
    return {
        "message": "MCP Orchestrator - Trợ lý cấp cao toàn diện",
        "version": "1.0.0",
        "tools_count": len(MCP_TOOLS)
    }

@app.get("/mcp/tools", response_model=List[ToolInfo])
async def list_tools():
    """Liệt kê tất cả MCP tools có sẵn"""
    return [ToolInfo(**tool) for tool in MCP_TOOLS.values()]

@app.get("/mcp/tools/{tool_id}")
async def get_tool(tool_id: str):
    """Lấy thông tin chi tiết của một tool"""
    if tool_id not in MCP_TOOLS:
        raise HTTPException(status_code=404, detail="Tool not found")
    return MCP_TOOLS[tool_id]

@app.post("/mcp/tools/{tool_id}/call", response_model=ToolCallResponse)
async def call_tool(tool_id: str, request: ToolCallRequest):
    """Gọi một MCP tool"""
    if tool_id not in MCP_TOOLS:
        raise HTTPException(status_code=404, detail="Tool not found")
    
    try:
        # Import tool handlers dynamically
        from tools import (
            gmail_tool,
            github_tool,
            search_tool,
            vision_tool,
            ocr_tool,
            zalo_tool
        )
        
        # Route to appropriate tool handler
        tool_handlers = {
            "gmail_send": gmail_tool.send_email,
            "gmail_read": gmail_tool.read_emails,
            "github_create_repo": github_tool.create_repo,
            "github_list_repos": github_tool.list_repos,
            "search_web": search_tool.search,
            "vision_analyze": vision_tool.analyze,
            "ocr_extract": ocr_tool.extract_text,
            "zalo_send_message": zalo_tool.send_message
        }
        
        handler = tool_handlers.get(tool_id)
        if not handler:
            raise HTTPException(status_code=404, detail="Tool handler not found")
        
        result = await handler(request.parameters)
        
        return ToolCallResponse(
            success=True,
            result=result
        )
        
    except Exception as e:
        return ToolCallResponse(
            success=False,
            result=None,
            error=str(e)
        )

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "tools_available": len(MCP_TOOLS),
        "services": {
            "gmail": bool(os.getenv("GMAIL_USER") and os.getenv("GMAIL_APP_PASSWORD")),
            "github": bool(os.getenv("GITHUB_TOKEN")),
            "perplexity": bool(os.getenv("PERPLEXITY_API_KEY")),
            "gemini": bool(os.getenv("GEMINI_API_KEY")),
            "zalo": bool(os.getenv("ZALO_OA_ACCESS_TOKEN"))
        }
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
