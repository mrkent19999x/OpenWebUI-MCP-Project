#!/bin/bash

# Apply Model Filter to All UIs
# Tự động áp dụng cấu hình lọc model cho tất cả UI interfaces

echo "🎯 Applying Model Filter to All AI Interfaces"
echo "============================================"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Function to update docker-compose with filtered models
update_docker_compose() {
    echo -e "${BLUE}📝 Updating Docker Compose with filtered models...${NC}"
    
    # Backup original
    cp docker-compose.yml docker-compose.yml.backup
    
    # Create filtered models list
    cat > /tmp/filtered_models.txt << 'EOF'
# Filtered Models List - Only Working Models
# Updated: $(date)

# Local Models (No API Key Required)
- llama3.1 (Ollama) - Fast General Chat
- mistral:7b (Ollama) - Balanced Performance  
- codellama (Ollama) - Programming Tasks
- phi3:mini (Ollama) - Lightweight Model

# Cloud Models (API Key Required but Working)
- gpt-4o-mini (OpenAI) - Fast & Affordable
- claude-3.5-haiku (Anthropic) - Quick Responses
- gemini-pro (Google) - Good Quality
EOF
    
    echo -e "${GREEN}✅ Created filtered models list${NC}"
}

# Function to create UI-specific configs
create_ui_configs() {
    echo -e "${BLUE}🎨 Creating UI-specific configurations...${NC}"
    
    # Open WebUI config
    create_openwebui_config
    
    # LiteLLM config
    create_litellm_config
    
    # LobeChat config
    create_lobechat_config
    
    # AnythingLLM config
    create_anythingllm_config
    
    echo -e "${GREEN}✅ All UI configs created${NC}"
}

# Open WebUI Configuration
create_openwebui_config() {
    mkdir -p openwebui/data/config
    
    cat > openwebui/data/config/models.json << 'EOF'
{
  "models": [
    {
      "id": "ollama-llama3.1",
      "name": "Llama 3.1 (Local)",
      "provider": "ollama",
      "api_base": "http://localhost:11434",
      "model": "llama3.1",
      "description": "Fast local model for general chat",
      "category": "Local AI"
    },
    {
      "id": "ollama-mistral",
      "name": "Mistral 7B (Local)", 
      "provider": "ollama",
      "api_base": "http://localhost:11434",
      "model": "mistral:7b",
      "description": "Balanced performance model",
      "category": "Local AI"
    },
    {
      "id": "ollama-codellama",
      "name": "Code Llama (Local)",
      "provider": "ollama", 
      "api_base": "http://localhost:11434",
      "model": "codellama",
      "description": "Specialized for programming",
      "category": "Programming"
    },
    {
      "id": "openai-gpt4o-mini",
      "name": "GPT-4o Mini (Cloud)",
      "provider": "openai",
      "model": "gpt-4o-mini",
      "api_key": "${OPENAI_API_KEY}",
      "description": "Fast and affordable cloud model",
      "category": "Cloud AI",
      "requires_key": true
    },
    {
      "id": "anthropic-haiku",
      "name": "Claude Haiku (Cloud)",
      "provider": "anthropic",
      "model": "claude-3-5-haiku-20241022",
      "api_key": "${ANTHROPIC_API_KEY}",
      "description": "Quick cloud responses",
      "category": "Cloud AI",
      "requires_key": true
    }
  ],
  "filters": {
    "show_only_working": true,
    "group_by_category": true,
    "sort_by_speed": true
  }
}
EOF
    
    echo -e "${GREEN}✅ Open WebUI config created${NC}"
}

