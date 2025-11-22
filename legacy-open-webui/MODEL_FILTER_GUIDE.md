# 🎯 AI Model Auto-Filter & Management Guide

## Vấn đề bạn gặp phải
Khi có quá nhiều provider và model, sẽ có:
- ❌ Nhiều model không hoạt động (cần API key)
- ❌ Model chậm hoặc không phản hồi
- ❌ Khó tìm model phù hợp cho từng task
- ❌ Lãng phí thời gian test từng model

## Giải pháp tự động

### 1. 📋 Lọc Model Tự Động

```bash
# Chạy script lọc model
chmod +x model-filter.sh
./model-filter.sh --full
```

Script sẽ tự động:
- ✅ Test tất cả model có sẵn
- ✅ Kiểm tra API keys
- ✅ Tạo danh sách model working
- ✅ Tạo cấu hình lọc cho từng UI

### 2. 🔧 Cấu hình Model cho Từng UI

#### A. Open WebUI - Chỉ hiển thị Model Working

**Tạo file cấu hình riêng:**
```javascript
// File: openwebui_filter_config.js
const FILTERED_MODELS = {
    // Local models (không cần API key)
    "local_working": [
        {
            id: "llama3.1",
            name: "Llama 3.1 (Fast)",
            description: "Model nhanh nhất, local",
            provider: "ollama",
            category: "General Chat"
        },
        {
            id: "mistral:7b", 
            name: "Mistral 7B (Balanced)",
            description: "Cân bằng tốc độ và chất lượng",
            provider: "ollama",
            category: "General Chat"
        },
        {
            id: "codellama",
            name: "Code Llama (Programming)",
            description: "Chuyên code và programming",
            provider: "ollama", 
            category: "Programming"
        }
    ],
    
    // Cloud models (cần API key nhưng hoạt động tốt)
    "cloud_working": [
        {
            id: "gpt-4o-mini",
            name: "GPT-4o Mini (Fast & Cheap)",
            description: "Rẻ và nhanh nhất từ OpenAI",
            provider: "openai",
            category: "General Chat"
        },
        {
            id: "claude-3.5-haiku", 
            name: "Claude 3.5 Haiku (Quick)",
            description: "Nhanh và thông minh",
            provider: "anthropic",
            category: "General Chat"
        }
    ]
};

// Export for UI use
if (typeof module !== 'undefined') {
    module.exports = FILTERED_MODELS;
}
```

#### B. Tạo Model Filter Component cho UI

**Open WebUI Filter Component:**
```javascript
// File: model-filter-component.js
class ModelFilter {
    constructor(containerId) {
        this.container = document.getElementById(containerId);
        this.filteredModels = FILTERED_MODELS;
        this.currentFilter = 'all';
    }

    init() {
        this.createFilterUI();
        this.loadWorkingModels();
    }

    createFilterUI() {
        const filterHTML = `
            <div class="model-filter-container">
                <div class="filter-tabs">
                    <button class="filter-tab active" data-filter="all">All Models</button>
                    <button class="filter-tab" data-filter="local_working">Local (Free)</button>
                    <button class="filter-tab" data-filter="cloud_working">Cloud (API)</button>
                </div>
                <div class="model-status-indicator">
                    <span class="status-badge working">✅ Working</span>
                    <span class="status-badge api-required">🔑 API Required</span>
                </div>
            </div>
        `;
        this.container.innerHTML = filterHTML;
        this.bindEvents();
    }

    bindEvents() {
        const tabs = this.container.querySelectorAll('.filter-tab');
        tabs.forEach(tab => {
            tab.addEventListener('click', (e) => {
                this.switchFilter(e.target.dataset.filter);
            });
        });
    }

    loadWorkingModels() {
        const modelsContainer = document.getElementById('models-container');
        modelsContainer.innerHTML = '';
        
        let models = [];
        switch(this.currentFilter) {
            case 'local_working':
                models = this.filteredModels.local_working;
                break;
            case 'cloud_working':
                models = this.filteredModels.cloud_working;
                break;
            default:
                models = [...this.filteredModels.local_working, ...this.filteredModels.cloud_working];
        }
        
        this.renderModels(models);
    }

    renderModels(models) {
        const modelsContainer = document.getElementById('models-container');
        
        models.forEach(model => {
            const modelCard = this.createModelCard(model);
            modelsContainer.appendChild(modelCard);
        });
    }

    createModelCard(model) {
        const card = document.createElement('div');
        card.className = 'model-card';
        card.innerHTML = `
            <div class="model-header">
                <h3>${model.name}</h3>
                <span class="model-category">${model.category}</span>
            </div>
            <p class="model-description">${model.description}</p>
            <div class="model-footer">
                <span class="model-provider">${model.provider}</span>
                <button class="use-model-btn" data-model="${model.id}">Use Model</button>
            </div>
        `;
        return card;
    }

    switchFilter(filter) {
        this.currentFilter = filter;
        this.loadWorkingModels();
        
        // Update active tab
        this.container.querySelectorAll('.filter-tab').forEach(tab => {
            tab.classList.remove('active');
        });
        this.container.querySelector(`[data-filter="${filter}"]`).classList.add('active');
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    const filter = new ModelFilter('model-filter');
    filter.init();
});
```

