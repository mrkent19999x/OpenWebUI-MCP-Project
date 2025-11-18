# 🤖 MiniMax Setup Guide - OpenWebUI Integration

## 📋 Tổng Quan Về MiniMax

**MiniMax** là một LLM provider của Trung Quốc, cung cấp các model AI mạnh mẽ với đặc điểm:
- ✅ Hỗ trợ tiếng Trung và tiếng Việt tốt
- ✅ Sandbox mode để chạy code an toàn
- ✅ API tương thích với OpenAI format
- ✅ Nhiều model khác nhau (abab, glm, etc.)

### MiniMax Models Phổ Biến:
- `abab-5.5-chat` - Model chat chính
- `abab-5.5s-chat` - Model nhỏ hơn, nhanh hơn
- `glm-4` - GLM series model
- `glm-4-flash` - Model nhanh

---

## 🔍 Kiểm Tra Trạng Thái Hiện Tại

### ✅ Đã Có:
- `MINIMAX_API_KEY` trong `.env.persistent` và `.env.example`
- Placeholder cho MiniMax trong compliance report

### ❌ Chưa Có:
- Cấu hình MiniMax API base URL trong docker-compose
- Cấu hình sandbox mode
- Hướng dẫn setup chi tiết

---

## 🚀 Cách Setup MiniMax Trong OpenWebUI

### Cách 1: Qua OpenAI-Compatible API (Khuyến Nghị)

MiniMax hỗ trợ OpenAI-compatible API, nên có thể dùng trực tiếp qua OpenWebUI.

### Cách 2: Qua Custom Provider Configuration

OpenWebUI hỗ trợ custom providers thông qua environment variables.

---

## 📝 Cấu Hình Chi Tiết

### 1. Lấy MiniMax API Key

1. Đăng ký tại: https://www.minimax.chat/
2. Vào Dashboard → API Keys
3. Tạo API key mới
4. Copy API key

### 2. MiniMax API Endpoints

- **Production API**: `https://api.minimax.chat/v1`
- **Sandbox API**: `https://api.minimax.chat/v1/sandbox` (nếu có)

### 3. Cấu Hình Trong OpenWebUI

OpenWebUI hỗ trợ MiniMax qua 2 cách:

#### Cách A: Dùng OpenAI-Compatible Mode

MiniMax API tương thích với OpenAI format, nên có thể dùng như sau:

```bash
# Trong .env hoặc docker-compose.yml
OPENAI_API_BASE_URL=https://api.minimax.chat/v1
OPENAI_API_KEY=your-minimax-api-key
```

**Lưu ý**: Cách này sẽ dùng chung với OpenAI config.

#### Cách B: Dùng Custom Provider (Nếu OpenWebUI hỗ trợ)

Một số version OpenWebUI hỗ trợ custom providers:

```bash
# Thêm vào docker-compose.yml
MINIMAX_API_KEY=your-api-key
MINIMAX_API_BASE_URL=https://api.minimax.chat/v1
ENABLE_MINIMAX=True
```

---

## 🏗️ Sandbox Mode

### MiniMax Sandbox Là Gì?

Sandbox mode cho phép chạy code Python một cách an toàn, cách ly với hệ thống chính.

### Cách Bật Sandbox:

1. **Qua API Parameter**:
   - Thêm parameter `sandbox=true` vào request
   - Hoặc dùng endpoint `/v1/sandbox`

2. **Qua Model Selection**:
   - Một số model của MiniMax có sandbox built-in
   - Chọn model có suffix `-sandbox`

### Cấu Hình Sandbox:

```bash
# Nếu OpenWebUI hỗ trợ
MINIMAX_SANDBOX_ENABLED=True
MINIMAX_SANDBOX_API_URL=https://api.minimax.chat/v1/sandbox
```

---

## 📁 Cấu Trúc Thư Mục Đề Xuất

```
/workspace/
├── docker-compose.yml          # ✅ Đã có - cần thêm MiniMax config
├── docker-compose.production.yml  # ✅ Đã có - cần thêm MiniMax config
├── .env.persistent            # ✅ Đã có MINIMAX_API_KEY
├── .env.example              # ✅ Đã có MINIMAX_API_KEY
├── minimax/
│   ├── config/
│   │   └── sandbox.json       # Sandbox configuration
│   ├── scripts/
│   │   └── test_minimax.sh    # Test script
│   └── README.md             # MiniMax specific docs
└── MINIMAX_SETUP_GUIDE.md    # ✅ File này
```

