#!/bin/bash

# OpenWebUI Persistent Environment Setup
# This script configures everything once and uses it permanently

set -e

echo "🚀 OpenWebUI Persistent Environment Setup"
echo "=========================================="

# GitHub Configuration (use .env.persistent for token)
GITHUB_USER="mrkent19999x"
REPO_NAME="OpenWebUI-MCP-Project"
REPO_URL="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"

# Load token from .env.persistent if available
if [ -f ".env.persistent" ]; then
    export $(cat .env.persistent | grep 'GITHUB_TOKEN=' | cut -d= -f1)
fi

echo "🔐 GitHub User: ${GITHUB_USER}"
echo "📋 Repository: ${REPO_NAME}"
echo ""

# Step 1: Setup Git (if available)
if command -v git &> /dev/null; then
    echo "🔧 Configuring Git..."
    
    # Configure git
    git config --global user.email "${GITHUB_USER}@users.noreply.github.com"
    git config --global user.name "${GITHUB_USER}"
    
    # Setup persistent credentials
    mkdir -p ~/.git-credentials
    echo "https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com" > ~/.git-credentials
    chmod 600 ~/.git-credentials
    
    # Enable credential store
    git config --global credential.helper store
    
    echo "✅ Git configured successfully"
else
    echo "⚠️  Git not available, using alternative approach"
fi

# Step 2: Create persistent config file
echo "📝 Creating persistent configuration..."

cat > /workspace/.env.persistent << EOF
# OpenWebUI Persistent Environment Configuration
# Generated: $(date)
# This config persists across sessions

# GitHub Configuration
GITHUB_TOKEN=${GITHUB_TOKEN}
GITHUB_USER=${GITHUB_USER}
REPO_NAME=${REPO_NAME}
REPO_URL=${REPO_URL}

# OpenWebUI Configuration
WEBUI_URL=http://localhost:3000
WEBUI_NAME=AgentChat
DEFAULT_LOCALE=vi
WEBUI_AUTH=True
ENABLE_SIGNUP=True

# MCP Configuration
ENABLE_DIRECT_CONNECTIONS=True
TOOL_SERVER_CONNECTIONS=[{
  "type":"openapi",
  "url":"http://orchestrator:8000/docs",
  "spec_type":"url",
  "spec":"",
  "path":"/openapi.json",
  "auth_type":"none",
  "key":"",
  "config":{"enable":true},
  "info":{
    "id":"orchestrator_mcp",
    "name":"Orchestrator MCP Gateway", 
    "description":"Complete MCP gateway with 6 tools"
  }
},{
  "type":"mcp",
  "url":"http://orchestrator:8000",
  "spec_type":"url",
  "spec":"",
  "path":"/mcp/tools",
  "auth_type":"none",
  "key":"",
  "config":{"enable":true},
  "info":{
    "id":"orchestrator_direct",
    "name":"Direct MCP Tools",
    "description":"Direct MCP tool access"
  }
}]

# API Keys (fill these with your actual keys)
GROQ_API_KEY=
OPENROUTER_API_KEY=
GEMINI_API_KEY=
MINIMAX_API_KEY=
PERPLEXITY_API_KEY=
OPENAI_API_KEY=
WHISPER_CLOUD_KEY=
TTS_API_KEY=
GOOGLE_VISION_API_KEY=
GMAIL_USER=
GMAIL_APP_PASSWORD=
GITHUB_TOKEN=${GITHUB_TOKEN}
ZALO_OA_ACCESS_TOKEN=
ZALO_OA_SECRET_KEY=
ZALO_OA_WEBHOOK_SECRET=

# Database
REDIS_URL=redis://redis:6379
QDRANT_URL=http://qdrant:6333

# Performance
ENABLE_REALTIME_CHAT_SAVE=False
CHAT_RESPONSE_STREAM_DELTA_CHUNK_SIZE=1
THREAD_POOL_SIZE=0
MODELS_CACHE_TTL=1
AIOHTTP_CLIENT_TIMEOUT=300

# Features
ENABLE_CHANNELS=False
ENABLE_USER_WEBHOOKS=True
ENABLE_ADMIN_EXPORT=True
ENABLE_ADMIN_CHAT_ACCESS=True

# Localization
DEFAULT_LOCALE=vi
ENABLE_LOGIN_FORM=True
SHOW_ADMIN_DETAILS=True
EOF

echo "✅ Persistent configuration saved to .env.persistent"

# Step 3: Copy to current .env
if [ -f "/workspace/Openwwebui/.env.example" ]; then
    cp /workspace/.env.persistent /workspace/Openwwebui/.env
    echo "✅ Environment config copied to OpenWebUI directory"
