#!/bin/bash

# ===============【配置參數】===============
SERVICE_NAME="backend.service"

# ===============【檢查服務狀態】===============
echo "檢查服務 $SERVICE_NAME 狀態..."
systemctl status "$SERVICE_NAME" --no-pager

# # 顯示啟動日誌
# echo "顯示最近的服務日誌..."
# journalctl -u "$SERVICE_NAME" --no-pager --since "1 hour ago"
