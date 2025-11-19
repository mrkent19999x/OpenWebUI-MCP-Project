#!/bin/bash
# ============================================
# SETUP NGROK TỰ ĐỘNG CHẠY KHI KHỞI ĐỘNG (SYSTEMD)
# Cipher tạo - Ngrok chạy 24/7 tự động
# ============================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
NGROK_SCRIPT="$SCRIPT_DIR/ngrok-auto-start.sh"
SERVICE_FILE="/etc/systemd/system/ngrok-openwebui.service"

echo "🚀 SETUP NGROK TỰ ĐỘNG CHẠY KHI KHỞI ĐỘNG"
echo ""

# Kiểm tra quyền root
if [ "$EUID" -ne 0 ]; then 
    echo "❌ Cần chạy với quyền root (sudo)"
    echo "👉 Chạy: sudo $0"
    exit 1
fi

# Kiểm tra ngrok script
if [ ! -f "$NGROK_SCRIPT" ]; then
    echo "❌ Không tìm thấy script: $NGROK_SCRIPT"
    exit 1
fi

# Tạo systemd service file
echo "📝 Tạo systemd service..."
cat > "$SERVICE_FILE" << EOF
[Unit]
Description=Ngrok tunnel for Open WebUI
After=network.target docker.service
Wants=network-online.target

[Service]
Type=simple
User=$SUDO_USER
WorkingDirectory=$PROJECT_DIR
ExecStart=$NGROK_SCRIPT
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

echo "✅ Đã tạo service file: $SERVICE_FILE"
echo ""

# Reload systemd
echo "🔄 Reload systemd..."
systemctl daemon-reload

# Enable service
echo "✅ Enable service (tự động chạy khi boot)..."
systemctl enable ngrok-openwebui.service

# Start service
echo "🚀 Start service..."
systemctl start ngrok-openwebui.service

# Kiểm tra status
sleep 3
echo ""
echo "📊 Status service:"
systemctl status ngrok-openwebui.service --no-pager | head -10

echo ""
echo "═══════════════════════════════════════"
echo "✅ ĐÃ SETUP XONG!"
echo "═══════════════════════════════════════"
echo ""
echo "📱 CÁC LỆNH QUẢN LÝ:"
echo ""
echo "   Xem status:"
echo "   sudo systemctl status ngrok-openwebui"
echo ""
echo "   Xem log:"
echo "   sudo journalctl -u ngrok-openwebui -f"
echo ""
echo "   Restart:"
echo "   sudo systemctl restart ngrok-openwebui"
echo ""
echo "   Stop:"
echo "   sudo systemctl stop ngrok-openwebui"
echo ""
echo "   Disable (tắt tự động chạy):"
echo "   sudo systemctl disable ngrok-openwebui"
echo ""
echo "📱 Link ngrok sẽ được lưu trong:"
echo "   $PROJECT_DIR/ngrok-link.txt"
echo ""

