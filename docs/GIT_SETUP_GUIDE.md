# 🔧 Git Remote Setup Guide

## Step 1: Tạo Repository trên GitHub/GitLab

### Option A: GitHub
1. Vào [GitHub.com](https://github.com) và login
2. Click "New repository" (nút xanh)
3. Repository name: `Openwwebui` hoặc `OpenWebUI-MCP-Project`
4. Description: `Enterprise OpenWebUI deployment với MCP integration`
5. Chọn **Public** hoặc **Private**
6. ✅ Check "Add a README file"
7. ✅ Chọn "Python" trong .gitignore
8. Click "Create repository"

### Option B: GitLab
1. Vào [GitLab.com](https://gitlab.com) và login
2. Click "New project"
3. Chọn "Create blank project"
4. Project name: `Openwwebui`
5. Description: `Enterprise OpenWebUI deployment with MCP integration`
6. Visibility: Public hoặc Private
7. Click "Create project"

## Step 2: Setup Git Remote

Thay thế `YOUR_USERNAME` và `YOUR_REPO_NAME` bằng thông tin thực:

```bash
# Navigate to project directory
cd /workspace

# Add remote origin (choose one option)

# Option 1: HTTPS (recommended)
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git

# Option 2: Git (if you have SSH setup)
git remote add origin git@github.com:YOUR_USERNAME/YOUR_REPO_NAME.git

# Verify remote setup
git remote -v
```

## Step 3: Configure Git User (if not done)

```bash
# Set your git user information
git config --global user.email "your.email@example.com"
git config --global user.name "Your Name"

# Or just for this project
git config user.email "your.email@example.com"
git config user.name "Your Name"
```

## Step 4: Initial Push

```bash
# Add all files
git add .

# Create initial commit
git commit -m "🎉 Initial commit: OpenWebUI + MCP Orchestrator Implementation

✨ Features:
- Native MCP support (OpenAPI + Streamable HTTP)
- Vietnamese localization
- 6 MCP tools: Search, Vision, OCR, Gmail, GitHub, Zalo OA
- Production-ready architecture with load balancing
- 82% OpenWebUI v0.6.36 compliance

📁 Structure:
- README.md - Project overview
- agent.md - Personal project guide
- OPENWEBUI_LATEST_COMPLIANCE.md - Feature compliance
- Openwwebui/ - Main application
  - docker-compose.yml - Development config
  - docker-compose.production.yml - Production with load balancing
  - orchestrator/ - MCP gateway implementation
  - tests/ - Testing suite

🚀 Ready for deployment!"

# Push to remote repository
git push -u origin master
```

## Step 5: Authentication Setup

### Option A: Personal Access Token (GitHub)
1. Go to GitHub Settings → Developer settings → Personal access tokens
2. Click "Generate new token" 
3. Name: "OpenWebUI Project"
4. Expiration: 90 days (hoặc custom)
5. Select scopes:
   - ✅ repo (Full control of private repositories)
   - ✅ workflow (Update GitHub Action workflows)
6. Click "Generate token"
7. **Copy token immediately** - it won't be shown again
8. Use token as password when prompted

### Option B: SSH Key (Recommended for security)
```bash
# Generate SSH key (if you don't have one)
ssh-keygen -t ed25519 -C "your.email@example.com"

# Add SSH key to ssh-agent
ssh-add ~/.ssh/id_ed25519

# Copy public key
cat ~/.ssh/id_ed25519.pub
```

Then add this key to:
- **GitHub**: Settings → SSH and GPG keys → New SSH key
- **GitLab**: User Settings → SSH Keys → Add new key

## Step 6: Troubleshooting

### Authentication Issues
```bash
# Check current remote
git remote -v

# Update remote URL if needed
git remote set-url origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git

# Test connection
git ls-remote origin
```

### Push Rejection (not fast-forward)
```bash
# Force push (use carefully!)
git push --force-with-lease origin master

# Or pull and merge first
git pull origin master
git push origin master
```

### Large File Issues
```bash
# Check for large files
git ls-files | xargs ls -lh

# Remove large files from history (if needed)
git filter-branch --force --index-filter \
'git rm --cached --ignore-unmatch path/to/large/file' \
--prune-empty --tag-name-filter cat -- --all

# Or use git lfs for large files
git lfs install
git lfs track "*.psd"
git add .gitattributes
git add *.psd
git commit -m "Add PSD files with LFS"
git push origin master
```

## Step 7: Continuous Integration

### GitHub Actions Setup
Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy OpenWebUI

on:
  push:
    branches: [ main, master ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Deploy to Production
      run: |
        echo "Deploying OpenWebUI with MCP integration..."
        # Add your deployment commands here
```

## Step 8: Backup Strategy

```bash
# Create backup branch
git checkout -b backup-$(date +%Y%m%d)
git push origin backup-$(date +%Y%m%d)

# Or create archive
git archive --format=zip --output=openwebui-project-$(date +%Y%m%d).zip master
```

## 🚀 Quick Commands Reference

```bash
# Setup (one-time only)
git remote add origin https://github.com/username/repo.git
git config user.email "you@example.com"
git config user.name "Your Name"

# Daily workflow
git add .
git commit -m "Descriptive commit message"
git push origin master

# Check status
git status
git log --oneline -5
git remote -v

# Sync with remote
git pull origin master
```

---

**Ready to push your OpenWebUI project to the cloud!** 🚀

*After setup, you can use standard git workflow for all future development.*