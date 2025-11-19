#!/bin/bash
# ============================================
# SCRIPT KHÔI PHỤC USER ADMIN
# Cipher tạo - Khôi phục user begau1302@gmail.com
# ============================================

EMAIL="begau1302@gmail.com"
PASSWORD="admin123"
NAME="Admin"

echo "🔧 Đang khôi phục user admin: $EMAIL"
echo ""

# Đợi database được tạo
DB_PATH="/app/backend/data/webui.db"
MAX_RETRIES=10
RETRY=0

while [ $RETRY -lt $MAX_RETRIES ]; do
    if docker exec open-webui test -f "$DB_PATH" 2>/dev/null; then
        echo "✅ Database đã tồn tại"
        break
    fi
    echo "⏳ Đợi database được tạo... ($RETRY/$MAX_RETRIES)"
    sleep 3
    RETRY=$((RETRY + 1))
done

if [ $RETRY -eq $MAX_RETRIES ]; then
    echo "⚠️  Database chưa được tạo, đợi thêm..."
fi

# Tạo/khôi phục user
docker exec open-webui python3 << PYEOF
import sqlite3
import hashlib
import secrets
import os
import time

db_path = '/app/backend/data/webui.db'
email = '$EMAIL'
password = '$PASSWORD'
name = '$NAME'

# Đợi database và bảng được tạo
max_wait = 30
waited = 0
while waited < max_wait:
    if os.path.exists(db_path):
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='users'")
        if cursor.fetchone():
            conn.close()
            break
        conn.close()
    time.sleep(1)
    waited += 1

if os.path.exists(db_path):
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    # Kiểm tra bảng users
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='users'")
    if cursor.fetchone():
        # Kiểm tra user
        cursor.execute('SELECT email, name, role FROM users WHERE email=?', (email,))
        user = cursor.fetchone()
        
        if user:
            print(f'✅ User đã tồn tại: {email}')
            # Update thành admin
            salt = secrets.token_hex(16)
            password_hash = hashlib.pbkdf2_hmac('sha256', password.encode(), salt.encode(), 100000).hex()
            cursor.execute('UPDATE users SET role=?, password_hash=?, name=? WHERE email=?', 
                          ('admin', f'{salt}:{password_hash}', name, email))
            conn.commit()
            print(f'✅ Đã khôi phục user admin')
        else:
            print(f'⚠️  Tạo user mới...')
            salt = secrets.token_hex(16)
            password_hash = hashlib.pbkdf2_hmac('sha256', password.encode(), salt.encode(), 100000).hex()
            cursor.execute('INSERT INTO users (email, password_hash, name, role, created_at, updated_at) VALUES (?, ?, ?, "admin", datetime("now"), datetime("now"))', 
                          (email, f'{salt}:{password_hash}', name))
            conn.commit()
            print(f'✅ Đã tạo user admin mới')
        
        # Liệt kê
        cursor.execute('SELECT email, name, role FROM users')
        users = cursor.fetchall()
        print('\n=== TẤT CẢ USERS ===')
        for u in users:
            print(f'Email: {u[0]} | Name: {u[1]} | Role: {u[2]}')
        
        conn.close()
        print(f'\n✅ THÔNG TIN ĐĂNG NHẬP:')
        print(f'   Email: {email}')
        print(f'   Password: {password}')
        print(f'   Role: admin')
    else:
        print('⚠️  Bảng users chưa tồn tại, đợi Open WebUI khởi tạo...')
        conn.close()
else:
    print('⚠️  Database chưa tồn tại, đợi Open WebUI tạo...')
PYEOF

echo ""
echo "✅ Hoàn tất!"

