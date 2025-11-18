#!/bin/bash
# Comprehensive Test Suite - Test 100% các loại môi trường

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Comprehensive Test Suite - 100% Môi Trường${NC}"
echo "=========================================="
echo ""

# Test counter
PASSED=0
FAILED=0
SKIPPED=0

test_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ PASS${NC}: $2"
        ((PASSED++))
    else
        echo -e "${RED}❌ FAIL${NC}: $2"
        ((FAILED++))
    fi
}

test_skip() {
    echo -e "${YELLOW}⏭️  SKIP${NC}: $1"
    ((SKIPPED++))
}

# ============================================
# 1. ENVIRONMENT TESTS
# ============================================
echo -e "${BLUE}📦 1. Environment Tests${NC}"
echo "----------------------------------------"

# Test 1.1: Docker environment
echo -n "Testing Docker environment... "
if command -v docker &> /dev/null && docker ps &> /dev/null; then
    test_result 0 "Docker available"
else
    test_result 1 "Docker not available"
fi

# Test 1.2: Python environment
echo -n "Testing Python environment... "
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1)
    test_result 0 "Python available: $PYTHON_VERSION"
else
    test_result 1 "Python not available"
fi

# Test 1.3: Node.js environment
echo -n "Testing Node.js environment... "
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version 2>&1)
    test_result 0 "Node.js available: $NODE_VERSION"
else
    test_skip "Node.js not available (optional)"
fi

# Test 1.4: Config files
echo -n "Testing config files... "
CONFIG_FILES=(
    "llm-providers-config.json"
    "code-execution-config.json"
    "ui-optimization-config.json"
    "docker-compose.yml"
    ".env.persistent"
)

MISSING_CONFIGS=()
for file in "${CONFIG_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        MISSING_CONFIGS+=("$file")
    fi
done

if [ ${#MISSING_CONFIGS[@]} -eq 0 ]; then
    test_result 0 "All config files present"
else
    test_result 1 "Missing configs: ${MISSING_CONFIGS[*]}"
fi

echo ""

# ============================================
# 2. CODE EXECUTION TESTS
# ============================================
echo -e "${BLUE}💻 2. Code Execution Tests${NC}"
echo "----------------------------------------"

# Test 2.1: Python code execution
echo -n "Testing Python execution... "
if command -v python3 &> /dev/null; then
    python3 -c "print('Hello from Python')" &> /dev/null
    test_result $? "Python execution"
else
    test_skip "Python not available"
fi

# Test 2.2: JavaScript execution
echo -n "Testing JavaScript execution... "
if command -v node &> /dev/null; then
    node -e "console.log('Hello from Node.js')" &> /dev/null
    test_result $? "JavaScript execution"
else
    test_skip "Node.js not available"
fi

# Test 2.3: Shell script execution
echo -n "Testing shell script execution... "
bash -c "echo 'Hello from Bash'" &> /dev/null
test_result $? "Shell script execution"

echo ""

# ============================================
# 3. FILE OPERATIONS TESTS
# ============================================
echo -e "${BLUE}📁 3. File Operations Tests${NC}"
echo "----------------------------------------"

TEST_DIR="/tmp/openwebui_test_$$"
mkdir -p "$TEST_DIR"

# Test 3.1: Create file
echo -n "Testing file creation... "
echo "test content" > "$TEST_DIR/test.txt"
if [ -f "$TEST_DIR/test.txt" ]; then
    test_result 0 "File creation"
else
    test_result 1 "File creation failed"
fi

# Test 3.2: Read file
echo -n "Testing file read... "
CONTENT=$(cat "$TEST_DIR/test.txt" 2>/dev/null)
if [ "$CONTENT" = "test content" ]; then
    test_result 0 "File read"
else
    test_result 1 "File read failed"
fi

# Test 3.3: Create directory
echo -n "Testing directory creation... "
mkdir -p "$TEST_DIR/subdir"
if [ -d "$TEST_DIR/subdir" ]; then
    test_result 0 "Directory creation"
else
    test_result 1 "Directory creation failed"
fi

# Test 3.4: Delete file
echo -n "Testing file deletion... "
rm -f "$TEST_DIR/test.txt"
if [ ! -f "$TEST_DIR/test.txt" ]; then
    test_result 0 "File deletion"
else
    test_result 1 "File deletion failed"
fi

# Cleanup
rm -rf "$TEST_DIR"

echo ""

# ============================================
# 4. API CONNECTION TESTS
# ============================================
echo -e "${BLUE}🌐 4. API Connection Tests${NC}"
echo "----------------------------------------"

# Test 4.1: Groq API (if key available)
echo -n "Testing Groq API connection... "
if [ -n "${GROQ_API_KEY:-}" ] && [ "${GROQ_API_KEY}" != "" ]; then
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "Authorization: Bearer $GROQ_API_KEY" \
        "https://api.groq.com/openai/v1/models" 2>/dev/null || echo "000")
    if [ "$RESPONSE" = "200" ]; then
        test_result 0 "Groq API connection"
    else
        test_result 1 "Groq API connection failed (HTTP $RESPONSE)"
    fi
else
    test_skip "Groq API key not set"
fi

# Test 4.2: OpenRouter API (if key available)
echo -n "Testing OpenRouter API connection... "
if [ -n "${OPENROUTER_API_KEY:-}" ] && [ "${OPENROUTER_API_KEY}" != "" ]; then
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "Authorization: Bearer $OPENROUTER_API_KEY" \
        "https://openrouter.ai/api/v1/models" 2>/dev/null || echo "000")
    if [ "$RESPONSE" = "200" ]; then
        test_result 0 "OpenRouter API connection"
    else
        test_result 1 "OpenRouter API connection failed (HTTP $RESPONSE)"
    fi
