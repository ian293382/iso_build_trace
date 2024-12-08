#!/bin/bash

# 配置 MySQL 賬號和密碼
MYSQL_USER="root"
MYSQL_PASSWORD="jms112"
MYSQL_HOST="127.0.0.1"
MYSQL_PORT="3306"

# 要創建的數據庫名稱
DATABASE_NAME="BlogApplication"

# 要創建的表及其結構
TABLES=(
    "CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(50) UNIQUE NOT NULL
    );"
    "CREATE TABLE IF NOT EXISTS posts (
        id INT AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(100) NOT NULL,
        content TEXT NOT NULL,
        user_id INT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id)
    );"
)

# 檢查 MySQL 連接是否正常
mysqladmin -u $MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -P $MYSQL_PORT ping > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Unable to connect to MySQL server at $MYSQL_HOST:$MYSQL_PORT"
    exit 1
fi

echo "Connected to MySQL server at $MYSQL_HOST:$MYSQL_PORT"

# 創建數據庫
echo "Creating database $DATABASE_NAME..."
mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -P $MYSQL_PORT -e "CREATE DATABASE IF NOT EXISTS $DATABASE_NAME;"
if [ $? -ne 0 ]; then
    echo "Error: Failed to create database $DATABASE_NAME"
    exit 1
fi
echo "Database $DATABASE_NAME created or already exists."

# 創建表
echo "Creating tables in database $DATABASE_NAME..."
for TABLE_SCHEMA in "${TABLES[@]}"; do
    mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -P $MYSQL_PORT $DATABASE_NAME -e "$TABLE_SCHEMA"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to execute table schema: $TABLE_SCHEMA"
        exit 1
    fi
done
echo "All tables created successfully in database $DATABASE_NAME."

echo "MySQL setup completed."
