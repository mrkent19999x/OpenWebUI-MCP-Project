#!/bin/bash

# ==============================================
# Open WebUI Stack Setup Script
# Multi-Provider AI Chat Interface Setup
# ==============================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
STACK_NAME="open-webui-stack"
DOMAIN="localhost"
GIT_REPO="https://github.com/open-webui/open-webui"

echo -e "${BLUE}🚀 Open WebUI Stack Setup${NC}"
echo -e "${BLUE}==============================${NC}"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not installed. Please install Docker Compose first.${NC}"
    exit 1
fi

# Create directory structure
echo -e "${YELLOW}📁 Creating directory structure...${NC}"
mkdir -p {open-webui-data,open-webui-cache,lobe-chat-data,anythingllm-storage,ollama-data,redis-data,litellm-db,prometheus-data,grafana-data,ssl,backups}
mkdir -p {extensions,plugins,custom-themes,logs}

# Copy configuration files
echo -e "${YELLOW}📋 Setting up configuration files...${NC}"

if [ ! -f .env ]; then
    cp .env.template .env
    echo -e "${YELLOW}⚠️  Please edit .env file and add your API keys${NC}"
    echo -e "${YELLOW}   You can also run 'make setup-keys' after editing .env${NC}"
fi

if [ ! -f nginx.conf ]; then
    echo -e "${YELLOW}⚠️  Please edit nginx.conf and set your domain${NC}"
fi

if [ ! -f prometheus.yml ]; then
    echo -e "${YELLOW}⚠️  Prometheus config copied${NC}"
fi

# Set proper permissions
chmod 755 .
chmod 644 *.yml *.conf *.template 2>/dev/null || true

# Check API keys
check_api_key() {
    local key_name=$1
    local key_value=$(eval echo \$$key_name)
    
    if [ -z "$key_value" ] || [ "$key_value" = "sk-your-$key_name-key-here" ]; then
        echo -e "${YELLOW}⚠️  $key_name not configured${NC}"
        return 1
    else
        echo -e "${GREEN}✅ $key_name configured${NC}"
        return 0
    fi
}

# Validate API keys
echo -e "${YELLOW}🔑 Validating API keys...${NC}"
source .env 2>/dev/null || echo -e "${RED}⚠️  No .env file found${NC}"

check_api_key "CEREBRAS_API_KEY" && echo "  - Cerebras: Highest priority (1M tokens/day)"
check_api_key "CLOUDFLARE_API_KEY" && echo "  - Cloudflare: High availability (10K neurons/day)"
check_api_key "GITHUB_TOKEN" && echo "  - GitHub Models: Multimodal support"
check_api_key "OPENROUTER_API_KEY" && echo "  - OpenRouter: Model variety"
check_api_key "GOOGLE_API_KEY" && echo "  - Google AI: Gemini models"

# Pull Docker images
echo -e "${YELLOW}🐳 Pulling Docker images...${NC}"
docker-compose pull

# Start services
echo -e "${YELLOW}🚀 Starting services...${NC}"

# Check if docker-compose or docker compose is available
if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
else
    DOCKER_COMPOSE="docker compose"
fi

# Start core services first
$DOCKER_COMPOSE up -d ollama redis

echo -e "${BLUE}Waiting for core services to be ready...${NC}"
sleep 30

# Pull some popular Ollama models
echo -e "${YELLOW}📦 Downloading Ollama models (this may take a while)...${NC}"
docker exec ollama ollama pull llama3.2:3b
docker exec ollama ollama pull phi3:mini

# Start all services
$DOCKER_COMPOSE up -d

echo -e "${BLUE}Waiting for all services to start...${NC}"
sleep 60

# Check service status
echo -e "${YELLOW}🔍 Checking service status...${NC}"

services=("open-webui-main:3000" "lobe-chat:3001" "anything-llm:3002" "litellm-proxy:4000" "grafana:3003" "prometheus:9090" "nginx:80")

for service in "${services[@]}"; do
    IFS=':' read -r name port <<< "$service"
    
    if curl -s "http://localhost:$port/health" > /dev/null 2>&1 || curl -s "http://localhost:$port" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ $name is running${NC}"
    else
        echo -e "${RED}❌ $name failed to start${NC}"
    fi
done

# Create backup script
cat > backup.sh << 'EOF'
#!/bin/bash
# Daily backup script
BACKUP_DIR="./backups/$(date +%Y-%m-%d)"
mkdir -p "$BACKUP_DIR"

echo "Creating backup..."

# Backup data directories
tar -czf "$BACKUP_DIR/open-webui-data.tar.gz" open-webui-data/
tar -czf "$BACKUP_DIR/lobe-chat-data.tar.gz" lobe-chat-data/
tar -czf "$BACKUP_DIR/anythingllm-storage.tar.gz" anythingllm-storage/
tar -czf "$BACKUP_DIR/ollama-data.tar.gz" ollama-data/
tar -czf "$BACKUP_DIR/redis-data.tar.gz" redis-data/

