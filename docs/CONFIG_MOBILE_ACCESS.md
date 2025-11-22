# 📱 CONFIG TRUY CẬP TỪ MOBILE (KHÔNG CÙNG MẠNG LAN)

## ✅ TÌNH TRẠNG HIỆN TẠI

- ✅ **Server đã chạy**: `http://192.168.1.176:7860` (chỉ truy cập được trong mạng LAN)
- ⚠️ **Mobile không cùng mạng LAN**: Cần config để truy cập từ bên ngoài

---

## 🚀 CÁCH 1: DÙNG NGROK (Dễ nhất - Khuyến nghị)

### Bước 1: Cài ngrok (nếu chưa có)
```bash
cd /home/mrkent/openwebui-merged
./scripts/setup-ngrok.sh
```

Hoặc cài thủ công:
```bash
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
sudo apt update && sudo apt install -y ngrok
```

### Bước 2: Lấy Authtoken từ ngrok
1. Vào: https://dashboard.ngrok.com/signup (đăng ký free)
2. Vào: https://dashboard.ngrok.com/get-started/your-authtoken
3. Copy authtoken (dạng: `ngrok_xxxxx...`)

### Bước 3: Setup và chạy ngrok
```bash
cd /home/mrkent/openwebui-merged

# Setup authtoken
ngrok config add-authtoken [YOUR_TOKEN]

# Chạy ngrok
./scripts/start-ngrok-simple.sh
```

Hoặc chạy thủ công:
```bash
# Dừng ngrok cũ (nếu có)
pkill ngrok

# Chạy ngrok ở background
nohup ngrok http 7860 --log=stdout > /tmp/ngrok.log 2>&1 &

# Đợi 5 giây
sleep 5

# Lấy link ngrok
curl -s http://localhost:4040/api/tunnels | python3 -c "import sys, json; data = json.load(sys.stdin); tunnels = data.get('tunnels', []); [print(t['public_url']) for t in tunnels if 'https' in t['public_url']]" | head -1
```

### Bước 4: Lấy link ngrok
Link sẽ có dạng: `https://xxxx-xxxx-xxxx.ngrok-free.app`

**Lưu ý:**
- ⚠️ Link free sẽ thay đổi mỗi lần chạy ngrok lại
- ✅ Nếu dùng ngrok paid plan → Link cố định
- ✅ Link được lưu trong file: `ngrok-link.txt`

### Bước 5: Truy cập từ mobile
1. Mở browser trên mobile
2. Vào link ngrok: `https://xxxx-xxxx-xxxx.ngrok-free.app`
3. Đăng nhập như bình thường

---

## 🌐 CÁCH 2: DÙNG PUBLIC IP (Nếu có router access)

### Bước 1: Lấy IP Public
```bash
curl ifconfig.me
```

### Bước 2: Config Port Forwarding trên Router
1. Vào router admin (thường là `192.168.1.1`)
2. Tìm "Port Forwarding" hoặc "Virtual Server"
3. Thêm rule:
   - **External Port**: 7860
   - **Internal IP**: 192.168.1.176
   - **Internal Port**: 7860
   - **Protocol**: TCP

### Bước 3: Truy cập từ mobile
- URL: `http://[IP_PUBLIC]:7860`
- Ví dụ: `http://123.45.67.89:7860`

**Lưu ý:**
- ⚠️ IP public có thể thay đổi (dùng Dynamic DNS nếu cần)
- ⚠️ Cần mở firewall trên server

---

## ⚙️ CÁCH 3: CONFIG DOCKER-COMPOSE ĐỂ HỖ TRỢ MOBILE

### Cập nhật WEBUI_URL trong docker-compose.yml

Nếu dùng ngrok:
```yaml
- WEBUI_URL=${WEBUI_URL:-https://xxxx-xxxx-xxxx.ngrok-free.app}
```

Nếu dùng public IP:
```yaml
- WEBUI_URL=${WEBUI_URL:-http://[IP_PUBLIC]:7860}
```

Sau đó restart:
```bash
docker-compose restart open-webui
```

---

## 🔧 SCRIPT TỰ ĐỘNG CHẠY NGROK

Em đã tạo script tự động:

### Script 1: Setup ngrok lần đầu
```bash
cd /home/mrkent/openwebui-merged
./scripts/setup-ngrok.sh
```

### Script 2: Chạy ngrok (sau khi đã setup)
```bash
cd /home/mrkent/openwebui-merged
./scripts/start-ngrok-simple.sh
```

### Script 3: Quick setup (paste token và chạy luôn)
```bash
cd /home/mrkent/openwebui-merged
./scripts/quick-ngrok.sh
```

---

## 📝 KIỂM TRA

### Kiểm tra ngrok đang chạy:
```bash
pgrep ngrok && echo "✅ Ngrok đang chạy" || echo "❌ Ngrok chưa chạy"
```

### Xem link ngrok:
```bash
curl -s http://localhost:4040/api/tunnels | python3 -c "import sys, json; data = json.load(sys.stdin); tunnels = data.get('tunnels', []); [print(t['public_url']) for t in tunnels if 'https' in t['public_url']]"
```

Hoặc xem file:
```bash
cat /home/mrkent/openwebui-merged/ngrok-link.txt
```

### Xem log ngrok:
```bash
tail -f /tmp/ngrok.log
```

---

## 🎯 KHUYẾN NGHỊ

**Dùng ngrok** vì:
- ✅ Dễ setup, không cần config router
- ✅ Có HTTPS sẵn (bảo mật hơn)
- ✅ Free plan đủ dùng cho cá nhân
- ✅ Không cần IP public cố định

**Lưu ý:**
- ⚠️ Link free thay đổi mỗi lần chạy lại
- ⚠️ Có giới hạn bandwidth (free plan)
- ✅ Có thể upgrade lên paid plan để có link cố định

---

## 🚀 CÁC BƯỚC NHANH

1. **Cài ngrok** (nếu chưa có):
   ```bash
   cd /home/mrkent/openwebui-merged
   ./scripts/setup-ngrok.sh
   ```

2. **Lấy authtoken** từ: https://dashboard.ngrok.com/get-started/your-authtoken

3. **Chạy ngrok**:
   ```bash
   ngrok config add-authtoken [YOUR_TOKEN]
   ./scripts/start-ngrok-simple.sh
   ```

4. **Lấy link** từ file `ngrok-link.txt` hoặc dashboard: http://localhost:4040

5. **Truy cập từ mobile** bằng link ngrok

---

**Anh muốn em setup ngrok luôn không? Hoặc anh muốn dùng cách nào?**

