# 🔒 HƯỚNG DẪN NGROK CHẠY 24/7

## ✅ ĐÃ SETUP XONG!

### 1. Systemd Service
- ✅ Đã tạo service: `ngrok-openwebui.service`
- ✅ Đã enable (tự động chạy khi boot)
- ✅ Đã start service

### 2. Link Ngrok
- **Link hiện tại**: `https://9d05824708d4.ngrok-free.app`
- **File lưu link**: `/home/mrkent/openwebui-merged/ngrok-link.txt`

---

## 📱 CÁCH SỬ DỤNG

### 1. Lấy Link Ngrok
```bash
cat /home/mrkent/openwebui-merged/ngrok-link.txt
```

### 2. Truy Cập Từ Mobile
1. Mở browser trên mobile
2. Vào link: `https://9d05824708d4.ngrok-free.app`
3. Đăng nhập: `begau1302@gmail.com` / `Baoan2022@`

---

## 🔧 QUẢN LÝ SERVICE

### Xem Status
```bash
sudo systemctl status ngrok-openwebui
```

### Xem Log
```bash
sudo journalctl -u ngrok-openwebui -f
```

### Restart
```bash
sudo systemctl restart ngrok-openwebui
```

### Stop
```bash
sudo systemctl stop ngrok-openwebui
```

### Start
```bash
sudo systemctl start ngrok-openwebui
```

---

## 🔄 TỰ ĐỘNG

Service đã được config:
- ✅ **Tự động chạy khi boot** (enable)
- ✅ **Tự động restart nếu lỗi** (Restart=always)
- ✅ **Tự động restart sau 10 giây** nếu crash

---

## 📝 LƯU Ý

### Link Free Plan:
- ⚠️ Link có thể thay đổi nếu restart service
- ✅ Nếu không restart → Link sẽ ổn định

### Để Link Cố Định:
1. Upgrade lên ngrok paid plan
2. Tạo domain cố định
3. Dùng domain đó

---

## 🎉 KẾT QUẢ

Sau khi setup:
- ✅ Ngrok tự động chạy khi khởi động máy
- ✅ Tự động restart nếu lỗi
- ✅ Link được lưu trong file
- ✅ Có thể truy cập từ mobile 24/7

---

**Anh thử vào link ngrok từ mobile xem nhé!**

