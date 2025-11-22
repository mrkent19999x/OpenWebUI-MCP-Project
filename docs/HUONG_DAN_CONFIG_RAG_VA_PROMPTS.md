# 📚 HƯỚNG DẪN CONFIG RAG VÀ PROMPTS/TOOLS

## 🎯 MỤC TIÊU
1. Config RAG (Knowledge Base) - để AI đọc và tìm kiếm trong tài liệu
2. Config Prompts/Tools ở sidebar bên phải khi vào app

---

## ✅ PHẦN 1: CONFIG RAG (KNOWLEDGE BASE)

### Bước 1: Vào Admin Settings → Tài liệu
1. Đăng nhập vào app: `http://192.168.1.176:7860`
2. Click avatar (góc trên bên phải) → "Admin Panel"
3. Click tab "Tài liệu" (Knowledge)

### Bước 2: Kiểm tra RAG đã được bật
- ✅ **ENABLE_KNOWLEDGE_BASE=True** (đã có trong docker-compose.yml)
- ✅ **ENABLE_RAG=True** (đã có trong docker-compose.yml)
- ✅ **VECTOR_DB=chroma** (đã có trong docker-compose.yml)

### Bước 3: Tạo Knowledge Base
1. Vào trang chính (không phải admin)
2. Click vào "Knowledge" hoặc "Knowledge Base" ở sidebar
3. Click "Create" hoặc "Tạo mới"
4. Đặt tên knowledge base (vd: "Tài liệu công ty")
5. Upload documents (PDF, DOCX, TXT, MD, v.v.)
6. Đợi AI index documents (tạo vector embeddings)

### Bước 4: Sử dụng RAG
- Khi chat, AI sẽ tự động tìm kiếm trong knowledge base
- Hoặc có thể nói: "Tìm trong knowledge base về..."
- AI sẽ trả lời dựa trên tài liệu đã upload

---

## ✅ PHẦN 2: CONFIG PROMPTS/TOOLS Ở SIDEBAR

### Bước 1: Kiểm tra Prompt Templates đã có
File `prompt-templates.json` đã được mount vào container:
- ✅ Đã có 10 prompt templates (Trợ Lý Tiếng Việt, Lập Trình, Viết Lách, v.v.)
- ✅ Đã có system prompts cho các models

### Bước 2: Đảm bảo file được load
1. Restart container để load prompt templates:
```bash
cd /home/mrkent/openwebui-merged
docker-compose restart open-webui
```

2. Kiểm tra file đã được mount:
```bash
docker-compose exec open-webui ls -la /app/backend/data/prompt-templates.json
docker-compose exec open-webui ls -la /app/backend/data/system-prompts.json
```

### Bước 3: Config trong UI để hiển thị Prompts
1. Vào Admin Settings → Giao diện (Interface)
2. Tìm phần "Prompt Templates" hoặc "Suggested Prompts"
3. Đảm bảo "Show Prompt Templates" được bật
4. Đảm bảo "Show Suggested Prompts" được bật

### Bước 4: Config Tools ở Sidebar
1. Vào Admin Settings → External Tools
2. Đảm bảo các tools đã được thêm:
   - MCP Server (nếu có)
   - Code Executor
   - Browser Automation
   - Jupyter

3. Tools sẽ tự động hiển thị ở sidebar khi được enable

---

## 🔧 CÁCH KIỂM TRA

### 1. Kiểm tra RAG hoạt động:
1. Tạo knowledge base
2. Upload 1 file PDF hoặc TXT
3. Đợi index xong
4. Chat: "Tìm trong knowledge base về [nội dung trong file]"
5. AI sẽ trả lời dựa trên file

### 2. Kiểm tra Prompts hiển thị:
1. Vào trang chính
2. Bên phải sidebar sẽ có:
   - "Suggested Prompts" hoặc "Gợi ý"
   - Danh sách các prompt templates
   - Tools (Code, Browser, v.v.)

---

## 📝 LƯU Ý

### RAG:
- ✅ Đã được enable trong docker-compose.yml
- ✅ Vector DB: Chroma (mặc định, không cần config thêm)
- ⚠️ Nếu muốn dùng PostgreSQL cho RAG tốt hơn, cần config DATABASE_URL

### Prompts:
- ✅ File prompt-templates.json đã có sẵn
- ✅ File system-prompts.json đã có sẵn
- ✅ Đã được mount vào container
- ⚠️ Cần restart container để load prompts mới

### Tools:
- ✅ Code Executor: Đã có (port 3001)
- ✅ Browser Automation: Đã có (port 4444)
- ✅ Jupyter: Đã có (port 8888)
- ✅ MCP Server: Đã có (port 3002)

---

## 🚀 CÁC BƯỚC NHANH

### Config RAG:
1. Vào app → Knowledge Base → Create
2. Upload documents
3. Đợi index
4. Dùng thôi!

### Config Prompts:
1. Restart container: `docker-compose restart open-webui`
2. Refresh trang
3. Prompts sẽ hiện ở sidebar

### Config Tools:
1. Tools đã được enable trong docker-compose.yml
2. Tự động hiển thị ở sidebar khi dùng

---

## 🎉 KẾT QUẢ

Sau khi config xong:
- ✅ RAG hoạt động: AI có thể đọc và tìm kiếm trong tài liệu
- ✅ Prompts hiển thị ở sidebar: User có thể chọn prompt nhanh
- ✅ Tools hiển thị: User có thể dùng Code, Browser, v.v.

---

**Nếu có vấn đề, hãy cho em biết!**

