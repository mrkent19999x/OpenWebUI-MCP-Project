# 🚀 Open WebUI - Multi-Agent AI Platform

## 🎯 TỔNG QUAN

Project này là **Multi-Agent AI Platform** kết hợp:
- ✅ **Open WebUI** (Base platform)
- ✅ **Manus AI** features (Terminal ẩn, Code execution, UI giống Manus)
- ✅ **MiniMax AI** (Multi-agent, Fast response)
- ✅ **LiteLLM Gateway** (100+ AI models) - Tạm tắt, dùng API keys trực tiếp
- ✅ **Multi-Agent Orchestrator** (Auto-routing, Task classification)

---

## 🚀 QUICK START

### 1. Clone Repository
```bash
git clone https://github.com/mrkent19999x/OpenWebUI-MCP-Project.git
cd OpenWebUI-MCP-Project
```

### 2. Setup Environment
```bash
# Tạo file .env (xem .env.example)
cp .env.example .env
nano .env  # Thêm API keys
```

### 3. Start Services
```bash
docker-compose up -d
```

### 4. Access Web UI
- **URL:** http://localhost:7860
- **Hoặc:** http://YOUR_IP:7860

---

## 📋 CÁC TÍNH NĂNG

### Core Features
- ✅ Chat với AI models (GPT-4, Claude, Gemini, MiniMax...)
- ✅ File Upload & Management
- ✅ Code Execution (Python, Node.js, Jupyter)
- ✅ Web Browser & Search
- ✅ Knowledge Base & RAG
- ✅ MCP Tools (GitHub, Docker)
- ✅ Multi-Agent System

### UI/UX
- ✅ Terminal ẩn hoàn toàn (giống Manus AI)
- ✅ Code preview trong chat
- ✅ Custom theme
- ✅ Vietnamese language support

### Prompts
- ✅ 10 Prompt Templates
- ✅ 8 System Prompts
- ✅ Prompt suggestions

---

## 🔑 API KEYS

Thêm API keys trong web UI:
1. Vào Settings → Connections
2. Thêm các API keys:
   - Google Gemini
   - MiniMax
   - Claude (Anthropic)
   - HuggingFace
   - Và các providers khác

**Hướng dẫn chi tiết:** Xem `HUONG_DAN_LAY_API_KEYS_DON_GIAN.md`

---

## 📁 CẤU TRÚC PROJECT

```
openwebui-merged/
├── docker-compose.yml          # Config tất cả services
├── prompt-templates.json       # 10 prompt templates
├── system-prompts.json         # 8 system prompts
├── code-execution-config.json  # Config code execution
├── ui-optimization-config.json # Config UI
├── workspace-config.json       # Config workspace
├── quick-actions.json         # 16 quick actions
├── custom-theme.css           # Custom theme
├── hide-terminal-theme.css    # Ẩn terminal
└── ... (các file khác)
```

---

## 🛠️ SERVICES

- **Open WebUI:** Port 7860
- **Jupyter:** Port 8888
- **MCP Server:** Port 3003
- **Browser Automation:** Port 4444
- **Code Executor:** Port 3001
- **Redis:** Port 6379

---

## 📚 DOCUMENTATION

- `HUONG_DAN_LAY_API_KEYS_DON_GIAN.md` - Hướng dẫn lấy API keys
- `CHECKLIST_TEST_BROWSER.md` - Checklist test bằng browser
- `DANH_SACH_CHUC_NANG.md` - Danh sách chức năng
- `BAO_CAO_TEST_HOAN_CHINH.md` - Báo cáo test

---

## ✅ ĐÃ HOÀN THIỆN

- ✅ Test tất cả services
- ✅ Config tất cả tính năng
- ✅ Tạo prompts và templates
- ✅ Mount ổ 500GB
- ✅ Dọn dẹp các phiên bản cũ

---

## 📝 LICENSE

Private project - mrkent19999x

---

**Sẵn sàng sử dụng!** 🎉

