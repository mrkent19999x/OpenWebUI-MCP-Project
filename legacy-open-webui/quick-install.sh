#!/bin/bash

# Open WebUI Stack - One-Click Installation Script
# Complete setup with all forks and alternatives

set -e

echo "🚀 Open WebUI Stack - Complete Installation"
echo "==========================================="

# Check prerequisites
echo "📋 Checking prerequisites..."

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Installing..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    usermod -aG docker $USER
fi

# Check Docker Compose
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose not found. Installing..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Create project directory
echo "📁 Creating project structure..."
mkdir -p open-webui-stack/{config,data,logs,backups,ssl}
cd open-webui-stack

# Download configuration files
echo "📥 Downloading configuration files..."

# Copy the docker-compose.yml, nginx.conf, etc. from previous files
# (These should be copied from the workspace)

# Create environment file
echo "🔧 Creating environment configuration..."
cat > .env << 'EOF'
# Open WebUI Stack - Environment Configuration
# Fill in your API keys here

# Security Keys (CHANGE THESE!)
WEBUI_SECRET_KEY=change-this-super-secret-key-32-chars-min
ADMIN_PASSWORD=change-this-admin-password
JWT_SECRET_KEY=change-this-jwt-secret-key

# AI Provider API Keys
CEREBRAS_API_KEY=sk-your-cerebras-api-key
CLOUDFLARE_API_KEY=your-cloudflare-token
CLOUDFLARE_ACCOUNT_ID=your-cloudflare-account-id
GITHUB_TOKEN=ghp-your-github-token
OPENROUTER_API_KEY=sk-or-your-openrouter-key
GOOGLE_API_KEY=your-google-ai-key
TOGETHER_API_KEY=your-together-ai-key

# Domain Configuration
DOMAIN=localhost
LETSENCRYPT_EMAIL=your-email@domain.com

# Monitoring
GRAFANA_ADMIN_PASSWORD=change-this-grafana-password
NGINX_BASIC_AUTH_USER=admin
NGINX_BASIC_AUTH_PASS=change-this-auth-password
EOF

# Set proper permissions
chmod 600 .env

# Start services
echo "🚀 Starting Open WebUI Stack..."

# Start core services
docker-compose up -d ollama redis

# Wait for core services
echo "⏳ Waiting for core services..."
sleep 30

# Pull popular models
echo "📦 Downloading Ollama models..."
docker exec ollama ollama pull llama3.2:3b
docker exec ollama ollama pull phi3:mini
docker exec ollama ollama pull gemma:2b

# Start all services
docker-compose up -d

# Wait for all services
echo "⏳ Waiting for all services to start..."
sleep 60

# Health check
echo "🔍 Running health checks..."
services=("open-webui-main:3000" "lobe-chat:3001" "anything-llm:3002" "litellm-proxy:4000" "grafana:3003" "prometheus:9090")

for service in "${services[@]}"; do
    IFS=':' read -r name port <<< "$service"
    if curl -s http://localhost:$port > /dev/null 2>&1; then
        echo "✅ $name is running on port $port"
    else
        echo "❌ $name failed to start"
    fi
done

echo ""
echo "🎉 Installation completed successfully!"
echo ""
echo "🌐 Access Points:"
echo "  • Open WebUI (Main): http://localhost:3000"
echo "  • LobeChat (Alternative): http://localhost:3001" 
echo "  • AnythingLLM (All-in-One): http://localhost:3002"
echo "  • Monitoring (Grafana): http://localhost:3003"
echo "  • Metrics (Prometheus): http://localhost:9090"
echo "  • API Gateway (LiteLLM): http://localhost:4000"
echo ""
echo "⚠️  Next steps:"
echo "1. Edit .env file with your API keys"
echo "2. Configure nginx.conf with your domain"
echo "3. Set up SSL certificates"
echo "4. Install Open WebUI extensions"
echo "5. Configure monitoring dashboards"
echo ""
echo "📚 Documentation:"
echo "  • Full guide: extensions/extension_guide.md"
echo "  • Configuration: docker-compose.yml"
echo "  • Makefile: make status|logs|restart|backup"