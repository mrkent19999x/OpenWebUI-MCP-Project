#!/usr/bin/env python3
"""
MCP Server - Model Context Protocol Server
"""
import os
import sys
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

app = FastAPI(title="MCP Server", version="1.0.0")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"], allow_headers=["*"])

@app.get("/health")
async def health():
    return {"status": "healthy", "service": "mcp-server"}

@app.get("/")
async def root():
    return {"service": "MCP Server", "version": "1.0.0", "status": "running"}

if __name__ == "__main__":
    port = int(os.getenv("MCP_SERVER_PORT", 3003))
    uvicorn.run(app, host="0.0.0.0", port=port)