# LiteLLM Configuration
create_litellm_config() {
    mkdir -p litellm/config
    
    cat > litellm/config/model_list.yaml << 'EOF'
model_list:
  # Local Models (No API Key)
  - model_name: llama-local
    litellm_params:
      model: ollama/llama3.1
      api_base: http://localhost:11434
      streaming: true
      supports_function_calling: true
      supports_parallel_function_calling: false

  - model_name: mistral-local  
    litellm_params:
      model: ollama/mistral:7b
      api_base: http://localhost:11434
      streaming: true

  - model_name: codellama-local
    litellm_params:
      model: ollama/codellama
      api_base: http://localhost:11434
      streaming: true

  # Cloud Models (API Key Required)
  - model_name: gpt-4o-mini-fast
    litellm_params:
      model: openai/gpt-4o-mini
      api_key: ${OPENAI_API_KEY}

  - model_name: claude-haiku-quick
    litellm_params:
      model: anthropic/claude-3-5-haiku-20241022
      api_key: ${ANTHROPIC_API_KEY}

  - model_name: gemini-pro-vision
    litellm_params:
      model: google/gemini-pro-vision
      api_key: ${GOOGLE_API_KEY}

general_settings:
  database_url: "sqlite:///./litellm.db"
  cache: true
  master_key: "your-master-key"
  
routing:
  # Load balancing among similar models
  strategies:
    - strategy:
        model_group_strategy:
          - "llama-local, mistral-local"
          - "gpt-4o-mini-fast, claude-haiku-quick"
EOF
    
    echo -e "${GREEN}✅ LiteLLM config created${NC}"
}

# LobeChat Configuration  
create_lobechat_config() {
    mkdir -p lobechat/data
    
    cat > lobechat/data/models.json << 'EOF'
{
  "models": [
    {
      "id": "ollama://llama3.1",
      "name": "Llama 3.1",
      "type": "ollama",
      "displayName": "Llama 3.1 (Local)",
      "description": "Fast local model for general conversation",
      "tags": ["local", "fast", "general"],
      "enabled": true,
      "isDefault": true
    },
    {
      "id": "ollama://mistral:7b",
      "name": "ollama://mistral:7b", 
      "type": "ollama",
      "displayName": "Mistral 7B (Local)",
      "description": "Balanced performance for various tasks",
      "tags": ["local", "balanced"],
      "enabled": true
    },
    {
      "id": "openai://gpt-4o-mini",
      "name": "openai://gpt-4o-mini",
      "type": "openai",
      "displayName": "GPT-4o Mini",
      "description": "Fast and affordable cloud model",
      "tags": ["cloud", "fast", "affordable"],
      "enabled": true,
      "requiresAuth": true
    }
  ],
  "groups": [
    {
      "id": "local-ai",
      "name": "Local AI (Free)",
      "description": "Local models running on your machine",
      "models": ["ollama://llama3.1", "ollama://mistral:7b"],
      "icon": "local"
    },
    {
      "id": "cloud-ai", 
      "name": "Cloud AI (API)",
      "description": "Cloud-based models via API",
      "models": ["openai://gpt-4o-mini"],
      "icon": "cloud"
    }
  ]
}
EOF
    
    echo -e "${GREEN}✅ LobeChat config created${NC}"
}

# AnythingLLM Configuration
create_anythingllm_config() {
    mkdir -p anythingllm/storage/anythingllm.db
    
    # Create models config for AnythingLLM
    cat > anythingllm/storage/config.json << 'EOF'
{
  "version": "1.0.0",
  "models": {
    "preferred": [
      {
        "name": "llama3.1",
        "provider": "ollama",
        "model": "llama3.1",
        "maxTokens": 4096,
        "temperature": 0.7,
        "vectorStore": "pinecone"
      }
    ],
    "fallback": [
      {
        "name": "mistral:7b", 
        "provider": "ollama",
        "model": "mistral:7b",
        "maxTokens": 4096,
        "temperature": 0.7
      }
    ]
  },
  "vector_db": {
    "type": "simple",
    "text_splitter": {
      "type": "token",
      "chunk_size": 1000,
      "chunk_overlap": 200
    }
  }
}
EOF
    
    echo -e "${GREEN}✅ AnythingLLM config created${NC}"
}

