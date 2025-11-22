# HƯỚNG DẪN CẤU HÌNH CHUYÊN SÂU OPEN WEBUI

## 📋 TÓM TẮT CÁC PHẦN ĐÃ CẤU HÌNH

### ✅ 1. CÀI ĐẶT CHUNG (General Settings)
- **Ngôn ngữ**: Đã set thành Tiếng Việt
- **Theme**: Hệ thống (tự động theo OS)
- **Notifications**: Tắt

### ✅ 2. KẾT NỐI (Connections)
- **API OpenAI**: Đã bật, URL: `https://api.openai.com/v1`
- **API Ollama**: Đã bật, URL: `http://host.docker.internal:11434`
- **Kết nối Trực tiếp**: ✅ ĐÃ BẬT (cho phép user thêm API keys của họ)
- **Cache Base Model List**: ✅ ĐÃ BẬT (tăng tốc độ load models)

### ✅ 3. THỰC THI MÃ (Code Execution)
- **Bật Thực thi Mã**: ✅ ĐÃ BẬT
- **Engine**: `pyodide` (có thể chuyển sang `jupyter`)
- **Trình thông dịch Mã**: ✅ ĐÃ BẬT
- **Engine Trình thông dịch**: `pyodide`

---

## 🔧 CÁC PHẦN CẦN CẤU HÌNH THÊM

### 📌 4. MÔ HÌNH (Models)
**Vị trí**: Admin Settings → Mô hình

**Cần làm gì**:
- Thêm các models từ các provider (OpenAI, Anthropic, Google, v.v.)
- Có thể thêm qua "Quản lý Kết nối API OpenAI" hoặc user tự thêm nếu bật "Kết nối Trực tiếp"

**Cách thêm model**:
1. Vào Admin Settings → Kết nối
2. Click "Quản lý Kết nối API OpenAI"
3. Click "Thêm kết nối"
4. Điền:
   - URL: API endpoint (vd: `https://api.openai.com/v1`)
   - API Key: Key của anh
   - Provider Type: Chọn provider (OpenAI, Anthropic, Google, v.v.)
   - Model IDs: Để trống để lấy tất cả, hoặc thêm từng model cụ thể

---

### 📌 5. TÌM KIẾM WEB (Web Search)
**Vị trí**: Admin Settings → Tìm kiếm Web

**Cần làm gì**:
- Bật tính năng tìm kiếm web
- Cấu hình API keys cho các search engines (Google, Bing, DuckDuckGo, v.v.)

**Các search engines có thể dùng**:
- Google Custom Search API
- Bing Search API
- DuckDuckGo (miễn phí, không cần API key)
- Tavily Search API

---

### 📌 6. EXTERNAL TOOLS
**Vị trí**: Admin Settings → External Tools

**Cần làm gì**:
- Thêm các tool servers (MCP servers, OpenAPI servers)
- Cấu hình các integrations như Google Drive, GitHub, v.v.

**Ví dụ**:
- MCP Server: Đã có trong docker-compose.yml (port 3002)
- Google Drive: Cần OAuth credentials
- GitHub: Cần Personal Access Token

---

### 📌 7. TÀI LIỆU (Knowledge Base / RAG)
**Vị trí**: Admin Settings → Tài liệu

**Cần làm gì**:
- Bật tính năng RAG (Retrieval-Augmented Generation)
- Cấu hình vector database (nếu dùng PostgreSQL)
- Cấu hình embedding models

**Lưu ý**: Hiện tại đang dùng SQLite, nếu muốn dùng RAG tốt hơn nên chuyển sang PostgreSQL.

---

### 📌 8. GIAO DIỆN (Interface)
**Vị trí**: Admin Settings → Giao diện

**Có thể config**:
- Custom CSS
- Custom JavaScript
- Logo và branding
- Theme colors
- Layout options

---

### 📌 9. ÂM THANH (Audio)
**Vị trí**: Admin Settings → Âm thanh

**Có thể config**:
- Text-to-Speech (TTS) providers
- Speech-to-Text (STT) providers
- Voice settings

---

### 📌 10. HÌNH ẢNH (Images)
**Vị trí**: Admin Settings → Hình ảnh

**Có thể config**:
- Image generation providers (DALL-E, Stable Diffusion, v.v.)
- Image analysis providers (GPT-4 Vision, Claude Vision, v.v.)

---

## 🎯 CÁC TÍNH NĂNG QUAN TRỌNG CẦN BẬT

### 1. Cho phép Chia sẻ Cộng đồng
- **Vị trí**: Admin Settings → Cài đặt chung → Tính năng
- **Mục đích**: Cho phép user chia sẻ prompts/models với cộng đồng

