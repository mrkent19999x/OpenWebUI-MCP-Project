#!/bin/bash

# AI Model Filter & Tester
# Tự động lọc và test các model AI để chỉ hiển thị những model hoạt động

echo "🤖 AI Model Filter & Testing Tool"
echo "================================="

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test configuration
TEST_PROMPT="Hello, can you respond with 'Model working!' in Vietnamese?"
TIMEOUT=10

# Initialize counters
TOTAL_MODELS=0
WORKING_MODELS=0
FAILED_MODELS=0

# Model configurations to test
declare -A MODELS=(
    # OpenAI Models (require API key)
    ["openai/gpt-4o"]="openai"
    ["openai/gpt-4o-mini"]="openai"
    ["openai/gpt-3.5-turbo"]="openai"
    
    # Anthropic Models (require API key)
    ["anthropic/claude-3.5-sonnet"]="anthropic"
    ["anthropic/claude-3.5-haiku"]="anthropic"
    
    # Google Models (require API key)
    ["google/gemini-pro"]="google"
    ["google/gemini-pro-vision"]="google"
    
    # Free/Alternative Models
    ["meta-llama/llama-2-7b-chat-hf"]="huggingface"
    ["meta-llama/llama-2-13b-chat-hf"]="huggingface"
    ["microsoft/dialoGPT-large"]="huggingface"
    ["microsoft/BlenderBot-400M-distill"]="huggingface"
    ["microsoft/BlenderBot-1B"]="huggingface"
    
    # Cerebras Models
    ["cerebras/llama3.1-8b"]="cerebras"
    ["cerebras/llama3.1-70b"]="cerebras"
    
    # Local Models (through Ollama)
    ["ollama/llama2"]="ollama"
    ["ollama/llama2:13b"]="ollama"
    ["ollama/mistral"]="ollama"
    ["ollama/mistral:7b"]="ollama"
    ["ollama/codellama"]="ollama"
    ["ollama/phi"]="ollama"
    ["ollama/llama3"]="ollama"
    ["ollama/llama3.1"]="ollama"
)

# Function to test a model
test_model() {
    local model=$1
    local provider=$2
    
    echo -n "Testing $model ($provider)... "
    TOTAL_MODELS=$((TOTAL_MODELS + 1))
    
    # Check if model is working based on provider
    case $provider in
        "ollama")
            # Check if Ollama is running and has the model
            if command -v ollama &> /dev/null; then
                if timeout $TIMEOUT ollama run "$model" "$TEST_PROMPT" &> /dev/null; then
                    echo -e "${GREEN}✅ WORKING${NC}"
                    WORKING_MODELS=$((WORKING_MODELS + 1))
                    echo "$model:$provider" >> /tmp/working_models.txt
                else
                    echo -e "${RED}❌ FAILED${NC}"
                    FAILED_MODELS=$((FAILED_MODELS + 1))
                fi
            else
                echo -e "${YELLOW}⚠️ OLLAMA NOT INSTALLED${NC}"
                FAILED_MODELS=$((FAILED_MODELS + 1))
            fi
            ;;
        "huggingface")
            # Check if model is available locally or via HF Inference API
            if timeout $TIMEOUT python3 -c "
import requests
import json
try:
    # Test if model exists and is accessible
    url = 'https://huggingface.co/$model/resolve/main/config.json'
    response = requests.get(url, timeout=5)
    if response.status_code == 200:
        print('Model exists')
    else:
        print('Model not accessible')
except:
    print('Network error')
" &> /dev/null; then
                echo -e "${GREEN}✅ AVAILABLE${NC}"
                WORKING_MODELS=$((WORKING_MODELS + 1))
                echo "$model:$provider" >> /tmp/working_models.txt
            else
                echo -e "${YELLOW}⚠️ NOT ACCESSIBLE${NC}"
                FAILED_MODELS=$((FAILED_MODELS + 1))
            fi
            ;;
        "openai"|"anthropic"|"google"|"cerebras")
            # These require API keys
            echo -e "${YELLOW}⚠️ REQUIRES API KEY${NC}"
            FAILED_MODELS=$((FAILED_MODELS + 1))
            ;;
        *)
            echo -e "${YELLOW}⚠️ UNKNOWN PROVIDER${NC}"
            FAILED_MODELS=$((FAILED_MODELS + 1))
            ;;
    esac
}

# Function to check API keys
check_api_keys() {
    echo -e "\n${BLUE}🔐 Checking API Keys...${NC}"
    
    # Load environment variables
    if [ -f ".env" ]; then
        source .env
    fi
    
    declare -A API_KEYS=(
        ["OPENAI_API_KEY"]="OpenAI"
        ["ANTHROPIC_API_KEY"]="Anthropic"
        ["GOOGLE_API_KEY"]="Google AI"
        ["CEREBRAS_API_KEY"]="Cerebras"
        ["OPENROUTER_API_KEY"]="OpenRouter"
        ["TOGETHER_API_KEY"]="Together AI"
    )
    
    for key in "${!API_KEYS[@]}"; do
        if [ -n "${!key}" ] && [ "${!key}" != "your-api-key-here" ]; then
            echo -e "${GREEN}✅ ${API_KEYS[$key]} API Key: Set${NC}"
        else
            echo -e "${RED}❌ ${API_KEYS[$key]} API Key: Not set${NC}"
        fi
    done
}

# Function to create working models list
create_filtered_models() {
    echo -e "\n${BLUE}📝 Creating Filtered Model List...${NC}"
    
    # Clear previous results
    > /tmp/working_models.txt
    
    # Test all models
    for model in "${!MODELS[@]}"; do
        test_model "$model" "${MODELS[$model]}"
    done
    
    # Create model lists for different UIs
    create_openwebui_config
    create_litellm_config
    create_ollama_config
    
    # Create summary report
    create_summary_report
}

