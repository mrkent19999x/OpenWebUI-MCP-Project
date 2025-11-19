# 🔑 HƯỚNG DẪN LẤY API KEYS CHO MODELS

## 📋 TỔNG HỢP CÁC API KEYS CẦN THIẾT

### 1. 🤖 **MiniMax API Key** (Quan trọng - Model nhanh, context lớn)

**Website**: https://www.minimax.chat/

**Cách lấy**:
1. Mở trình duyệt, vào https://www.minimax.chat/
2. Click **"Đăng ký"** hoặc **"Đăng nhập"** (nếu đã có tài khoản)
3. Sau khi đăng nhập, vào **Dashboard** hoặc **Settings**
4. Tìm mục **"API Keys"** hoặc **"API管理"**
5. Click **"Tạo API Key mới"** hoặc **"Generate New Key"**
6. Copy key (dạng: `sk-xxxxx...`)
7. Lưu vào file `.env`: 
   ```
   MINIMAX_API_KEY=sk-xxxxx...
   ```

**Lưu ý**: MiniMax có free tier, nhưng có giới hạn requests.

---

### 2. 🧠 **Anthropic (Claude) API Key**

**Website**: https://console.anthropic.com/

**Cách lấy**:
1. Mở trình duyệt, vào https://console.anthropic.com/
2. Click **"Sign Up"** hoặc **"Sign In"**
3. Sau khi đăng nhập, vào **Settings** (biểu tượng bánh răng)
4. Chọn **"API Keys"** ở menu bên trái
5. Click **"Create Key"**
6. Đặt tên cho key (ví dụ: "Open WebUI")
7. Copy key (dạng: `sk-ant-xxxxx...`)
8. Lưu vào file `.env`:
   ```
   ANTHROPIC_API_KEY=sk-ant-xxxxx...
   ```

**Lưu ý**: Claude có free tier $5 credit khi đăng ký mới.

---

### 3. 🌐 **Google AI (Gemini) API Key**

**Website**: https://aistudio.google.com/app/apikey

**Cách lấy**:
1. Mở trình duyệt, vào https://aistudio.google.com/app/apikey
2. Đăng nhập bằng Google account
3. Click **"Create API Key"** hoặc **"Get API Key"**
4. Chọn project (hoặc tạo project mới)
5. Copy key (dạng: `AIza...`)
6. Lưu vào file `.env`:
   ```
   GOOGLE_API_KEY=AIza...
   ```

**Lưu ý**: Gemini có free tier rất hào phóng (60 requests/phút).

---

### 4. 🤗 **HuggingFace API Key**

**Website**: https://huggingface.co/settings/tokens

**Cách lấy**:
1. Mở trình duyệt, vào https://huggingface.co/
2. Đăng ký/Đăng nhập
3. Click vào avatar → **Settings**
4. Chọn **"Access Tokens"** ở menu bên trái
5. Click **"New token"**
6. Đặt tên (ví dụ: "Open WebUI")
7. Chọn quyền: **Read** hoặc **Write**
8. Copy token (dạng: `hf_xxxxx...`)
9. Lưu vào file `.env`:
   ```
   HUGGINGFACE_API_KEY=hf_xxxxx...
   ```

**Lưu ý**: HuggingFace free, không giới hạn.

---

### 5. 🔧 **GitHub Token** (Cho MCP Server)

**Website**: https://github.com/settings/tokens

**Cách lấy**:
1. Mở trình duyệt, vào https://github.com/
2. Đăng nhập GitHub
3. Click avatar → **Settings**
4. Scroll xuống → **Developer settings**
5. Chọn **"Personal access tokens"** → **"Tokens (classic)"**
6. Click **"Generate new token"** → **"Generate new token (classic)"**
7. Đặt tên (ví dụ: "Open WebUI MCP")
8. Chọn scopes:
   - ✅ `repo` (Full control of private repositories)
   - ✅ `workflow` (Update GitHub Action workflows)
   - ✅ `read:org` (Read org and team membership)
9. Click **"Generate token"**
10. **Copy token ngay** (chỉ hiện 1 lần, dạng: `ghp_xxxxx...`)
11. Lưu vào file `.env`:
    ```
    GITHUB_TOKEN=ghp_xxxxx...
    ```

---

## 📝 TẠO FILE .ENV

Tạo file `.env` trong thư mục `/home/mrkent/openwebui-merged/`:

```bash
cd /home/mrkent/openwebui-merged
nano .env
```

Hoặc dùng editor khác. Nội dung file:

```env
# AI Models API Keys
MINIMAX_API_KEY=sk-xxxxx...
ANTHROPIC_API_KEY=sk-ant-xxxxx...
GOOGLE_API_KEY=AIza...
HUGGINGFACE_API_KEY=hf_xxxxx...

# Integration Tokens
GITHUB_TOKEN=ghp_xxxxx...

# Optional - Nếu cần
PERPLEXITY_API_KEY=pplx-xxxxx...
GEMINI_API_KEY=AIza...  # Nếu khác với GOOGLE_API_KEY
VERCEL_TOKEN=xxxxx...

# Database
POSTGRES_PASSWORD=your_secure_password_here

# LiteLLM
LITELLM_MASTER_KEY=sk-litellm-1234567890abcdef
```

**Lưu ý**: Thay `xxxxx...` bằng key thật của anh!

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

3. **Test trong Open WebUI**:
   - Vào http://localhost:7860
   - Settings → Connections
   - Kiểm tra các models có hiển thị không

---

## 🎯 MODELS QUAN TRỌNG NHẤT

### Nếu chỉ lấy 1-2 keys:
1. **MiniMax** - Nhanh, context lớn, free tier
2. **Google Gemini** - Free tier hào phóng, tốt

### Nếu lấy đầy đủ:
1. MiniMax
2. Claude (Anthropic)
3. Google Gemini
4. HuggingFace
5. GitHub (cho MCP)

---

## 💡 LƯU Ý

- **Bảo mật**: Không share API keys với ai
- **Free tier**: Một số có free, một số cần trả phí
- **Rate limits**: Kiểm tra giới hạn của từng API
- **Backup**: Lưu keys ở nơi an toàn

---

## 🆘 NẾU GẶP VẤN ĐỀ

1. **Key không hoạt động**: Kiểm tra lại key đã copy đúng chưa
2. **Hết quota**: Kiểm tra usage trên dashboard của từng service
3. **Lỗi kết nối**: Kiểm tra internet và firewall

