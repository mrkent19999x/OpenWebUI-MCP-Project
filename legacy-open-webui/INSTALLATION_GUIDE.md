# 🚀 Open WebUI Stack - Hướng Dẫn Cài Đặt Chi Tiết 2025

## 📋 Tổng Quan
Hệ thống AI Chat Interface đa nền tảng với **5 giao diện chính** và **10+ nhà cung cấp API miễn phí**, tích hợp LiteLLM để tự động routing và failover.

### 🏗️ Kiến Trúc Hệ Thống
```
┌─────────────────────────────────────────────────────────┐
│                    NGINX REVERSE PROXY                  │
│                  (Load Balancer + SSL)                  │
└─────────────────┬───────────────────────────────────────┘
                  │
        ┌─────────┼─────────┐
        │         │         │
┌───────▼─────┐ ┌──▼────┐ ┌──▼──────┐ ┌───▼─────┐ ┌───▼─────┐
│ OPEN WEBUI  │ │LOBECHAT│ │ANYTHING │ │LIBRECHAT│ │  BIGAGI │
│ Port: 3000  │ │ 3001  │ │  3002   │ │  3003  │ │  3004  │
└─────────────┘ └───────┘ └─────────┘ └─────────┘ └────────┘
        │         │         │         │         │
        └─────────┼─────────┼─────────┼─────────┘
                  │         │         │
        ┌─────────▼─────────▼─────────▼─────────┐
│              LITELLM API GATEWAY              │
│                Port: 4000                     │
└─────────────────────────────────────────────────┘
        │         │         │         │         │
┌───────▼─────┐ ┌──▼────┐ ┌──▼────┐ ┌──▼────┐ ┌──▼────┐
│   CEREBRAS  │ │CF AI  │ │GITHUB │ │OPENRT │ │GEMINI │
│ 1M tokens/ │ │10K    │ │Multi  │ │Variety│ │Ultra  │
│ day         │ │neuron │ │modal  │ │       │ │tokens │
└─────────────┘ └───────┘ └───────┘ └───────┘ └───────┘
        │
┌───────▼─────────────────────────────────────┐
│               OLLAMA LOCAL                   │
│          (Fallback when offline)            │
└─────────────────────────────────────────────┘
```

## 🔥 Tính Năng Nổi Bật

### 🎯 **Multi-Platform UI**
- **Open WebUI** (58k ⭐) - Giao diện gốc, plugin ecosystem phong phú
- **LobeChat** (15k ⭐) - Modern, mobile-first design
- **AnythingLLM** (3k ⭐) - All-in-one RAG system  
- **LibreChat** (13k ⭐) - Enterprise multi-user
- **BigAGI** (2k ⭐) - Developer workflows

### 🧠 **AI Providers (Free Tier)**
1. **Cerebras** - 1 triệu tokens/ngày 🏆
2. **Cloudflare Workers AI** - 10K neurons/ngày
3. **GitHub Models** - Multimodal hỗ trợ
4. **OpenRouter** - Đa dạng models
5. **Google AI Studio** - Gemini ultra long context
6. **Together AI** - Models mới nhất
7. **DeepInfra** - Backup
8. **Replicate** - Specialized
9. **Ollama Local** - Offline fallback
10. **Puter.js** - Emergency backup

### ⚡ **Smart Routing System**
- **Load balancing** tự động
- **Failover** thông minh  
- **Caching** Redis cho performance
- **Rate limiting** per model
- **Health monitoring** real-time
- **Budget control** tự động

## 🛠️ Yêu Cầu Hệ Thống

### **Tối Thiểu**
- RAM: 4GB
- Storage: 20GB free space
- CPU: 2 cores
- OS: Ubuntu 20.04+, CentOS 8+, macOS 12+
- Docker & Docker Compose

### **Khuyến Nghị**
- RAM: 8GB+
- Storage: 50GB+ SSD
- CPU: 4+ cores  
- Network: Stable internet connection

## 🚀 Cài Đặt Nhanh (15 phút)

