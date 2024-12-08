#!/bin/bash

# ===============【配置參數】===============
SERVICE_NAME="backend.service"

# ===============【關閉服務】===============
echo "關閉服務 $SERVICE_NAME..."
systemctl stop "$SERVICE_NAME"

# 禁用服務開機自啟
echo "禁用服務開機自啟..."
systemctl disable "$SERVICE_NAME"

# 確認服務狀態
echo "檢查服務狀態..."
systemctl status "$SERVICE_NAME" --no-pager

echo "服務已關閉並禁用開機自啟。"
