# Danh Sách Nguồn AI Miễn Phí Mới Nhất 2025
## (Quota Cao, Không Cần Thẻ Tín Dụng)

*Cập nhật: Tháng 11/2025*

### 🏆 TOP NGUỒN KHUYẾN NGHỊ (Quota Cao Nhất)

#### 1. **Cerebras** - 🥇 *Quota Khủng Nhất*
- **Website**: https://cerebras.ai
- **Đăng ký**: Không cần thẻ tín dụng
- **Free Tier**: 1 triệu tokens/ngày (cực kỳ hào phóng)
- **Rate Limit**: 600 requests/phút
- **Context**: 65K tokens
- **Models**: Llama 3.1, Qwen, và nhiều model hiện đại
- **Ưu điểm**: Tốc độ inference nhanh nhất thế giới
- **OpenAI Compatible**: ✅

#### 2. **Cloudflare Workers AI** - 🥈 *Ổn Định & Miễn Phí Vĩnh Viễn*
- **Website**: https://dash.cloudflare.com/ai
- **Đăng ký**: Cloudflare account miễn phí
- **Free Tier**: 10,000 Neurons/ngày (tương đương ~50K tokens)
- **Rate Limit**: 100 requests/phút
- **Models**: Llama 3.1, Mixtral, Stable Diffusion
- **Ưu điểm**: Không giới hạn thời gian, infrastructure toàn cầu
- **OpenAI Compatible**: ✅

#### 3. **GitHub Models** - 🥉 *Dễ Đăng Ký Nhất*
- **Website**: https://github.com/features/copilot/models
- **Đăng ký**: Chỉ cần GitHub account
- **Free Tier**: Giới hạn theo rate limit, không cần credit
- **Rate Limit**: 20 requests/phút cho free models
- **Models**: GPT-4o mini, Claude 3.5, Llama 3.1
- **Ưu điểm**: Tích hợp GitHub ecosystem
- **OpenAI Compatible**: ✅

---

### 📊 DANH SÁCH NGUỒN ĐẦY ĐỦ (Cập Nhật 2025)

| Nguồn | Quota/ngày | Rate Limit | Đăng ký | OpenAI Compatible | Đánh giá |
|-------|------------|------------|---------|-------------------|----------|
| **Cerebras** | 1M tokens | 600 RPM | Dễ | ✅ | ⭐⭐⭐⭐⭐ |
| **Cloudflare AI** | 10K neurons | 100 RPM | Dễ | ✅ | ⭐⭐⭐⭐⭐ |
| **GitHub Models** | Rate limited | 20 RPM | Rất dễ | ✅ | ⭐⭐⭐⭐ |
| **OpenRouter** | 50 requests | 20 RPM | Trung bình | ✅ | ⭐⭐⭐⭐ |
| **Google AI Studio** | 15 requests | 15 RPM | Trung bình | ✅ | ⭐⭐⭐ |
| **Together AI** | $25 credits | 60 RPM | Dễ | ✅ | ⭐⭐⭐ |
| **DeepInfra** | Pay-per-use | 200 concurrent | Dễ | ✅ | ⭐⭐⭐ |
| **Replicate** | Giới hạn | 600 RPM | Dễ | ✅ | ⭐⭐ |
| **Puter.js** | Unlimited* | Không giới hạn | Rất dễ | ✅ | ⭐⭐⭐⭐⭐ |

---

### 🔧 HƯỚNG DẪN TÍCH HỢP OPEN WEBUI

#### Bước 1: Đăng Ký Nhiều Nguồn (15 phút)
```bash
# Tạo tài khoản theo thứ tự ưu tiên:
1. Cerebras.ai - Đăng nhập → API Keys → Create new key
2. Cloudflare - Workers AI → Get started → API token
3. GitHub Models - github.com → Features → Models → Try it
4. OpenRouter - openrouter.ai → Keys → Create key
5. Google AI Studio - aistudio.google.com → Get API key
```

#### Bước 2: Cấu Hình Open WebUI

**Cách 1: Thêm từng nguồn riêng lẻ**
```
Settings → Connections → Add Connection → OpenAI API

# Cerebras
Base URL: https://api.cerebras.ai/v1
API Key: [your-cerebras-key]

# Cloudflare Workers AI  
Base URL: https://api.cloudflare.com/client/v4/accounts/YOUR_ACCOUNT_ID/ai/v1
API Key: [your-cloudflare-token]

# GitHub Models
Base URL: https://models.inference.ai.azure.com
API Key: [your-github-token]
```

**Cách 2: Dùng LiteLLM Proxy (Khuyến nghị)**
```yaml
# config.yaml cho LiteLLM
model_list:
  - model_name: cerebras-llama
    litellm_params:
      model: cerebras/llama-3.1-70b
      api_base: https://api.cerebras.ai/v1
      api_key: ${CEREBRAS_API_KEY}
  
  - model_name: cloudflare-llama
    litellm_params:
      model: cloudflare/llama-3.1-8b-instruct
      api_base: https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/ai/v1
      api_key: ${CF_API_KEY}
  
  - model_name: github-gpt4o
    litellm_params:
      model: github/gpt-4o-mini
      api_base: https://models.inference.ai.azure.com
      api_key: ${GITHUB_TOKEN}

general_settings:
  database_url: sqlite:///./litellm.db
  master_key: your-secret-key
```

**Chạy LiteLLM Proxy:**
```bash
# Docker (Khuyến nghị)
docker run -p 4000:4000 -v $(pwd)/config.yaml:/app/config.yaml \
  -e CEREBRAS_API_KEY=your-key \
  -e CF_API_KEY=your-key \
  ghcr.io/berriai/litellm:main-latest \
  --config /app/config.yaml

# Hoặc local
pip install litellm
litellm --config config.yaml
```

