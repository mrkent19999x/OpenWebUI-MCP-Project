# 📱 TRUY CẬP TỪ MOBILE BÊN NGOÀI WiFi

## ⚠️ VẤN ĐỀ

Link hiện tại: `http://192.168.1.176:7860`
- Đây là **IP LOCAL** (192.168.x.x)
- Chỉ truy cập được trong **cùng mạng WiFi**
- **KHÔNG** truy cập được từ mobile bên ngoài WiFi

---

## ✅ GIẢI PHÁP

### CÁCH 1: PORT FORWARDING (Router) - TỐT NHẤT

#### Bước 1: Lấy IP Public
```bash
curl ifconfig.me
# Hoặc vào: https://whatismyipaddress.com
```

#### Bước 2: Cấu hình Router
1. Đăng nhập router (thường: `192.168.1.1` hoặc `192.168.0.1`)
2. Vào **Port Forwarding** hoặc **Virtual Server**
3. Thêm rule:
   - **External Port**: 7860 (hoặc port khác)
   - **Internal IP**: 192.168.1.176
   - **Internal Port**: 7860
   - **Protocol**: TCP
4. Lưu và khởi động lại router

#### Bước 3: Truy cập từ mobile
```
http://[IP_PUBLIC]:7860
```
Ví dụ: `http://123.45.67.89:7860`

**⚠️ LƯU Ý:**
- Cần mở firewall trên PC (port 7860)
- Có thể cần cấu hình firewall router
- IP public có thể thay đổi (dùng Dynamic DNS nếu cần)

---

### CÁCH 2: NGROK (Dễ nhất - Không cần cấu hình router)

#### Bước 1: Cài ngrok
```bash
# Trên PC
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
sudo apt update && sudo apt install ngrok
```

#### Bước 2: Đăng ký ngrok (free)
1. Vào: https://dashboard.ngrok.com/signup
2. Lấy **authtoken**

#### Bước 3: Chạy ngrok
```bash
ngrok config add-authtoken [YOUR_TOKEN]
ngrok http 7860
```

#### Bước 4: Truy cập từ mobile
- Ngrok sẽ cho link: `https://xxxx-xxxx-xxxx.ngrok-free.app`
- Truy cập link này từ mobile (bất kỳ đâu)

**✅ Ưu điểm:**
- Dễ setup
- Không cần cấu hình router
- Có HTTPS tự động
- Free (có giới hạn)

**⚠️ Nhược điểm:**
- Link thay đổi mỗi lần chạy (trừ khi dùng paid plan)
- Có giới hạn bandwidth (free)

---

### CÁCH 3: TAILSCALE (VPN - An toàn nhất)

#### Bước 1: Cài Tailscale trên PC
```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

#### Bước 2: Cài Tailscale trên mobile
- iOS: App Store → Tailscale
- Android: Play Store → Tailscale
- Đăng nhập cùng tài khoản

#### Bước 3: Truy cập từ mobile
```
http://[PC_TAILSCALE_IP]:7860
```

**✅ Ưu điểm:**
- An toàn (VPN)
- IP cố định
- Free cho personal use
- Dễ setup

---

### CÁCH 4: DYNAMIC DNS (Nếu IP public thay đổi)

1. Đăng ký Dynamic DNS (ví dụ: No-IP, DuckDNS)
2. Cấu hình router để update DNS tự động
3. Truy cập: `http://your-domain.ddns.net:7860`

---

## 🔒 BẢO MẬT

**QUAN TRỌNG:** Khi mở port ra ngoài, cần:

1. **Bật authentication:**
   - Trong Open WebUI: Settings → Authentication → Enable
   - Tạo user/password mạnh

2. **HTTPS (khuyến nghị):**
   - Dùng nginx reverse proxy với SSL
   - Hoặc dùng ngrok (có HTTPS sẵn)

3. **Firewall:**
   - Chỉ mở port cần thiết (7860)
   - Cấu hình firewall router

---

## 📊 SO SÁNH

| Cách | Độ khó | Bảo mật | Chi phí | Tốc độ |
|------|--------|---------|---------|--------|
| Port Forwarding | Trung bình | ⚠️ | Free | ✅✅✅ |
| Ngrok | Dễ | ⚠️ | Free (có giới hạn) | ✅✅ |
| Tailscale | Dễ | ✅✅✅ | Free | ✅✅ |
| Dynamic DNS | Khó | ⚠️ | Free | ✅✅✅ |

---

## 🚀 KHUYẾN NGHỊ

**Cho anh (không biết code):**
1. **Ngrok** - Dễ nhất, setup nhanh
2. **Tailscale** - An toàn hơn, IP cố định
3. **Port Forwarding** - Tốt nhất nhưng cần cấu hình router

---

**Tạo bởi**: Cipher  
**Ngày**: 2025-11-19

