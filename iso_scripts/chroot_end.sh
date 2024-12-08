#!/bin/bash

echo "=============== [chroot_end] ==============="

# ===============【清理系統檔案】===============
# 清理下載的暫存檔案
echo "清理暫存檔案..."
apt clean
apt autoremove -y

# ===============【取消所有掛載】===============
echo "取消掛載的系統目錄..."

# 確保 /proc, /sys, /dev 等目錄正確卸載
umount -lf /proc || echo "警告: /proc 無法卸載或已卸載"
umount -lf /sys || echo "警告: /sys 無法卸載或已卸載"
umount -lf /dev/pts || echo "警告: /dev/pts 無法卸載或已卸載"
umount -lf /dev || echo "警告: /dev 無法卸載或已卸載"

# 驗證掛載是否完全卸載
if mountpoint -q /proc; then
    echo "錯誤: /proc 未成功卸載"
fi

if mountpoint -q /sys; then
    echo "錯誤: /sys 未成功卸載"
fi

if mountpoint -q /dev/pts; then
    echo "錯誤: /dev/pts 未成功卸載"
fi

if mountpoint -q /dev; then
    echo "錯誤: /dev 未成功卸載"
fi

# ===============【退出 Chroot】===============
echo "退出 chroot 環境..."
# 手動輸入 exit 命令退出 chroot
