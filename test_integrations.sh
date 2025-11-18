#!/bin/bash

# Test Script - Kiểm tra tất cả tích hợp
# Trợ lý cấp cao toàn diện

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

ORCHESTRATOR_URL=${ORCHESTRATOR_URL:-http://localhost:8000}

echo -e "${BLUE}🧪 Testing MCP Orchestrator Integrations${NC}"
echo "=========================================="
echo ""

# Test 1: Health Check
echo -e "${YELLOW}Test 1: Health Check${NC}"
RESPONSE=$(curl -s "${ORCHESTRATOR_URL}/health" || echo "ERROR")
if echo "$RESPONSE" | grep -q "healthy"; then
    echo -e "${GREEN}✅ Orchestrator is healthy${NC}"
    echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
else
    echo -e "${RED}❌ Orchestrator health check failed${NC}"
    echo "$RESPONSE"
    exit 1
fi
echo ""

# Test 2: List Tools
echo -e "${YELLOW}Test 2: List MCP Tools${NC}"
RESPONSE=$(curl -s "${ORCHESTRATOR_URL}/mcp/tools" || echo "ERROR")
if echo "$RESPONSE" | grep -q "gmail"; then
    echo -e "${GREEN}✅ Tools listed successfully${NC}"
    echo "$RESPONSE" | jq '.[].id' 2>/dev/null || echo "$RESPONSE"
else
    echo -e "${RED}❌ Failed to list tools${NC}"
    echo "$RESPONSE"
    exit 1
fi
echo ""

# Test 3: Gmail Tool (if configured)
echo -e "${YELLOW}Test 3: Gmail Tool${NC}"
if [ -n "$GMAIL_USER" ] && [ -n "$GMAIL_APP_PASSWORD" ]; then
    echo -e "${BLUE}Gmail credentials found, testing...${NC}"
    RESPONSE=$(curl -s -X POST "${ORCHESTRATOR_URL}/mcp/tools/gmail_read/call" \
        -H "Content-Type: application/json" \
        -d '{"tool": "gmail_read", "parameters": {"limit": 5}}' || echo "ERROR")
    if echo "$RESPONSE" | grep -q "success"; then
        echo -e "${GREEN}✅ Gmail tool works${NC}"
    else
        echo -e "${YELLOW}⚠️  Gmail tool test failed (may need OAuth setup)${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Gmail credentials not configured${NC}"
fi
echo ""

# Test 4: GitHub Tool (if configured)
echo -e "${YELLOW}Test 4: GitHub Tool${NC}"
if [ -n "$GITHUB_TOKEN" ]; then
    echo -e "${BLUE}GitHub token found, testing...${NC}"
    RESPONSE=$(curl -s -X POST "${ORCHESTRATOR_URL}/mcp/tools/github_list_repos/call" \
        -H "Content-Type: application/json" \
        -d '{"tool": "github_list_repos", "parameters": {}}' || echo "ERROR")
    if echo "$RESPONSE" | grep -q "success"; then
        echo -e "${GREEN}✅ GitHub tool works${NC}"
    else
        echo -e "${YELLOW}⚠️  GitHub tool test failed${NC}"
        echo "$RESPONSE"
    fi
else
    echo -e "${YELLOW}⚠️  GitHub token not configured${NC}"
fi
echo ""

# Test 5: Search Tool (if configured)
echo -e "${YELLOW}Test 5: Search Tool${NC}"
if [ -n "$PERPLEXITY_API_KEY" ]; then
    echo -e "${BLUE}Perplexity API key found, testing...${NC}"
    RESPONSE=$(curl -s -X POST "${ORCHESTRATOR_URL}/mcp/tools/search_web/call" \
        -H "Content-Type: application/json" \
        -d '{"tool": "search_web", "parameters": {"query": "test"}}' || echo "ERROR")
    if echo "$RESPONSE" | grep -q "success"; then
        echo -e "${GREEN}✅ Search tool works${NC}"
    else
        echo -e "${YELLOW}⚠️  Search tool test failed${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Perplexity API key not configured${NC}"
fi
echo ""

# Test 6: Vision Tool (if configured)
echo -e "${YELLOW}Test 6: Vision Tool${NC}"
if [ -n "$GEMINI_API_KEY" ]; then
    echo -e "${BLUE}Gemini API key found${NC}"
    echo -e "${GREEN}✅ Vision tool configured${NC}"
else
    echo -e "${YELLOW}⚠️  Gemini API key not configured${NC}"
fi
echo ""

# Test 7: OCR Tool
echo -e "${YELLOW}Test 7: OCR Tool${NC}"
if command -v tesseract &> /dev/null; then
    echo -e "${GREEN}✅ Tesseract OCR installed${NC}"
else
    echo -e "${YELLOW}⚠️  Tesseract OCR not installed${NC}"
fi
echo ""

# Test 8: Zalo Tool (if configured)
echo -e "${YELLOW}Test 8: Zalo OA Tool${NC}"
if [ -n "$ZALO_OA_ACCESS_TOKEN" ]; then
    echo -e "${BLUE}Zalo OA token found${NC}"
    echo -e "${GREEN}✅ Zalo tool configured${NC}"
else
    echo -e "${YELLOW}⚠️  Zalo OA token not configured${NC}"
fi
echo ""

# Summary
echo -e "${BLUE}📊 Summary${NC}"
echo "=========="
echo -e "Orchestrator: ${GREEN}✅ Running${NC}"
echo -e "Gmail: $([ -n "$GMAIL_USER" ] && echo -e "${GREEN}✅ Configured${NC}" || echo -e "${YELLOW}⚠️  Not configured${NC}")"
echo -e "GitHub: $([ -n "$GITHUB_TOKEN" ] && echo -e "${GREEN}✅ Configured${NC}" || echo -e "${YELLOW}⚠️  Not configured${NC}")"
echo -e "Search: $([ -n "$PERPLEXITY_API_KEY" ] && echo -e "${GREEN}✅ Configured${NC}" || echo -e "${YELLOW}⚠️  Not configured${NC}")"
echo -e "Vision: $([ -n "$GEMINI_API_KEY" ] && echo -e "${GREEN}✅ Configured${NC}" || echo -e "${YELLOW}⚠️  Not configured${NC}")"
echo -e "OCR: $(command -v tesseract &> /dev/null && echo -e "${GREEN}✅ Installed${NC}" || echo -e "${YELLOW}⚠️  Not installed${NC}")"
echo -e "Zalo: $([ -n "$ZALO_OA_ACCESS_TOKEN" ] && echo -e "${GREEN}✅ Configured${NC}" || echo -e "${YELLOW}⚠️  Not configured${NC}")"
echo ""
echo -e "${GREEN}✅ Testing completed!${NC}"
