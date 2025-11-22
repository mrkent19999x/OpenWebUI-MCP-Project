# 🚀 Fix Ngay: Lọc Model Tự Động

## ❌ Vấn đề bạn đang gặp
```
Khi click vào model dropdown:
- Có 100+ model hiện ra
- 80% model không hoạt động  
- Phải test từng model mất thời gian
- Có model cần API key, có model không
```

## ✅ Giải pháp trong 3 bước

### Bước 1: Chạy script lọc model (30 giây)
```bash
chmod +x model-filter.sh apply-model-filter.sh
./model-filter.sh --full
```

### Bước 2: Áp dụng cấu hình lọc (30 giây)  
```bash
./apply-model-filter.sh --config-only
```

### Bước 3: Khởi động hệ thống (2 phút)
```bash
docker-compose up -d
```

## 🎯 Kết quả ngay lập tức

**Trước khi fix:**
- ❌ 100+ model rối rắm
- ❌ Không biết model nào hoạt động
- ❌ Test từng model mất thời gian

**Sau khi fix:**
- ✅ Chỉ 5-8 model đã được lọc
- ✅ Mỗi model có ghi chú rõ ràng
- ✅ Phân loại: Local (free) vs Cloud (API)
- ✅ Có tốc độ và độ ổn định

## 🔍 Model nào sẽ hiện sau khi lọc

### Local AI (Miễn phí - Chạy trên máy)
1. **Llama 3.1** - Nhanh nhất, chat thường
2. **Mistral 7B** - Cân bằng, nhiều task
3. **Code Llama** - Chuyên programming

### Cloud AI (Cần API key - Chất lượng cao)
4. **GPT-4o Mini** - OpenAI, rẻ và nhanh
5. **Claude Haiku** - Anthropic, thông minh

## 🛠️ Tùy chỉnh thêm (Optional)

### Thêm model vào whitelist
```bash
# Edit file: openwebui/data/config/models.json
# Thêm model bạn muốn vào danh sách
```

### Lọc theo category
```javascript
// Chỉ hiển thị model programming
const filteredModels = allModels.filter(m => m.category === "Programming");

// Chỉ hiển thị model miễn phí  
const freeModels = allModels.filter(m => m.requiresKey === false);
```

### Đổi thứ tự ưu tiên
```bash
# Model nào lên đầu
1. llama3.1 (nhanh nhất)
2. mistral:7b (cân bằng)
3. codellama (programming)
```

## 📱 Kiểm tra kết quả

### Mở các UI interface:
- **Open WebUI**: http://localhost:3000
- **LobeChat**: http://localhost:3210  
- **AnythingLLM**: http://localhost:3001

### Test model hoạt động:
```bash
# Kiểm tra Ollama
curl http://localhost:11434/api/tags

# Test model nhanh
echo "Hello" | ollama run llama3.1
```

## 🔧 Troubleshooting

### Nếu không có model nào hiện:
```bash
# Kiểm tra Ollama có chạy không
pgrep ollama

# Khởi động Ollama
ollama serve &

# Pull model cần thiết
ollama pull llama3.1
ollama pull mistral:7b
ollama pull codellama
```

### Nếu model lỗi:
```bash
# Chạy lại filter
./model-filter.sh --test

# Xem log chi tiết
docker-compose logs openwebui
```

### Nếu cần API key:
```bash
# Kiểm tra file .env
cat .env | grep API_KEY

# Thêm API key vào .env
echo "OPENAI_API_KEY=sk-your-key-here" >> .env
```

## ⚡ Quick Commands

```bash
# Lọc và chỉ hiển thị model working
./model-filter.sh --filter

# Test tất cả model
./model-filter.sh --test

# Xem báo cáo chi tiết  
./model-filter.sh --full

# Apply config và start services
./apply-model-filter.sh --start

# Chỉ test không thay đổi gì
./apply-model-filter.sh --test-only
```

## 🎉 Done! 

Sau khi chạy 3 bước trên, bạn sẽ có:

✅ **Clean Model List**: Chỉ 5-8 model đã test và working  
✅ **Clear Categories**: Local vs Cloud được phân biệt rõ  
✅ **Performance Info**: Tốc độ và độ ổn định của từng model  
✅ **No More Guesswork**: Biết chắc model nào hoạt động  

**Thời gian setup: < 5 phút**  
**Kết quả: Model dropdown gọn gàng, dễ sử dụng!**

---

> 💡 **Tip**: Save 3 scripts này vào shortcuts để dùng lâu dài:
> - `model-filter.sh` - Lọc model
> - `apply-model-filter.sh` - Apply config  
> - `quick-clean.sh` - Cleanup nhanh (nếu cần)