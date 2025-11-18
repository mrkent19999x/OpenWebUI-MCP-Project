#!/bin/bash

# MiniMax API Test Script
# Usage: ./test_minimax.sh [API_KEY]

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get API key from argument or environment
API_KEY=${1:-${MINIMAX_API_KEY}}

if [ -z "$API_KEY" ]; then
    echo -e "${RED}❌ Error: API key not provided${NC}"
    echo "Usage: $0 [API_KEY]"
    echo "Or set MINIMAX_API_KEY environment variable"
    exit 1
fi

API_BASE_URL=${MINIMAX_API_BASE_URL:-https://api.minimax.chat/v1}

echo -e "${YELLOW}🧪 Testing MiniMax API Connection...${NC}"
echo "API Base URL: $API_BASE_URL"
echo ""

# Test 1: List Models
echo -e "${YELLOW}Test 1: List Available Models${NC}"
RESPONSE=$(curl -s -X GET "${API_BASE_URL}/models" \
    -H "Authorization: Bearer ${API_KEY}" \
    -H "Content-Type: application/json")

if echo "$RESPONSE" | grep -q "error"; then
    echo -e "${RED}❌ Failed to list models${NC}"
    echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
    exit 1
else
    echo -e "${GREEN}✅ Models listed successfully${NC}"
    echo "$RESPONSE" | jq '.data[].id' 2>/dev/null || echo "$RESPONSE"
fi

echo ""

# Test 2: Chat Completion
echo -e "${YELLOW}Test 2: Chat Completion${NC}"
RESPONSE=$(curl -s -X POST "${API_BASE_URL}/chat/completions" \
    -H "Authorization: Bearer ${API_KEY}" \
    -H "Content-Type: application/json" \
    -d '{
        "model": "abab-5.5-chat",
        "messages": [
            {"role": "user", "content": "Hello, say hi in Vietnamese"}
        ],
        "temperature": 0.7,
        "max_tokens": 100
    }')

if echo "$RESPONSE" | grep -q "error"; then
    echo -e "${RED}❌ Chat completion failed${NC}"
    echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
    exit 1
else
    echo -e "${GREEN}✅ Chat completion successful${NC}"
    echo "$RESPONSE" | jq -r '.choices[0].message.content' 2>/dev/null || echo "$RESPONSE"
fi

echo ""

# Test 3: Sandbox (if enabled)
if [ "${MINIMAX_SANDBOX_ENABLED:-false}" = "true" ]; then
    echo -e "${YELLOW}Test 3: Sandbox Mode${NC}"
    SANDBOX_URL=${MINIMAX_SANDBOX_API_URL:-https://api.minimax.chat/v1/sandbox}
    
    RESPONSE=$(curl -s -X POST "${SANDBOX_URL}/execute" \
        -H "Authorization: Bearer ${API_KEY}" \
        -H "Content-Type: application/json" \
        -d '{
            "code": "print(\"Hello from sandbox\")",
            "language": "python"
        }')
    
    if echo "$RESPONSE" | grep -q "error"; then
        echo -e "${RED}❌ Sandbox test failed${NC}"
        echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
    else
        echo -e "${GREEN}✅ Sandbox test successful${NC}"
        echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
    fi
else
    echo -e "${YELLOW}Test 3: Sandbox Mode (Skipped - not enabled)${NC}"
fi

echo ""
echo -e "${GREEN}✅ All tests completed!${NC}"
