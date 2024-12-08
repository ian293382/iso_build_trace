#!/bin/bash

# 引入共用設定
source ./../conf/config_db.sh

echo "=============== [Active DB] ==============="

# 確保 MySQL 服務啟動
echo "啟動 MySQL 服務..."
sudo systemctl start mysql || { echo "MySQL 無法啟動！"; exit 1; }

# 執行 mysql_secure_installation 的自動化設置
echo "執行 mysql_secure_installation 配置..."
sudo mysql -u root -e "
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
"

# 檢查資料庫是否已存在
DB_EXIST=$(sudo mysql -u root -e "SHOW DATABASES LIKE 'BlogApplication';" | grep -c "BlogApplication")

if [ "$DB_EXIST" -eq 0 ]; then
    echo "建立資料庫 BlogApplication..."
    sudo mysql -u root -e "CREATE DATABASE BlogApplication;"
    echo "匯入資料庫結構和數據..."
    sudo mysql -u $DB_USER -p$DB_PWD BlogApplication < $DB_PATH$DB_NORMAL || { echo "匯入資料庫失敗！"; exit 1; }
else
    echo "資料庫 BlogApplication 已存在，跳過建立和匯入。"
fi

# 插入特定數據（可選）
echo "插入初始化數據..."
sudo mysql -u $DB_USER -p$DB_PWD -e "
USE BlogApplication;
INSERT INTO users (id, username) VALUES (NULL, 'ian') ON DUPLICATE KEY UPDATE username='ian';
INSERT INTO posts (id, title, content, user_id) VALUES (NULL, 'This is my first post', 'string', 1) ON DUPLICATE KEY UPDATE content='string';
"

# 開啟遠端登入權限，設定 root 密碼
echo "配置遠端登入和 root 密碼..."
sudo mysql -u root -e "
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_PWD';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' IDENTIFIED BY '$DB_PWD';
FLUSH PRIVILEGES;
"

echo "=============== [Database Setup 完成] ==============="