### 2. Cho phép phản hồi, đánh giá
- **Vị trí**: Admin Settings → Cài đặt chung → Tính năng
- **Mục đích**: User có thể đánh giá responses

### 3. Ghi chú (Notes)
- **Vị trí**: Admin Settings → Cài đặt chung → Tính năng
- **Mục đích**: User có thể tạo notes trong app

### 4. Webhook Người dùng
- **Vị trí**: Admin Settings → Cài đặt chung → Tính năng
- **Mục đích**: Gửi webhooks khi có events (user login, chat created, v.v.)

---

## 📝 HƯỚNG DẪN THÊM API KEYS

### Cách 1: Thêm qua Admin Settings (Khuyến nghị)
1. Vào Admin Settings → Kết nối
2. Click "Quản lý Kết nối API OpenAI"
3. Click "Thêm kết nối"
4. Điền thông tin:
   - **URL**: API endpoint
   - **API Key**: Key của anh
   - **Provider Type**: Chọn provider
   - **Model IDs**: Để trống hoặc thêm cụ thể

### Cách 2: User tự thêm (nếu bật "Kết nối Trực tiếp")
1. User vào Settings → External Tools
2. Click "Thêm kết nối"
3. Điền thông tin tương tự

---

## 🔐 CÁC API KEYS CẦN THIẾT

### 1. OpenAI
- **URL**: `https://api.openai.com/v1`
- **Lấy key**: https://platform.openai.com/api-keys
- **Models**: GPT-4, GPT-3.5, DALL-E, Whisper, v.v.

### 2. Anthropic (Claude)
- **URL**: `https://api.anthropic.com/v1`
- **Lấy key**: https://console.anthropic.com/
- **Models**: Claude 3 Opus, Sonnet, Haiku

### 3. Google (Gemini)
- **URL**: `https://generativelanguage.googleapis.com/v1`
- **Lấy key**: https://makersuite.google.com/app/apikey
- **Models**: Gemini Pro, Gemini Ultra

### 4. MiniMax
- **URL**: `https://api.minimax.chat/v1`
- **Lấy key**: https://www.minimax.chat/
- **Models**: abab5.5, abab6.5

### 5. Tìm kiếm Web
- **Google Custom Search**: https://developers.google.com/custom-search/v1/overview
- **Bing Search**: https://www.microsoft.com/en-us/bing/apis/bing-web-search-api
- **Tavily**: https://tavily.com/

---

## ⚙️ CẤU HÌNH NÂNG CAO

### 1. Chuyển sang PostgreSQL (cho RAG tốt hơn)
1. Vào Admin Settings → Cơ sở dữ liệu
2. Set `DATABASE_URL` trong docker-compose.yml
3. Restart services

### 2. Cấu hình Jupyter cho Code Execution
1. Vào Admin Settings → Thực thi Mã
2. Chọn Engine: `jupyter`
3. Đảm bảo Jupyter service đang chạy (port 8888)

### 3. Cấu hình MCP Server
1. Vào Admin Settings → External Tools
2. Thêm MCP server:
   - URL: `http://mcp-server:3002`
   - Type: OpenAPI hoặc MCP

---

## 🎓 GIẢI THÍCH CÁC THUẬT NGỮ

### Kết nối Trực tiếp (Direct Connection)
- **Là gì**: Cho phép user tự thêm API keys của họ vào app
- **Tại sao cần**: Mỗi user có thể dùng API keys riêng, không cần admin quản lý
- **Cách dùng**: User vào Settings → External Tools → Thêm kết nối

### Cache Base Model List
- **Là gì**: Lưu danh sách models vào cache để load nhanh hơn
- **Tại sao cần**: Giảm thời gian load khi mở app
- **Lưu ý**: Có thể không thấy models mới ngay, cần refresh cache

### Engine Thực thi Mã
- **pyodide**: Chạy Python trong browser (không cần server)
- **jupyter**: Chạy code trên Jupyter server (mạnh hơn, cần server)

### RAG (Retrieval-Augmented Generation)
- **Là gì**: AI có thể đọc và tìm kiếm trong tài liệu của anh
- **Tại sao cần**: AI trả lời chính xác hơn dựa trên tài liệu của anh
- **Cách dùng**: Upload files, AI sẽ tự động index và search

---

## 📞 HỖ TRỢ

Nếu anh cần hỗ trợ thêm về:
- Cách thêm API keys cụ thể
- Cấu hình các tính năng nâng cao
- Troubleshooting

Hãy cho em biết, em sẽ giúp anh config từng phần một!

---

**Lưu ý**: File này được tạo tự động sau khi em đã config một số phần cơ bản. Anh có thể tham khảo và config thêm các phần khác theo nhu cầu.

