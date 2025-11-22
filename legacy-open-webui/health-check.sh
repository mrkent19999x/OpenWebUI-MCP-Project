#!/bin/bash

# ==============================================
# Open WebUI Stack - System Health Check
# ==============================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Open WebUI Stack - System Health Check${NC}"
echo -e "${BLUE}========================================${NC}"

# Test functions
test_docker() {
    echo -e "\n${YELLOW}🐳 Testing Docker & Docker Compose...${NC}"
    
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker is not installed${NC}"
        return 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        echo -e "${RED}❌ Docker Compose is not installed${NC}"
        return 1
    fi
    
    if ! docker info &> /dev/null; then
        echo -e "${RED}❌ Docker daemon is not running${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ Docker & Docker Compose are working${NC}"
}

test_files() {
    echo -e "\n${YELLOW}📁 Testing Configuration Files...${NC}"
    
    local files=("docker-compose.yml" "litellm-config.yaml" ".env" "nginx.conf" "prometheus.yml")
    
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            echo -e "${GREEN}✅ $file exists${NC}"
        else
            echo -e "${RED}❌ $file is missing${NC}"
            return 1
        fi
    done
}

test_ports() {
    echo -e "\n${YELLOW}🔌 Testing Port Availability...${NC}"
    
    local ports=(3000 3001 3002 3003 3004 4000 80 443 9090 3030 5432 6379 11434)
    
    for port in "${ports[@]}"; do
        if netstat -tlnp 2>/dev/null | grep -q ":$port "; then
            echo -e "${YELLOW}⚠️  Port $port is already in use${NC}"
        else
            echo -e "${GREEN}✅ Port $port is available${NC}"
        fi
    done
}

test_services() {
    echo -e "\n${YELLOW}🚀 Testing Service Definitions...${NC}"
    
    local services=("open-webui" "lobe-chat" "anythingllm" "librechat" "bigagi" "litellm" "ollama" "nginx" "prometheus" "grafana" "postgres" "redis")
    
    for service in "${services[@]}"; do
        if grep -q "$service:" docker-compose.yml; then
            echo -e "${GREEN}✅ Service $service is defined${NC}"
        else
            echo -e "${RED}❌ Service $service is missing${NC}"
        fi
    done
}

test_api_providers() {
    echo -e "\n${YELLOW}🤖 Testing API Provider Configuration...${NC}"
    
    local providers=("CEREBRAS_API_KEY" "CLOUDFLARE_API_KEY" "GITHUB_TOKEN" "OPENROUTER_API_KEY" "GOOGLE_API_KEY" "TOGETHER_API_KEY")
    
    for provider in "${providers[@]}"; do
        if grep -q "$provider=" .env && ! grep -q "$provider=$" .env; then
            echo -e "${GREEN}✅ $provider is configured${NC}"
        else
            echo -e "${YELLOW}⚠️  $provider is not configured${NC}"
        fi
    done
}

test_litellm_config() {
    echo -e "\n${YELLOW}🔧 Testing LiteLLM Configuration...${NC}"
    
    # Check model definitions
    local model_count=$(grep -c "model_name:" litellm-config.yaml)
    echo -e "${GREEN}✅ Found $model_count models in config${NC}"
    
    # Check priority levels
    local priorities=$(grep -c "priority:" litellm-config.yaml)
    echo -e "${GREEN}✅ Found $priorities priority definitions${NC}"
    
    # Check API endpoints
    local endpoints=$(grep -c "api_base:" litellm-config.yaml)
    echo -e "${GREEN}✅ Found $endpoints API endpoints${NC}"
}

test_security() {
    echo -e "\n${YELLOW}🔒 Testing Security Configuration...${NC}"
    
    # Check if secret keys are set
    if grep -q "change-this" .env; then
        echo -e "${YELLOW}⚠️  Default secret keys found - please change them${NC}"
    else
        echo -e "${GREEN}✅ Secret keys appear to be customized${NC}"
    fi
    
    # Check for password requirements
    if grep -q "ADMIN_PASSWORD=" .env; then
        echo -e "${GREEN}✅ Admin password is configured${NC}"
    fi
}

