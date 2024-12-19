# ===============〖引進共用資料〗===============
. ./0_config # 等同 source ./conf/config_db.sh 跟source不同之處，可用sh驅動


# ===============〖回到原本系統後，壓回filesystem.squashfs並製作全新ISO〗===============
## 刪除原本的 filesystem.squashfs 檔
## 再將客製完的squashfs-root，壓成 filesystem.squashfs，把原本的取代掉。
echo "--------- [3_burn] REMAKE filesystem.squashfs ---------"
mksquashfs ./../${UNPACK_OUTPUT_FILENAME}/casper/squashfs-root ./../${UNPACK_OUTPUT_FILENAME}/casper/filesystem.squashfs

## 壓完再把用不到squashfs-root刪除掉，以免佔空間。
echo "--------- [3_burn] REMOVE squashfs-root ---------"
rm -rf ./../${UNPACK_OUTPUT_FILENAME}/casper/squashfs-root

## (可省略) 重新計算filesystem.size 為了看是否到達4GB 而造成FAIL
# printf $(du -sx --block-size 1 squashfs-root |cut -f1) > ../casper/filesystem.size

## 製作 md5sum.txt 內容 _P.S. 安裝時給系統核對時使用，但實際測試即便內容為空iso_build還是可以順利運行。_
## md5sum.txt直接從isocopy出來
# echo "--------- [3_burn] GENERATE MD5 CHECKSUM FOR ALL FILES ---------"
# find ./../${UNPACK_OUTPUT_FILENAME} -type f -print0 | xargs -0 md5sum | grep -v isolinux/boot.cat | tee ./../${UNPACK_OUTPUT_FILENAME}/md5sum.txt
echo "--------- [3_burn] CLEAN UP THE md5sum.txt ---------"
echo > ./../${UNPACK_OUTPUT_FILENAME}/md5sum.txt
# echo "--------- [3_burn] COPY THE md5sum.txt ---------"
# cp -p ./../iso_build/ref/md5sum.txt ./../${UNPACK_OUTPUT_FILENAME}


# ---------〖燒錄ISO〗---------

## 1. 傳統燒錄
# mkisofs -D -r -V $OUTPUT_COVER_FILENAME -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o "../4.0test_${TIME}_MKI.iso" .
## 2. 傳統燒錄有含UEFI配置
# genisoimage -quiet -D -r -V $OUTPUT_COVER_FILENAME

echo "--------- [3_burn] BURNING AN ISO IMAGE ---------"
cd ./../${UNPACK_OUTPUT_FILENAME}

xorriso -as mkisofs -r \
  -iso-level 3 \
  -V $OUTPUT_COVER_FILENAME \
  -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot \
  -boot-load-size 4 -boot-info-table \
  -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot \
  -isohybrid-gpt-basdat -isohybrid-apm-hfsplus \
  -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
  -o ../output/4.0test_${TIME}_XOR.iso \
  ./boot . \
  -x ./sys -x ./proc -x ./dev -x ./tmp
