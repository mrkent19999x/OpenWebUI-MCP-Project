# OpenWebUI-MCP-Project: Manus AI Equivalent Environment

## 🎯 Tính năng tương đương Manus AI

### ✅ Đã có đủ cấu hình:

1. **🖥️ Code Execution Sandbox**
   - **Ngôn ngữ hỗ trợ**: Python, Node.js, Bash, Shell
   - **Container Isolation**: Chạy code trong môi trường tách biệt
   - **Timeout Protection**: Tự động dừng code chạy quá lâu
   - **Security Level**: Kiểm soát truy cập tài nguyên

2. **🌐 Web Automation**
   - **Browser Control**: Điều khiển trình duyệt tự động
   - **Web Scraping**: Thu thập dữ liệu từ website
   - **Form Automation**: Điền form và submit tự động
   - **Screenshot Capture**: Chụp ảnh màn hình

3. **🚀 Auto-Deployment**
   - **Public URL**: Tự động deploy lên URL công khai
   - **SSL/HTTPS**: Hỗ trợ chứng chỉ SSL
   - **Nginx Reverse Proxy**: Cân bằng tải và proxy
   - **CDN Ready**: Tối ưu cho CDN

4. **📁 File Management**
   - **MinIO Storage**: Lưu trữ file giống S3
   - **Version Control**: Quản lý phiên bản file
   - **Multi-format Support**: Hỗ trợ mọi định dạng file
   - **API Access**: Upload/download qua API

5. **🔗 GitHub Integration**
   - **MCP Protocol**: Model Context Protocol cho GitHub
   - **Persistent Auth**: Xác thực lâu dài (không cần token mỗi lần)
   - **Repository Management**: Tạo, commit, push tự động
   - **PR Creation**: Tạo Pull Request tự động

## 🚀 Cách chạy môi trường

### Bước 1: Chuẩn bị Environment
```bash
# Copy environment file
cp .env.example .env

# Chỉnh sửa .env với GitHub token của bạn
nano .env
```

### Bước 2: Chạy toàn bộ môi trường
```bash
# Chạy script tự động
./start-sandbox.sh

# Hoặc chạy manual
docker-compose -f docker-compose.sandbox.yml up -d
```

### Bước 3: Kiểm tra trạng thái
```bash
# Xem log các service
docker-compose -f docker-compose.sandbox.yml logs -f

# Kiểm tra health các service
curl http://localhost:7860/    # OpenWebUI
curl http://localhost:5000/health    # Code Executor
curl http://localhost:8000/health    # MCP Server
```

## 📱 Các Service và Port

| Service | Port | URL | Chức năng |
|---------|------|-----|-----------|
| OpenWebUI | 7860 | http://localhost:7860 | Giao diện chính |
| Code Executor | 5000 | http://localhost:5000 | Chạy code (Python/Node/Bash) |
| MCP Server | 8000 | http://localhost:8000 | GitHub operations |
| Web Automation | 3000 | http://localhost:3000 | Browser automation |
| Auto-Deployer | 80 | http://localhost:80 | Deploy public URL |
| File Manager | 9000 | http://localhost:9000 | Quản lý file |
| LiteLLM | 4000 | http://localhost:4000 | AI model gateway |
| Ollama | 11434 | http://localhost:11434 | Local AI models |
| Redis | 6379 | localhost:6379 | Cache & sessions |
| PostgreSQL | 5432 | localhost:5432 | Database |

## 🛠️ API Usage Examples

### 1. Execute Code (giống Manus AI code sandbox)
```bash
# Execute Python code
curl -X POST http://localhost:5000/execute/code \
  -H "Content-Type: application/json" \
  -d '{
    "language": "python",
    "code": "import numpy as np\nprint(np.array([1, 2, 3]) * 2)",
    "timeout": 30
  }'

# Execute Node.js code
curl -X POST http://localhost:5000/execute/code \
  -H "Content-Type: application/json" \
  -d '{
    "language": "nodejs",
    "code": "console.log(\"Hello from Node.js!\")"
  }'
```

