#!/bin/bash

# ===============【配置參數】===============
SERVICE_NAME="backend.service"
SERVICE_SRC="/home/ian/backend/services/$SERVICE_NAME"
SERVICE_DEST="/etc/systemd/system/$SERVICE_NAME"
EXECUTABLE_PATH="/home/ian/backend/dist/python_demo/main"
LOG_FILE="/var/log/backend.log"

# ===============【檢查與準備】===============
# 確保服務文件存在
if [ ! -f "$SERVICE_SRC" ]; then
    echo "錯誤: 找不到服務文件 $SERVICE_SRC"
    exit 1
fi

# 確保執行檔存在
if [ ! -f "$EXECUTABLE_PATH" ]; then
    echo "錯誤: 找不到執行檔 $EXECUTABLE_PATH"
    exit 1
fi

# 確保執行檔具備執行權限
chmod +x "$EXECUTABLE_PATH"

# 確保日誌文件存在並可寫入
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
fi
chmod 666 "$LOG_FILE"

# ===============【部署服務】===============
echo "部署服務文件到 $SERVICE_DEST..."
cp "$SERVICE_SRC" "$SERVICE_DEST"

# 重新加載 systemd 配置
echo "重新加載 systemd 配置..."
systemctl daemon-reload

# 啟用服務開機自啟
echo "設置服務開機自啟..."
systemctl enable "$SERVICE_NAME"

# 啟動服務
echo "啟動服務..."
systemctl start "$SERVICE_NAME"

# 檢查服務狀態
echo "檢查服務狀態..."
systemctl status "$SERVICE_NAME" --no-pager

echo "服務部署完成並已啟動。"