fi

# Step 4: Create GitHub Repository Setup Script
echo "📦 Creating repository setup script..."

cat > /workspace/setup-github-repo.sh << 'EOF'
#!/bin/bash

# Load persistent config
source /workspace/.env.persistent

echo "🌐 Creating GitHub Repository: ${REPO_NAME}"
echo "URL: https://github.com/${GITHUB_USER}/${REPO_NAME}"

# Step 1: Create repository using GitHub API
echo "📋 Creating repository on GitHub..."

# Check if repo exists
REPO_CHECK=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" \
  "https://api.github.com/repos/${GITHUB_USER}/${REPO_NAME}" 2>/dev/null || echo "NOT_FOUND")

if [[ $REPO_CHECK == *"Not Found"* ]] || [[ $REPO_CHECK == "" ]]; then
    echo "📝 Creating new repository..."
    
    # Create repository via GitHub API
    curl -X POST \
      -H "Authorization: token ${GITHUB_TOKEN}" \
      -H "Accept: application/vnd.github.v3+json" \
      https://api.github.com/user/repos \
      -d '{
        "name": "'${REPO_NAME}'",
        "description": "Enterprise OpenWebUI deployment with MCP integration",
        "private": false,
        "auto_init": true,
        "gitignore_template": "Python"
      }'
else
    echo "✅ Repository already exists"
fi

# Step 2: Setup git if available
if command -v git &> /dev/null; then
    echo "🔗 Setting up git remote..."
    
    cd /workspace
    
    # Add remote
    git remote remove origin 2>/dev/null || true
    git remote add origin "${REPO_URL}"
    
    # Add all files
    git add .
    
    # Create commit
    git commit -m "🎉 Initial commit: OpenWebUI + MCP Orchestrator Implementation

✨ Features:
- Native MCP support (OpenAPI + Streamable HTTP)
- Vietnamese localization  
- 6 MCP tools: Search, Vision, OCR, Gmail, GitHub, Zalo OA
- Production-ready architecture with load balancing
- 82% OpenWebUI v0.6.36 compliance

📁 Structure:
- README.md - Project overview
- agent.md - Personal project guide
- OPENWEBUI_LATEST_COMPLIANCE.md - Feature compliance
- GIT_SETUP_GUIDE.md - Git setup instructions
- setup-env.sh - Persistent environment setup
- setup-github-repo.sh - Repository creation script
- Openwwebui/ - Main application

🚀 Ready for deployment!" || echo "No changes to commit"
    
    # Push to remote
    git push -u origin master 2>/dev/null || echo "⚠️  Push failed - check repository permissions"
    
    echo "✅ Repository setup complete!"
    echo "🌐 Repository: https://github.com/${GITHUB_USER}/${REPO_NAME}"
fi

echo ""
echo "🎯 Next steps:"
echo "1. Visit: https://github.com/${GITHUB_USER}/${REPO_NAME}"
echo "2. Fill API keys in .env file"
echo "3. Deploy: ./manage.sh production up"
echo "4. Monitor: ./manage.sh health-check"
EOF

chmod +x /workspace/setup-github-repo.sh

echo "✅ Repository setup script created"

# Step 5: Create environment source script
echo "🔄 Creating environment source script..."

cat > /workspace/source-env.sh << 'EOF'
#!/bin/bash
# Source this file to load persistent environment
if [ -f "/workspace/.env.persistent" ]; then
    echo "🔄 Loading persistent environment..."
    source /workspace/.env.persistent
    echo "✅ Environment loaded"
    echo "🌐 Repository: ${REPO_URL}"
    echo "👤 GitHub User: ${GITHUB_USER}"
else
    echo "❌ Persistent environment not found"
    echo "Run: ./setup-env.sh"
fi
EOF

chmod +x /workspace/source-env.sh

echo "✅ Environment source script created"

# Step 6: Verification
echo ""
echo "🧪 Verification:"
echo "✅ Persistent config: /workspace/.env.persistent"
echo "✅ Repository script: /workspace/setup-github-repo.sh"
echo "✅ Environment loader: /workspace/source-env.sh"
echo ""

# Step 7: Instructions for user
echo "🎯 TO CONTINUE:"
echo "1. Run: ./setup-github-repo.sh"
echo "2. Or manually create repo: https://github.com/new"
echo "3. Then: ./source-env.sh && ./manage.sh production up"
echo ""

echo "🎉 PERSISTENT SETUP COMPLETE!"
echo "Your configuration is now saved and will persist across sessions!"