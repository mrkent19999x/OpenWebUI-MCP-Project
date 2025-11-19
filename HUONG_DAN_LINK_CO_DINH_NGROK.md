# 🔒 HƯỚNG DẪN LINK NGROK CỐ ĐỊNH

## 💰 CHI PHÍ

### Free Plan (Miễn phí)
- ❌ **Không có link cố định**
- ⚠️ Link thay đổi mỗi lần restart
- ✅ Đủ dùng cho cá nhân
- ✅ Không giới hạn thời gian

### Paid Plans (Trả phí)
- ✅ **Có link cố định** (static domain)
- 💵 **$8/tháng** (Starter plan)
- 💵 **$20/tháng** (Pro plan) - có nhiều tính năng hơn
- ✅ Link không bao giờ thay đổi

---

## 🆓 CÁCH 1: FREE - DÙNG LINK TẠM THỜI (Không tốn tiền)

### Ưu điểm:
- ✅ Miễn phí
- ✅ Đủ dùng cho cá nhân
- ✅ Link chỉ thay đổi khi restart ngrok

### Nhược điểm:
- ⚠️ Link thay đổi nếu restart ngrok
- ⚠️ Phải lấy link mới mỗi lần restart

### Cách dùng:
1. Link hiện tại: `https://9d05824708d4.ngrok-free.app`
2. Link được lưu tự động trong: `ngrok-link.txt`
3. Nếu restart ngrok → Lấy link mới từ file

### Script tự động lấy link:
```bash
cat /home/mrkent/openwebui-merged/ngrok-link.txt
```

---

## 💵 CÁCH 2: PAID - LINK CỐ ĐỊNH (Trả phí)

### Bước 1: Đăng ký ngrok paid plan
1. Vào: https://dashboard.ngrok.com/pricing
2. Chọn plan:
   - **Starter**: $8/tháng (đủ dùng)
   - **Pro**: $20/tháng (nhiều tính năng hơn)
3. Thanh toán

### Bước 2: Tạo static domain
1. Vào: https://dashboard.ngrok.com/cloud-edge/domains
2. Click "Add Domain"
3. Chọn domain:
   - **ngrok-free.app** (miễn phí với paid plan)
   - **Custom domain** (nếu có)
4. Đặt tên (vd: `my-openwebui.ngrok-free.app`)

### Bước 3: Config ngrok với domain
Tạo file config: `~/.ngrok2/ngrok.yml`
```yaml
version: "2"
authtoken: YOUR_TOKEN
tunnels:
  openwebui:
    proto: http
    addr: 7860
    domain: my-openwebui.ngrok-free.app
```

### Bước 4: Chạy ngrok
```bash
ngrok start openwebui
```

Hoặc update script:
```bash
# Sửa script ngrok-auto-start.sh
# Thay: ngrok http 7860
# Bằng: ngrok start openwebui
```

---

## 🆓 CÁCH 3: FREE - DÙNG SCRIPT TỰ ĐỘNG LẤY LINK (Không tốn tiền)

### Script tự động lấy và gửi link qua email/telegram:
Em có thể tạo script tự động:
1. Lấy link mới mỗi khi ngrok restart
2. Gửi link qua email hoặc Telegram
3. Hoặc lưu vào file và anh check file đó

### Ví dụ script:
```bash
#!/bin/bash
# Tự động lấy link và gửi thông báo
LINK=$(curl -s http://localhost:4040/api/tunnels | python3 -c "...")
echo "$LINK" > ngrok-link.txt

# Gửi email (nếu có SMTP)
# hoặc gửi Telegram (nếu có bot)
```

---

## 🎯 KHUYẾN NGHỊ

### Nếu anh chỉ dùng cá nhân:
- ✅ **Dùng FREE plan** - Đủ dùng
- ✅ Link được lưu tự động trong file
- ✅ Chỉ cần check file khi restart

### Nếu anh cần link cố định:
- 💵 **Trả $8/tháng** cho Starter plan
- ✅ Link không bao giờ thay đổi
- ✅ Tiện hơn cho team hoặc production

---

## 📝 SO SÁNH

| Tính năng | Free | Paid ($8/tháng) |
|-----------|------|-----------------|
| Link cố định | ❌ | ✅ |
| Link tạm thời | ✅ | ✅ |
| Giới hạn bandwidth | Có | Nhiều hơn |
| Custom domain | ❌ | ✅ |
| Chi phí | $0 | $8/tháng |

---

## 🚀 CÁCH ĐƠN GIẢN NHẤT (FREE)

### Hiện tại anh đang dùng:
1. ✅ Ngrok đã chạy tự động
2. ✅ Link được lưu trong: `ngrok-link.txt`
3. ✅ Chỉ cần check file khi cần

### Script nhanh để lấy link:
```bash
# Tạo alias để lấy link nhanh
echo 'alias ngrok-link="cat /home/mrkent/openwebui-merged/ngrok-link.txt"' >> ~/.bashrc
source ~/.bashrc

# Sau đó chỉ cần gõ:
ngrok-link
```

---

## 💡 GỢI Ý

### Nếu anh muốn link cố định nhưng không muốn trả phí:
1. **Dùng Dynamic DNS** (miễn phí):
   - No-IP, DuckDNS, v.v.
   - Cần config router port forwarding
   - Link sẽ là: `yourname.ddns.net:7860`

2. **Dùng Cloudflare Tunnel** (miễn phí):
   - cloudflared (tương tự ngrok)
   - Có thể dùng domain riêng
   - Miễn phí hoàn toàn

---

## 🎉 KẾT LUẬN

**Hiện tại (FREE):**
- ✅ Link: `https://9d05824708d4.ngrok-free.app`
- ✅ Được lưu tự động
- ✅ Chỉ thay đổi khi restart ngrok
- ✅ **Không tốn tiền**

**Nếu muốn link cố định:**
- 💵 Trả $8/tháng cho ngrok Starter
- ✅ Link không bao giờ thay đổi
- ✅ Tiện hơn

---

**Anh muốn em setup cách nào? Free hay Paid?**

