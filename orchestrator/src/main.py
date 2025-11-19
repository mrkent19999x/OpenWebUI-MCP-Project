#!/usr/bin/env python3
"""
Multi-Agent Orchestrator - Auto-routing và task classification
Khởi động như một máy tính, tự động xử lý tasks
"""
import os
import sys
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

app = FastAPI(title="Multi-Agent Orchestrator", version="1.0.0")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"], allow_headers=["*"])

@app.get("/health")
async def health():
    return {"status": "healthy", "service": "orchestrator", "auto_start": True, "mode": "agent_computer"}

@app.get("/")
async def root():
    return {"service": "Multi-Agent Orchestrator", "version": "1.0.0", "status": "running", "mode": "agent_computer", "auto_start": True}

if __name__ == "__main__":
    port = int(os.getenv("ORCHESTRATOR_PORT", 8000))
    uvicorn.run(app, host="0.0.0.0", port=port)
