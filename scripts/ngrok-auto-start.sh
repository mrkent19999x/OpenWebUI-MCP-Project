#!/bin/bash
# ============================================
# SCRIPT TỰ ĐỘNG CHẠY NGROK KHI KHỞI ĐỘNG
# Cipher tạo - Ngrok tự động chạy 24/7
# ============================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_FILE="$PROJECT_DIR/ngrok-link.txt"
LOG_FILE="/tmp/ngrok.log"

echo "🚀 KIỂM TRA NGROK..."

# Kiểm tra ngrok đã cài chưa
if ! command -v ngrok &> /dev/null; then
    echo "❌ Ngrok chưa cài!"
    exit 1
fi

# Kiểm tra authtoken
if ! ngrok config check &> /dev/null; then
    echo "❌ Ngrok chưa có authtoken!"
    exit 1
fi

# Kiểm tra ngrok đã chạy chưa
if pgrep -f "ngrok http 7860" > /dev/null; then
    echo "✅ Ngrok đã đang chạy"
    
    # Lấy link hiện tại
    sleep 2
    NGROK_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | python3 -c "import sys, json; data = json.load(sys.stdin); tunnels = data.get('tunnels', []); [print(t['public_url']) for t in tunnels if 'https' in t['public_url']]" 2>/dev/null | head -1)
    
    if [ -n "$NGROK_URL" ]; then
        echo "📱 Link ngrok: $NGROK_URL"
        echo "$NGROK_URL" > "$OUTPUT_FILE"
    fi
    exit 0
fi

# Dừng ngrok cũ nếu có
echo "🛑 Dừng ngrok cũ..."
pkill ngrok 2>/dev/null
sleep 2

# Chạy ngrok
echo "🚀 Đang chạy ngrok (port 7860)..."
nohup ngrok http 7860 --log=stdout > "$LOG_FILE" 2>&1 &
NGROK_PID=$!

echo "✅ Ngrok đang chạy (PID: $NGROK_PID)"

# Đợi ngrok khởi động
sleep 5

# Lấy link
NGROK_URL=""
MAX_RETRIES=10
RETRY_COUNT=0

while [ -z "$NGROK_URL" ] && [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    sleep 2
    RETRY_COUNT=$((RETRY_COUNT + 1))
    
    API_RESPONSE=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null)
    if [ -n "$API_RESPONSE" ]; then
        NGROK_URL=$(echo "$API_RESPONSE" | python3 -c "import sys, json; data = json.load(sys.stdin); tunnels = data.get('tunnels', []); [print(t['public_url']) for t in tunnels if 'https' in t['public_url']]" 2>/dev/null | head -1)
    fi
done

if [ -n "$NGROK_URL" ]; then
    echo "✅ Link ngrok: $NGROK_URL"
    echo "$NGROK_URL" > "$OUTPUT_FILE"
    echo "💾 Đã lưu vào: $OUTPUT_FILE"
else
    echo "⚠️  Chưa lấy được link, xem log: tail -f $LOG_FILE"
fi

