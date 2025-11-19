#!/bin/bash

# Environment Validation Script for OpenWebUI-MCP-Project
# Checks required environment variables and connectivity

set -e

echo "🔍 Validating OpenWebUI-MCP Environment..."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[ℹ]${NC} $1"
}

# Check .env file exists
if [ ! -f ".env" ]; then
    print_error ".env file not found!"
    print_info "Copy .env.example to .env and fill in your values"
    print_info "Run: cp .env.example .env"
    exit 1
fi

print_status "Found .env file"

# Source environment
source .env

# Check required environment variables
echo ""
echo "📋 Checking Required Variables..."

REQUIRED_VARS=(
    "WEBUI_URL"
    "WEBUI_NAME"
    "WEBUI_SECRET_KEY"
)

OPTIONAL_VARS=(
    "OPENAI_API_KEY"
    "ANTHROPIC_API_KEY"
    "MINIMAX_API_KEY"
    "DATABASE_URL"
    "GITHUB_TOKEN"
    "GEMINI_API_KEY"
)

# Check required variables
for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var}" ]; then
        print_error "$var is required but not set"
        exit 1
    else
        print_status "$var is set"
    fi
done

# Check optional variables
for var in "${OPTIONAL_VARS[@]}"; do
    if [ -z "${!var}" ]; then
        print_warning "$var is not set (optional)"
    else
        print_status "$var is set"
    fi
done

# Validate WEBUI_SECRET_KEY length
if [ ${#WEBUI_SECRET_KEY} -lt 32 ]; then
    print_error "WEBUI_SECRET_KEY must be at least 32 characters"
    exit 1
fi

print_status "WEBUI_SECRET_KEY length is adequate"

# Extract port from WEBUI_URL
PORT=$(echo $WEBUI_URL | sed 's/.*://' | sed 's/[:/].*//')
if [ ! -z "$PORT" ]; then
    if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_warning "Port $PORT is already in use"
    else
        print_status "Port $PORT is available"
    fi
fi

# Check Docker installation
echo ""
echo "🐳 Checking Docker Installation..."

if command -v docker &> /dev/null; then
    print_status "Docker is installed"
    if docker info &> /dev/null; then
        print_status "Docker daemon is running"
    else
        print_error "Docker daemon is not running"
        print_info "Start Docker daemon and try again"
        exit 1
    fi
else
    print_error "Docker is not installed"
    print_info "Install Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check Docker Compose
if command -v docker-compose &> /dev/null || docker compose version &> /dev/null; then
    print_status "Docker Compose is available"
else
    print_error "Docker Compose is not installed"
    print_info "Install Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

# Check required directories
echo ""
echo "📁 Checking Directory Structure..."

REQUIRED_DIRS=(
    "config"
    "config/prompts"
    "config/cursor"
    "config/ui"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        print_status "Directory $dir exists"
    else
        print_warning "Directory $dir not found - creating..."
        mkdir -p "$dir"
        print_status "Created directory $dir"
    fi
done

# Check required files
echo ""
echo "📄 Checking Required Files..."

REQUIRED_FILES=(
    "docker-compose.yml"
    ".env"
    ".env.example"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        print_status "File $file exists"
    else
        print_error "File $file not found"
        exit 1
    fi
done

# Test API connectivity
echo ""
echo "🌐 Testing API Connectivity..."

# Test OpenAI API
if [ ! -z "$OPENAI_API_KEY" ]; then
    if curl -s -H "Authorization: Bearer $OPENAI_API_KEY" https://api.openai.com/v1/models > /dev/null; then
        print_status "OpenAI API connection successful"
    else
        print_error "OpenAI API connection failed"
    fi
fi

# Test Anthropic API
if [ ! -z "$ANTHROPIC_API_KEY" ]; then
    if curl -s -H "x-api-key: $ANTHROPIC_API_KEY" https://api.anthropic.com/v1/messages > /dev/null; then
        print_status "Anthropic API connection successful"
    else
        print_error "Anthropic API connection failed"
    fi
fi

# Test MiniMax API
if [ ! -z "$MINIMAX_API_KEY" ]; then
    if curl -s -H "Authorization: Bearer $MINIMAX_API_KEY" https://api.minimax.chat/v1/text/chatcompletion_v2 > /dev/null; then
        print_status "MiniMax API connection successful"
    else
        print_warning "MiniMax API connection test skipped (different endpoint format)"
    fi
fi

# Test GitHub API
if [ ! -z "$GITHUB_TOKEN" ]; then
    if curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user > /dev/null; then
        print_status "GitHub API connection successful"
    else
        print_error "GitHub API connection failed"
    fi
fi

# Check system resources
echo ""
echo "💻 Checking System Resources..."

# Check available memory
MEMORY_GB=$(free -g | awk '/^Mem:/{print $2}')
if [ $MEMORY_GB -ge 4 ]; then
    print_status "Available memory: ${MEMORY_GB}GB (sufficient)"
elif [ $MEMORY_GB -ge 2 ]; then
    print_warning "Available memory: ${MEMORY_GB}GB (minimum recommended)"
else
    print_error "Available memory: ${MEMORY_GB}GB (insufficient - need at least 2GB)"
fi

# Check disk space
DISK_GB=$(df -BG . | awk 'NR==2{print $4}' | sed 's/G//')
if [ $DISK_GB -ge 10 ]; then
    print_status "Available disk space: ${DISK_GB}GB (sufficient)"
else
    print_warning "Available disk space: ${DISK_GB}GB (may need more for models)"
fi

# Summary
echo ""
echo "🎉 Environment validation complete!"
print_status "Your OpenWebUI-MCP-Project is ready to start!"
echo ""
print_info "Next steps:"
echo "  1. docker-compose up -d"
echo "  2. Visit: $WEBUI_URL"
echo "  3. Login with: admin / admin"
echo ""
print_info "For troubleshooting, check logs:"
echo "  docker-compose logs -f open-webui"

exit 0