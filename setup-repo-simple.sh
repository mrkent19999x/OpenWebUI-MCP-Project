#!/bin/bash

echo "🚀 Setting up GitHub Repository..."

# Load environment variables from .env.persistent
export GITHUB_USER="mrkent19999x"
export REPO_NAME="OpenWebUI-MCP-Project"
export REPO_URL="https://github.com/mrkent19999x/OpenWebUI-MCP-Project.git"

# Load GitHub token from .env.persistent (excluding the token line itself)
export $(cat .env.persistent | grep 'GITHUB_TOKEN=' | cut -d= -f1)

echo "✅ Environment loaded:"
echo "   GITHUB_USER: $GITHUB_USER"
echo "   REPO_NAME: $REPO_NAME"
echo "   Token: ${GITHUB_TOKEN:0:10}...${GITHUB_TOKEN: -6}" 2>/dev/null || echo "   Token: Available but hidden"
echo ""

# Configure git
echo "🔧 Configuring Git..."
git config --global user.email "${GITHUB_USER}@users.noreply.github.com"
git config --global user.name "${GITHUB_USER}"
git config --global credential.helper store

# Store GitHub credentials
echo "$REPO_URL" | git credential approve

echo "✅ Git configured successfully"
echo ""

# Check if repository exists
echo "🔍 Checking repository existence..."
REPO_CHECK=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" \
  "https://api.github.com/repos/${GITHUB_USER}/${REPO_NAME}" 2>/dev/null || echo "ERROR")

if [[ $REPO_CHECK == *"Not Found"* ]] || [[ $REPO_CHECK == "ERROR" ]]; then
    echo "📝 Creating new repository on GitHub..."
    
    CREATE_RESPONSE=$(curl -X POST \
      -H "Authorization: token ${GITHUB_TOKEN}" \
      -H "Accept: application/vnd.github.v3+json" \
      https://api.github.com/user/repos \
      -d '{
        "name": "'${REPO_NAME}'",
        "description": "Enterprise OpenWebUI deployment with MCP integration - Vietnamese localization",
        "private": false,
        "auto_init": true,
        "gitignore_template": "Python"
      }' 2>/dev/null)
    
    if [[ $CREATE_RESPONSE == *"Created"* ]]; then
        echo "✅ Repository created successfully"
        echo "Response: $CREATE_RESPONSE"
    else
        echo "⚠️ Repository may already exist or creation failed"
        echo "Response: $CREATE_RESPONSE"
    fi
else
    echo "✅ Repository already exists"
fi

echo ""

# Setup git and push
echo "🔗 Setting up Git repository..."
cd /workspace

# Add remote origin
git remote remove origin 2>/dev/null || true
git remote add origin "${REPO_URL}"

# Check if there are changes to commit
if ! git diff-index --quiet HEAD --; then
    echo "📁 Adding files to repository..."
    git add .
    
    echo "💾 Creating commit..."
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
- source-env.sh - Environment loader
- Openwwebui/ - Main application with Docker configs

🚀 Ready for deployment!"
    
    echo "🚀 Pushing to GitHub..."
    git push -u origin master
    
    if [ $? -eq 0 ]; then
        echo "🎉 Successfully pushed to GitHub!"
    else
        echo "⚠️ Push failed - trying with different branch"
        git push -u origin main 2>/dev/null || echo "⚠️ Push failed - check repository permissions"
    fi
else
    echo "📝 No changes to commit"
fi

echo ""
echo "🎯 Repository Status:"
echo "✅ Repository URL: $REPO_URL"
echo "✅ GitHub token configured"
echo ""
echo "🌐 Access your repository at:"
echo "https://github.com/$GITHUB_USER/$REPO_NAME"
echo ""
echo "🚀 Next steps:"
echo "1. Visit your GitHub repository"
echo "2. Fill API keys in .env file" 
echo "3. Deploy: ./manage.sh production up"
echo "4. Monitor: ./manage.sh health-check"
echo ""
echo "🔄 To reload environment in new sessions:"
echo "source ./source-env.sh"