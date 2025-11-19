# 🌐 CHECKLIST TEST BẰNG BROWSER - HOÀN THIỆN TOÀN BỘ

## 🎯 MỤC TIÊU

**Em đã tạo prompts và config xong! Bây giờ anh test bằng browser để đảm bảo tất cả hoạt động!**

---

## ✅ EM ĐÃ LÀM XONG

### 1. **Tạo Prompt Templates** ✅
- ✅ File: `prompt-templates.json`
- ✅ 10 prompt templates:
  - Trợ Lý Tiếng Việt
  - Trợ Lý Lập Trình
  - Trợ Lý Viết Lách
  - Chuyên Gia Phân Tích Dữ Liệu
  - Giáo Viên
  - Cố Vấn Kinh Doanh
  - Phiên Dịch Viên
  - Chuyên Gia Debug
  - Quản Lý Dự Án
  - Nhà Văn Sáng Tạo

### 2. **Tạo System Prompts** ✅
- ✅ File: `system-prompts.json`
- ✅ 8 system prompts:
  - Mặc định
  - Tiếng Việt
  - Lập Trình
  - Viết Lách
  - Phân Tích
  - Giáo Viên
  - Kinh Doanh
  - Sáng Tạo

### 3. **Mount vào Docker** ✅
- ✅ Đã mount `prompt-templates.json` vào container
- ✅ Đã mount `system-prompts.json` vào container
- ✅ Đã restart Open WebUI

### 4. **Config đã enable:**
- ✅ `ENABLE_PROMPT_TEMPLATES=True`
- ✅ `ENABLE_PROMPT_SUGGESTIONS=True`

---

## 🌐 CHECKLIST TEST BẰNG BROWSER

### BƯỚC 1: Mở Web UI

**URL:** http://192.168.1.176:7860

**Kiểm tra:**
- [ ] Web UI mở được
- [ ] Giao diện hiển thị bình thường
- [ ] Không có lỗi trong console (F12)

### BƯỚC 2: Test Models & API Keys

**Vào:** Settings → Connections (hoặc API Keys)

**Thêm API keys:**
- [ ] Google Gemini API Key
- [ ] MiniMax API Key
- [ ] Claude (Anthropic) API Key (nếu có)
- [ ] HuggingFace API Key (nếu có)

**Vào:** Settings → Models

**Kiểm tra:**
- [ ] Có models hiển thị sau khi thêm API keys
- [ ] Chọn được model
- [ ] Model hiển thị đúng tên

### BƯỚC 3: Test Prompts & Templates

**Vào:** Settings → Prompts (hoặc Templates)

**Kiểm tra:**
- [ ] Có prompt templates hiển thị
- [ ] Có thể chọn prompt template
- [ ] Prompt template áp dụng đúng khi chat

**Test prompt templates:**
- [ ] Chọn "Trợ Lý Tiếng Việt" → Chat thử → Kiểm tra trả lời bằng tiếng Việt
- [ ] Chọn "Trợ Lý Lập Trình" → Chat "Viết code Python..." → Kiểm tra code có comment
- [ ] Chọn "Trợ Lý Viết Lách" → Chat "Viết bài về..." → Kiểm tra nội dung hay

**Vào:** Settings → System Prompts

**Kiểm tra:**
- [ ] Có system prompts hiển thị
- [ ] Có thể chọn system prompt
- [ ] System prompt áp dụng đúng

### BƯỚC 4: Test Chat Features

**Test Chat cơ bản:**
- [ ] Tạo chat mới
- [ ] Chat với model
- [ ] Xem response streaming (từng từ hiện ra)
- [ ] Chat history lưu được

**Test Chat nâng cao:**
- [ ] Export chat (Settings → Export)
- [ ] Import chat (Settings → Import)
- [ ] Tạo chat folder
- [ ] Thêm tags cho chat
- [ ] Search chat

### BƯỚC 5: Test File Operations

**Test File Upload:**
- [ ] Click icon 📁 (Upload)
- [ ] Chọn file test (PDF, TXT, DOC...)
- [ ] Upload thành công
- [ ] File hiển thị trong uploads

**Test File Preview:**
- [ ] Click vào file đã upload
- [ ] File preview hiển thị đúng
- [ ] Có thể download file

**Test File Delete:**
- [ ] Xóa file test
- [ ] File đã xóa khỏi uploads

### BƯỚC 6: Test Code Execution

