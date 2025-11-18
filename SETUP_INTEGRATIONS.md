# 🔌 Hướng Dẫn Kết Nối Các Services - Trợ Lý Cấp Cao Toàn Diện

## 🎯 Mục Tiêu

Setup đầy đủ để có **trợ lý cấp cao toàn diện** với:
- ✅ Kết nối Gmail đơn giản
- ✅ Kết nối GitHub đơn giản
- ✅ Tất cả chức năng hoạt động thật

---

## 📋 Checklist Tích Hợp

### ✅ Đã Có Code:
- [x] Orchestrator FastAPI server
- [x] 6 MCP tools (Gmail, GitHub, Search, Vision, OCR, Zalo)
- [x] Test script
- [x] Docker config

### ⚠️ Cần Setup:
- [ ] Gmail credentials
- [ ] GitHub token
- [ ] API keys (Perplexity, Gemini)
- [ ] Zalo OA token (optional)

---

## 🔧 Setup Từng Service

### 1. 📧 Gmail Integration

#### Bước 1: Tạo App Password

1. Vào [Google Account](https://myaccount.google.com/)
2. Security → 2-Step Verification (bật nếu chưa)
3. App passwords → Generate
4. Chọn "Mail" và "Other"
5. Copy password

#### Bước 2: Điền Vào .env

```bash
GMAIL_USER=your-email@gmail.com
GMAIL_APP_PASSWORD=your-app-password
```

#### Bước 3: Test

```bash
# Test Gmail connection
curl -X POST http://localhost:8000/mcp/tools/gmail_read/call \
  -H "Content-Type: application/json" \
  -d '{"tool": "gmail_read", "parameters": {"limit": 5}}'
```

---

### 2. 🐙 GitHub Integration

#### Bước 1: Tạo Personal Access Token

1. Vào [GitHub Settings](https://github.com/settings/tokens)
2. Developer settings → Personal access tokens → Tokens (classic)
3. Generate new token
4. Chọn scopes:
   - ✅ `repo` (Full control)
   - ✅ `workflow` (Optional)
5. Copy token

#### Bước 2: Điền Vào .env

```bash
GITHUB_TOKEN=ghp_your_token_here
```

#### Bước 3: Test

```bash
# Test GitHub connection
curl -X POST http://localhost:8000/mcp/tools/github_list_repos/call \
  -H "Content-Type: application/json" \
  -d '{"tool": "github_list_repos", "parameters": {}}'
```

---

### 3. 🔍 Search (Perplexity)

#### Bước 1: Lấy API Key

1. Vào [Perplexity AI](https://www.perplexity.ai/)
2. Sign up / Login
3. Vào API settings
4. Generate API key

#### Bước 2: Điền Vào .env

```bash
PERPLEXITY_API_KEY=pplx-your-key-here
```

#### Bước 3: Test

```bash
# Test search
curl -X POST http://localhost:8000/mcp/tools/search_web/call \
  -H "Content-Type: application/json" \
  -d '{"tool": "search_web", "parameters": {"query": "test"}}'
```

---

### 4. 👁️ Vision (Gemini)

#### Bước 1: Lấy API Key

1. Vào [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create API key
3. Copy key

#### Bước 2: Điền Vào .env

```bash
GEMINI_API_KEY=your-gemini-key-here
```

---

### 5. 📄 OCR (Tesseract)

#### Bước 1: Install Tesseract

```bash
# Ubuntu/Debian
sudo apt-get install tesseract-ocr

# macOS
brew install tesseract

# Docker (already in requirements)
# No setup needed
```

---

### 6. 💬 Zalo OA (Optional)

#### Bước 1: Setup Zalo OA

1. Đăng ký Zalo OA
2. Lấy Access Token
3. Lấy Secret Key

#### Bước 2: Điền Vào .env

```bash
ZALO_OA_ACCESS_TOKEN=your-token
ZALO_OA_SECRET_KEY=your-secret
```

---

## 🚀 Khởi Động Orchestrator

### Cách 1: Docker Compose

```bash
# Thêm orchestrator vào docker-compose.yml
# (Em sẽ tạo file này)

docker-compose up -d orchestrator
```

### Cách 2: Standalone

```bash
cd orchestrator
pip install -r requirements.txt
python src/main.py
```

---

## 🧪 Test Tất Cả Chức Năng

### Chạy Test Script

```bash
# Load environment
source .env.persistent

# Run tests
./test_integrations.sh
```

### Test Manual

```bash
# 1. Health check
curl http://localhost:8000/health

# 2. List tools
curl http://localhost:8000/mcp/tools

# 3. Test Gmail
curl -X POST http://localhost:8000/mcp/tools/gmail_read/call \
  -H "Content-Type: application/json" \
  -d '{"tool": "gmail_read", "parameters": {"limit": 5}}'

# 4. Test GitHub
curl -X POST http://localhost:8000/mcp/tools/github_list_repos/call \
  -H "Content-Type: application/json" \
  -d '{"tool": "github_list_repos", "parameters": {}}'
```

---

## 📊 Status Dashboard

Sau khi setup, check status:

```bash
curl http://localhost:8000/health | jq '.services'
```

Kết quả:
```json
{
  "gmail": true,
  "github": true,
  "perplexity": true,
  "gemini": true,
  "zalo": false
}
```

---

## ✅ Verification Checklist

- [ ] Gmail credentials configured
- [ ] GitHub token configured
- [ ] Perplexity API key configured
- [ ] Gemini API key configured
- [ ] Tesseract installed
- [ ] Orchestrator running
- [ ] All tools test passed
- [ ] OpenWebUI connected to orchestrator

---

## 🎯 Kết Luận

Sau khi setup đầy đủ, anh sẽ có:

1. ✅ **Trợ Lý Cấp Cao Toàn Diện**
   - Quản lý email (Gmail)
   - Quản lý GitHub
   - Tìm kiếm web
   - Phân tích hình ảnh
   - OCR text extraction
   - Gửi Zalo (optional)

2. ✅ **Kết Nối Đơn Giản**
   - Chỉ cần điền API keys
   - Tự động kết nối
   - Test script để verify

3. ✅ **Hoạt Động Thật**
   - Tất cả chức năng đã có code
   - Test scripts để verify
   - Health check endpoint

**Chúc anh setup thành công!** 🚀
