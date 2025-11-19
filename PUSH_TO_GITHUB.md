# 🔑 Hướng dẫn Push Repository lên GitHub

## Bước 1: Có token GitHub chưa anh?

**Nếu chưa có, anh tạo Personal Access Token:**

1. Go to GitHub.com → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click "Generate new token (classic)"
3. Chọn scopes:
   - ✅ repo (Full control of private repositories)
   - ✅ workflow (Update GitHub Action workflows)
4. Copy token (bắt đầu bằng `ghp_`)

## Bước 2: Setup remote repository

```bash
cd /workspace/OpenWebUI-MCP-Project

# Add remote origin
git remote add origin https://github.com/mrkent19999x/OpenWebUI-MCP-Project.git

# Verify remote
git remote -v
```

## Bước 3: Push với token

**Cách 1: Using token trong URL**
```bash
# Thay TOKEN bằng token thực của anh
git push https://ghp_TOKEN@github.com/mrkent19999x/OpenWebUI-MCP-Project.git main
```

**Cách 2: Using credential helper (Khuyến nghị)**
```bash
# Set credential helper
git config --global credential.helper store

# Set remote with username
git remote set-url origin https://mrkent19999x:ghp_TOKEN@github.com/mrkent19999x/OpenWebUI-MCP-Project.git

# Push
git push origin main
```

## Bước 4: Kiểm tra

Sau khi push thành công, anh vào:
- https://github.com/mrkent19999x/OpenWebUI-MCP-Project
- Kiểm tra có 2 commits mới được push lên không

## 📁 Files đã được tối ưu và sẽ push:

- ✅ README.md (fixed git conflict)
- ✅ docker-compose.yml (optimized version)
- ✅ .env.example (complete template)
- ✅ validate-env.sh (environment checker)
- ✅ test-configuration.sh (configuration tester)
- ✅ config/ folder structure
- ✅ All documentation files

## ⚠️ Lưu ý:

- **KHÔNG push .env file** (chỉ push .env.example)
- **Token là bí mật**, đừng chia sẻ với ai
- **Mật khẩu GitHub không dùng được**, phải dùng token

---

**Chờ token của anh để push lên GitHub!** 🚀