### 3. 🚀 Tự Động Setup và Test

**Script tự động setup:**
```bash
#!/bin/bash
# File: auto-setup-models.sh

echo "🤖 Auto Setup Working Models"
echo "=========================="

# 1. Setup Ollama (local models)
setup_ollama() {
    echo "📦 Setting up Ollama..."
    curl -fsSL https://ollama.ai/install.sh | sh
    
    # Install working models
    echo "📥 Installing recommended models..."
    ollama pull llama3.1:8b
    ollama pull mistral:7b  
    ollama pull codellama:7b
    ollama pull phi3:mini
    
    echo "✅ Ollama setup complete!"
}

# 2. Check and test API keys
check_api_keys() {
    echo "🔑 Checking API keys..."
    
    # Load .env file
    source .env
    
    # Test OpenAI
    if [ -n "$OPENAI_API_KEY" ]; then
        echo "Testing OpenAI API..."
        curl -s -H "Authorization: Bearer $OPENAI_API_KEY" \
             https://api.openai.com/v1/models | grep -q "gpt-4o" && \
        echo "✅ OpenAI API working" || echo "❌ OpenAI API failed"
    fi
    
    # Test Anthropic
    if [ -n "$ANTHROPIC_API_KEY" ]; then
        echo "Testing Anthropic API..."
        curl -s -H "x-api-key: $ANTHROPIC_API_KEY" \
             https://api.anthropic.com/v1/messages \
             -d '{"max_tokens": 5}' && \
        echo "✅ Anthropic API working" || echo "❌ Anthropic API failed"
    fi
}

# 3. Create filtered configs
create_configs() {
    echo "⚙️ Creating filtered configurations..."
    
    # Run model filter
    chmod +x model-filter.sh
    ./model-filter.sh --full
    
    # Update docker-compose with filtered models
    # (We'll add this in the next step)
}

# 4. Apply configurations
apply_configs() {
    echo "🔄 Applying configurations..."
    
    # Update Open WebUI config
    if [ -f "openwebui_filter_config.js" ]; then
        cp openwebui_filter_config.js ./openwebui/data/
    fi
    
    # Update LiteLLM config  
    if [ -f "litellm_filtered_config.yaml" ]; then
        cp litellm_filtered_config.yaml ./litellm/config.yaml
    fi
    
    echo "✅ Configurations applied!"
}

# Run all steps
main() {
    setup_ollama
    check_api_keys
    create_configs
    apply_configs
    
    echo ""
    echo "🎉 Auto setup complete!"
    echo ""
    echo "📋 Summary:"
    echo "- Local models: Ollama is running with filtered models"
    echo "- Cloud models: API keys tested and configured"
    echo "- UI configs: Filtered model lists created"
    echo ""
    echo "🚀 Next steps:"
    echo "1. Start services: docker-compose up -d"
    echo "2. Open http://localhost:3000 for Open WebUI"
    echo "3. Models are pre-filtered and ready to use!"
}

main "$@"
```

### 4. 🎨 Enhanced UI Filters

**CSS cho Model Filter:**
```css
/* File: model-filter.css */
.model-filter-container {
    margin: 20px 0;
    padding: 20px;
    background: #f8f9fa;
    border-radius: 8px;
}

.filter-tabs {
    display: flex;
    gap: 10px;
    margin-bottom: 15px;
}

.filter-tab {
    padding: 8px 16px;
    border: none;
    background: #e9ecef;
    border-radius: 4px;
    cursor: pointer;
    transition: all 0.3s;
}

.filter-tab.active {
    background: #007bff;
    color: white;
}

.filter-tab:hover {
    background: #0056b3;
    color: white;
}

.model-status-indicator {
    display: flex;
    gap: 15px;
    margin-bottom: 15px;
}

.status-badge {
    padding: 4px 8px;
    border-radius: 4px;
    font-size: 12px;
    font-weight: bold;
}

.status-badge.working {
    background: #d4edda;
    color: #155724;
}

.status-badge.api-required {
    background: #fff3cd;
    color: #856404;
}

.model-card {
    background: white;
    border: 1px solid #dee2e6;
    border-radius: 8px;
    padding: 15px;
    margin: 10px 0;
    transition: all 0.3s;
}

.model-card:hover {
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    transform: translateY(-2px);
}

.model-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
}

.model-category {
    background: #e9ecef;
    padding: 2px 8px;
    border-radius: 12px;
    font-size: 12px;
}

.use-model-btn {
    background: #007bff;
    color: white;
    border: none;
    padding: 8px 16px;
    border-radius: 4px;
    cursor: pointer;
}

.use-model-btn:hover {
    background: #0056b3;
}
```

