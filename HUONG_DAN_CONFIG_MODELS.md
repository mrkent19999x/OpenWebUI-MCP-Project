# 🔧 HƯỚNG DẪN CONFIG MODELS VÀ CÁC CHỨC NĂNG

## 🎯 VẤN ĐỀ HIỆN TẠI

Anh đang ở trong web UI nhưng:
- ❌ **Không thấy models nào** (vì LiteLLM Gateway chưa chạy)
- ❌ **Các chức năng chưa config**: MCP, Google Drive, Update file folder

---

## 1. 🔧 FIX MODELS (LiteLLM Gateway)

### Vấn đề:
- LiteLLM Gateway đang lỗi (Exit 127)
- PostgreSQL đã chạy ✅

### Cách fix:

**Bước 1: Kiểm tra file config**
```bash
ls -lah /home/mrkent/openwebui-merged/litellm_config.yaml
```

**Bước 2: Restart LiteLLM**
```bash
cd /home/mrkent/openwebui-merged
docker-compose restart litellm-gateway
```

**Bước 3: Kiểm tra logs**
```bash
docker-compose logs litellm-gateway
```

**Bước 4: Kiểm tra models**
- Vào web UI: http://192.168.1.176:7860
- Vào Settings → Models
- Sẽ thấy các models từ LiteLLM

---

## 2. 🔑 CONFIG API KEYS

### File: `.env` hoặc trong docker-compose.yml

**Các API keys cần config:**

1. **OpenAI (GPT-4, GPT-3.5)**
```bash
OPENAI_API_KEY=sk-xxxxx
```

2. **Anthropic (Claude)**
```bash
ANTHROPIC_API_KEY=sk-ant-xxxxx
```

3. **Google AI (Gemini)**
```bash
GOOGLE_API_KEY=xxxxx
```

4. **MiniMax**
```bash
MINIMAX_API_KEY=xxxxx
```

5. **HuggingFace**
```bash
HUGGINGFACE_API_KEY=hf_xxxxx
```

**Cách thêm vào .env:**
```bash
cd /home/mrkent/openwebui-merged
nano .env
# Thêm các API keys vào
```

**Sau đó restart:**
```bash
docker-compose restart open-webui
```

---

## 3. 🔌 CONFIG MCP (Model Context Protocol)

### Đã có trong docker-compose.yml:
```yaml
- ENABLE_DIRECT_CONNECTIONS=True
- MCP_SERVER_URL=http://mcp-server:3003
- ENABLE_MCP_TOOLS=True
```

### MCP Server đang chạy:
- **Port:** `3003`
- **Container:** `mcp-server`
- **Status:** ✅ Running

### Cách sử dụng:
1. Vào web UI: http://192.168.1.176:7860
2. Vào Settings → Tools → MCP
3. Enable MCP Tools
4. Config MCP Server URL: `http://mcp-server:3003`

### MCP Tools có sẵn:
- ✅ GitHub integration
- ✅ Docker management
- ✅ File operations

---

## 4. 📁 CONFIG GOOGLE DRIVE

### Hiện tại chưa có Google Drive integration trong Open WebUI

**Có thể thêm bằng cách:**

1. **Sử dụng MCP Tools:**
   - Tạo MCP tool mới cho Google Drive
   - Config Google Drive API credentials

2. **Hoặc dùng File Upload:**
   - Upload file từ Google Drive vào Open WebUI
   - File sẽ được lưu tại: `/home/mrkent/openwebui-storage/openwebui-data/uploads`

### Nếu muốn tích hợp Google Drive:

**Cần:**
- Google Drive API credentials
- OAuth 2.0 setup
- MCP tool cho Google Drive

**Có thể thêm vào docker-compose.yml:**
```yaml
- GOOGLE_DRIVE_CLIENT_ID=${GOOGLE_DRIVE_CLIENT_ID:-}
- GOOGLE_DRIVE_CLIENT_SECRET=${GOOGLE_DRIVE_CLIENT_SECRET:-}
- ENABLE_GOOGLE_DRIVE=${ENABLE_GOOGLE_DRIVE:-False}
```

---

## 5. 📂 UPDATE FILE FOLDER

### File operations đã được enable:
```yaml
- ENABLE_FILE_UPLOAD=True
- ENABLE_FILE_PREVIEW=True
- ENABLE_FILE_DOWNLOAD=True
- ENABLE_FILE_DELETE=True
```

### Upload folder:
- **Path:** `/home/mrkent/openwebui-storage/openwebui-data/uploads`
- **Max size:** `100MB`
- **Allowed types:** `.pdf,.txt,.doc,.docx,.xls,.xlsx,.csv,.json,.md,.py,.js,.ts,.html,.css,.jpg,.jpeg,.png,.gif,.webp,.svg`

### Cách sử dụng:
1. Vào web UI
2. Click vào icon Upload (📁)
3. Chọn file cần upload
4. File sẽ được lưu trong uploads folder

---

## 6. ✅ KIỂM TRA SAU KHI FIX

### 1. Kiểm tra Models:
```bash
curl http://localhost:7860/api/models
```

### 2. Kiểm tra LiteLLM:
```bash
curl http://localhost:4000/health
```

### 3. Kiểm tra MCP:
```bash
curl http://localhost:3003/health
```

### 4. Vào web UI:
- http://192.168.1.176:7860
- Settings → Models → Sẽ thấy các models
- Settings → Tools → Sẽ thấy MCP tools

---

## 📝 TÓM TẮT

### Đã có:
- ✅ MCP Server (port 3003)
- ✅ File Upload (uploads folder)
- ✅ LiteLLM Gateway (port 4000) - cần fix
- ✅ PostgreSQL (port 5432) - đã chạy

### Cần làm:
1. ✅ Fix LiteLLM Gateway
2. ✅ Thêm API keys vào .env
3. ✅ Config MCP trong web UI
4. ⚠️ Google Drive (chưa có, cần thêm)

### Sau khi fix:
- Models sẽ hiển thị trong web UI
- MCP tools sẽ hoạt động
- File upload sẽ hoạt động

---

**Em sẽ fix LiteLLM Gateway ngay bây giờ!** 🔧

