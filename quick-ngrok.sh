#!/bin/bash
# ============================================
# QUICK SETUP NGROK - CHỈ CẦN PASTE TOKEN
# Cipher tạo - Dễ nhất cho anh
# ============================================

echo "🚀 QUICK SETUP NGROK"
echo ""
echo "📋 Anh mở Chrome, vào link này:"
echo "   https://dashboard.ngrok.com/get-started/your-authtoken"
echo ""
echo "👉 Copy authtoken (dạng: ngrok_xxxxx...)"
echo ""
read -p "👉 Dán token vào đây: " TOKEN

if [ -z "$TOKEN" ]; then
    echo "❌ Không có token, thoát..."
    exit 1
fi

echo ""
echo "⏳ Đang setup ngrok..."
ngrok config add-authtoken "$TOKEN" 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Đã setup ngrok thành công!"
    echo ""
    echo "🚀 Đang chạy ngrok (port 7860)..."
    echo ""
    
    # Dừng ngrok cũ nếu có
    pkill ngrok 2>/dev/null
    sleep 2
    
    # Chạy ngrok ở background
    nohup ngrok http 7860 --log=stdout > /tmp/ngrok.log 2>&1 &
    NGROK_PID=$!
    
    echo "✅ Ngrok đang chạy (PID: $NGROK_PID)"
    echo ""
    echo "⏳ Đợi 10 giây để ngrok khởi động..."
    sleep 10
    
    # Lấy link
    NGROK_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | python3 -c "import sys, json; data = json.load(sys.stdin); tunnels = data.get('tunnels', []); [print(t['public_url']) for t in tunnels if 'https' in t['public_url']]" 2>/dev/null | head -1)
    
    if [ -n "$NGROK_URL" ]; then
        echo ""
        echo "════════════════════════════════════════════════"
        echo "✅ LINK NGROK CHO ANH:"
        echo "════════════════════════════════════════════════"
        echo ""
        echo "   $NGROK_URL"
        echo ""
        echo "════════════════════════════════════════════════"
        echo ""
        echo "📱 Truy cập từ mobile (bất kỳ đâu):"
        echo "   Mở trình duyệt mobile → Dán link trên"
        echo ""
        echo "💾 Lưu link vào file:"
        echo "$NGROK_URL" > /home/mrkent/openwebui-merged/ngrok-link.txt
        echo "   File: /home/mrkent/openwebui-merged/ngrok-link.txt"
        echo ""
        echo "🔍 Dashboard ngrok:"
        echo "   http://localhost:4040"
        echo ""
        echo "🛑 Dừng ngrok:"
        echo "   pkill ngrok"
        echo ""
    else
        echo "⚠️  Chưa lấy được link, đợi thêm..."
        echo "   Xem log: tail -f /tmp/ngrok.log"
        echo "   Hoặc dashboard: http://localhost:4040"
    fi
else
    echo "❌ Lỗi setup ngrok, kiểm tra lại token"
    exit 1
fi

