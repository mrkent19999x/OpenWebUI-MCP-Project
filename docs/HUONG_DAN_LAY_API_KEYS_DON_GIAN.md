# 🔑 HƯỚNG DẪN LẤY API KEYS - ĐƠN GIẢN NHẤT

## 🎯 ANH CẦN LẤY API KEYS TỪ ĐÂU?

Em sẽ hướng dẫn anh từng bước một, rất đơn giản!

---

## 📌 CÁC NƠI LẤY API KEYS (Từ dễ đến khó)

### 1. 🌟 **GOOGLE GEMINI** (Dễ nhất, Free, Nên lấy đầu tiên)

**Link trực tiếp:** https://aistudio.google.com/app/apikey

**Cách làm:**
1. Click vào link trên → Mở trang Google AI Studio
2. Đăng nhập bằng tài khoản Google của anh
3. Click nút **"Create API Key"** (màu xanh)
4. Chọn project (hoặc tạo mới nếu chưa có)
5. **Copy key** (dạng: `AIzaSy...`)
6. Lưu lại để dùng sau

**Tại sao nên lấy đầu tiên:**
- ✅ Free, không cần thẻ tín dụng
- ✅ 60 requests/phút (rất nhiều)
- ✅ Model Gemini tốt, nhanh

---

### 2. 🤖 **MINIMAX** (Quan trọng - Model Việt Nam tốt)

**Link trực tiếp:** https://www.minimax.chat/

**Cách làm:**
1. Click vào link trên → Mở trang MiniMax
2. Click **"Đăng ký"** hoặc **"Đăng nhập"** (góc trên bên phải)
3. Sau khi đăng nhập, vào **Dashboard** (bảng điều khiển)
4. Tìm mục **"API Keys"** hoặc **"API管理"** (quản lý API)
5. Click **"Tạo API Key mới"** hoặc **"Generate New Key"**
6. **Copy key** (dạng: `sk-xxxxx...`)
7. Lưu lại

**Tại sao quan trọng:**
- ✅ Model Việt Nam, hiểu tiếng Việt tốt
- ✅ Context lớn (có thể nhớ nhiều thông tin)
- ✅ Nhanh

---

### 3. 🧠 **CLAUDE (ANTHROPIC)** (Tùy chọn - Model mạnh)

**Link trực tiếp:** https://console.anthropic.com/

**Cách làm:**
1. Click vào link trên → Mở trang Anthropic
2. Click **"Sign Up"** (đăng ký) hoặc **"Sign In"** (đăng nhập)
3. Sau khi đăng nhập, click vào **Settings** (biểu tượng bánh răng ⚙️)
4. Chọn **"API Keys"** ở menu bên trái
5. Click **"Create Key"**
6. Đặt tên cho key (ví dụ: "Open WebUI")
7. **Copy key** (dạng: `sk-ant-xxxxx...`)
8. Lưu lại

**Lưu ý:**
- ⚠️ Cần thẻ tín dụng (nhưng có $5 free credit khi đăng ký)
- ✅ Model Claude rất mạnh, thông minh

---

### 4. 🤗 **HUGGINGFACE** (Free, Không cần thẻ)

**Link trực tiếp:** https://huggingface.co/settings/tokens

**Cách làm:**
1. Click vào link trên → Mở trang HuggingFace
2. Đăng ký/Đăng nhập (nếu chưa có tài khoản)
3. Click vào **avatar** (ảnh đại diện) góc trên bên phải
4. Chọn **"Settings"**
5. Ở menu bên trái, chọn **"Access Tokens"**
6. Click **"New token"**
7. Đặt tên (ví dụ: "Open WebUI")
8. Chọn quyền: **Read** (đọc) hoặc **Write** (ghi)
9. **Copy token** (dạng: `hf_xxxxx...`)
10. Lưu lại

**Tại sao nên lấy:**
- ✅ Hoàn toàn free
- ✅ Không giới hạn
- ✅ Nhiều models miễn phí

---

### 5. 🔧 **GITHUB TOKEN** (Cho MCP Server - Tùy chọn)