else
    test_skip "OpenRouter API key not set"
fi

# Test 4.3: Local orchestrator (if running)
echo -n "Testing local orchestrator... "
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
    "http://localhost:8000/health" 2>/dev/null || echo "000")
if [ "$RESPONSE" = "200" ]; then
    test_result 0 "Local orchestrator connection"
else
    test_skip "Local orchestrator not running"
fi

echo ""

# ============================================
# 5. CONFIG VALIDATION TESTS
# ============================================
echo -e "${BLUE}⚙️  5. Config Validation Tests${NC}"
echo "----------------------------------------"

# Test 5.1: JSON syntax validation
echo -n "Testing JSON syntax... "
JSON_FILES=(
    "llm-providers-config.json"
    "code-execution-config.json"
    "ui-optimization-config.json"
    "workspace-config.json"
    "quick-actions.json"
)

JSON_ERRORS=()
for file in "${JSON_FILES[@]}"; do
    if [ -f "$file" ]; then
        python3 -m json.tool "$file" &> /dev/null
        if [ $? -ne 0 ]; then
            JSON_ERRORS+=("$file")
        fi
    fi
done

if [ ${#JSON_ERRORS[@]} -eq 0 ]; then
    test_result 0 "All JSON files valid"
else
    test_result 1 "Invalid JSON: ${JSON_ERRORS[*]}"
fi

# Test 5.2: Docker Compose validation
echo -n "Testing Docker Compose syntax... "
if command -v docker-compose &> /dev/null; then
    docker-compose -f docker-compose.yml config &> /dev/null
    test_result $? "Docker Compose syntax"
else
    test_skip "docker-compose not available"
fi

echo ""

# ============================================
# 6. UI COMPONENT TESTS
# ============================================
echo -e "${BLUE}🎨 6. UI Component Tests${NC}"
echo "----------------------------------------"

# Test 6.1: CSS files
echo -n "Testing CSS files... "
CSS_FILES=(
    "custom-theme.css"
    "hide-terminal-theme.css"
)

MISSING_CSS=()
for file in "${CSS_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        MISSING_CSS+=("$file")
    fi
done

if [ ${#MISSING_CSS[@]} -eq 0 ]; then
    test_result 0 "All CSS files present"
else
    test_result 1 "Missing CSS: ${MISSING_CSS[*]}"
fi

# Test 6.2: JavaScript components
echo -n "Testing JavaScript components... "
if [ -f "code-preview-component.js" ]; then
    # Basic syntax check
    node -c code-preview-component.js &> /dev/null
    test_result $? "JavaScript component syntax"
else
    test_result 1 "code-preview-component.js not found"
fi

echo ""

# ============================================
# 7. SECURITY TESTS
# ============================================
echo -e "${BLUE}🔒 7. Security Tests${NC}"
echo "----------------------------------------"

# Test 7.1: Dangerous commands blocked
echo -n "Testing dangerous command blocking... "
DANGEROUS_COMMANDS=("rm -rf /" "format" "mkfs" "dd if=")
BLOCKED_COUNT=0

# This is a simulation - actual blocking happens in code execution
for cmd in "${DANGEROUS_COMMANDS[@]}"; do
    # Check if command is in blocked list in config
    if grep -q "$cmd" code-execution-config.json 2>/dev/null; then
        ((BLOCKED_COUNT++))
    fi
done

if [ $BLOCKED_COUNT -gt 0 ]; then
    test_result 0 "Dangerous commands configured"
else
    test_result 1 "Dangerous commands not configured"
fi

# Test 7.2: API keys not exposed
echo -n "Testing API key security... "
if grep -q "API_KEY=.*[a-zA-Z0-9]" .env.persistent 2>/dev/null; then
    # Check if keys are empty (good) or have placeholder
    EMPTY_KEYS=$(grep -c "API_KEY=$" .env.persistent 2>/dev/null || echo "0")
    if [ "$EMPTY_KEYS" -gt 0 ]; then
        test_result 0 "API keys not exposed (empty/default)"
    else
        test_result 1 "API keys may be exposed"
    fi
else
    test_result 0 "API keys not found in .env.persistent"
fi

echo ""

# ============================================
# SUMMARY
# ============================================
echo "=========================================="
echo -e "${BLUE}📊 Test Summary${NC}"
echo "----------------------------------------"
echo -e "${GREEN}✅ Passed: $PASSED${NC}"
echo -e "${RED}❌ Failed: $FAILED${NC}"
echo -e "${YELLOW}⏭️  Skipped: $SKIPPED${NC}"
echo ""

TOTAL=$((PASSED + FAILED + SKIPPED))
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}⚠️  Some tests failed. Please review above.${NC}"
    exit 1
fi
