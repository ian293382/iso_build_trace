#!/bin/bash

echo "=============== [chroot_end] ==============="

# ===============【清理系統檔案】===============
if command -v apt &>/dev/null; then
    echo "清理暫存檔案..."
    apt clean
    apt autoremove -y
else
    echo "警告: apt 命令不可用，跳過清理步驟"
fi

# ===============【取消所有掛載】===============
echo "取消掛載的系統目錄..."

# 定義函式來卸載掛載點
function unmount_if_mounted() {
    local mount_point=$1
    if mountpoint -q $mount_point; then
        umount -lf $mount_point || echo "警告: $mount_point 無法卸載或已卸載"
    fi
}

# 定義函式檢查掛載狀態
function check_unmount_status() {
    local mount_point=$1
    if mountpoint -q $mount_point; then
        echo "錯誤: $mount_point 未成功卸載"
    else
        echo "$mount_point 已成功卸載"
    fi
}

# 依次卸載掛載點
unmount_if_mounted /proc
unmount_if_mounted /sys
unmount_if_mounted /dev/pts
unmount_if_mounted /dev

# 驗證卸載結果
check_unmount_status /proc
check_unmount_status /sys
check_unmount_status /dev/pts
check_unmount_status /dev

# ===============【退出 Chroot】===============
echo "所有清理步驟完成，準備退出 chroot 環境。"
echo "請輸入 'exit' 來退出 chroot 環境。"