### 2. GitHub Operations với MCP
```bash
# Create repository
curl -X POST http://localhost:8000/github/create \
  -H "Content-Type: application/json" \
  -d '{
    "repo_name": "manus-ai-test",
    "description": "Test repository from MCP"
  }'

# Commit files
curl -X POST http://localhost:8000/github/commit \
  -H "Content-Type: application/json" \
  -d '{
    "repo_name": "manus-ai-test",
    "file_path": "README.md",
    "content": "# Test repository created by Manus AI equivalent",
    "commit_message": "Initial commit"
  }'
```

### 3. Web Automation
```bash
# Open URL and take screenshot
curl -X POST http://localhost:3000/browser/open \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com",
    "action": "screenshot",
    "save_path": "/app/screenshots/example.png"
  }'
```

### 4. Auto-Deployment
```bash
# Deploy to public URL
curl -X POST http://localhost:80/deploy \
  -H "Content-Type: application/json" \
  -d '{
    "project_name": "my-app",
    "source_path": "/app/code",
    "public_url": true
  }'
```

### 5. File Management
```bash
# Upload file
curl -X POST http://localhost:9000/files/upload \
  -F "file=@test.txt"

# Download file
curl -X GET http://localhost:9000/files/download/test.txt
```

## 🔧 Configuration Files

### .env Configuration
```env
# GitHub MCP Configuration
GITHUB_TOKEN=ghp_your_token_here
GITHUB_USERNAME=your_username
GITHUB_REPO=OpenWebUI-MCP-Project

# MCP Server
MCP_GITHUB_HOST=localhost
MCP_GITHUB_PORT=8000

# Deployment
DEPLOY_DOMAIN=your-domain.com
SSL_ENABLED=true

# LiteLLM
LITELLM_MASTER_KEY=sk-your-litellm-key
LITELLM_MASTER_KEY_ID=1
```

### OpenWebUI Integration
Môi trường này tích hợp với OpenWebUI để:
- **Model Management**: Quản lý 100+ AI models
- **LiteLLM Gateway**: Cân bằng tải AI requests
- **Vietnamese Support**: Giao diện tiếng Việt
- **Sandbox Integration**: Kết hợp với code execution

## 🆚 So sánh với Manus AI

| Tính năng | Manus AI | OpenWebUI-MCP | Status |
|-----------|----------|---------------|--------|
| Code Execution | ✅ | ✅ | **MATCHED** |
| Web Automation | ✅ | ✅ | **MATCHED** |
| Auto-Deployment | ✅ | ✅ | **MATCHED** |
| File Management | ✅ | ✅ | **MATCHED** |
| GitHub Integration | ✅ | ✅ | **MATCHED** |
| AI Model Gateway | ❌ | ✅ | **ENHANCED** |
| Vietnamese UI | ❌ | ✅ | **ENHANCED** |
| Cost | $499k/month | **FREE** | **SUPERIOR** |

## 🎯 Advantages so với Manus AI

1. **💰 Free hoàn toàn** - Không trả phí như Manus AI
2. **🔓 Open Source** - Code mở, có thể tùy chỉnh
3. **🇻🇳 Vietnamese Support** - Giao diện tiếng Việt
4. **🤖 AI Model Gateway** - Quản lý nhiều AI models
5. **📱 Mobile Friendly** - Tối ưu cho mobile development
6. **🔧 Extensible** - Có thể thêm tính năng mới

## 📞 Support & Troubleshooting

### Common Issues:
1. **Port conflicts**: Thay đổi port trong docker-compose.sandbox.yml
2. **Docker issues**: Restart Docker daemon
3. **Memory issues**: Tăng Docker memory limit
4. **Network issues**: Kiểm tra firewall/network settings

### Commands hữu ích:
```bash
# View all logs
docker-compose -f docker-compose.sandbox.yml logs -f

# Restart specific service
docker-compose -f docker-compose.sandbox.yml restart code-executor

# Stop all services
docker-compose -f docker-compose.sandbox.yml down

# Clean up everything
docker-compose -f docker-compose.sandbox.yml down -v --rmi all
```

---

**🎉 Môi trường Manus AI equivalent đã sẵn sàng sử dụng!**
**🚀 Chạy `./start-sandbox.sh` để bắt đầu ngay!**