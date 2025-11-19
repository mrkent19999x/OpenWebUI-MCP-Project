#!/bin/bash
# ============================================
# SCRIPT SETUP NGROK CHO OPEN WEBUI
# Cipher tạo - Tự động setup ngrok
# ============================================

echo "🚀 SETUP NGROK CHO OPEN WEBUI"
echo ""

# Kiểm tra ngrok đã cài chưa
if ! command -v ngrok &> /dev/null; then
    echo "📦 Đang cài ngrok..."
    curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
    echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
    sudo apt update && sudo apt install -y ngrok
fi

echo "✅ Ngrok đã cài: $(ngrok version)"
echo ""

# Kiểm tra authtoken
if ! ngrok config check &> /dev/null; then
    echo "⚠️  Ngrok cần authtoken!"
    echo ""
    echo "📋 CÁCH LẤY AUTHTOKEN:"
    echo "   1. Vào: https://dashboard.ngrok.com/signup"
    echo "   2. Đăng ký (free)"
    echo "   3. Vào: https://dashboard.ngrok.com/get-started/your-authtoken"
    echo "   4. Copy authtoken"
    echo ""
    read -p "👉 Dán authtoken vào đây: " AUTHTOKEN
    
    if [ -n "$AUTHTOKEN" ]; then
        ngrok config add-authtoken "$AUTHTOKEN"
        echo "✅ Đã thêm authtoken!"
    else
        echo "❌ Không có authtoken, thoát..."
        exit 1
    fi
fi

# Dừng ngrok cũ nếu có
pkill ngrok 2>/dev/null
sleep 2

# Chạy ngrok
echo ""
echo "🚀 Đang chạy ngrok (port 7860)..."
echo ""

# Chạy ngrok ở background
nohup ngrok http 7860 --log=stdout > /tmp/ngrok.log 2>&1 &
NGROK_PID=$!

echo "✅ Ngrok đang chạy (PID: $NGROK_PID)"
echo ""

# Đợi ngrok khởi động
sleep 8

# Lấy link
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | python3 -c "import sys, json; data = json.load(sys.stdin); tunnels = data.get('tunnels', []); [print(t['public_url']) for t in tunnels if 'https' in t['public_url']]" 2>/dev/null | head -1)

if [ -n "$NGROK_URL" ]; then
    echo "✅ LINK NGROK:"
    echo ""
    echo "   $NGROK_URL"
    echo ""
    echo "📱 Truy cập từ mobile (bất kỳ đâu):"
    echo "   Mở trình duyệt → Dán link trên"
    echo ""
    echo "🔍 Dashboard ngrok:"
    echo "   http://localhost:4040"
    echo ""
    echo "💾 Lưu link vào file:"
    echo "$NGROK_URL" > /home/mrkent/openwebui-merged/ngrok-link.txt
    echo "   File: /home/mrkent/openwebui-merged/ngrok-link.txt"
    echo ""
    echo "🛑 Dừng ngrok:"
    echo "   pkill ngrok"
else
    echo "⚠️  Chưa lấy được link, đợi thêm..."
    echo "   Xem log: tail -f /tmp/ngrok.log"
fi