# Function to test all configurations
test_configurations() {
    echo -e "${BLUE}🧪 Testing configurations...${NC}"
    
    # Test Ollama
    if command -v ollama &> /dev/null; then
        echo -e "${GREEN}✅ Ollama is installed${NC}"
        
        # Test if models are available
        for model in llama3.1 mistral:7b codellama; do
            if timeout 5 ollama list | grep -q "$model"; then
                echo -e "${GREEN}✅ Model $model is available${NC}"
            else
                echo -e "${YELLOW}⚠️  Model $model not found - would need to be pulled${NC}"
            fi
        done
    else
        echo -e "${RED}❌ Ollama not installed${NC}"
    fi
    
    # Test API keys
    if [ -f ".env" ]; then
        source .env
        
        if [ -n "$OPENAI_API_KEY" ] && [ "$OPENAI_API_KEY" != "your-api-key-here" ]; then
            echo -e "${GREEN}✅ OpenAI API key configured${NC}"
        else
            echo -e "${YELLOW}⚠️  OpenAI API key not configured${NC}"
        fi
        
        if [ -n "$ANTHROPIC_API_KEY" ] && [ "$ANTHROPIC_API_KEY" != "your-api-key-here" ]; then
            echo -e "${GREEN}✅ Anthropic API key configured${NC}"
        else
            echo -e "${YELLOW}⚠️  Anthropic API key not configured${NC}"
        fi
    else
        echo -e "${RED}❌ .env file not found${NC}"
    fi
    
    echo -e "${GREEN}✅ Configuration testing complete${NC}"
}

# Function to start services with filtered models
start_services() {
    echo -e "${BLUE}🚀 Starting services with filtered models...${NC}"
    
    # Start Ollama first
    if command -v ollama &> /dev/null; then
        echo -e "${GREEN}Starting Ollama service...${NC}"
        if ! pgrep -x "ollama" > /dev/null; then
            nohup ollama serve > /tmp/ollama.log 2>&1 &
            sleep 5
        fi
    fi
    
    # Start Docker services
    echo -e "${GREEN}Starting Docker services...${NC}"
    docker-compose up -d
    
    echo -e "${GREEN}✅ Services started${NC}"
}

# Function to show final status
show_status() {
    echo -e "\n${BLUE}📊 Model Filter Status Summary${NC}"
    echo "================================="
    
    echo -e "\n${GREEN}🎯 Filtered Models Available:${NC}"
    echo "• Llama 3.1 (Local) - Fast general chat"
    echo "• Mistral 7B (Local) - Balanced performance"
    echo "• Code Llama (Local) - Programming tasks"
    echo "• GPT-4o Mini (Cloud) - Fast & affordable*"
    echo "• Claude Haiku (Cloud) - Quick responses*"
    echo ""
    echo "* Requires API key configuration"
    
    echo -e "\n${GREEN}🔗 Access Points:${NC}"
    echo "• Open WebUI: http://localhost:3000"
    echo "• LobeChat: http://localhost:3210"
    echo "• AnythingLLM: http://localhost:3001"
    echo "• LibreChat: http://localhost:3080"
    echo "• BigAGI: http://localhost:3004"
    echo "• Ollama: http://localhost:11434"
    
    echo -e "\n${GREEN}⚡ Quick Test:${NC}"
    echo "curl http://localhost:11434/api/tags"
    echo ""
    echo -e "${GREEN}✅ Model filtering applied successfully!${NC}"
}

# Main execution
main() {
    echo -e "${BLUE}🎯 Applying Model Filter Configuration${NC}\n"
    
    # Step 1: Update docker compose
    update_docker_compose
    
    # Step 2: Create UI configs
    create_ui_configs
    
    # Step 3: Test configurations
    test_configurations
    
    # Step 4: Ask user if they want to start services
    echo -e "\n${YELLOW}Would you like to start the services with filtered models? (y/n)${NC}"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        start_services
        show_status
    else
        echo -e "${GREEN}Configuration saved. Start services manually with: docker-compose up -d${NC}"
    fi
}

# Check if running with arguments
case "${1:-}" in
    "--test-only")
        test_configurations
        ;;
    "--config-only")
        update_docker_compose
        create_ui_configs
        echo -e "${GREEN}✅ Configuration files created successfully${NC}"
        ;;
    "--start")
        start_services
        show_status
        ;;
    "--help"|"")
        echo "Model Filter Application Tool"
        echo "Usage: $0 [--test-only|--config-only|--start|--help]"
        echo ""
        echo "Options:"
        echo "  --test-only    Only test configurations"
        echo "  --config-only  Only create config files"
        echo "  --start        Start services after config"
        echo "  --help         Show this help"
        ;;
    *)
        main
        ;;
esac