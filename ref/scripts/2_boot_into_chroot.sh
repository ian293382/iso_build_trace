# ===============〖引進共用資料〗===============
. ./0_config # 等同 source ./conf/config_db.sh 跟source不同之處，可用sh驅動


# ===============〖切換chroot(準備開始進行iso內部部署)〗===============
# 解開linux系統目錄的squashfs檔
# (備註：unsquashfs filesystem.squashfs 是為了還原 linux boot下所有部署檔案目錄)
unsquashfs "./../${UNPACK_OUTPUT_FILENAME}/casper/filesystem.squashfs" 
mv squashfs-root "./../${UNPACK_OUTPUT_FILENAME}/casper/"

# 將下載的iso_build資料 copy squashfs-root/opt 下
cp -rp ./../iso_build_trace "./../${UNPACK_OUTPUT_FILENAME}/casper/squashfs-root/opt"

# 進入系統並切換
# (備註：將還原的 filesystem.squashfs(squashfs-root) 改為根目錄使用。這樣之後壓回filesystem.squashfs時，就可以儲存之前所有變動。)
chroot "./../${UNPACK_OUTPUT_FILENAME}/casper/squashfs-root"
