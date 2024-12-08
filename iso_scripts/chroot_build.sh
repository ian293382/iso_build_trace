#!/bin/bash

echo "=============== [chroot_build_new] ==============="

# =============== [設定路徑] ===============
BACKEND_SRC="/opt/iso_build_trace/ref/backend"  # 源目錄
BACKEND_DEST="/opt/ian/backend"                 # 目標目錄
SKEL_DEST="/etc/skel"                           # 最終存放目錄

# =============== [檢查並準備目錄] ===============
echo "檢查目錄..."
if [ ! -d "$BACKEND_SRC" ]; then
    echo "錯誤：源目錄 $BACKEND_SRC 不存在！"
    exit 1
fi

echo "創建目標目錄 $BACKEND_DEST..."
mkdir -p "$BACKEND_DEST"

# =============== [複製文件到目標目錄] ===============
echo "複製文件從 $BACKEND_SRC 到 $BACKEND_DEST..."
cp -rp "$BACKEND_SRC/"* "$BACKEND_DEST"

# =============== [進入目錄並執行依賴安裝與打包] ===============
echo "切換到目標目錄 $BACKEND_DEST..."
cd "$BACKEND_DEST" || { echo "錯誤：無法進入目錄 $BACKEND_DEST"; exit 1; }

# 檢查打包腳本是否存在
BUILD_SCRIPT="./auto_build_config.sh"
if [ -f "$BUILD_SCRIPT" ]; then
    echo "找到打包腳本：$BUILD_SCRIPT"
else
    echo "錯誤：打包腳本 $BUILD_SCRIPT 不存在！"
    exit 1
fi

# 確保腳本可執行
chmod +x "$BUILD_SCRIPT"

# 安裝依賴
if [ -f "requirements.txt" ]; then
    echo "安裝依賴項..."
    pip install -r requirements.txt
else
    echo "警告：找不到 requirements.txt，跳過依賴安裝。"
fi

# 執行打包腳本
echo "執行打包腳本 $BUILD_SCRIPT..."
bash "$BUILD_SCRIPT" run_build
if [ $? -ne 0 ]; then
    echo "錯誤：打包過程中出現問題！"
    exit 1
fi

echo "打包完成。"

# =============== [複製結果到 /etc/skel] ===============
echo "將打包後的 backend 複製到 $SKEL_DEST..."
cp -rp "$BACKEND_DEST" "$SKEL_DEST"

echo "=============== [chroot_build_new 完成] ==============="
