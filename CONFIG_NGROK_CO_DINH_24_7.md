# 🔒 CONFIG NGROK CỐ ĐỊNH - CHẠY 24/7

## ✅ ĐÃ HOÀN THÀNH

### 1. Link Ngrok Hiện Tại
- **Link**: `https://9d05824708d4.ngrok-free.app`
- **Đã lưu**: `ngrok-link.txt`

### 2. Scripts Đã Tạo
- ✅ `scripts/ngrok-auto-start.sh` - Script tự động chạy ngrok
- ✅ `scripts/setup-ngrok-systemd.sh` - Setup ngrok chạy tự động khi boot

---

## 🚀 CÁCH 1: SETUP TỰ ĐỘNG CHẠY KHI KHỞI ĐỘNG (KHUYẾN NGHỊ)

### Bước 1: Chạy script setup
```bash
cd /home/mrkent/openwebui-merged
sudo ./scripts/setup-ngrok-systemd.sh
```

Script sẽ:
- ✅ Tạo systemd service
- ✅ Enable service (tự động chạy khi boot)
- ✅ Start service ngay
- ✅ Ngrok sẽ tự động chạy mỗi khi khởi động máy

### Bước 2: Kiểm tra
```bash
# Xem status
sudo systemctl status ngrok-openwebui

# Xem log
sudo journalctl -u ngrok-openwebui -f
```

### Bước 3: Lấy link
```bash
cat /home/mrkent/openwebui-merged/ngrok-link.txt
```

---

## 🔧 CÁCH 2: CHẠY THỦ CÔNG (Nếu không muốn dùng systemd)

### Chạy script tự động:
```bash
cd /home/mrkent/openwebui-merged
./scripts/ngrok-auto-start.sh
```

### Thêm vào crontab để tự động chạy:
```bash
crontab -e
```

Thêm dòng:
```bash
@reboot /home/mrkent/openwebui-merged/scripts/ngrok-auto-start.sh
```

---

## 🔒 CÁCH 3: LINK CỐ ĐỊNH (Ngrok Paid Plan)

### Nếu anh có ngrok paid plan:
1. Vào: https://dashboard.ngrok.com/cloud-edge/domains
2. Tạo domain cố định (vd: `my-openwebui.ngrok-free.app`)
3. Chạy ngrok với domain:
   ```bash
   ngrok http 7860 --domain=my-openwebui.ngrok-free.app
   ```

### Hoặc dùng config file:
Tạo file `~/.ngrok2/ngrok.yml`:
```yaml
version: "2"
authtoken: YOUR_TOKEN
tunnels:
  openwebui:
    proto: http
    addr: 7860
    domain: my-openwebui.ngrok-free.app
```

Chạy:
```bash
ngrok start openwebui
```

---

## 📱 QUẢN LÝ NGROK

### Xem status:
```bash
sudo systemctl status ngrok-openwebui
```

### Xem log:
```bash
sudo journalctl -u ngrok-openwebui -f
```

### Restart:
```bash
sudo systemctl restart ngrok-openwebui
```

### Stop:
```bash
sudo systemctl stop ngrok-openwebui
```

### Start:
```bash
sudo systemctl start ngrok-openwebui
```

### Disable (tắt tự động chạy):
```bash
sudo systemctl disable ngrok-openwebui
```

---

## 🔄 TỰ ĐỘNG RESTART NGROK (Nếu bị lỗi)

Service đã được config `Restart=always`, nên:
- ✅ Tự động restart nếu ngrok bị crash
- ✅ Tự động restart sau 10 giây nếu lỗi
- ✅ Tự động chạy lại khi máy khởi động

---

## 📝 LƯU Ý

### Link Free Plan:
- ⚠️ Link thay đổi mỗi lần chạy lại ngrok
- ✅ Nếu dùng systemd service → Link sẽ ổn định (chỉ thay đổi khi restart service)

### Link Paid Plan:
- ✅ Link cố định hoàn toàn
- ✅ Không thay đổi dù restart bao nhiêu lần

### Cách lấy link mới:
```bash
# Tự động lấy và lưu vào file
cat /home/mrkent/openwebui-merged/ngrok-link.txt

# Hoặc xem dashboard
# http://localhost:4040
```

---

## 🎯 KHUYẾN NGHỊ

**Dùng systemd service** vì:
- ✅ Tự động chạy khi boot
- ✅ Tự động restart nếu lỗi
- ✅ Dễ quản lý (start/stop/restart)
- ✅ Log đầy đủ

**Chạy ngay:**
```bash
cd /home/mrkent/openwebui-merged
sudo ./scripts/setup-ngrok-systemd.sh
```

---

## 🎉 KẾT QUẢ

Sau khi setup:
- ✅ Ngrok tự động chạy khi khởi động máy
- ✅ Tự động restart nếu lỗi
- ✅ Link được lưu trong `ngrok-link.txt`
- ✅ Có thể truy cập từ mobile 24/7

---

**Anh chạy script setup để ngrok tự động chạy 24/7 nhé!**