### **Bước 1: Clone & Setup**
```bash
# Clone repository (hoặc copy files đã tạo)
git clone https://github.com/your-repo/open-webui-stack.git
cd open-webui-stack

# Make scripts executable
chmod +x *.sh
```

### **Bước 2: Cài Đặt Docker (nếu chưa có)**
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y docker.io docker-compose
sudo systemctl enable docker
sudo systemctl start docker

# macOS
brew install --cask docker
```

### **Bước 3: Environment Configuration**
```bash
# Copy template và cấu hình
cp .env.template .env

# Edit file .env với API keys của bạn
nano .env
```

### **Bước 4: Quick Install**
```bash
# Chạy cài đặt tự động
./quick-install.sh

# Hoặc manual với docker-compose
docker-compose up -d
```

### **Bước 5: Verify**
```bash
# Check services status
docker-compose ps

# Kiểm tra logs
docker-compose logs -f open-webui
```

## 🔑 Cấu Hình API Keys

### **1. Cerebras (Khuyến Nghị Nhất)**
```bash
# Đăng ký: https://cloud.cerebras.ai/
# Free: 1 triệu tokens/ngày
CEREBRAS_API_KEY=sk-your-key-here
```

### **2. Cloudflare Workers AI**
```bash
# Đăng ký: https://dash.cloudflare.com/
# Free: 10K neurons/ngày
CLOUDFLARE_API_KEY=your-token
CLOUDFLARE_ACCOUNT_ID=your-account-id
```

### **3. GitHub Models**
```bash
# Đăng ký: https://github.com/marketplace/models
# Create Personal Access Token
GITHUB_TOKEN=ghp_your-token
```

### **4. OpenRouter**
```bash
# Đăng ký: https://openrouter.ai/
# Free tier available
OPENROUTER_API_KEY=sk-or-your-key
```

### **5. Google AI Studio**
```bash
# Đăng ký: https://aistudio.google.com/
# Free Gemini access
GOOGLE_API_KEY=your-key
```

### **6. Together AI**
```bash
# Đăng ký: https://api.together.xyz/
# $5 free credits
TOGETHER_API_KEY=your-key
```

## 📊 Các Port & URLs

| Service | Port | URL | Mô Tả |
|---------|------|-----|-------|
| **Open WebUI** | 3000 | http://localhost:3000 | Main chat interface |
| **LobeChat** | 3001 | http://localhost:3001 | Modern UI |
| **AnythingLLM** | 3002 | http://localhost:3002 | RAG system |
| **LibreChat** | 3003 | http://localhost:3003 | Enterprise |
| **BigAGI** | 3004 | http://localhost:3004 | Developer tools |
| **LiteLLM API** | 4000 | http://localhost:4000 | API Gateway |
| **Nginx** | 80/443 | http://localhost | Reverse proxy |
| **Grafana** | 3030 | http://localhost:3030 | Monitoring |
| **Prometheus** | 9090 | http://localhost:9090 | Metrics |

## 🎛️ Quản Lý Hệ Thống

### **Commands Hữu Ích**
```bash
# Stop/Start services
docker-compose down
docker-compose up -d

# View logs
docker-compose logs -f [service-name]

# Restart specific service
docker-compose restart open-webui

# Scale services
docker-compose up -d --scale open-webui=2

# Backup data
docker run --rm -v open-webui-data:/data -v $(pwd):/backup alpine tar czf /backup/open-webui-backup.tar.gz /data

# Update images
docker-compose pull && docker-compose up -d
```

### **Health Checks**
```bash
# Check all services
curl http://localhost:4000/health/liveliness

# Check specific service
curl http://localhost:3000/api/v1/health
```

## 📈 Monitoring & Analytics

### **Grafana Dashboards**
- **Access**: http://localhost:3030
- **Default**: admin / admin123!@#
- **Dashboards**: System metrics, API usage, error rates

### **Key Metrics**
- **Request volume** per model
- **Response time** latency
- **Success/error rates** by provider
- **Token usage** vs limits
- **Cache hit rates**

## 🛡️ Bảo Mật & Performance

### **Security Features**
- Rate limiting per model
- API key validation
- CORS protection  
- Session management
- Data encryption

### **Performance Optimization**
- Redis caching
- Connection pooling
- Load balancing
- Health checks
- Automatic failover

## 🔧 Troubleshooting

### **Common Issues**

#### 1. **Services không start**
```bash
# Check Docker status
docker --version
docker-compose --version

