# 🔗 HƯỚNG DẪN WEBHOOK - OPEN WEBUI

## 🎯 WEBHOOK LÀ GÌ?

**Webhook** giống như một "địa chỉ nhận tin nhắn" - khi có sự kiện xảy ra (ví dụ: có tin nhắn mới, có file upload), Open WebUI sẽ gửi thông tin đến webhook URL của anh.

**Ví dụ đơn giản:**
- Anh có webhook URL: `https://example.com/webhook`
- Khi có tin nhắn mới → Open WebUI gửi thông tin đến URL đó
- Server của anh nhận được thông tin → Làm gì đó (gửi email, lưu database, v.v.)

---

## 🔗 WEBHOOK URL CỦA ANH

### 1. **Webhook URL từ Ngrok** (Hiện tại)

**Link ngrok của anh:**
```
https://9d05824708d4.ngrok-free.app
```

**Webhook endpoint:**
```
https://9d05824708d4.ngrok-free.app/api/v1/webhook
```

**Lưu ý:**
- ⚠️ Link này thay đổi mỗi lần chạy ngrok lại
- ✅ Nếu dùng ngrok paid plan → Link cố định
- ✅ Có HTTPS tự động

---

### 2. **Webhook URL từ IP Local** (Trong mạng WiFi)

**Link local:**
```
http://192.168.1.176:7860
```

**Webhook endpoint:**
```
http://192.168.1.176:7860/api/v1/webhook
```

**Lưu ý:**
- ⚠️ Chỉ truy cập được trong cùng mạng WiFi
- ❌ Không truy cập được từ internet

---

### 3. **Webhook URL từ IP Public** (Nếu có port forwarding)

**Link public:**
```
http://[IP_PUBLIC]:7860
```

**Webhook endpoint:**
```
http://[IP_PUBLIC]:7860/api/v1/webhook
```

**Lưu ý:**
- ✅ Truy cập được từ internet
- ⚠️ Cần cấu hình router (port forwarding)
- ⚠️ Cần mở firewall

---

## 📋 CÁC LOẠI WEBHOOK

### 1. **Incoming Webhook** (Nhận thông tin từ Open WebUI)

**Dùng để:**
- Nhận notifications khi có tin nhắn mới
- Nhận thông tin khi có file upload
- Nhận logs, errors
- Tích hợp với Discord, Slack, Telegram

**Cách setup:**
1. Tạo webhook endpoint trên server của anh
2. Config webhook URL trong Open WebUI
3. Open WebUI sẽ gửi POST request đến URL đó

**Ví dụ payload:**
```json
{
  "event": "message.created",
  "data": {
    "message_id": "123",
    "user_id": "user_123",
    "content": "Hello world",
    "timestamp": "2025-01-19T10:00:00Z"
  }
}
```

---

### 2. **Outgoing Webhook** (Gửi thông tin đến Open WebUI)

**Dùng để:**
- Tích hợp với services khác
- Trigger actions từ bên ngoài
- Gửi tin nhắn từ API

**Cách setup:**
1. Gửi POST request đến Open WebUI API
2. Open WebUI xử lý và trả về kết quả

**Ví dụ:**
```bash
curl -X POST https://9d05824708d4.ngrok-free.app/api/v1/chat \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Hello",
    "model": "gpt-4"
  }'
```

---

## 🔧 CÁCH SETUP WEBHOOK

### Bước 1: Thêm webhook config vào docker-compose.yml

Em đã thêm các biến môi trường webhook vào `docker-compose.yml`:

```yaml
# Webhook Configuration
- ENABLE_WEBHOOKS=True
- WEBHOOK_URL=${WEBHOOK_URL:-}
- WEBHOOK_SECRET=${WEBHOOK_SECRET:-}
- WEBHOOK_EVENTS=message.created,file.uploaded,error.occurred
```

### Bước 2: Tạo file .env

Thêm vào file `.env`:

```env
# Webhook Settings
ENABLE_WEBHOOKS=True
WEBHOOK_URL=https://your-webhook-server.com/webhook
WEBHOOK_SECRET=your-secret-key-here
WEBHOOK_EVENTS=message.created,file.uploaded,error.occurred
```

### Bước 3: Restart services

```bash
cd /home/mrkent/openwebui-merged
docker-compose restart
```

---

## 📱 TÍCH HỢP VỚI DISCORD, SLACK, TELEGRAM

### 1. **Discord Webhook**

**Cách lấy Discord webhook URL:**
1. Vào Discord server của anh
2. Settings → Integrations → Webhooks
3. Create Webhook
4. Copy webhook URL (dạng: `https://discord.com/api/webhooks/xxxxx/xxxxx`)

**Config trong .env:**
```env
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/xxxxx/xxxxx
ENABLE_DISCORD_NOTIFICATIONS=True
```

---

### 2. **Slack Webhook**

**Cách lấy Slack webhook URL:**
1. Vào Slack workspace
2. Apps → Incoming Webhooks
3. Add to Slack
4. Chọn channel
5. Copy webhook URL

**Config trong .env:**
```env
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/xxxxx/xxxxx
ENABLE_SLACK_NOTIFICATIONS=True
```

---

### 3. **Telegram Bot Webhook**

**Cách setup:**
1. Tạo bot với @BotFather trên Telegram
2. Lấy bot token
3. Setup webhook cho bot