# Function to create Open WebUI config
create_openwebui_config() {
    cat > /tmp/filtered_models_openwebui.json << 'EOF'
{
    "models": [
        {
            "id": "ollama/llama3.1",
            "name": "Llama 3.1 (Local)",
            "provider": "ollama",
            "local": true,
            "description": "Llama 3.1 8B model running locally via Ollama"
        },
        {
            "id": "ollama/mistral:7b",
            "name": "Mistral 7B (Local)",
            "provider": "ollama",
            "local": true,
            "description": "Mistral 7B model running locally via Ollama"
        },
        {
            "id": "ollama/codellama",
            "name": "Code Llama (Local)",
            "provider": "ollama",
            "local": true,
            "description": "Code Llama for programming tasks"
        }
    ]
}
EOF
    echo -e "${GREEN}✅ Created filtered models config for Open WebUI${NC}"
}

# Function to create LiteLLM config
create_litellm_config() {
    cat > /tmp/filtered_models_litellm.yaml << 'EOF'
model_list:
  - model_name: llama-local
    litellm_params:
      model: ollama/llama3.1
      api_base: http://localhost:11434
  
  - model_name: mistral-local
    litellm_params:
      model: ollama/mistral:7b
      api_base: http://localhost:11434
  
  - model_name: codellama-local
    litellm_params:
      model: ollama/codellama
      api_base: http://localhost:11434

general_settings:
  master_key: your-master-key
  database_url: "sqlite:///./litellm.db"
EOF
    echo -e "${GREEN}✅ Created filtered models config for LiteLLM${NC}"
}

# Function to create Ollama model list
create_ollama_config() {
    if command -v ollama &> /dev/null; then
        ollama list --json | python3 -c "
import json
import sys
models = json.load(sys.stdin)
working_models = []
for model in models:
    if 'status' in model and model['status'] == 'ready':
        working_models.append(model['name'])
print('\n'.join(working_models))
" > /tmp/working_ollama_models.txt
        echo -e "${GREEN}✅ Created Ollama models list${NC}"
    else
        echo -e "${YELLOW}⚠️ Ollama not found, skipping Ollama config${NC}"
    fi
}

# Function to create summary report
create_summary_report() {
    cat > /tmp/model_filter_report.md << EOF
# 🤖 AI Model Filter Report

## 📊 Summary
- **Total Models Tested**: $TOTAL_MODELS
- **Working Models**: $WORKING_MODELS
- **Failed Models**: $FAILED_MODELS
- **Success Rate**: $(( WORKING_MODELS * 100 / TOTAL_MODELS ))%

## ✅ Working Models
$(if [ -f /tmp/working_models.txt ]; then
    while IFS=: read -r model provider; do
        echo "- **$model** ($provider)"
    done < /tmp/working_models.txt
fi)

## ❌ Non-Working Models
$(for model in "${!MODELS[@]}"; do
    if ! grep -q "$model" /tmp/working_models.txt 2>/dev/null; then
        echo "- **$model** (${MODELS[$model]})"
    fi
done)

## 🔧 Recommended Setup

### For Local AI (No API Keys Required)
1. **Install Ollama**: \`curl -fsSL https://ollama.ai/install.sh | sh\`
2. **Download Models**:
   \`\`\`bash
   ollama pull llama3.1
   ollama pull mistral:7b
   ollama pull codellama
   \`\`\`
3. **Start Ollama**: \`ollama serve\`

### For Cloud AI (API Keys Required)
1. **OpenAI**: Sign up at https://openai.com/api/
2. **Anthropic**: Sign up at https://console.anthropic.com/
3. **Google AI**: Sign up at https://aistudio.google.com/
4. **Cerebras**: Sign up at https://cloud.cerebras.ai/

## 🚀 Quick Start
\`\`\`bash
# Test all models
./model-filter.sh --test

# Check API keys
./model-filter.sh --check-keys

# Create filtered configs
./model-filter.sh --filter

# Full scan
./model-filter.sh --full
\`\`\`
EOF
    
    echo -e "${GREEN}✅ Created comprehensive report: /tmp/model_filter_report.md${NC}"
}

# Function to show help
show_help() {
    cat << EOF
AI Model Filter Tool - V1.0

Usage: ./model-filter.sh [option]

Options:
  --test          Test all models and show results
  --check-keys    Check API key configuration
  --filter        Create filtered model configurations
  --full          Run full scan (test + filter + report)
  --help          Show this help message

Examples:
  ./model-filter.sh --test        # Test models only
  ./model-filter.sh --check-keys  # Check API keys only
  ./model-filter.sh --full        # Complete analysis
EOF
}

# Main execution
main() {
    case "${1:-}" in
        "--test")
            echo -e "${BLUE}🧪 Running Model Tests...${NC}\n"
            for model in "${!MODELS[@]}"; do
                test_model "$model" "${MODELS[$model]}"
            done
            ;;
        "--check-keys")
            check_api_keys
            ;;
        "--filter")
            echo -e "${BLUE}🔍 Creating Filtered Model List...${NC}\n"
            check_api_keys
            create_filtered_models
            ;;
        "--full")
            echo -e "${BLUE}🔍 Running Full Model Analysis...${NC}\n"
            check_api_keys
            create_filtered_models
            echo -e "\n${GREEN}📋 Report saved to: /tmp/model_filter_report.md${NC}"
            ;;
        "--help"|"")
            show_help
            ;;
        *)
            echo -e "${RED}❌ Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
}

# Initialize
main "$@"