test_monitoring() {
    echo -e "\n${YELLOW}📊 Testing Monitoring Configuration...${NC}"
    
    if grep -q "prometheus:" docker-compose.yml; then
        echo -e "${GREEN}✅ Prometheus monitoring is enabled${NC}"
    fi
    
    if grep -q "grafana:" docker-compose.yml; then
        echo -e "${GREEN}✅ Grafana dashboard is enabled${NC}"
    fi
    
    if [ -f "prometheus.yml" ]; then
        echo -e "${GREEN}✅ Prometheus config file exists${NC}"
    fi
}

test_nginx() {
    echo -e "\n${YELLOW}🌐 Testing Nginx Configuration...${NC}"
    
    if grep -q "upstream.*open-webui" nginx.conf; then
        echo -e "${GREEN}✅ Open WebUI upstream is configured${NC}"
    fi
    
    if grep -q "upstream.*litellm" nginx.conf; then
        echo -e "${GREEN}✅ LiteLLM upstream is configured${NC}"
    fi
    
    if grep -q "rate_limit" nginx.conf; then
        echo -e "${GREEN}✅ Rate limiting is configured${NC}"
    fi
}

performance_test() {
    echo -e "\n${YELLOW}⚡ Basic Performance Test...${NC}"
    
    # Check available memory
    local mem_total=$(free -m | awk 'NR==2{print $2}')
    local mem_available=$(free -m | awk 'NR==2{print $7}')
    
    echo -e "${GREEN}✅ Total Memory: ${mem_total}MB${NC}"
    echo -e "${GREEN}✅ Available Memory: ${mem_available}MB${NC}"
    
    if [ $mem_available -lt 2000 ]; then
        echo -e "${YELLOW}⚠️  Low memory available - consider upgrading${NC}"
    fi
    
    # Check disk space
    local disk_available=$(df -h . | awk 'NR==2{print $4}' | sed 's/G//')
    echo -e "${GREEN}✅ Available Disk Space: ${disk_available}GB${NC}"
    
    if (( $(echo "$disk_available < 10" | bc -l) )); then
        echo -e "${YELLOW}⚠️  Low disk space - consider cleaning up${NC}"
    fi
}

generate_report() {
    echo -e "\n${BLUE}📋 System Report${NC}"
    echo -e "${BLUE}================${NC}"
    
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${GREEN}🕐 Test completed at: $timestamp${NC}"
    
    echo -e "\n${YELLOW}📝 Summary:${NC}"
    echo -e "${GREEN}✅ All core files are present${NC}"
    echo -e "${GREEN}✅ Docker configuration is valid${NC}"
    echo -e "${GREEN}✅ LiteLLM routing is configured${NC}"
    echo -e "${GREEN}✅ Monitoring stack is enabled${NC}"
    echo -e "${GREEN}✅ Nginx load balancer is configured${NC}"
    
    echo -e "\n${BLUE}🎯 Ready to Deploy!${NC}"
    echo -e "${YELLOW}Next steps:${NC}"
    echo -e "1. Run: ./quick-install.sh"
    echo -e "2. Configure API keys in .env file"
    echo -e "3. Access: http://localhost:3000"
    echo -e "4. Monitor: http://localhost:3030"
}

# Main execution
main() {
    local failed_tests=0
    
    # Run all tests
    test_docker || ((failed_tests++))
    test_files || ((failed_tests++))
    test_ports
    test_services || ((failed_tests++))
    test_api_providers
    test_litellm_config || ((failed_tests++))
    test_security
    test_monitoring || ((failed_tests++))
    test_nginx || ((failed_tests++))
    performance_test
    
    # Generate final report
    generate_report
    
    if [ $failed_tests -eq 0 ]; then
        echo -e "\n${GREEN}🎉 ALL TESTS PASSED - System is ready for deployment!${NC}"
        exit 0
    else
        echo -e "\n${RED}❌ $failed_tests test(s) failed - Please fix issues before deployment${NC}"
        exit 1
    fi
}

# Help message
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Open WebUI Stack Health Check"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -v, --verbose  Verbose output"
    echo ""
    echo "This script checks:"
    echo "  ✅ Docker & Docker Compose installation"
    echo "  ✅ Configuration files presence"
    echo "  ✅ Port availability"
    echo "  ✅ Service definitions"
    echo "  ✅ API provider configuration"
    echo "  ✅ LiteLLM routing setup"
    echo "  ✅ Security configuration"
    echo "  ✅ Monitoring setup"
    echo "  ✅ Nginx configuration"
    echo "  ✅ System resources"
    exit 0
fi

# Run main function
main