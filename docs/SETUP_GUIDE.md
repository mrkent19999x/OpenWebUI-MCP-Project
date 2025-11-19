# 🚀 OpenWebUI-MCP-Project Setup Guide

## 📋 Quick Start

### 1. **Clone & Setup**
```bash
git clone https://github.com/mrkent19999x/OpenWebUI-MCP-Project.git
cd OpenWebUI-MCP-Project
```

### 2. **Environment Configuration**
```bash
# Copy và customize .env file
cp .env.example .env
# Edit .env với API keys bạn có
```

### 3. **Deploy**
```bash
docker-compose up -d
```

### 4. **Access**
- OpenWebUI: http://localhost:3000
- LiteLLM API: http://localhost:4000

---

## 🛠️ MCP Integration Setup

### **Option 1: GitHub MCP Tool** (Recommended)
```bash
# Sử dụng GitHub MCP thay vì bash commands
# Trong Cursor hoặc MCP-compatible editor:
/github/repo --clone https://github.com/mrkent19999x/OpenWebUI-MCP-Project
```

### **Option 2: Traditional Git**
```bash
git clone https://github.com/mrkent19999x/OpenWebUI-MCP-Project.git
cd OpenWebUI-MCP-Project
# Edit files với your preferred editor
git add .
git commit -m "your changes"
git push origin main
```

---

## 💻 Cursor Setup

### **1. Install MCP Extension**
```bash
# Trong Cursor
# Extensions → Search "MCP" → Install MCP Extension
```

### **2. Configure MCP Server**
Tạo file `~/.cursor/mcp-servers.json`:
```json
{
  "github": {
    "command": "npx",
    "args": ["@cursor/mcp-github", "--token", "YOUR_GITHUB_TOKEN"]
  },
  "docker": {
    "command": "npx", 
    "args": ["@cursor/mcp-docker"]
  }
}
```

### **3. MCP Commands trong Cursor**
```bash
# GitHub operations
/github/repo clone --url https://github.com/mrkent19999x/OpenWebUI-MCP-Project

# File operations
/file/read --path OpenWebUI-MCP-Project/docker-compose.yml
/file/write --path OpenWebUI-MCP-Project/.env --content YOUR_ENV_CONTENT

# Docker operations  
/docker/compose up --project OpenWebUI-MCP-Project
```

---

## 🔐 API Keys Setup

### **Free Tier APIs** (Recommended to start)
1. **Groq** (FREE - Ultra Fast)
   - Visit: https://console.groq.com/keys
   - Create free API key
   - Add to `.env`: `GROQ_API_KEY=gsk_xxx`

2. **OpenRouter** (FREE Tier)
   - Visit: https://openrouter.ai/keys
   - Get free tier key
   - Add to `.env`: `OPENROUTER_API_KEY=sk-or_xxx`

3. **Hugging Face** (FREE)
   - Visit: https://huggingface.co/settings/tokens
   - Create token với inference permission
   - Add to `.env`: `HUGGINGFACE_API_KEY=hf_xxx`

4. **Perplexity** (FREE Tier)
   - Visit: https://www.perplexity.ai/settings/api
   - Get free API key
   - Add to `.env`: `PERPLEXITY_API_KEY=pplx_xxx`

### **Vietnamese Support**
```bash
# MiniMax (Vietnamese models)
MINIMAX_API_KEY=your-minimax-key
MINIMAX_API_BASE_URL=https://api.minimax.chat/v1
```

---

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   OpenWebUI     │    │   LiteLLM       │    │   100+ AI       │
│   (Port 3000)   │───▶│   Gateway       │───▶│   Models        │
│                 │    │   (Port 4000)   │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   PostgreSQL    │    │     Redis       │    │   Local Models  │
│   (Metadata)    │    │   (Cache)       │    │   (Ollama)      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

---

## 🚀 Deployment Commands

### **Start Services**
```bash
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

### **Stop Services**
```bash
docker-compose down
```

### **Restart Specific Service**
```bash
docker-compose restart open-webui
docker-compose restart litellm
```

---

## 🔍 Troubleshooting

### **Common Issues**

1. **Port already in use**
   ```bash
   sudo lsof -i :3000
   sudo lsof -i :4000
   docker-compose down
   ```

2. **API Keys not working**
   - Check `.env` file syntax
   - Verify API key format
   - Check provider documentation

3. **LiteLLM not loading models**
   - Check `litellm_config.yaml`
   - Verify PostgreSQL connection
   - Check LiteLLM logs: `docker-compose logs litellm`

4. **Database connection failed**
   ```bash
   docker-compose logs postgres
   # Check database creation
   ```

### **Log Commands**
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f open-webui
docker-compose logs -f litellm
docker-compose logs -f postgres
```

---

## 📱 Features Available

### **100+ AI Models Support**
- ✅ OpenAI: GPT-4, GPT-3.5-turbo
- ✅ Anthropic: Claude-3 models
- ✅ Google: Gemini Pro
- ✅ MiniMax: Vietnamese models
- ✅ Groq: Ultra-fast inference
- ✅ HuggingFace: 100+ open source
- ✅ Local: Ollama models

### **Vietnamese Support**
- ✅ Default language: Vietnamese
- ✅ MiniMax Vietnamese models
- ✅ Localized interface
- ✅ Vietnamese tokenization

### **Performance Features**
- ✅ Load balancing
- ✅ Redis caching
- ✅ WebSocket streaming
- ✅ Async processing
- ✅ Connection pooling

---

## 🎯 Next Steps

1. **Choose your AI providers** (start với free tier)
2. **Configure .env** với API keys
3. **Deploy và test**
4. **Customize models** theo nhu cầu
5. **Setup monitoring** (optional)

**Need help? Ask anytime!** 🚀
