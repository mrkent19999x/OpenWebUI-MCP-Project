#!/bin/bash

# OpenWebUI-MCP-Project: Manus AI Equivalent Deployment Script
# This script starts the complete sandbox environment

set -e

echo "🚀 Starting OpenWebUI-MCP Sandbox Environment..."
echo "📋 Capabilities: Code Execution, Web Automation, Auto-Deployment, GitHub Integration"
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found!"
    echo "Please create .env file with your GitHub token:"
    echo "GITHUB_TOKEN=your_github_token_here"
    exit 1
fi

# Load environment variables
source .env

# Validate GitHub token
if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ Error: GITHUB_TOKEN not found in .env file!"
    exit 1
fi

echo "✅ Environment loaded successfully"
echo "🔐 GitHub Token: ${GITHUB_TOKEN:0:10}..."
echo ""

# Create required directories
echo "📁 Creating directories..."
mkdir -p logs deploy-config config litellm scripts
mkdir -p code-executor/mcp-server  # For service communication

# Build and start services
echo "🏗️  Building Docker images..."
docker-compose -f docker-compose.sandbox.yml build --no-cache

echo "🎯 Starting services..."
docker-compose -f docker-compose.sandbox.yml up -d

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 30

# Health checks
echo "🏥 Checking service health..."

services=(
    "openwebui:7860"
    "code-executor:5000"
    "mcp-server:8000"
    "web-automation:3000"
    "auto-deployer:80"
    "file-manager:9000"
)

for service in "${services[@]}"; do
    name="${service%:*}"
    port="${service#*:}"
    
    echo -n "Checking $name ($port)... "
    if curl -f -s "http://localhost:$port/health" > /dev/null 2>&1 || \
       curl -f -s "http://localhost:$port/" > /dev/null 2>&1; then
        echo "✅ OK"
    else
        echo "❌ FAILED"
    fi
done

echo ""
echo "🎉 OpenWebUI-MCP Sandbox Environment Started Successfully!"
echo ""
echo "📱 Access Points:"
echo "   🌐 OpenWebUI:        http://localhost:7860"
echo "   ⚡ Code Executor:     http://localhost:5000"
echo "   🔧 MCP Server:        http://localhost:8000"
echo "   🕷️  Web Automation:    http://localhost:3000"
echo "   🚀 Auto-Deployer:     http://localhost:80"
echo "   📁 File Manager:      http://localhost:9000"
echo ""
echo "📚 API Endpoints:"
echo "   POST /execute/code    - Execute code (Python, Node.js, Bash)"
echo "   POST /github/create   - Create GitHub repository"
echo "   POST /github/commit   - Commit files to GitHub"
echo "   POST /deploy          - Auto-deploy to public URL"
echo "   POST /browser/open    - Open browser and navigate"
echo ""
echo "🎯 Usage Examples:"
echo "   # Execute Python code:"
echo "   curl -X POST http://localhost:5000/execute/code -d '{\"language\": \"python\", \"code\": \"print(\\\"Hello Manus AI!\\\")\"}'"
echo ""
echo "   # Create GitHub repo:"
echo "   curl -X POST http://localhost:8000/github/create -d '{\"repo_name\": \"test-repo\", \"description\": \"Test repository\"}'"
echo ""
echo "📊 View logs: docker-compose -f docker-compose.sandbox.yml logs -f"
echo "🛑 Stop all: docker-compose -f docker-compose.sandbox.yml down"
echo ""
echo "✨ Your Manus AI equivalent is ready! ✨"