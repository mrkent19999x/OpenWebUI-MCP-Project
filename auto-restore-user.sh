#!/bin/bash
# Script tự động khôi phục user khi database sẵn sàng

EMAIL="begau1302@gmail.com"
PASSWORD="admin123"
NAME="Admin"

echo "🔧 Đang chờ database sẵn sàng để khôi phục user: $EMAIL"

for i in {1..30}; do
    docker exec open-webui python3 << PYEOF 2>/dev/null
import sqlite3
import hashlib
import secrets
import os

db_path = '/app/backend/data/webui.db'
email = '$EMAIL'
password = '$PASSWORD'
name = '$NAME'

if os.path.exists(db_path):
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='users'")
    if cursor.fetchone():
        cursor.execute('SELECT email FROM users WHERE email=?', (email,))
        if cursor.fetchone():
            print('✅ User đã tồn tại')
        else:
            salt = secrets.token_hex(16)
            password_hash = hashlib.pbkdf2_hmac('sha256', password.encode(), salt.encode(), 100000).hex()
            cursor.execute('INSERT INTO users (email, password_hash, name, role, created_at, updated_at) VALUES (?, ?, ?, "admin", datetime("now"), datetime("now"))', 
                          (email, f'{salt}:{password_hash}', name))
            conn.commit()
            print('✅ Đã tạo user admin')
        
        cursor.execute('SELECT email, name, role FROM users WHERE email=?', (email,))
        user = cursor.fetchone()
        if user:
            print(f'Email: {user[0]} | Name: {user[1]} | Role: {user[2]}')
        
        conn.close()
PYEOF
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ THÔNG TIN ĐĂNG NHẬP:"
        echo "   Email: $EMAIL"
        echo "   Password: $PASSWORD"
        echo "   Role: admin"
        exit 0
    fi
    
    sleep 2
done

echo "⚠️  Chưa thể tạo user, vui lòng đăng ký qua web UI"
