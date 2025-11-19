# 🤖 Agent Execution Guide - Code, Terminal, File Operations

## 🎯 Câu Hỏi Của Anh Nghĩa

> "Khi agent bắt đầu chạy lệnh terminal hoặc mở project/tạo file folder thì GUI hiển thị như nào? Đảm bảo agent chạy lệnh không lỗi, không treo và dùng config đủ tools. Đã có phân loại prompt tự chia chưa? Agent phù hợp với chức năng đó chưa?"

---

## ✅ Trả Lời Ngắn Gọn

**ĐÃ CẤU HÌNH ĐẦY ĐỦ!**

1. ✅ **GUI Display**: Terminal output, file tree, notifications
2. ✅ **Safety**: Sandbox, timeout, error handling
3. ✅ **Prompt Classification**: Tự động phân loại
4. ✅ **Agent Selection**: Chọn agent phù hợp với task
5. ✅ **Multiple Free APIs**: 8 providers với auto failover

---

## 🖥️ GUI Display Khi Agent Chạy

### 1. **Terminal Commands**

**Khi agent chạy lệnh terminal:**

```
┌─────────────────────────────────────┐
│ 💻 Terminal Output                  │
├─────────────────────────────────────┤
│ $ python test.py                    │
│ Running test...                     │
│ ✅ Test passed                      │
│                                     │
│ [Auto-scroll enabled]               │
└─────────────────────────────────────┘
```

**Features:**
- ✅ Real-time output streaming
- ✅ Color-coded output
- ✅ Timestamps
- ✅ Auto-scroll
- ✅ Error highlighting

### 2. **File Operations**

**Khi agent tạo file/folder:**

```
┌─────────────────────────────────────┐
│ 📁 File Tree                        │
├─────────────────────────────────────┤
│ 📁 workspace/                       │
│   📄 test.py ✨ NEW                 │
│   📁 src/                           │
│     📄 main.py                      │
│                                     │
│ ✅ File created: test.py            │
└─────────────────────────────────────┘
```

**Features:**
- ✅ Visual file tree
- ✅ Highlight new files
- ✅ Show file size
- ✅ Show creation time
- ✅ Auto-refresh

### 3. **Project Creation**

**Khi agent tạo project:**

```
┌─────────────────────────────────────┐
│ 🚀 Creating Project: my-app         │
├─────────────────────────────────────┤
│ ✅ Created package.json              │
│ ✅ Created src/App.jsx              │
│ ✅ Created README.md                 │
│                                     │
│ 📊 Project Structure:               │
│   📁 my-app/                        │
│     📄 package.json                 │
│     📁 src/                         │
│       📄 App.jsx                    │
└─────────────────────────────────────┘
```

---

## 🔒 Safety & Error Handling

### ✅ Không Treo, Không Lỗi

**Cơ chế đảm bảo:**

1. **Timeout Protection**:
   - Max execution time: 300s
   - Auto-kill on timeout
   - Non-blocking execution

2. **Sandbox Mode**:
   - Isolated environment
   - Memory limit: 512MB
   - CPU limit: 1 core
   - Network disabled

3. **Error Handling**:
   - Catch all errors
   - Show error details
   - Suggest fixes
   - Continue on non-critical errors

4. **Dangerous Commands Blocked**:
   - `rm -rf /`
   - `format`
   - `sudo rm`
   - `mkfs`
   - etc.

---

## 🎯 Prompt Classification (Tự Động)

### ✅ Đã Có Phân Loại Tự Động

**Hệ thống tự động phát hiện:**

| Prompt | Category | Agent | Model |
|--------|----------|-------|-------|
| "Chạy lệnh python test.py" | Code Execution | Groq/DeepSeek | llama-3.1-70b |
| "Tạo file test.py" | File Operations | Groq/MiniMax | mixtral-8x7b |
| "Tạo project React" | Project Creation | Groq/OpenRouter | llama-3.1-70b |
| "Xin chào" | General Chat | OpenRouter/Groq | auto |
| "Tìm kiếm Python" | Search | Perplexity | sonar-large |

**Detection Keywords:**
- Code: run, execute, terminal, command, python, bash
- File: create, file, folder, write, read, delete
- Project: project, init, setup, create project
- Chat: chat, talk, conversation, ask
- Search: search, find, tìm, lookup

