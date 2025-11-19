#!/bin/bash
# ============================================
# SCRIPT CHẠY NGROK ĐƠN GIẢN
# Cipher tạo - Chạy ngrok để truy cập từ mạng ngoài
# ============================================

# Lấy thư mục hiện tại (tự động)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_FILE="$SCRIPT_DIR/ngrok-link.txt"

echo "🚀 ĐANG CHẠY NGROK..."
echo ""

# Kiểm tra ngrok đã cài chưa
if ! command -v ngrok &> /dev/null; then
    echo "❌ Ngrok chưa cài!"
    echo "👉 Chạy: ./setup-ngrok.sh để cài ngrok trước"
    exit 1
fi

# Kiểm tra python3 có sẵn không (cần để lấy link)
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 chưa cài!"
    echo "👉 Cần python3 để lấy link ngrok"
    exit 1
fi

# Kiểm tra authtoken
if ! ngrok config check &> /dev/null; then
    echo "❌ Ngrok chưa có authtoken!"
    echo "👉 Chạy: ./setup-ngrok.sh để setup authtoken"
    exit 1
fi

# Dừng ngrok cũ nếu có
echo "🛑 Dừng ngrok cũ (nếu có)..."
pkill ngrok 2>/dev/null
sleep 2

# Chạy ngrok
echo "🚀 Đang chạy ngrok (port 7860)..."
echo ""

# Chạy ngrok ở background
nohup ngrok http 7860 --log=stdout > /tmp/ngrok.log 2>&1 &
NGROK_PID=$!

echo "✅ Ngrok đang chạy (PID: $NGROK_PID)"
echo ""

# Kiểm tra ngrok có chạy thành công không
sleep 2
if ! kill -0 $NGROK_PID 2>/dev/null; then
    echo "❌ Ngrok không chạy được! Xem log: tail -f /tmp/ngrok.log"
    exit 1
fi

# Đợi ngrok khởi động và lấy link (thử nhiều lần)
echo "⏳ Đợi ngrok khởi động..."
NGROK_URL=""
MAX_RETRIES=5
RETRY_COUNT=0

while [ -z "$NGROK_URL" ] && [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    sleep 2
    RETRY_COUNT=$((RETRY_COUNT + 1))
    echo "   Thử lấy link lần $RETRY_COUNT/$MAX_RETRIES..."
    
    # Lấy link từ API ngrok
    API_RESPONSE=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null)
    if [ -n "$API_RESPONSE" ]; then
        NGROK_URL=$(echo "$API_RESPONSE" | python3 -c "import sys, json; data = json.load(sys.stdin); tunnels = data.get('tunnels', []); [print(t['public_url']) for t in tunnels if 'https' in t['public_url']]" 2>/dev/null | head -1)
    fi
done

echo ""

if [ -n "$NGROK_URL" ]; then
    echo ""
    echo "═══════════════════════════════════════"
    echo "✅ LINK NGROK CỦA ANH:"
    echo "═══════════════════════════════════════"
    echo ""
    echo "   $NGROK_URL"
    echo ""
    echo "═══════════════════════════════════════"
    echo ""
    echo "📱 CÁCH DÙNG:"
    echo "   1. Copy link trên"
    echo "   2. Mở trình duyệt trên máy/mobile khác"
    echo "   3. Dán link vào → Enter"
    echo "   4. Truy cập được OpenWebUI từ bất kỳ đâu!"
    echo ""
    echo "🔍 Dashboard ngrok (xem thông tin):"
    echo "   http://localhost:4040"
    echo ""
    echo "💾 Link đã lưu vào file:"
    echo "   $OUTPUT_FILE"
    echo ""
    echo "🛑 Dừng ngrok:"
    echo "   pkill ngrok"
    echo ""
    
    # Lưu link vào file (tự động tạo thư mục nếu cần)
    mkdir -p "$(dirname "$OUTPUT_FILE")"
    echo "$NGROK_URL" > "$OUTPUT_FILE"
    echo "✅ Đã lưu link!"
else
    echo ""
    echo "⚠️  Chưa lấy được link ngay, đợi thêm..."
    echo "   Xem log: tail -f /tmp/ngrok.log"
    echo "   Hoặc vào: http://localhost:4040 để xem link"
    echo ""
fi

