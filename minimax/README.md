# 🤖 MiniMax Integration Directory

Thư mục này chứa các file cấu hình và script cho MiniMax integration.

## 📁 Cấu Trúc

```
minimax/
├── config/
│   └── sandbox.json          # Cấu hình sandbox mode
├── scripts/
│   └── test_minimax.sh       # Script test API connection
├── sandbox/                  # Sandbox workspace (nếu cần)
└── README.md                 # File này
```

## 🚀 Quick Start

### 1. Test API Connection

```bash
# Cách 1: Truyền API key trực tiếp
./minimax/scripts/test_minimax.sh YOUR_API_KEY

# Cách 2: Dùng environment variable
export MINIMAX_API_KEY=YOUR_API_KEY
./minimax/scripts/test_minimax.sh
```

### 2. Cấu Hình Sandbox

Chỉnh sửa `config/sandbox.json` để cấu hình sandbox mode:

```json
{
  "sandbox": {
    "enabled": true,
    "timeout": 30,
    "memory_limit": "512MB"
  }
}
```

Sau đó set trong `.env`:
```bash
MINIMAX_SANDBOX_ENABLED=True
```

### 3. Sử Dụng Trong OpenWebUI

1. Vào OpenWebUI → Settings → Models
2. Add Model → OpenAI-Compatible
3. Điền:
   - Name: `MiniMax abab-5.5-chat`
   - Base URL: `https://api.minimax.chat/v1`
   - API Key: `your-api-key`
   - Model: `abab-5.5-chat`

## 📚 Tài Liệu

Xem `MINIMAX_SETUP_GUIDE.md` ở thư mục gốc để biết chi tiết.
