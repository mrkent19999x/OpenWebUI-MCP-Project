# 📋 CONFIG SIDEBAR BÊN PHẢI (PROMPTS & TOOLS)

## ✅ ĐÃ CÓ SẴN:

### 1. Prompt Templates
- ✅ File: `prompt-templates.json` (10 templates tiếng Việt)
- ✅ File: `system-prompts.json` (8 system prompts)
- ✅ Đã mount vào container: `/app/backend/data/`

### 2. Link Cloudflare Tunnel
```
https://circulation-robertson-bass-lesson.trycloudflare.com
```

## 🔧 CÁCH BẬT PROMPTS Ở SIDEBAR:

### Bước 1: Vào Admin Settings → Interface
1. Login: begau1302@gmail.com / Baoan2022@
2. Click avatar → "Admin Panel"
3. Click tab "Interface"

### Bước 2: Enable Prompts
Tìm và bật các switch:
- ✅ "Show Prompt Templates"
- ✅ "Show Suggested Prompts"
- ✅ "Enable Right Sidebar"
- ✅ "Show Tools Panel"

### Bước 3: Refresh trang
- F5 hoặc Ctrl+R
- Prompts sẽ hiện ở sidebar bên phải

## 📝 LƯU Ý:

- Prompts đã có sẵn trong file, chỉ cần enable trong UI
- Nếu không thấy, restart container: `docker-compose restart open-webui`
- Tools (Code, Browser) sẽ tự động hiện khi được enable