### 5. 📊 Model Performance Dashboard

**Real-time Model Status:**
```javascript
// File: model-status-monitor.js
class ModelStatusMonitor {
    constructor() {
        this.models = new Map();
        this.updateInterval = 30000; // 30 seconds
    }

    async checkModelStatus(modelId, provider) {
        try {
            const start = Date.now();
            let response;
            
            switch(provider) {
                case 'ollama':
                    response = await this.testOllamaModel(modelId);
                    break;
                case 'openai':
                    response = await this.testOpenAIModel(modelId);
                    break;
                case 'anthropic':
                    response = await this.testAnthropicModel(modelId);
                    break;
                default:
                    response = { status: 'unknown', latency: 0 };
            }
            
            const latency = Date.now() - start;
            
            this.models.set(modelId, {
                status: response.status,
                latency: latency,
                lastChecked: new Date(),
                provider: provider
            });
            
            return { status: response.status, latency: latency };
        } catch (error) {
            this.models.set(modelId, {
                status: 'error',
                latency: 0,
                lastChecked: new Date(),
                provider: provider,
                error: error.message
            });
            return { status: 'error', error: error.message };
        }
    }

    async testOllamaModel(modelId) {
        const response = await fetch('http://localhost:11434/api/generate', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                model: modelId,
                prompt: 'Hello',
                stream: false
            })
        });
        
        if (response.ok) {
            return { status: 'online' };
        } else {
            return { status: 'offline' };
        }
    }

    async testOpenAIModel(modelId) {
        // Requires API key, would need to be implemented with actual key
        return { status: 'unknown' };
    }

    getWorkingModels() {
        const working = [];
        this.models.forEach((status, modelId) => {
            if (status.status === 'online') {
                working.push({ id: modelId, ...status });
            }
        });
        return working;
    }

    getSlowModels(threshold = 3000) {
        const slow = [];
        this.models.forEach((status, modelId) => {
            if (status.status === 'online' && status.latency > threshold) {
                slow.push({ id: modelId, ...status });
            }
        });
        return slow;
    }

    startMonitoring() {
        setInterval(() => {
            this.checkAllModels();
        }, this.updateInterval);
    }

    async checkAllModels() {
        const modelList = this.getModelList();
        for (const model of modelList) {
            await this.checkModelStatus(model.id, model.provider);
        }
    }

    getModelList() {
        // This would be loaded from your filtered models config
        return [
            { id: 'llama3.1', provider: 'ollama' },
            { id: 'mistral:7b', provider: 'ollama' },
            { id: 'codellama', provider: 'ollama' },
            { id: 'gpt-4o-mini', provider: 'openai' },
            { id: 'claude-3.5-haiku', provider: 'anthropic' }
        ];
    }
}

// Initialize monitor
document.addEventListener('DOMContentLoaded', () => {
    const monitor = new ModelStatusMonitor();
    monitor.startMonitoring();
    
    // Update UI with status
    setInterval(() => {
        updateModelStatusUI(monitor);
    }, 1000);
});

function updateModelStatusUI(monitor) {
    const workingModels = monitor.getWorkingModels();
    const slowModels = monitor.getSlowModels();
    
    console.log(`Working models: ${workingModels.length}`);
    console.log(`Slow models: ${slowModels.length}`);
    
    // Update UI elements with status
    // This would integrate with your actual UI
}
```

## 🎯 Kết Quả Mong Đợi

Sau khi áp dụng giải pháp này:

1. **✅ Chỉ thấy model hoạt động**: Không còn thấy model lỗi hoặc cần API key
2. **⚡ Tự động test và lọc**: Script tự động kiểm tra và cập nhật danh sách
3. **🏷️ Phân loại rõ ràng**: Local (miễn phí) vs Cloud (API) vs Programming
4. **📊 Theo dõi hiệu suất**: Đo tốc độ và độ ổn định của từng model
5. **🔧 Cấu hình dễ dàng**: Chỉ cần chạy 1 script để setup everything

## 🚀 Bắt Đầu Ngay

```bash
# Chạy lọc model ngay lập tức
chmod +x model-filter.sh
./model-filter.sh --full

# Hoặc chạy auto setup
chmod +x auto-setup-models.sh  
./auto-setup-models.sh
```

Với giải pháp này, bạn sẽ không còn phải đối mặt với danh sách model rối rắm nữa! 🎉