**Cấu hình Open WebUI với LiteLLM:**
```
Settings → Connections → Add Connection → OpenAI API
Base URL: http://localhost:4000
API Key: your-secret-key (từ config.yaml)
```

---

### 🚀 CHIẾN LƯỢC TỐI ƯU SỬ DỤNG

#### 1. **Rotation Tự Động**
```yaml
# liteLLM routing với health check
model_list:
  - model_name: primary-llm
    litellm_params:
      model: cerebras/llama-3.1-70b
      api_base: https://api.cerebras.ai/v1
      api_key: ${CEREBRAS_API_KEY}
  
  - model_name: fallback-llm
    litellm_params:
      model: cloudflare/llama-3.1-8b-instruct
      api_base: https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/ai/v1
      api_key: ${CF_API_KEY}

# Health check và auto-fallback
litellm_params:
  num_retries: 3
  request_timeout: 30
```

#### 2. **Caching Thông Minh**
```python
# Trong Open WebUI
Settings → Functions → Enable Response Caching
# Giảm 60% API calls cho câu hỏi tương tự
```

#### 3. **Chọn Model Phù Hợp**
- **Công việc nhẹ**: Llama 3.1 8B (Cloudflare, GitHub)
- **Công việc nặng**: Llama 3.1 70B (Cerebras)
- **Multimodal**: GPT-4o mini (GitHub Models)
- **Coding**: Claude 3.5 (OpenRouter free)

#### 4. **Theo Dõi Usage**
```bash
# Tạo script theo dõi quota
#!/bin/bash
echo "=== QUOTA CHECK $(date) ==="
echo "Cerebras: $(curl -s -H "Authorization: Bearer $CEREBRAS_API_KEY" \
  https://api.cerebras.ai/v1/user | jq -r '.limits.remaining')"
echo "Cloudflare: Check dashboard manually"
echo "GitHub: Check models.inference.ai.azure.com"
```

---

### 🔥 NGUỒN ĐẶC BIỆT: PUTER.JS

**Puter.js** cung cấp API unlimited không cần API key:

```javascript
import { AI } from "puter";

const completion = await AI.chat.completions.create({
    messages: [
        { role: "user", content: "Xin chào!" }
    ],
    model: "claude-3.5-sonnet",
    max_tokens: 1000,
});

// Hoặc OpenAI compatible
const client = new AI.OpenAI({
    apiKey: "puter", // Dummy key
    baseURL: "https://api.puter.com/v1"
});
```

**Ưu điểm**: 
- ✅ Không cần đăng ký, không cần API key
- ✅ Access miễn phí các model cao cấp
- ✅ Không giới hạn requests
- ⚠️ Có thể bị rate limit khi quá tải

---

### 📈 DỰ PHÒNG KHI HẾT QUOTA

#### 1. **Local Fallback với Ollama**
```bash
# Cài đặt Ollama
curl -fsSL https://ollama.ai/install.sh | sh
ollama pull llama3.2:3b
ollama serve

# Cấu hình Open WebUI
Base URL: http://localhost:11434
```

#### 2. **Backup Models**
- **Ollama**: llama3.2 3B (1.2GB RAM)
- **Oobabooga**: WebUI local với nhiều models
- **LM Studio**: Desktop app cho Mac/Windows

---

### 💡 TIPS VÀ THỦ THUẬT

#### 1. **Tối Ưu Token**
```
- Dùng "Compression" trong Open WebUI
- Bật "Function calling" để tránh context dài
- Split long conversations
```

#### 2. **Phân Tán Rủi Ro**
```
- Đăng ký 5-7 nguồn khác nhau
- Không phụ thuộc 100% vào 1 nguồn
- Theo dõi status pages của từng nguồn
```

#### 3. **Cập Nhật Liên Tục**
```bash
# Theo dõi GitHub repo để cập nhật
https://github.com/cheahjs/free-llm-api-resources
```

---

### ⚡ THỰC HÀNH NHANH (5 Phút Setup)

```bash
# 1. Đăng ký Cerebras (5 phút)
# - Vào cerebras.ai
# - Sign up → API Keys → Create new key
# - Copy key

# 2. Test ngay trong Open WebUI
# Settings → Connections → Add Connection
# Base URL: https://api.cerebras.ai/v1
# API Key: [paste your key]
# Model: llama-3.1-70b
# Test: "Xin chào, bạn là ai?"

# 3. Thêm Cloudflare (backup)
# Tương tự với Cloudflare Workers AI
```

---

### 🔗 LINKS QUAN TRỌNG

- **Status Pages**: 
  - Cerebras: https://status.cerebras.ai
  - Cloudflare: https://www.cloudflarestatus.com
  - GitHub: https://www.githubstatus.com

- **Community**:
  - Reddit: r/LocalLLaMA, r/singularity
  - Discord: Open WebUI community
  - GitHub Discussions

- **Documentation**:
  - LiteLLM: https://docs.litellm.ai
  - Open WebUI: https://github.com/open-webui/open-webui

---

### 📝 GHI CHÚ CẬP NHẬT

- **11/2025**: Cerebras tăng quota lên 1M tokens/ngày
- **10/2025**: GitHub Models hỗ trợ BYOK (Bring Your Own Key)
- **09/2025**: Cloudflare Workers AI ổn định, không thay đổi limit
- **08/2025**: OpenRouter cập nhật rate limits cho free tier

---

**💡 Kết luận**: Với setup đúng cách, bạn có thể sử dụng AI miễn phí với quota >10 triệu tokens/tháng mà không cần thẻ tín dụng. Ưu tiên Cerebras + Cloudflare + GitHub Models là bộ ba hoàn hảo cho nhu cầu cá nhân.