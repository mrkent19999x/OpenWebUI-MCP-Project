# 🚀 Hướng Dẫn Tính Năng Mới - OpenWebUI v0.6.36

## 📋 Tổng Quan

File này giải thích tất cả các tính năng mới đã được cấu hình trong repo này, bao gồm các tính năng từ OpenWebUI v0.6.33 đến v0.6.36.

---

## 🔐 1. OAuth 2.1 Enhancements (v0.6.35-v0.6.36)

### Tính năng:
- **Phân tách nhóm OAuth**: Cho phép cấu hình cách phân tách các nhóm từ OAuth provider
- **Phân tách vai trò**: Cấu hình cách phân tách các vai trò (roles)
- **OAuth không cần email**: Cho phép đăng nhập OAuth mà không cần email scope

### Cấu hình:
```bash
OAUTH_GROUPS_SEPARATOR=;          # Dấu phân cách nhóm (mặc định: ;)
OAUTH_ROLES_SEPARATOR=,           # Dấu phân cách vai trò (mặc định: ,)
ENABLE_OAUTH_WITHOUT_EMAIL=False  # Bật OAuth không cần email
ENABLE_STAR_SESSIONS_MIDDLEWARE=True  # Chia sẻ session giữa các instance
```

### Khi nào dùng:
- Khi bạn có nhiều nhóm/vai trò từ OAuth provider (Google, GitHub, etc.)
- Khi muốn chia sẻ session giữa nhiều OpenWebUI instances

---

## 🎨 2. Image Generation System (v0.6.35)

### Tính năng:
- **Gemini 2.5 Flash Image**: Tạo ảnh bằng Google Gemini 2.5 Flash
- **Qwen Image Edit**: Chỉnh sửa ảnh bằng Qwen model
- **AUTOMATIC1111 Integration**: Tích hợp với Stable Diffusion WebUI

### Cấu hình:
```bash
ENABLE_IMAGE_GENERATION=True
GEMINI_API_KEY=your-gemini-api-key
GEMINI_API_BASE_URL=https://generativelanguage.googleapis.com/v1beta
ENABLE_GEMINI_2_5_FLASH_IMAGE=True
ENABLE_QWEN_IMAGE_EDIT=True
AUTOMATIC1111_API_URL=http://localhost:7860  # Nếu dùng local Stable Diffusion
ENABLE_AUTOMATIC1111_JSON_PARAMS=True
```