**Test tạo code:**
- [ ] Chat "Tạo file Python test.py với code tính tổng 2 số"
- [ ] Code preview hiển thị trong chat
- [ ] Click "Create" hoặc "Approve"
- [ ] File được tạo thành công

**Test chạy code:**
- [ ] Chat "Chạy code Python: print('Hello World')"
- [ ] Code được chạy
- [ ] Kết quả hiển thị trong chat (không hiện terminal)

### BƯỚC 7: Test Web Browser & Search

**Test Web Search:**
- [ ] Chat "Tìm kiếm web về Python"
- [ ] Web search hoạt động
- [ ] Kết quả search hiển thị

**Test Web Browser:**
- [ ] Chat "Mở trang web https://www.python.org"
- [ ] Browser automation hoạt động
- [ ] Nội dung trang web hiển thị

### BƯỚC 8: Test Knowledge Base

**Tạo Knowledge Base:**
- [ ] Vào Knowledge Base
- [ ] Click "Create" hoặc "New"
- [ ] Đặt tên knowledge base
- [ ] Upload documents (PDF, TXT, DOC...)
- [ ] Documents được xử lý

**Test RAG Search:**
- [ ] Chat "Tìm trong knowledge base về..."
- [ ] RAG search hoạt động
- [ ] Kết quả từ knowledge base hiển thị

### BƯỚC 9: Test MCP Tools

**Enable MCP:**
- [ ] Vào Settings → Tools → MCP
- [ ] Enable MCP Tools
- [ ] MCP Server kết nối được

**Test MCP Tools:**
- [ ] Chat "List GitHub repositories"
- [ ] GitHub tool hoạt động
- [ ] Kết quả hiển thị

### BƯỚC 10: Test Agents

**Test Agents:**
- [ ] Chat "Tìm thông tin về Python và tạo file demo"
- [ ] Agent tự động làm nhiều bước:
  - [ ] Step 1: Search web
  - [ ] Step 2: Generate code
  - [ ] Step 3: Create file
- [ ] Agent hoàn thành task

### BƯỚC 11: Test UI/UX

**Test Theme:**
- [ ] Vào Settings → Theme
- [ ] Chuyển Dark mode
- [ ] Chuyển Light mode
- [ ] Theme áp dụng đúng

**Test Language:**
- [ ] Vào Settings → Language
- [ ] Chọn Vietnamese
- [ ] UI hiển thị tiếng Việt

**Test Hide Terminal:**
- [ ] Chat "Chạy code..."
- [ ] Terminal KHÔNG hiển thị (bị ẩn)
- [ ] Chỉ hiện code preview trong chat

**Test Custom Theme:**
- [ ] Custom theme CSS đã áp dụng
- [ ] UI đẹp hơn, giống Manus AI

### BƯỚC 12: Test Admin Settings

**Vào:** Settings → Admin (nếu có quyền admin)

**Kiểm tra:**
- [ ] Admin panel mở được
- [ ] User management hoạt động
- [ ] Model management hoạt động
- [ ] System settings hoạt động

---

## 📋 TÓM TẮT CHECKLIST

### Core Features:
- [ ] Models & API Keys
- [ ] Prompts & Templates
- [ ] Chat
- [ ] File Upload
- [ ] Code Execution

### Advanced Features:
- [ ] Web Browser & Search
- [ ] Knowledge Base & RAG
- [ ] MCP Tools
- [ ] Agents

### UI/UX:
- [ ] Theme (Dark/Light)
- [ ] Language (Vietnamese)
- [ ] Hide Terminal
- [ ] Custom Theme

---

## ✅ SAU KHI TEST XONG

**Nếu tất cả đều OK:**
- ✅ Hoàn thiện 100%!
- ✅ Sẵn sàng sử dụng!

**Nếu có lỗi:**
- ⚠️ Ghi lại lỗi
- ⚠️ Em sẽ fix ngay!

---

## 🎯 KẾT QUẢ MONG ĐỢI

**Sau khi test xong, anh sẽ có:**
- ✅ 10 prompt templates sẵn sàng
- [ ] 8 system prompts sẵn sàng
- ✅ Tất cả chức năng hoạt động
- ✅ UI đẹp, giống Manus AI
- ✅ Terminal ẩn, chỉ hiện chat

---

**Anh test bằng browser và báo lại kết quả nhé!** 🌐

