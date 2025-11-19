# ✅ TỔNG HỢP LINK VÀ CONFIG SIDEBAR

## 🌐 LINK CLOUDFLARE TUNNEL (CỐ ĐỊNH):

```
https://circulation-robertson-bass-lesson.trycloudflare.com
```

📱 **Dùng được trên mobile, không cần cùng mạng LAN**
✅ Tự động khởi động khi boot
✅ Chạy 24/7

**Login:**
- Email: begau1302@gmail.com
- Password: Baoan2022@

---

## 📋 CONFIG SIDEBAR BÊN PHẢI (PROMPTS & TOOLS)

### ✅ ĐÃ CÓ SẴN:

1. **Prompt Templates** (10 templates):
   - 🇻🇳 Trợ Lý Tiếng Việt
   - 💻 Trợ Lý Lập Trình
   - ✍️ Trợ Lý Viết Lách
   - 📊 Chuyên Gia Phân Tích Dữ Liệu
   - 👨‍🏫 Giáo Viên
   - 💼 Cố Vấn Kinh Doanh
   - 🌐 Phiên Dịch Viên
   - 🐛 Chuyên Gia Debug
   - 📋 Quản Lý Dự Án
   - ✨ Nhà Văn Sáng Tạo

2. **System Prompts** (8 prompts):
   - Mặc định
   - Tiếng Việt
   - Lập Trình
   - Viết Lách
   - Phân Tích
   - Giáo Viên
   - Kinh Doanh
   - Sáng Tạo

3. **Files đã mount vào container:**
   - `/app/backend/data/prompt-templates.json`
   - `/app/backend/data/system-prompts.json`

---

## 🔧 CÁCH BẬT PROMPTS Ở SIDEBAR:

### Bước 1: Vào Admin Settings → Interface
1. Login vào app
2. Click avatar (góc trên bên phải) → "Admin Panel"
3. Click tab "Interface" (Giao diện)

### Bước 2: Enable Prompts
Tìm và bật các switch:
- ✅ "Show Prompt Templates" hoặc "Hiển thị Prompt Templates"
- ✅ "Show Suggested Prompts" hoặc "Hiển thị Gợi ý"
- ✅ "Enable Right Sidebar" hoặc "Bật Sidebar Bên Phải"
- ✅ "Show Tools Panel" hoặc "Hiển thị Tools"

### Bước 3: Save và Refresh
1. Click "Save" ở cuối trang
2. Refresh trang (F5)
3. Prompts sẽ hiện ở sidebar bên phải

---

## 📝 LƯU Ý:

- **Prompts đã có sẵn** trong file, chỉ cần enable trong UI
- Nếu không thấy prompts:
  1. Restart container: `docker-compose restart open-webui`
  2. Đợi 30 giây
  3. Refresh trang
- **Tools** (Code, Browser) sẽ tự động hiện khi được enable trong External Tools

---

## 🎯 KẾT QUẢ:

Sau khi config xong, sidebar bên phải sẽ có:
- ✅ Danh sách prompt templates (click để dùng ngay)
- ✅ Suggested prompts (gợi ý)
- ✅ Tools (Code Execution, Browser, v.v.)
- ✅ Folders (nếu có)

