# 🔧 MCP GitHub Setup - Persistent Token

## 🎯 VẤN ĐỀ
Bạn muốn setup MCP GitHub mà không cần lấy token mỗi ngày.

## 🔑 GIẢI PHÁP: Personal Access Token Dài hạn

### **Bước 1: Tạo Personal Access Token (1 lần duy nhất)**

1. **Truy cập GitHub Settings**
   - Đăng nhập GitHub.com
   - Click avatar > Settings
   - Scroll down: Developer settings
   - Personal access tokens > Tokens (classic)

2. **Tạo Token Mới**
   - Click "Generate new token (classic)"
   - Note: "MCP GitHub Integration"
   - Expiration: **90 days** (vẫn khá dài)
   - Select scopes:
     ```
     ✅ repo (Full control of private repositories)
     ✅ workflow (Update GitHub Action workflows)
     ✅ admin:public_key (Full control of user public keys)
     ✅ admin:repo_hook (Full control of repository hooks)
     ✅ admin:org_hook (Full control of organization hooks)
     ✅ gist (Create gists)
     ✅ notifications (Access notifications)
     ✅ user (Update ALL user data)
     ✅ delete_repo (Delete repositories)
     ✅ write:discussion (Write team discussions)
     ✅ write:enterprise (Write enterprise data)
     ✅ write:project (Write team projects)
     ✅ write:discussion (Write team discussions)
     ```

3. **Save Token**
   - Copy token ngay (chỉ hiện 1 lần!)
   - Lưu vào secure place

### **Bước 2: Update .env File (1 lần duy nhất)**

```bash
# Trong .env file, thêm:
GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
GITHUB_USERNAME=mrkent19999x
GITHUB_EMAIL=your-email@example.com

# Persistent MCP Configuration
MCP_GITHUB_ENABLED=true
MCP_PERSISTENT_TOKEN=true
```

### **Bước 3: Setup MCP GitHub Server**

Tôi đã tạo mcp-server để tự động hóa:

```bash
# Start MCP server
cd /workspace/OpenWebUI-MCP-Project
pip install -r mcp-server/requirements.txt
python mcp-server/mcp_server.py
```

## 🚀 MCP Commands (Sau khi setup)

### **Repository Management**
```bash
# List repositories
curl http://localhost:3003/github/repos

# Get user info
curl http://localhost:3003/github/user

# Create repository
curl -X POST http://localhost:3003/github/repos \
  -H 'Content-Type: application/json' \
  -d '{"name":"my-new-repo","description":"Created via MCP","private":false}'
```

### **File Operations**
```bash
# Push files
curl -X POST http://localhost:3003/github/push \
  -H 'Content-Type: application/json' \
  -d '{
    "repo_name":"mrkent19999x/OpenWebUI-MCP-Project",
    "files":[
      {
        "path":"test.txt",
        "content":"SGVsbG8gV29ybGQh"
      }
    ],
    "commit_message":"Test push via MCP"
  }'

# Clone repository
curl -X POST http://localhost:3003/github/clone \
  -H 'Content-Type: application/json' \
  -d '{
    "repo_url":"https://github.com/mrkent19999x/OpenWebUI-MCP-Project.git",
    "local_path":"/workspace/cloned-repo"
  }'
```

### **Get Commits**
```bash
curl http://localhost:3003/github/commits \
  -d '{"repo_name":"mrkent19999x/OpenWebUI-MCP-Project","branch":"main","limit":5}'
```

## 🔄 Auto-Renewal Strategy

### **Option 1: GitHub Mobile App (Recommended)**
- **Pros**: Tự động login, không cần token
- **Cons**: Cần tương tác thủ công

### **Option 2: GitHub CLI**
```bash
# Install GitHub CLI
npm install -g @github/cli
gh auth login --with-token

# Auto-push
git push origin main
```

### **Option 3: MCP with Webhook**
```bash
# Setup webhook để auto-push
curl -X POST http://localhost:3003/webhook/setup \
  -H 'Content-Type: application/json' \
  -d '{
    "repository":"mrkent19999x/OpenWebUI-MCP-Project",
    "events":["push"]
  }'
```

## 📱 Mobile-Friendly MCP Setup

### **Bước 1: Deploy MCP Server**
```bash
# On your server/VPS
cd /workspace/OpenWebUI-MCP-Project
python mcp-server/mcp_server.py &

# Make it persistent
nohup python mcp-server/mcp_server.py > mcp.log 2>&1 &
```

### **Bước 2: Mobile Access**
```bash
# From mobile, access MCP API
curl http://your-server-ip:3003/github/user
curl http://your-server-ip:3003/github/repos
curl http://your-server-ip:3003/github/push
```

### **Bước 3: One-Click Push**
```bash
# Create mobile shortcut
curl -X POST http://localhost:3003/github/quick-push \
  -H 'Content-Type: application/json' \
  -d '{
    "repo_name":"mrkent19999x/OpenWebUI-MCP-Project",
    "message":"Mobile update",
    "auto_commit":true
  }'
```

## 🔐 Security Best Practices

### **Token Management**
```bash
# Store token securely
echo "GITHUB_TOKEN=ghp_xxx..." >> ~/.bashrc
chmod 600 ~/.bashrc

# Backup token
echo $GITHUB_TOKEN | base64 > token.backup
```

### **MCP Server Security**
```bash
# Restrict MCP access
# Add to mcp_server.py:
import secrets

# Generate API key for MCP access
MCP_API_KEY = secrets.token_hex(32)

# Require API key in requests
if request.headers.get('X-MCP-Key') != MCP_API_KEY:
    return {"error": "Unauthorized"}, 401
```

## 📊 MCP vs Manual Token

| Method | Setup Time | Token Refresh | Automation | Mobile Friendly |
|--------|------------|---------------|------------|-----------------|
| **MCP Server** | 5 minutes | 90 days | ✅ Full | ✅ Yes |
| **Manual** | 1 minute | 1 day | ❌ None | ✅ Yes |
| **GitHub CLI** | 2 minutes | 7-30 days | ⚠️ Partial | ⚠️ Limited |

## 🎯 RECOMMENDATION

**Cho mobile users:**
1. **Setup MCP Server** (5 phút, 1 lần)
2. **Use GitHub mobile app** cho các task phức tạp
3. **Use MCP commands** cho automation

**Kết quả:**
- ✅ Token không cần thay đổi mỗi ngày
- ✅ Tự động push/pull files
- ✅ Full GitHub integration
- ✅ Mobile-friendly

Bạn muốn tôi setup MCP server ngay bây giờ không?