---

## 🔧 Các Bước Setup

### Bước 1: Thêm Config Vào Docker Compose

Cần thêm vào `docker-compose.yml` và `docker-compose.production.yml`:

```yaml
environment:
  # MiniMax Configuration
  - MINIMAX_API_KEY=${MINIMAX_API_KEY}
  - MINIMAX_API_BASE_URL=${MINIMAX_API_BASE_URL:-https://api.minimax.chat/v1}
  - ENABLE_MINIMAX=${ENABLE_MINIMAX:-True}
  - MINIMAX_SANDBOX_ENABLED=${MINIMAX_SANDBOX_ENABLED:-False}
```

### Bước 2: Cập Nhật .env Files

Thêm vào `.env.persistent` và `.env.example`:

```bash
# MiniMax Configuration
MINIMAX_API_KEY=
MINIMAX_API_BASE_URL=https://api.minimax.chat/v1
ENABLE_MINIMAX=True
MINIMAX_SANDBOX_ENABLED=False
```

### Bước 3: Test Connection

```bash
# Test API key
curl -X POST https://api.minimax.chat/v1/chat/completions \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "abab-5.5-chat",
    "messages": [{"role": "user", "content": "Hello"}]
  }'
```

---

## 🎯 Sử Dụng Trong OpenWebUI UI

### Cách 1: Thêm Model Qua Settings

1. Vào OpenWebUI → Settings → Models
2. Click "Add Model"
3. Chọn "OpenAI-Compatible"
4. Điền:
   - Name: `MiniMax abab-5.5-chat`
   - Base URL: `https://api.minimax.chat/v1`
   - API Key: `your-minimax-api-key`
   - Model: `abab-5.5-chat`

### Cách 2: Dùng Environment Variables

Nếu OpenWebUI tự động detect MiniMax từ env vars, model sẽ xuất hiện tự động.

---

## 🔒 Sandbox Security

### Sandbox Mode Features:
- ✅ Code isolation
- ✅ Resource limits
- ✅ Network restrictions
- ✅ File system sandboxing

### Khi Nào Dùng Sandbox:
- Khi cần chạy code Python từ user
- Khi muốn test code an toàn
- Khi cần code execution trong chat

---

## 📊 So Sánh Với Các Provider Khác

| Feature | MiniMax | OpenAI | Groq |
|---------|---------|--------|------|
| Tiếng Việt | ✅ Tốt | ⚠️ Trung bình | ⚠️ Trung bình |
| Sandbox | ✅ Có | ❌ Không | ❌ Không |
| Giá | 💰 Trung bình | 💰💰 Đắt | 💰 Rẻ |
| Tốc độ | ⚡ Nhanh | ⚡⚡ Rất nhanh | ⚡⚡⚡ Cực nhanh |

---

## ❓ Troubleshooting

### Lỗi: API Key Invalid
- Kiểm tra API key đúng chưa
- Kiểm tra API key còn hạn không
- Thử tạo API key mới

### Lỗi: Model Not Found
- Kiểm tra model name đúng chưa
- Xem danh sách model: `curl https://api.minimax.chat/v1/models`

### Lỗi: Sandbox Not Working
- Kiểm tra sandbox enabled chưa
- Kiểm tra API endpoint đúng chưa
- Xem logs: `./manage.sh dev logs open-webui`

---

## 📚 Tài Liệu Tham Khảo

- MiniMax Official Docs: https://www.minimax.chat/docs
- MiniMax API Reference: https://api.minimax.chat/docs
- OpenWebUI Provider Docs: https://docs.openwebui.com/providers

---

## ✅ Checklist Setup

- [ ] Đăng ký tài khoản MiniMax
- [ ] Lấy API key
- [ ] Thêm config vào docker-compose.yml
- [ ] Cập nhật .env files
- [ ] Test API connection
- [ ] Thêm model vào OpenWebUI UI
- [ ] Test chat với MiniMax model
- [ ] Test sandbox mode (nếu cần)

---

**Chúc anh setup thành công!** 🚀