# Backup configuration
cp .env "$BACKUP_DIR/" 2>/dev/null || true
cp nginx.conf "$BACKUP_DIR/" 2>/dev/null || true
cp litellm-config.yaml "$BACKUP_DIR/" 2>/dev/null || true

echo "Backup completed: $BACKUP_DIR"

# Remove old backups (keep 30 days)
find ./backups -type d -mtime +30 -exec rm -rf {} + 2>/dev/null || true
EOF

chmod +x backup.sh

# Install Open WebUI extensions
echo -e "${YELLOW}🔧 Installing extensions...${NC}"
mkdir -p extensions

# Download popular extensions
if [ ! -f extensions/open-webui-tools.tar.gz ]; then
    echo "Downloading Open WebUI Tools..."
    curl -L "https://github.com/Haervwe/open-webui-tools/archive/main.tar.gz" -o extensions/open-webui-tools.tar.gz
    tar -xzf extensions/open-webui-tools.tar.gz -C extensions/
fi

# Create maintenance script
cat > maintenance.sh << 'EOF'
#!/bin/bash
# Maintenance script

echo "=== Open WebUI Stack Maintenance ==="
echo "Date: $(date)"

# Check disk usage
echo "Disk Usage:"
df -h

# Check Docker containers
echo -e "\nDocker Containers Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Check service health
echo -e "\nService Health Check:"
curl -s http://localhost:3000/health && echo " - Open WebUI: OK" || echo " - Open WebUI: FAIL"
curl -s http://localhost:4000/health && echo " - LiteLLM: OK" || echo " - LiteLLM: FAIL"
curl -s http://localhost:6379 && echo " - Redis: OK" || echo " - Redis: FAIL"

# Clean up old Docker resources
echo -e "\nCleaning up Docker resources..."
docker system prune -f

# Update models list
echo -e "\nChecking for model updates..."
docker exec ollama ollama list

echo "Maintenance completed."
EOF

chmod +x maintenance.sh

# Create monitoring dashboard
echo -e "${YELLOW}📊 Setting up monitoring...${NC}"
echo "Grafana Dashboard: http://localhost:3003"
echo "Prometheus: http://localhost:9090"
echo "Default admin credentials: admin / admin123"

echo -e "\n${GREEN}🎉 Setup completed successfully!${NC}"
echo -e "\n${BLUE}Access Points:${NC}"
echo "  🌐 Open WebUI: http://localhost:3000"
echo "  🌐 LobeChat: http://localhost:3001"
echo "  🌐 AnythingLLM: http://localhost:3002"
echo "  🌐 Monitoring: http://localhost:3003"
echo "  📊 Prometheus: http://localhost:9090"
echo "  🔗 API Gateway: http://localhost:4000"

echo -e "\n${YELLOW}Next Steps:${NC}"
echo "1. Edit .env file with your API keys"
echo "2. Edit nginx.conf with your domain"
echo "3. Run 'docker-compose restart' to apply changes"
echo "4. Run './backup.sh' for initial backup"
echo "5. Run './maintenance.sh' for health check"

echo -e "\n${BLUE}Management Commands:${NC}"
echo "  make status    - Check service status"
echo "  make logs      - View logs"
echo "  make restart   - Restart all services"
echo "  make backup    - Create backup"
echo "  make update    - Update services"
echo "  make down      - Stop all services"

# Create Makefile for easy management
cat > Makefile << 'EOF'
.PHONY: status logs restart backup update down clean

# Check service status
status:
	@echo "=== Service Status ==="
	@docker-compose ps
	@echo -e "\n=== Health Check ==="
	@curl -s http://localhost:3000/health && echo "Open WebUI: OK" || echo "Open WebUI: FAIL"
	@curl -s http://localhost:4000/health && echo "LiteLLM: OK" || echo "LiteLLM: FAIL"

# View logs
logs:
	@echo "=== Open WebUI Logs ==="
	@docker-compose logs -f open-webui-main

# Restart services
restart:
	@echo "Restarting all services..."
	@docker-compose restart

# Create backup
backup:
	@./backup.sh

# Update services
update:
	@echo "Updating Docker images..."
	@docker-compose pull
	@docker-compose up -d

# Stop all services
down:
	@echo "Stopping all services..."
	@docker-compose down

# Clean everything
clean:
	@echo "Cleaning Docker volumes and data..."
	@docker-compose down -v
	@docker system prune -f

# Install Ollama models
models:
	@echo "Installing Ollama models..."
	@docker exec ollama ollama pull llama3.2:3b
	@docker exec ollama ollama pull phi3:mini
	@docker exec ollama ollama pull gemma:2b

# Setup API keys
setup-keys:
	@echo "Checking API key configuration..."
	@bash -c 'source .env 2>/dev/null; echo "Cerebras API: $${CEREBRAS_API_KEY:0:20}..."'
	@bash -c 'source .env 2>/dev/null; echo "Cloudflare API: $${CLOUDFLARE_API_KEY:0:20}..."'
	@bash -c 'source .env 2>/dev/null; echo "GitHub Token: $${GITHUB_TOKEN:0:20}..."'
EOF

echo -e "\n${GREEN}✅ Setup script completed!${NC}"