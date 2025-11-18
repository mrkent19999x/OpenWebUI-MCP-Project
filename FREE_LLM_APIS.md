# 🆓 Free LLM APIs - Auto Failover Configuration

## 🎯 Mục Tiêu

Tìm và config nhiều API agent cloud **FREE hoặc có giới hạn** để:
- ✅ Tự động thay model khi một model hết
- ✅ Phân loại prompt tự động
- ✅ Agent phù hợp với chức năng

---

## 🆓 Free LLM APIs Available

### 1. **Groq** (FREE - Very Fast)
- **Rate Limit**: 30 requests/minute (free tier)
- **Models**: llama-3.1-70b, mixtral-8x7b, gemma2-9b
- **Speed**: ⚡⚡⚡ Cực nhanh
- **API**: https://api.groq.com/openai/v1
- **Setup**: Free, chỉ cần email

### 2. **OpenRouter** (FREE Tier Available)
- **Rate Limit**: 100 requests/day (free)
- **Models**: 100+ models từ nhiều providers
- **Aggregation**: Tự động chọn best model
- **API**: https://openrouter.ai/api/v1
- **Setup**: Free tier với credit

### 3. **Together AI** (FREE Credits)
- **Rate Limit**: $25 free credits
- **Models**: llama-2, mistral, mixtral
- **API**: https://api.together.xyz/v1
- **Setup**: Free credits khi sign up

### 4. **Hugging Face Inference** (FREE)
- **Rate Limit**: Unlimited (public models)
- **Models**: 1000+ models
- **API**: https://api-inference.huggingface.co
- **Setup**: Free với Hugging Face account

### 5. **Replicate** (FREE Credits)
- **Rate Limit**: $5 free credits
- **Models**: llama, mistral, stable-diffusion
- **API**: https://api.replicate.com/v1
- **Setup**: Free credits

### 6. **Anthropic Claude** (FREE Trial)
- **Rate Limit**: Limited free tier
- **Models**: claude-3-haiku (free), claude-3-sonnet
- **API**: https://api.anthropic.com/v1
- **Setup**: Free trial available

### 7. **Cohere** (FREE Tier)
- **Rate Limit**: 100 requests/month (free)
- **Models**: command, command-light
- **API**: https://api.cohere.ai/v1
- **Setup**: Free tier

### 8. **MiniMax** (FREE Credits)
- **Rate Limit**: Free credits
- **Models**: abab-5.5-chat, glm-4
- **API**: https://api.minimax.chat/v1
- **Setup**: Free credits khi đăng ký

### 9. **DeepSeek** (FREE Tier)
- **Rate Limit**: Free tier available
- **Models**: deepseek-chat, deepseek-coder
- **API**: https://api.deepseek.com/v1
- **Setup**: Free tier

### 10. **Perplexity** (FREE Tier)
- **Rate Limit**: Limited free requests
- **Models**: llama-3.1-sonar (online search)
- **API**: https://api.perplexity.ai
- **Setup**: Free tier

---

## 🔄 Auto Failover Strategy

### Priority Order (Khi Model Hết):

1. **Groq** (Fastest) → Fallback to
2. **OpenRouter** (Aggregation) → Fallback to
3. **Together AI** → Fallback to
4. **Hugging Face** → Fallback to
5. **Replicate** → Fallback to
6. **MiniMax** → Fallback to
7. **DeepSeek** → Fallback to
8. **Perplexity** (Last resort)

---

## 📊 Model Selection by Task Type

### Code Execution / Terminal:
- **Primary**: Groq (llama-3.1-70b) - Fastest
- **Fallback**: DeepSeek (deepseek-coder) - Code specialist
- **Fallback**: Together AI (codellama)

### File Operations:
- **Primary**: Groq (mixtral-8x7b) - Good reasoning
- **Fallback**: OpenRouter (auto-select)
- **Fallback**: MiniMax

### General Chat:
- **Primary**: OpenRouter (auto-select best)
- **Fallback**: Groq
- **Fallback**: Together AI

### Complex Reasoning:
- **Primary**: Anthropic Claude (if available)
- **Fallback**: Groq (llama-3.1-70b)
- **Fallback**: Together AI

---

## 🔧 Configuration Template

```json
{
  "llm_providers": {
    "groq": {
      "enabled": true,
      "priority": 1,
      "api_key": "${GROQ_API_KEY}",
      "base_url": "https://api.groq.com/openai/v1",
      "models": ["llama-3.1-70b-versatile", "mixtral-8x7b-32768"],
      "rate_limit": 30,
      "timeout": 30,
      "tasks": ["code", "file", "general"]
    },
    "openrouter": {
      "enabled": true,
      "priority": 2,
      "api_key": "${OPENROUTER_API_KEY}",
      "base_url": "https://openrouter.ai/api/v1",
      "models": ["auto"],
      "rate_limit": 100,
      "timeout": 60,
      "tasks": ["general", "reasoning"]
    },
    "together": {
      "enabled": true,
      "priority": 3,
      "api_key": "${TOGETHER_API_KEY}",
      "base_url": "https://api.together.xyz/v1",
      "models": ["mistralai/Mixtral-8x7B-Instruct-v0.1"],
      "rate_limit": 50,
      "timeout": 60,
      "tasks": ["code", "general"]
    },
    "huggingface": {
      "enabled": true,
      "priority": 4,
      "api_key": "${HUGGINGFACE_API_KEY}",
      "base_url": "https://api-inference.huggingface.co",
      "models": ["meta-llama/Llama-2-70b-chat-hf"],
      "rate_limit": 1000,
      "timeout": 120,
      "tasks": ["general"]
    },
    "minimax": {
      "enabled": true,
      "priority": 5,
      "api_key": "${MINIMAX_API_KEY}",
      "base_url": "https://api.minimax.chat/v1",
      "models": ["abab-5.5-chat"],
      "rate_limit": 100,
      "timeout": 60,
      "tasks": ["general", "vietnamese"]
    }
  },
  "failover": {
    "enabled": true,
    "max_retries": 3,
    "retry_delay": 2,
    "check_quota": true,
    "auto_switch": true
  },
  "prompt_routing": {
    "enabled": true,
    "rules": {
      "code_execution": {
        "providers": ["groq", "deepseek", "together"],
        "model": "llama-3.1-70b-versatile"
      },
      "file_operations": {
        "providers": ["groq", "openrouter", "minimax"],
        "model": "mixtral-8x7b-32768"
      },
      "general_chat": {
        "providers": ["openrouter", "groq", "together"],
        "model": "auto"
      },
      "vietnamese": {
        "providers": ["minimax", "groq", "openrouter"],
        "model": "abab-5.5-chat"
      }
    }
  }
}
```

---

## 🚀 Setup Instructions

### Bước 1: Lấy API Keys (FREE)

1. **Groq**: https://console.groq.com/ → Sign up → Get API key
2. **OpenRouter**: https://openrouter.ai/ → Sign up → Get API key
3. **Together AI**: https://together.ai/ → Sign up → Get $25 credits
4. **Hugging Face**: https://huggingface.co/ → Settings → Access Tokens
5. **MiniMax**: https://www.minimax.chat/ → Sign up → Get API key

### Bước 2: Điền Vào Config

Xem file `llm-providers-config.json` (sẽ tạo)

### Bước 3: Enable Auto Failover

Config sẽ tự động switch khi model hết!

---

## 📋 Next Steps

Em sẽ tạo:
1. ✅ Config file cho multiple providers
2. ✅ Auto-failover mechanism
3. ✅ Prompt routing system
4. ✅ Code execution safety checks
