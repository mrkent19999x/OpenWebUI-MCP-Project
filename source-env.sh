#!/bin/bash
# Source this file to load persistent environment

echo "🔄 Loading persistent OpenWebUI environment..."

if [ -f "/workspace/.env.persistent" ]; then
    # Load the persistent environment
    source /workspace/.env.persistent
    
    echo "✅ Environment loaded successfully!"
    echo "🌐 Repository: ${REPO_URL}"
    echo "👤 GitHub User: ${GITHUB_USER}"
    echo "🎯 Ready for development and deployment"
    
    # Also copy to OpenWebUI directory if exists
    if [ -d "/workspace/Openwwebui" ]; then
        cp /workspace/.env.persistent /workspace/Openwwebui/.env
        echo "✅ Config copied to Openwwebui/.env"
    fi
    
else
    echo "❌ Persistent environment not found!"
    echo "Run ./setup-env.sh first"
fi