**Link trực tiếp:** https://github.com/settings/tokens

**Cách làm:**
1. Click vào link trên → Mở trang GitHub
2. Đăng nhập GitHub (nếu chưa có thì đăng ký)
3. Click vào **avatar** (ảnh đại diện) góc trên bên phải
4. Chọn **"Settings"**
5. Scroll xuống dưới, tìm **"Developer settings"** → Click vào
6. Chọn **"Personal access tokens"** → **"Tokens (classic)"**
7. Click **"Generate new token"** → **"Generate new token (classic)"**
8. Đặt tên (ví dụ: "Open WebUI MCP")
9. Chọn các quyền (scopes):
   - ✅ `repo` (Full control of private repositories)
   - ✅ `workflow` (Update GitHub Action workflows)
   - ✅ `read:org` (Read org and team membership)
10. Scroll xuống, click **"Generate token"**
11. **Copy token ngay** (chỉ hiện 1 lần, dạng: `ghp_xxxxx...`)
12. Lưu lại ngay (không copy được lần 2!)

**Tại sao cần:**
- ✅ Để MCP Server kết nối với GitHub
- ✅ Tự động deploy code lên GitHub
- ✅ Quản lý repositories

---

## 📝 CÁC API KEYS KHÁC (Tùy chọn - Nếu muốn thêm)

### 6. **GROQ** (Free tier tốt)
- Link: https://console.groq.com/keys
- Đăng ký → API Keys → Create Key
- Copy key → Lưu

### 7. **DEEPSEEK** (Free tier)
- Link: https://platform.deepseek.com/api_keys
- Đăng ký → API Keys → Create Key
- Copy key → Lưu

### 8. **OPENROUTER** (Nhiều models)
- Link: https://openrouter.ai/keys
- Đăng ký → API Keys → Create Key
- Copy key → Lưu

### 9. **PERPLEXITY** (Search tốt)
- Link: https://www.perplexity.ai/settings/api
- Đăng ký → API Keys → Create Key
- Copy key → Lưu

---

## 💾 LƯU API KEYS VÀO FILE .ENV

Sau khi lấy xong các API keys, anh cần lưu vào file `.env`:

### Bước 1: Tạo file .env
```bash
cd /home/mrkent/openwebui-merged
nano .env
```

### Bước 2: Thêm các keys vào file

Copy và paste vào file `.env` (thay `xxxxx...` bằng key thật của anh):

```env
# ============================================
# AI MODELS API KEYS
# ============================================

# Google Gemini (Nên có)
GOOGLE_API_KEY=AIzaSy...  # Thay bằng key thật

# MiniMax (Quan trọng)
MINIMAX_API_KEY=sk-xxxxx...  # Thay bằng key thật

# Claude (Tùy chọn)
ANTHROPIC_API_KEY=sk-ant-xxxxx...  # Thay bằng key thật

# HuggingFace (Free)
HUGGINGFACE_API_KEY=hf_xxxxx...  # Thay bằng key thật

# GitHub (Cho MCP)
GITHUB_TOKEN=ghp_xxxxx...  # Thay bằng key thật

# ============================================
# CÁC API KEYS KHÁC (Tùy chọn)
# ============================================

# Groq
GROQ_API_KEY=xxxxx...

# DeepSeek
DEEPSEEK_API_KEY=xxxxx...

# OpenRouter
OPENROUTER_API_KEY=xxxxx...

# Perplexity
PERPLEXITY_API_KEY=pplx-xxxxx...

# Together AI
TOGETHER_API_KEY=xxxxx...

# Replicate
REPLICATE_API_KEY=xxxxx...

# Cohere
COHERE_API_KEY=xxxxx...

# ============================================
# SECURITY & DATABASE
# ============================================

# Secret Key (Tạo ngẫu nhiên)
WEBUI_SECRET_KEY=your-secret-key-here-12345
JWT_SECRET_KEY=your-jwt-secret-key-here-12345

# Database Password
POSTGRES_PASSWORD=your_secure_password_here

# LiteLLM Master Key
LITELLM_MASTER_KEY=sk-litellm-1234567890abcdef

# ============================================
# ADMIN SETTINGS (Tùy chọn)
# ============================================

# Admin User (Nếu muốn tạo admin)
ADMIN_USER_EMAIL=admin@example.com
ADMIN_USER_PASSWORD=your_admin_password_here
```

