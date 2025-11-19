# 📋 DANH SÁCH CÁC FILE HƯỚNG DẪN LẤY API KEYS

## 🎯 CÁC FILE HƯỚNG DẪN CÓ SẴN

### 1. **LAY_API_KEYS_NHANH.txt** ⚡ (NHANH NHẤT)
- **File:** `LAY_API_KEYS_NHANH.txt`
- **Nội dung:** Hướng dẫn nhanh, ngắn gọn
- **Dùng khi:** Anh muốn xem nhanh các bước

### 2. **HUONG_DAN_LAY_API_KEYS_DON_GIAN.md** 📖 (DỄ HIỂU NHẤT)
- **File:** `HUONG_DAN_LAY_API_KEYS_DON_GIAN.md`
- **Nội dung:** Hướng dẫn đơn giản, dễ hiểu
- **Dùng khi:** Anh muốn hướng dẫn chi tiết, dễ làm theo

### 3. **HUONG_DAN_LAY_API_KEYS.md** 📚 (ĐẦY ĐỦ NHẤT)
- **File:** `HUONG_DAN_LAY_API_KEYS.md`
- **Nội dung:** Hướng dẫn đầy đủ, chi tiết
- **Dùng khi:** Anh muốn biết tất cả các API keys

### 4. **API_KEYS_GUIDE.md** 🔑 (HƯỚNG DẪN CHUYÊN NGHIỆP)
- **File:** `API_KEYS_GUIDE.md`
- **Nội dung:** Hướng dẫn chuyên nghiệp, có nhiều options
- **Dùng khi:** Anh muốn tìm hiểu sâu hơn

---

## 🚀 KHUYẾN NGHỊ CHO ANH

### Nếu anh muốn nhanh:
👉 **Đọc:** `LAY_API_KEYS_NHANH.txt`

### Nếu anh muốn dễ hiểu:
👉 **Đọc:** `HUONG_DAN_LAY_API_KEYS_DON_GIAN.md`

### Nếu anh muốn đầy đủ:
👉 **Đọc:** `HUONG_DAN_LAY_API_KEYS.md`

---

## 📝 TÓM TẮT CÁC API KEYS CẦN LẤY

### 1. **MiniMax** (Quan trọng nhất)
- **Website:** https://www.minimax.chat/
- **Free tier:** Có, nhưng có giới hạn
- **Paid:** Không giới hạn
- **Key format:** `sk-xxxxx...`

### 2. **Google Gemini** (Free tốt)
- **Website:** https://aistudio.google.com/app/apikey
- **Free tier:** Rất hào phóng (60 requests/phút)
- **Paid:** Không giới hạn
- **Key format:** `AIza...`

### 3. **Claude (Anthropic)** (Model xịn)
- **Website:** https://console.anthropic.com/
- **Free tier:** $5 credit khi đăng ký
- **Paid:** Không giới hạn
- **Key format:** `sk-ant-xxxxx...`

### 4. **HuggingFace** (Free, không giới hạn)
- **Website:** https://huggingface.co/settings/tokens
- **Free tier:** Free, không giới hạn
- **Paid:** Không cần
- **Key format:** `hf_xxxxx...`

### 5. **GitHub Token** (Cho MCP)
- **Website:** https://github.com/settings/tokens
- **Free:** Free
- **Key format:** `ghp_xxxxx...`

---

## 💰 MODEL GIỚI HẠN VS KHÔNG GIỚI HẠN

### 🆓 **MODEL FREE (CÓ GIỚI HẠN):**
- **MiniMax Free:** Giới hạn requests/tháng
- **Google Gemini Free:** 60 requests/phút
- **Claude Free:** $5 credit (hết là hết)
- **HuggingFace:** Free, không giới hạn (nhưng model nhẹ hơn)

### 💎 **MODEL PAID (KHÔNG GIỚI HẠN):**
- **MiniMax Paid:** Không giới hạn requests
- **Google Gemini Paid:** Không giới hạn
- **Claude Paid:** Không giới hạn
- **OpenAI GPT-4:** Paid, không giới hạn

---

## 🎯 KHUYẾN NGHỊ CHO ANH

### Vì PC anh chạy model nhẹ, Mac cũng lắm:
👉 **Anh nên dùng model xịn không giới hạn:**

1. **MiniMax Paid** (Nếu có)
   - Model nhanh, context lớn
   - Không giới hạn requests
   - Giá hợp lý

2. **Google Gemini Paid** (Nếu có)
   - Model tốt, free tier đã rất hào phóng
   - Paid không giới hạn

3. **Claude Paid** (Nếu có)
   - Model xịn nhất
   - Không giới hạn

4. **HuggingFace** (Free, không giới hạn)
   - Free, không giới hạn
   - Nhiều models

---

## 📂 VỊ TRÍ CÁC FILE

Tất cả các file đều ở trong:
```
/home/mrkent/openwebui-merged/
```

**Các file:**
- `LAY_API_KEYS_NHANH.txt`
- `HUONG_DAN_LAY_API_KEYS_DON_GIAN.md`
- `HUONG_DAN_LAY_API_KEYS.md`
- `API_KEYS_GUIDE.md`

---

## ✅ SAU KHI LẤY API KEYS

1. **Tạo file `.env`:**
   ```bash
   cd /home/mrkent/openwebui-merged
   nano .env
   ```

2. **Thêm các keys vào:**
   ```env
   MINIMAX_API_KEY=sk-xxxxx...
   GOOGLE_API_KEY=AIza...
   ANTHROPIC_API_KEY=sk-ant-xxxxx...
   HUGGINGFACE_API_KEY=hf_xxxxx...
   GITHUB_TOKEN=ghp_xxxxx...
   ```

3. **Restart services:**
   ```bash
   docker-compose restart
   ```

4. **Vào web UI và thêm keys:**
   - http://192.168.1.176:7860
   - Settings → Connections
   - Thêm các API keys

---

**Em khuyến nghị anh đọc file `HUONG_DAN_LAY_API_KEYS_DON_GIAN.md` - dễ hiểu nhất!** 📖

