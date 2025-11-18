#!/bin/bash
# Script để integrate failover system vào OpenWebUI

set -e

echo "🔧 Integrating Agent Failover System..."

# Copy config files vào OpenWebUI volume
CONFIG_DIR="/workspace/config"
mkdir -p "$CONFIG_DIR"

# Copy LLM providers config
cp llm-providers-config.json "$CONFIG_DIR/"
cp code-execution-config.json "$CONFIG_DIR/"
cp agent-failover.py "$CONFIG_DIR/"

echo "✅ Config files copied to $CONFIG_DIR"

# Update docker-compose to mount config
echo ""
echo "📝 Note: Add volume mount to docker-compose.yml:"
echo "  volumes:"
echo "    - ./config:/app/config"
echo ""

echo "✅ Integration complete!"
echo ""
echo "🚀 Next steps:"
echo "  1. Điền API keys vào .env.persistent"
echo "  2. docker-compose up -d"
echo "  3. Test với prompts khác nhau"