### Cách lấy API Key:
1. **Gemini API**: Vào [Google AI Studio](https://makersuite.google.com/app/apikey)
2. **AUTOMATIC1111**: Chạy local hoặc dùng dịch vụ cloud

### Khi nào dùng:
- Khi muốn tạo ảnh từ text prompt
- Khi muốn chỉnh sửa ảnh bằng AI
- Khi có Stable Diffusion WebUI đang chạy

---

## 🔊 3. Audio/TTS System (v0.6.35)

### Tính năng:
- **ElevenLabs TTS**: Text-to-Speech chất lượng cao
- **Mistral Voxtral TTS**: TTS model mới từ Mistral (voxtral-small, voxtral-mini)
- **Global Audio Queue**: Hàng đợi audio toàn cục, tránh phát chồng chéo
- **TTS Stop Control**: Điều khiển dừng/phát TTS

### Cấu hình:
```bash
# ElevenLabs
ELEVENLABS_API_BASE_URL=https://api.elevenlabs.io/v1
ELEVENLABS_API_KEY=your-elevenlabs-key

# Mistral Voxtral
MISTRAL_OCR_API_BASE_URL=https://api.mistral.ai/v1
MISTRAL_API_KEY=your-mistral-key
ENABLE_MISTRAL_VOXTRAL_TTS=True
VOXTRAL_MODEL=voxtral-small  # hoặc voxtral-mini

# Audio Queue
ENABLE_GLOBAL_AUDIO_QUEUE=True
ENABLE_TTS_STOP_CONTROL=True
```

### Cách lấy API Key:
1. **ElevenLabs**: Đăng ký tại [elevenlabs.io](https://elevenlabs.io)
2. **Mistral**: Đăng ký tại [mistral.ai](https://mistral.ai)

### Khi nào dùng:
- Khi muốn chatbot đọc text thành giọng nói
- Khi cần TTS cho tiếng Việt (Voxtral hỗ trợ tốt)
- Khi muốn tránh nhiều audio phát cùng lúc

---

## 📄 4. MinerU Document Processing (v0.6.34)

### Tính năng:
- **MinerU Integration**: Xử lý tài liệu PDF, Word, Excel chuyên nghiệp
- **Advanced Parsing**: Phân tích cấu trúc tài liệu phức tạp

### Cấu hình:
```bash
ENABLE_MINERU=False  # Bật thành True nếu muốn dùng
MINERU_API_URL=http://mineru:8000
MINERU_API_KEY=your-mineru-key
```

### Setup MinerU:
1. Deploy MinerU service (có thể dùng Docker)
2. Cập nhật `MINERU_API_URL` trỏ đến service của bạn
3. Đặt `ENABLE_MINERU=True`

### Khi nào dùng:
- Khi cần xử lý tài liệu phức tạp (PDF có bảng, hình ảnh)
- Khi cần extract thông tin từ Word/Excel
- Khi cần phân tích cấu trúc tài liệu

---

## 🌐 5. External Document Loaders (v0.6.35)

### Tính năng:
- **Forward User Info Headers**: Chuyển tiếp thông tin user cho external document loaders
- Cho phép các loader bên ngoài biết user đang request

### Cấu hình:
```bash
ENABLE_FORWARD_USER_INFO_HEADERS=True
```

### Khi nào dùng:
- Khi bạn có custom document loaders
- Khi cần authentication cho external loaders
- Khi muốn track user khi load documents

---

## 📱 6. Progressive Web App (v0.6.33)

### Tính năng:
- **PWA Support**: Cài đặt OpenWebUI như app trên mobile
- **Android Share Target**: Chia sẻ từ Android app khác vào OpenWebUI

### Cấu hình:
```bash
ENABLE_PROGRESSIVE_WEB_APP=True
ENABLE_PWA_ANDROID_SHARE_TARGET=True
```

### Cách dùng:
1. Mở OpenWebUI trên mobile browser
2. Browser sẽ hỏi "Thêm vào màn hình chính"
3. Sau khi thêm, có thể share text/images từ app khác vào OpenWebUI

### Khi nào dùng:
- Khi muốn dùng OpenWebUI như mobile app
- Khi muốn tích hợp với các app Android khác

---

## 📊 Tổng Kết Tính Năng

| Tính Năng | Version | Trạng Thái | Cần API Key |
|-----------|---------|------------|-------------|
| OAuth 2.1 Enhancements | v0.6.36 | ✅ Đã cấu hình | ❌ Không |
| Image Generation | v0.6.35 | ✅ Đã cấu hình | ✅ Gemini/AUTOMATIC1111 |
| Audio/TTS System | v0.6.35 | ✅ Đã cấu hình | ✅ ElevenLabs/Mistral |
| MinerU Processing | v0.6.34 | ✅ Đã cấu hình | ⚠️ Tùy chọn |
| External Loaders | v0.6.35 | ✅ Đã cấu hình | ❌ Không |
| Progressive Web App | v0.6.33 | ✅ Đã cấu hình | ❌ Không |

---

## 🎯 Bước Tiếp Theo

1. **Copy file cấu hình**:
   ```bash
   cp .env.example .env
   ```

2. **Điền API keys** vào file `.env`:
   - Gemini API (cho Image Generation)
   - ElevenLabs API (cho TTS)
   - Mistral API (cho Voxtral TTS)
   - Các API khác nếu cần

3. **Khởi động lại services**:
   ```bash
   ./manage.sh dev restart
   ```

4. **Kiểm tra tính năng**:
   - Vào OpenWebUI UI
   - Test từng tính năng đã bật
   - Xem logs nếu có lỗi

---

## ❓ Câu Hỏi Thường Gặp

### Q: Tính năng nào không cần API key?
A: OAuth enhancements, External Loaders, Progressive Web App

### Q: Tôi có thể bật tất cả tính năng không?
A: Có, nhưng cần điền API keys tương ứng. Một số tính năng có thể tốn phí.

### Q: Làm sao biết tính năng đã hoạt động?
A: Kiểm tra logs: `./manage.sh dev logs open-webui`

### Q: Có thể tắt tính năng không cần không?
A: Có, đặt `ENABLE_XXX=False` trong file `.env`

---

**Chúc anh thành công với các tính năng mới!** 🎉