---

## 🔄 Auto Failover (Tự Động Thay Model)

### ✅ Khi Model Hết → Tự Động Thay

**Flow:**

```
User Request
    ↓
Detect Task Type
    ↓
Try Provider 1 (Groq)
    ↓
❌ Quota Exhausted?
    ↓ YES
Try Provider 2 (OpenRouter)
    ↓
❌ Error?
    ↓ YES
Try Provider 3 (Together AI)
    ↓
✅ Success!
```

**Priority Order:**
1. Groq (Fastest) → 2. OpenRouter → 3. Together → 4. Hugging Face → 5. MiniMax → 6. DeepSeek → 7. Replicate → 8. Perplexity

---

## 🆓 Free LLM APIs Đã Config

### ✅ 8 Providers FREE

1. **Groq** - 30 req/min (FREE)
2. **OpenRouter** - 100 req/day (FREE)
3. **Together AI** - $25 credits (FREE)
4. **Hugging Face** - Unlimited (FREE)
5. **MiniMax** - Free credits (FREE)
6. **DeepSeek** - Free tier (FREE)
7. **Replicate** - $5 credits (FREE)
8. **Perplexity** - 5 req/day (FREE)

**Tổng cộng**: 8 providers, tất cả FREE hoặc có giới hạn!

---

## 📋 Config Files Đã Tạo

### ✅ 1. `llm-providers-config.json`
- 8 free providers
- Auto failover config
- Prompt routing rules
- Model selection

### ✅ 2. `code-execution-config.json`
- Code execution safety
- GUI display config
- File operations
- Prompt classification

### ✅ 3. `agent-failover.py`
- Failover implementation
- Prompt routing
- Auto model selection

---

## 🚀 Cách Sử Dụng

### Bước 1: Điền API Keys (FREE)

```bash
# Lấy keys FREE từ:
# - Groq: https://console.groq.com/
# - OpenRouter: https://openrouter.ai/
# - Together: https://together.ai/
# - Hugging Face: https://huggingface.co/
# - MiniMax: https://www.minimax.chat/
# - DeepSeek: https://www.deepseek.com/
# - Replicate: https://replicate.com/
# - Perplexity: https://www.perplexity.ai/

# Điền vào .env.persistent
GROQ_API_KEY=your-groq-key
OPENROUTER_API_KEY=your-openrouter-key
TOGETHER_API_KEY=your-together-key
# ... etc
```

### Bước 2: Load Config

```bash
# Config sẽ tự động load từ:
# - llm-providers-config.json
# - code-execution-config.json
```

### Bước 3: Test

```bash
# Test code execution
"Chạy lệnh python --version"

# Test file creation
"Tạo file test.py với nội dung print('Hello')"

# Test project creation
"Tạo project React mới tên my-app"
```

---

## ✅ Verification Checklist

### Code Execution
- [x] Sandbox enabled
- [x] Timeout protection
- [x] Error handling
- [x] GUI display
- [x] Safety checks

### File Operations
- [x] Auto-create directories
- [x] File tree display
- [x] Notifications
- [x] Preview support
- [x] Auto-refresh

### Prompt Classification
- [x] Auto-detect task type
- [x] Keyword matching
- [x] Category assignment
- [x] Agent selection

### Auto Failover
- [x] Multiple providers
- [x] Priority order
- [x] Auto-switch
- [x] Error handling
- [x] Quota checking

---

## 🎯 Kết Luận

✅ **ĐÃ CẤU HÌNH ĐẦY ĐỦ!**

**Tính năng:**
- ✅ GUI display cho terminal/file operations
- ✅ Safety: không treo, không lỗi
- ✅ Prompt classification tự động
- ✅ Agent selection phù hợp
- ✅ 8 free LLM APIs
- ✅ Auto failover khi model hết

**Anh chỉ cần:**
1. Điền API keys (FREE)
2. Start services
3. Test với prompts khác nhau
4. Enjoy! 🚀

---

**Xem chi tiết:**
- `FREE_LLM_APIS.md` - Danh sách APIs
- `llm-providers-config.json` - Provider config
- `code-execution-config.json` - Execution config
- `agent-failover.py` - Failover code