**Config trong .env:**
```env
TELEGRAM_BOT_TOKEN=xxxxx:xxxxx
TELEGRAM_CHAT_ID=xxxxx
ENABLE_TELEGRAM_NOTIFICATIONS=True
```

---

## 🧪 TEST WEBHOOK

### Test webhook với curl:

```bash
# Test incoming webhook
curl -X POST https://9d05824708d4.ngrok-free.app/api/v1/webhook \
  -H "Content-Type: application/json" \
  -H "X-Webhook-Secret: your-secret-key" \
  -d '{
    "event": "test",
    "data": {
      "message": "Test webhook"
    }
  }'
```

### Test với webhook tester:

1. Vào: https://webhook.site/
2. Copy webhook URL (tự động tạo)
3. Thêm vào `.env`:
   ```env
   WEBHOOK_URL=https://webhook.site/xxxxx-xxxxx-xxxxx
   ```
4. Restart services
5. Xem kết quả trên webhook.site

---

## 📊 CÁC SỰ KIỆN WEBHOOK (Events)

Open WebUI có thể gửi webhook cho các sự kiện:

1. **message.created** - Tin nhắn mới được tạo
2. **message.updated** - Tin nhắn được cập nhật
3. **message.deleted** - Tin nhắn bị xóa
4. **file.uploaded** - File được upload
5. **file.deleted** - File bị xóa
6. **user.created** - User mới được tạo
7. **user.updated** - User được cập nhật
8. **error.occurred** - Có lỗi xảy ra
9. **model.changed** - Model được thay đổi
10. **chat.created** - Chat mới được tạo

**Config events trong .env:**
```env
WEBHOOK_EVENTS=message.created,file.uploaded,error.occurred
```

---

## 🔒 BẢO MẬT WEBHOOK

### 1. **Webhook Secret**

Luôn dùng secret key để verify webhook:

```env
WEBHOOK_SECRET=your-very-secret-key-here-12345
```

**Verify trong code:**
```python
import hmac
import hashlib

def verify_webhook(payload, signature, secret):
    expected_signature = hmac.new(
        secret.encode(),
        payload.encode(),
        hashlib.sha256
    ).hexdigest()
    return hmac.compare_digest(signature, expected_signature)
```

### 2. **HTTPS Only**

- ✅ Luôn dùng HTTPS cho webhook URL
- ❌ Không dùng HTTP (không an toàn)

### 3. **IP Whitelist** (Nếu có thể)

Chỉ cho phép IP của Open WebUI gửi webhook.

---

## 📝 VÍ DỤ WEBHOOK PAYLOAD

### Message Created Event:

```json
{
  "event": "message.created",
  "timestamp": "2025-01-19T10:00:00Z",
  "data": {
    "message_id": "msg_123",
    "chat_id": "chat_456",
    "user_id": "user_789",
    "content": "Hello, how are you?",
    "model": "gpt-4",
    "role": "user"
  }
}
```

### File Uploaded Event:

```json
{
  "event": "file.uploaded",
  "timestamp": "2025-01-19T10:00:00Z",
  "data": {
    "file_id": "file_123",
    "file_name": "document.pdf",
    "file_size": 1024000,
    "file_type": "application/pdf",
    "user_id": "user_789",
    "upload_url": "https://..."
  }
}
```

### Error Occurred Event:

```json
{
  "event": "error.occurred",
  "timestamp": "2025-01-19T10:00:00Z",
  "data": {
    "error_type": "APIError",
    "error_message": "API key invalid",
    "user_id": "user_789",
    "request_id": "req_123"
  }
}
```

---

## 🚀 KHUYẾN NGHỊ

### Cho anh (không biết code):

1. **Nếu chỉ muốn nhận notifications:**
   - Dùng Discord/Slack webhook (dễ nhất)
   - Copy webhook URL → Thêm vào `.env`
   - Restart services → Xong!

2. **Nếu muốn tích hợp với services khác:**
   - Cần có server/webhook endpoint
   - Hoặc dùng services như Zapier, Make.com

3. **Nếu muốn test:**
   - Dùng https://webhook.site/ (miễn phí, dễ test)

---

## 🆘 TROUBLESHOOTING

### Webhook không hoạt động:

1. **Kiểm tra webhook URL:**
   ```bash
   curl -X POST https://your-webhook-url.com/webhook \
     -H "Content-Type: application/json" \
     -d '{"test": "data"}'
   ```

2. **Kiểm tra logs:**
   ```bash
   docker logs open-webui | grep webhook
   ```

3. **Kiểm tra config:**
   ```bash
   docker exec open-webui env | grep WEBHOOK
   ```

### Webhook bị timeout:

- Tăng timeout trong config
- Kiểm tra server webhook có chạy không
- Kiểm tra firewall/network

---

## 📞 CẦN HỖ TRỢ?

Nếu anh gặp khó khăn khi setup webhook, cứ hỏi em nhé!

---

**Tóm lại:**
- 🔗 **Webhook URL của anh (ngrok):** `https://9d05824708d4.ngrok-free.app/api/v1/webhook`
- 🔗 **Webhook URL local:** `http://192.168.1.176:7860/api/v1/webhook`
- 📝 **Cách setup:** Thêm vào `.env` → Restart services
- 🧪 **Test:** Dùng webhook.site hoặc curl

**Tạo bởi**: Cipher  
**Ngày**: 2025-01-19