# View logs
docker-compose logs [service-name]

# Restart Docker
sudo systemctl restart docker
```

#### 2. **Port conflicts**
```bash
# Check port usage
netstat -tlnp | grep :3000

# Kill process using port
sudo lsof -ti:3000 | xargs kill -9
```

#### 3. **API Keys không work**
```bash
# Test key directly
curl -H "Authorization: Bearer YOUR_KEY" \
     https://api.cerebras.ai/v1/models

# Check .env file
cat .env | grep -E "API_KEY|ID"
```

#### 4. **Low performance**
```bash
# Monitor resource usage
docker stats

# Check disk space
df -h

# Monitor network
iftop -i eth0
```

### **Log Locations**
```
- Docker logs: ~/.docker/containers/
- Service logs: docker-compose logs [service]
- Nginx logs: ./logs/nginx/
- Database logs: ./logs/postgres/
```

## 📚 Advanced Configuration

### **Custom Model Groups**
```yaml
# Edit litellm-config.yaml
model_groups:
  fast_inference:
    models: ["llama-3.1-8b-cerebras", "gpt-4o-mini-github"]
    
  high_quality:
    models: ["llama-3.1-70b-cerebras", "claude-3.5-sonnet-github"]
    
  coding_specialized:
    models: ["codellama-replicate", "qwen-2.5-together"]
```

### **Rate Limiting**
```yaml
# Per model limits
rate_limits:
  "llama-3.1-70b-cerebras":
    rpm: 100  # requests per minute
    rph: 2000 # requests per hour
```

### **Custom Environment**
```bash
# Development mode
LOG_LEVEL=debug
DEBUG_MODE=true

# Production mode  
LOG_LEVEL=info
DEBUG_MODE=false
ENABLE_MONITORING=true
```

## 🎯 Usage Tips

### **Best Practices**
1. **Thứ tự ưu tiên**: Cerebras → Cloudflare → GitHub → OpenRouter
2. **Monitoring**: Check Grafana dashboard daily
3. **Backup**: Automatic daily backups enabled
4. **Updates**: Run monthly image updates

### **Cost Optimization**
- Use Cerebras for bulk requests (highest quota)
- Use local Ollama for development/testing
- Monitor token usage in Grafana
- Set budget alerts at 80% usage

### **Performance Tuning**
- Enable caching: improves response time by 40%
- Use load balancing: distributes load evenly
- Monitor health checks: automatic failover
- Regular log rotation: prevents disk full

## 📞 Support & Community

### **Resources**
- **Documentation**: Comprehensive guides included
- **API Reference**: http://localhost:4000/docs
- **Health Dashboard**: http://localhost:4000/health
- **Metrics**: http://localhost:9090 (Prometheus)

### **Getting Help**
1. Check logs: `docker-compose logs [service]`
2. Verify configuration: Review .env file
3. Test connectivity: Use provided curl commands
4. Monitor metrics: Check Grafana dashboards

---

## ✅ Kết Quả Mong Đợi

Sau khi cài đặt thành công, bạn sẽ có:

✅ **5 giao diện AI** hoạt động đồng thời  
✅ **10+ nguồn API miễn phí** được tích hợp  
✅ **Smart routing** tự động chọn model tốt nhất  
✅ **Load balancing** phân phối tải hiệu quả  
✅ **Monitoring real-time** với Grafana  
✅ **Failover tự động** khi provider gặp sự cố  
✅ **Caching system** tăng tốc độ phản hồi  
✅ **Security layers** bảo vệ hệ thống  

**Total: 5 UIs + 10 APIs = 15 cách truy cập AI khác nhau!**

🎉 **Chúc bạn sử dụng hiệu quả hệ thống AI mạnh mẽ này!**