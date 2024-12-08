# ===============〖安裝 iso build 全部需求套件〗===============
## 取得遠端更新伺服器的套件檔案清單
apt update 
## 安裝 解壓縮軟體工具 (備註：傳統mount iso會有不明原因導致autoinstall失敗的問題。故需用7-zip粹取出完整iso檔內容才能進行)
apt install p7zip-full -y
## 安裝 SquashFS 壓縮軟體工具 (備註：處理linux squashfs檔的專用套件，理論上7-zip套件應也可處理，但為求保險還是使用squashfs-tools。)
apt install squashfs-tools -y
## 安裝 燒錄工具 (備註：和 mksisofs、genisoimage一樣，但 xorriso 可燒錄出 UEFI/傳統BIOS混合式iso)
apt install xorriso -y
## 安裝 燒錄工具 (備註：xorriso 需藉由 genisoimage(mksisofs) 去驅動，所以仍需安裝 genisoimage)
apt install genisoimage -y
## 安裝 isolinux (備註：xorriso 缺少 /usr/lib/ISOLINUX/isohdpfx.bin 檔無法正常燒錄，故需要安裝此套件)
apt install isolinux  -y
## 安裝 cloud-init (備註：可驗證 user-data 格式是否正確。)
## 進入user-data的目錄下右邊這個指令 `cloud-init devel schema --config-file user-data` 格式正確會出現 `Valid cloud-config: user-data` 這個訊息
apt install cloud-init -y

