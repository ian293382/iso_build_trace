#!/bin/bash

# ===============〖引進共用資料〗===============
. ./0_config # 加載共用配置

# ===============〖準備解壓並切換chroot環境〗===============
# 解壓前檢查並清理目標目錄
if [ -d "squashfs-root" ]; then
    echo "清理殘留的 squashfs-root 目錄..."
    rm -rf squashfs-root || { echo "無法刪除 squashfs-root，請手動檢查"; exit 1; }
fi

echo "解壓 filesystem.squashfs..."
unsquashfs "./../${UNPACK_OUTPUT_FILENAME}/casper/filesystem.squashfs" || { echo "解壓失敗"; exit 1; }

# 確保目標目錄無殘留
if [ -d "./../${UNPACK_OUTPUT_FILENAME}/casper/squashfs-root" ]; then
    echo "清理殘留目錄..."
    rm -rf "./../${UNPACK_OUTPUT_FILENAME}/casper/squashfs-root" || { echo "清理失敗"; exit 1; }
fi

echo "移動解壓目錄..."
mv squashfs-root "./../${UNPACK_OUTPUT_FILENAME}/casper/" || { echo "移動解壓目錄失敗"; exit 1; }

# 複製資源文件到解壓目錄
echo "複製 iso_build 資料至目標目錄..."
cp -rp ./../iso_build_trace "./../${UNPACK_OUTPUT_FILENAME}/casper/squashfs-root/opt" || { echo "複製資料失敗"; exit 1; }

# ===============〖進入chroot環境〗===============
echo "準備進入 chroot 環境..."
if [ ! -f "./../${UNPACK_OUTPUT_FILENAME}/casper/squashfs-root/bin/bash" ]; then
    echo "錯誤: /bin/bash 不存在，解壓可能失敗"
    exit 1
fi

chroot "./../${UNPACK_OUTPUT_FILENAME}/casper/squashfs-root" /bin/bash || { echo "進入 chroot 環境失敗"; exit 1; }

echo "chroot 部署完成"

# 可能會失敗 用下面進行查詢還有沒有重複 掛載 
# mount | grep squashfs-root
# 解除掛載
# umount -lf /home/ian/source-files/casper/squashfs-root/dev/pts 
