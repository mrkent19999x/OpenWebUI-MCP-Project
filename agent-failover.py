"""
Agent Failover System - Tự động thay model khi hết
"""

import os
import json
import httpx
import asyncio
from typing import Dict, Any, Optional, List
from datetime import datetime

class LLMProvider:
    def __init__(self, config: Dict[str, Any]):
        self.name = config["name"]
        self.priority = config["priority"]
        self.enabled = config["enabled"]
        self.api_key = os.getenv(config["api_key_env"])
        self.base_url = config["base_url"]
        self.models = config["models"]
        self.rate_limit = config.get("rate_limit", {})
        self.timeout = config.get("timeout", 60)
        self.cost = config.get("cost", "PAID")
        self.quota_check = config.get("quota_check", False)
        self.last_error = None
        self.last_success = None
        self.error_count = 0
        
    async def check_quota(self) -> bool:
        """Kiểm tra quota còn không"""
        if not self.quota_check:
            return True
        
        # Check based on provider
        if self.name == "Groq":
            # Groq free tier: 30 req/min
            return True  # Assume available
        
        elif self.name == "OpenRouter":
            # Check daily limit
            return True  # Assume available
        
        elif self.name == "Together":
            # Check credits
            return True  # Assume available
        
        return True
    
    async def call(self, model: str, messages: List[Dict], **kwargs) -> Dict[str, Any]:
        """Gọi API"""
        if not self.api_key:
            raise ValueError(f"{self.name} API key not configured")
        
        if not await self.check_quota():
            raise ValueError(f"{self.name} quota exhausted")
        
        async with httpx.AsyncClient(timeout=self.timeout) as client:
            try:
                response = await client.post(
                    f"{self.base_url}/chat/completions",
                    headers={
                        "Authorization": f"Bearer {self.api_key}",
                        "Content-Type": "application/json"
                    },
                    json={
                        "model": model,
                        "messages": messages,
                        **kwargs
                    }
                )
                
                if response.status_code == 200:
                    self.last_success = datetime.now()
                    self.error_count = 0
                    return response.json()
                else:
                    self.last_error = f"HTTP {response.status_code}: {response.text}"
                    self.error_count += 1
                    raise Exception(self.last_error)
                    
            except Exception as e:
                self.last_error = str(e)
                self.error_count += 1
                raise

class PromptRouter:
    def __init__(self, config_path: str = "llm-providers-config.json"):
        with open(config_path, 'r') as f:
            self.config = json.load(f)
        
        # Initialize providers
        self.providers = {}
        for name, provider_config in self.config["llm_providers"].items():
            if provider_config.get("enabled", False):
                self.providers[name] = LLMProvider(provider_config)
        
        # Sort by priority
        self.providers = dict(sorted(
            self.providers.items(),
            key=lambda x: x[1].priority
        ))
    
    def detect_task_type(self, prompt: str) -> str:
        """Tự động phát hiện loại task từ prompt"""
        prompt_lower = prompt.lower()
        
        for task_type, rule in self.config["prompt_routing"]["rules"].items():
            keywords = rule.get("detection_keywords", [])
            for keyword in keywords:
                if keyword.lower() in prompt_lower:
                    return task_type
        
        return "general_chat"
    
    def get_providers_for_task(self, task_type: str) -> List[LLMProvider]:
        """Lấy danh sách providers phù hợp cho task"""
        if task_type not in self.config["prompt_routing"]["rules"]:
            task_type = "general_chat"
        
        rule = self.config["prompt_routing"]["rules"][task_type]
        provider_names = rule.get("providers", [])
        
        providers = []
        for name in provider_names:
            if name in self.providers:
                providers.append(self.providers[name])
        
        return providers
    
    def get_model_for_task(self, task_type: str, provider: LLMProvider) -> str:
        """Lấy model phù hợp cho task và provider"""
        if task_type not in self.config["prompt_routing"]["rules"]:
            task_type = "general_chat"
        
        rule = self.config["prompt_routing"]["rules"][task_type]
        preferred_models = rule.get("preferred_models", [])
        
        # Find matching model in provider's models
        for model_id in preferred_models:
            for model in provider.models:
                if model["id"] == model_id:
                    return model_id
        
        # Fallback to first available model
        if provider.models:
            return provider.models[0]["id"]
        
        return "auto"
    
    async def call_with_failover(
        self,
        prompt: str,
        task_type: Optional[str] = None,
        **kwargs
    ) -> Dict[str, Any]:
        """Gọi với auto failover"""
        # Auto-detect task type if not provided
        if not task_type:
            task_type = self.detect_task_type(prompt)
        
        # Get providers for this task
        providers = self.get_providers_for_task(task_type)
        
        if not providers:
            raise Exception("No providers available for this task")
        
        # Try each provider in order
        last_error = None
        for provider in providers:
            try:
                model = self.get_model_for_task(task_type, provider)
                messages = [{"role": "user", "content": prompt}]
                
                result = await provider.call(model, messages, **kwargs)
                
                return {
                    "success": True,
                    "provider": provider.name,
                    "model": model,
                    "task_type": task_type,
                    "result": result
                }
                
            except Exception as e:
                last_error = e
                print(f"⚠️ {provider.name} failed: {e}, trying next...")
                continue
        
        # All providers failed
        raise Exception(f"All providers failed. Last error: {last_error}")

# Usage example
async def main():
    router = PromptRouter()
    
    # Test với prompt khác nhau
    test_prompts = [
        "Tạo file test.py với code Python",
        "Chạy lệnh ls -la trong terminal",
        "Tạo project React mới",
        "Xin chào, bạn khỏe không?",
        "Tìm kiếm thông tin về Python"
    ]
    
    for prompt in test_prompts:
        try:
            result = await router.call_with_failover(prompt)
            print(f"✅ {prompt[:30]}... → {result['provider']} ({result['model']})")
        except Exception as e:
            print(f"❌ {prompt[:30]}... → Error: {e}")

if __name__ == "__main__":
    asyncio.run(main())