### Bước 3: Lưu file
- Nhấn `Ctrl + O` (lưu)
- Nhấn `Enter` (xác nhận)
- Nhấn `Ctrl + X` (thoát)

---

## ✅ SAU KHI LƯU API KEYS

### Bước 1: Restart services
```bash
cd /home/mrkent/openwebui-merged
docker-compose restart
```

### Bước 2: Kiểm tra services
```bash
docker-compose ps
```

### Bước 3: Test trong Open WebUI
1. Mở trình duyệt: http://192.168.1.176:7860
2. Vào **Settings** (Cài đặt)
3. Vào **Connections** (Kết nối)
4. Kiểm tra các models có hiển thị không

---

## 🎯 KHUYẾN NGHỊ CHO ANH

### Nếu chỉ muốn lấy 2-3 keys (Đơn giản nhất):
1. ✅ **Google Gemini** - Free, dễ lấy nhất
2. ✅ **MiniMax** - Model Việt Nam tốt
3. ✅ **HuggingFace** - Free, không giới hạn

### Nếu muốn đầy đủ (Tốt nhất):
1. ✅ Google Gemini
2. ✅ MiniMax
3. ✅ Claude (Anthropic)
4. ✅ HuggingFace
5. ✅ GitHub (cho MCP)
6. ✅ Groq (free tier)
7. ✅ DeepSeek (free tier)

---

## 💡 LƯU Ý QUAN TRỌNG

1. **Bảo mật:**
   - ❌ KHÔNG share API keys với ai
   - ❌ KHÔNG đăng keys lên mạng
   - ✅ Chỉ dùng trong file `.env` (file này không được commit lên Git)

2. **Free tier:**
   - Một số có free tier (Google, HuggingFace, Groq, DeepSeek)
   - Một số cần trả phí sau khi hết free credit (Claude, MiniMax)

3. **Rate limits:**
   - Mỗi API có giới hạn số requests/phút
   - Kiểm tra trên dashboard của từng service

4. **Backup:**
   - Lưu keys ở nơi an toàn (password manager)
   - Không để mất keys (một số chỉ hiện 1 lần)

---

## 🆘 NẾU GẶP VẤN ĐỀ

### Key không hoạt động:
- ✅ Kiểm tra lại key đã copy đúng chưa (không có khoảng trắng)
- ✅ Kiểm tra key có hết hạn không
- ✅ Kiểm tra key có đúng format không

### Hết quota:
- ✅ Kiểm tra usage trên dashboard của từng service
- ✅ Đợi reset quota (thường là theo tháng)
- ✅ Nâng cấp plan nếu cần

### Lỗi kết nối:
- ✅ Kiểm tra internet
- ✅ Kiểm tra firewall
- ✅ Kiểm tra services có chạy không: `docker-compose ps`

---

## 📞 CẦN HỖ TRỢ?

Nếu anh gặp khó khăn khi lấy API keys, cứ hỏi em nhé! Em sẽ hướng dẫn chi tiết hơn.

---

**Tóm lại:**
- 🌟 **Google Gemini**: https://aistudio.google.com/app/apikey (Dễ nhất, nên lấy đầu tiên)
- 🤖 **MiniMax**: https://www.minimax.chat/ (Quan trọng, model Việt Nam)
- 🧠 **Claude**: https://console.anthropic.com/ (Tùy chọn, model mạnh)
- 🤗 **HuggingFace**: https://huggingface.co/settings/tokens (Free, không giới hạn)
- 🔧 **GitHub**: https://github.com/settings/tokens (Cho MCP)

**Sau khi lấy xong → Lưu vào file `.env` → Restart services → Xong!** 🎉

