# ⚡ CONFIG RAG VÀ PROMPTS NHANH

## ✅ ĐÃ HOÀN THÀNH

### 1. RAG (Knowledge Base)
- ✅ **ENABLE_KNOWLEDGE_BASE=True** (đã có trong docker-compose.yml)
- ✅ **ENABLE_RAG=True** (đã có trong docker-compose.yml)
- ✅ **VECTOR_DB=chroma** (đã có trong docker-compose.yml)
- ✅ **Files prompt-templates.json và system-prompts.json đã được mount**

### 2. Prompts/Tools
- ✅ **Prompt templates đã có sẵn** (10 templates tiếng Việt)
- ✅ **System prompts đã có sẵn** (cho các models)
- ✅ **Container đã được restart** để load prompts

---

## 🚀 CÁCH SỬ DỤNG

### 1. Sử dụng RAG (Knowledge Base)

**Bước 1: Tạo Knowledge Base**
1. Vào app: `http://192.168.1.176:7860`
2. Click vào "Knowledge" hoặc "Knowledge Base" ở sidebar bên trái
3. Click "Create" hoặc "Tạo mới"
4. Đặt tên (vd: "Tài liệu công ty")
5. Upload documents (PDF, DOCX, TXT, MD, v.v.)
6. Đợi AI index (tạo vector embeddings) - mất vài phút

**Bước 2: Sử dụng RAG khi chat**
- Khi chat, AI sẽ tự động tìm kiếm trong knowledge base
- Hoặc nói: "Tìm trong knowledge base về [chủ đề]"
- AI sẽ trả lời dựa trên tài liệu đã upload

### 2. Sử dụng Prompts ở Sidebar

**Prompts sẽ tự động hiển thị:**
1. Vào trang chính
2. Bên phải sidebar sẽ có:
   - **"Gợi ý một số mẫu prompt"** hoặc **"Suggested"**
   - Danh sách các prompt templates:
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

3. Click vào prompt để sử dụng ngay

### 3. Sử dụng Tools

**Tools sẽ tự động hiển thị khi cần:**
- **Code Execution**: Khi AI cần chạy code
- **Browser Automation**: Khi AI cần duyệt web
- **Jupyter**: Khi chọn engine Jupyter
- **MCP Server**: Khi cần dùng MCP tools

---

## 🔧 NẾU KHÔNG THẤY PROMPTS

### Cách 1: Refresh trang
- Nhấn F5 hoặc Ctrl+R
- Prompts sẽ hiện sau khi refresh

### Cách 2: Kiểm tra container
```bash
cd /home/mrkent/openwebui-merged
docker-compose logs open-webui | grep -i prompt
```

### Cách 3: Restart lại container
```bash
cd /home/mrkent/openwebui-merged
docker-compose restart open-webui
```

---

## 📝 LƯU Ý

1. **RAG cần thời gian index**: Sau khi upload documents, đợi vài phút để AI index
2. **Prompts tự động load**: Không cần config thêm, chỉ cần refresh trang
3. **Tools tự động hiện**: Khi AI cần dùng tool, nó sẽ tự động hiện

---

## 🎉 KẾT QUẢ

Sau khi làm theo hướng dẫn:
- ✅ **RAG hoạt động**: AI có thể đọc và tìm kiếm trong tài liệu
- ✅ **Prompts hiển thị**: 10 prompt templates tiếng Việt ở sidebar
- ✅ **Tools sẵn sàng**: Code, Browser, Jupyter, MCP đều hoạt động

---

**Anh thử vào app và kiểm tra xem prompts có hiện ở sidebar chưa nhé!**

