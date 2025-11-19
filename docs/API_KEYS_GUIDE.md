# 🔑 HƯỚNG DẪN LẤY API KEYS

## 📋 TỔNG HỢP CÁC API KEYS CẦN THIẾT

### 1. 🤖 **MiniMax API Key**
- **Website**: https://www.minimax.chat/
- **Cách lấy**:
  1. Đăng ký/Đăng nhập tại minimax.chat
  2. Vào Dashboard → API Keys
  3. Tạo API key mới
  4. Copy key vào `.env`: `MINIMAX_API_KEY=your_key_here`

### 2. 🧠 **Anthropic (Claude) API Key**
- **Website**: https://console.anthropic.com/
- **Cách lấy**:
  1. Đăng ký/Đăng nhập tại console.anthropic.com
  2. Vào Settings → API Keys
  3. Tạo API key mới
  4. Copy key vào `.env`: `ANTHROPIC_API_KEY=your_key_here`

### 3. 🌐 **Google AI (Gemini) API Key**
- **Website**: https://aistudio.google.com/app/apikey
- **Cách lấy**:
  1. Đăng nhập Google account
  2. Vào AI Studio → Get API Key
  3. Tạo API key mới
  4. Copy key vào `.env`: `GOOGLE_API_KEY=your_key_here`

### 4. 🤗 **HuggingFace API Key**
- **Website**: https://huggingface.co/settings/tokens
- **Cách lấy**:
  1. Đăng ký/Đăng nhập tại huggingface.co
  2. Vào Settings → Access Tokens
  3. Tạo token mới (read/write)
  4. Copy token vào `.env`: `HUGGINGFACE_API_KEY=your_token_here`

### 5. 🔧 **GitHub Token**
- **Website**: https://github.com/settings/tokens
- **Cách lấy**:
  1. Đăng nhập GitHub
  2. Vào Settings → Developer settings → Personal access tokens → Tokens (classic)
  3. Generate new token (classic)
  4. Chọn scopes: `repo`, `workflow`, `read:org`
  5. Copy token vào `.env`: `GITHUB_TOKEN=your_token_here`

### 6. 🔍 **Perplexity API Key** (Optional)
- **Website**: https://www.perplexity.ai/settings/api
- **Cách lấy**:
  1. Đăng nhập Perplexity
  2. Vào Settings → API
  3. Tạo API key
  4. Copy key vào `.env`: `PERPLEXITY_API_KEY=your_key_here`

### 7. 📧 **Gmail App Password** (Optional - cho email features)
- **Website**: https://myaccount.google.com/apppasswords
- **Cách lấy**:
  1. Bật 2-Step Verification
  2. Vào App passwords
  3. Tạo app password mới
  4. Copy password vào `.env`: `GMAIL_APP_PASSWORD=your_password_here`

### 8. 🚀 **Vercel Token** (Optional - cho deployment)
- **Website**: https://vercel.com/account/tokens
- **Cách lấy**:
  1. Đăng nhập Vercel
  2. Vào Settings → Tokens
  3. Tạo token mới
  4. Copy token vào `.env`: `VERCEL_TOKEN=your_token_here`

---

## 📝 TẠO FILE .ENV

Tạo file `.env` trong thư mục `openwebui-merged/`:

```bash
# AI Models API Keys
MINIMAX_API_KEY=your_minimax_key_here
ANTHROPIC_API_KEY=your_claude_key_here
GOOGLE_API_KEY=your_gemini_key_here
HUGGINGFACE_API_KEY=your_huggingface_token_here
PERPLEXITY_API_KEY=your_perplexity_key_here

# Integration Tokens
GITHUB_TOKEN=your_github_token_here
VERCEL_TOKEN=your_vercel_token_here

# Gmail (Optional)
GMAIL_USER=your_email@gmail.com
GMAIL_APP_PASSWORD=your_app_password_here

# Zalo OA (Optional - cho Zalo integration)
ZALO_OA_ACCESS_TOKEN=your_zalo_token_here
ZALO_OA_SECRET_KEY=your_zalo_secret_here

# Database
POSTGRES_PASSWORD=your_secure_password_here

# LiteLLM
LITELLM_MASTER_KEY=sk-litellm-1234567890abcdef
```

---

## ✅ SAU KHI SET API KEYS

1. **Restart services**:
```bash
cd /home/mrkent/openwebui-merged
docker-compose restart
```

2. **Kiểm tra services**:
```bash
docker-compose ps
```

3. **Test API connections**:
- Vào Open WebUI → Settings → Connections
- Kiểm tra các models có hiển thị không

---

## 💡 LƯU Ý

- **Bảo mật**: Không commit file `.env` lên GitHub
- **Free tier**: Một số API có free tier, một số cần trả phí
- **Rate limits**: Kiểm tra rate limits của từng API
- **Backup**: Lưu backup các API keys ở nơi an toàn

