#!/bin/bash

# Quick setup script for mobile users
# Lấy .env API token và push code

echo "🚀 MOBILE SETUP - OPENWEBUI MCP PROJECT"
echo "========================================"

# Load .env file
if [ -f ".env" ]; then
    echo "📄 Loading environment from .env..."
    export $(grep -v '^#' .env | xargs)
else
    echo "❌ .env file not found!"
    exit 1
fi

# Check GITHUB_TOKEN
if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ GITHUB_TOKEN not found in .env"
    echo "Please add GITHUB_TOKEN=your_token_here to .env"
    exit 1
fi

echo "✅ GitHub token found: ${GITHUB_TOKEN:0:10}..."

# Show repository info
echo
echo "📋 Repository Information:"
echo "   Name: OpenWebUI-MCP-Project"
echo "   Owner: mrkent19999x"
echo "   URL: https://github.com/mrkent19999x/OpenWebUI-MCP-Project"
echo

# List files to push
echo "📁 Files ready to push:"
echo "   ✅ docker-compose.sandbox.yml"
echo "   ✅ MANUS_AI_COMPARISON.md"
echo "   ✅ MOBILE_PUSH_GUIDE.md"
echo "   ✅ code-executor/server.js"
echo "   ✅ mcp-server/mcp_server.py"
echo "   ✅ push-with-mcp.sh"
echo

# Show push commands
echo "📱 MOBILE PUSH OPTIONS:"
echo "======================="
echo
echo "Option 1 - GitHub Web (Fastest):"
echo "1. Open https://github.com/mrkent19999x/OpenWebUI-MCP-Project"
echo "2. Click 'uploading an existing file'"
echo "3. Upload the files listed above"
echo "4. Commit message: 'feat: Enhanced OpenWebUI-MCP with Sandbox Environment'"
echo
echo "Option 2 - GitHub Mobile App:"
echo "1. Install GitHub mobile app"
echo "2. Login and search for 'OpenWebUI-MCP-Project'"
echo "3. Clone repository"
echo "4. Add files and commit"
echo
echo "Option 3 - MCP Commands (If available):"
echo "   bash push-with-mcp.sh"

# Test .env configuration
echo
echo "🔍 TESTING CONFIGURATION..."
echo "=========================="

# Test LiteLLM config
if grep -q "LITELLM_PORT=4000" .env; then
    echo "✅ LiteLLM configuration found"
else
    echo "⚠️  LiteLLM configuration missing"
fi

# Test OpenWebUI config
if grep -q "WEBUI_PORT=3000" .env; then
    echo "✅ OpenWebUI configuration found"
else
    echo "⚠️  OpenWebUI configuration missing"
fi

# Show deployment commands
echo
echo "🚀 DEPLOYMENT (after push):"
echo "==========================="
echo "git clone https://github.com/mrkent19999x/OpenWebUI-MCP-Project.git"
echo "cd OpenWebUI-MCP-Project"
echo "docker-compose -f docker-compose.sandbox.yml up -d"
echo
echo "🌐 Access URLs:"
echo "   OpenWebUI: http://localhost:3000"
echo "   LiteLLM API: http://localhost:4000"
echo "   Jupyter: http://localhost:8888"
echo "   Browser Automation: http://localhost:4444"
echo "   MCP Server: http://localhost:3003"

echo
echo "📞 NEXT STEPS:"
echo "=============="
echo "1. Choose push option above"
echo "2. Push code to GitHub"
echo "3. Clone và deploy trên máy local"
echo "4. Test all services"
echo
echo "🎉 Enhanced OpenWebUI-MCP is ready for mobile deployment!"