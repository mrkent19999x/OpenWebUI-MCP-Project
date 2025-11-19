# 🔐 HƯỚNG DẪN PUSH VỚI TOKEN

## ✅ ĐÃ THIẾT LẬP XONG

- ✅ Đã thêm remote: `https://github.com/mrkent19999x/OpenWebUI-MCP-Project.git`
- ✅ Đã đổi branch thành `main`
- ⚠️ Cần authentication để push

---

## 🔑 CÁCH 1: DÙNG PERSONAL ACCESS TOKEN (DỄ NHẤT)

### Bước 1: Tạo Token

1. **Vào GitHub:** https://github.com/settings/tokens
2. **Click "Generate new token"** → **"Generate new token (classic)"**
3. **Đặt tên:** "OpenWebUI Push Token"
4. **Chọn scopes:**
   - ✅ `repo` (Full control of private repositories)
5. **Click "Generate token"**
6. **Copy token ngay** (chỉ hiện 1 lần, dạng: `ghp_xxxxx...`)

### Bước 2: Push với Token

**Cách 1: Push trực tiếp (nhập token khi hỏi)**
```bash
cd /home/mrkent/openwebui-merged
git push -u origin main
# Username: mrkent19999x
# Password: [Paste token vừa copy]
```

**Cách 2: Lưu token trong URL (tiện hơn)**
```bash
cd /home/mrkent/openwebui-merged
git remote set-url origin https://mrkent19999x:YOUR_TOKEN@github.com/mrkent19999x/OpenWebUI-MCP-Project.git
git push -u origin main
```

---

## 🔑 CÁCH 2: DÙNG SSH (AN TOÀN HƠN)

### Bước 1: Tạo SSH Key (nếu chưa có)

```bash
ssh-keygen -t ed25519 -C "mrkent19999x@github"
# Nhấn Enter để dùng default location
# Nhấn Enter để không đặt passphrase (hoặc đặt nếu muốn)
```

### Bước 2: Copy SSH Key

```bash
cat ~/.ssh/id_ed25519.pub
# Copy toàn bộ output
```

### Bước 3: Thêm SSH Key vào GitHub

1. **Vào GitHub:** https://github.com/settings/keys
2. **Click "New SSH key"**
3. **Đặt tên:** "OpenWebUI Server"
4. **Paste key** vừa copy
5. **Click "Add SSH key"**

### Bước 4: Đổi remote sang SSH

```bash
cd /home/mrkent/openwebui-merged
git remote set-url origin git@github.com:mrkent19999x/OpenWebUI-MCP-Project.git
git push -u origin main
```

---

## 🚀 EM SẼ LÀM GÌ?

**Nếu anh có token:**
- Anh cho em biết token, em sẽ push ngay
- Hoặc anh tự push: `git push -u origin main` (nhập token khi hỏi)

**Nếu anh muốn dùng SSH:**
- Em sẽ giúp setup SSH key
- Sau đó push bằng SSH

---

## 📝 LƯU Ý

**Bảo mật:**
- ⚠️ KHÔNG share token với ai
- ⚠️ KHÔNG commit token vào code
- ✅ Token chỉ dùng để push

**Sau khi push xong:**
- ✅ Code sẽ có trên GitHub
- ✅ Anh có thể xem tại: https://github.com/mrkent19999x/OpenWebUI-MCP-Project

---

**Anh tạo token và cho em biết, hoặc anh tự push nhé!** 🔐

