# ISO_BUILD 流程
```plantxt

使用者目錄 /home/Ian
├─ tool:            放置欲iso build 檔案 (當前為 Ubuntu 20.04.06 乾淨版本)
├─ scripts:         腳本放置區 (從iso_build裡複製出來。之後所有流程都會在這個目錄下操作。)
│     └─ 0_config: 初始設定檔 (目前可能先不用 提區參數區域[優化後才會使用這個檔案])
├─ source-files:   還原iso內容的目錄
├─ output:         放置 iso_build完的 iso
└─ iso_build:      bitbucket download下來的iso build專案
```

## 準備作業

### user-data 製作
先弄加鹽   openssl rand -base64 12 => 6g/7n3VLrMFYMuE8
加密輸出   openssl passwd -6 -salt 6g/7n3VLrMFYMuE8 jms112 => 打進你的user-data裡面

- 進去工作區域(準備燒錄iso_build的東西)<br>
*(使用 1. `cd`  `cd~` 3.`cd /home/ian` 是一樣的意思)*
    - 去找我的git clone 這個專案下來 但是你看到這一篇的時候已經是我的專案了所以跳過這一個步驟吧<br>
    - 將部屬腳本複製出來我們將以ref作為主體開始進行iso部屬
        -  `cp -rp iso_build_trace/ref/scripts .`
    - 切換root 使用者
        - `sudo su `
    - **(這裡將會安裝 iso_build所有需求套件 如果你有執行過一次就不用在做)**<br>
    *(可以使用 `dkpg -l {xorr*,p7zip*,squashfs*}`) 查看內部套件是否都安裝*
        - `bash 0_install_pkgs.sh`
    -   工作區和user-data設定創造自動安裝部屬<br>
        _建立工作去  **tool**(放置原生地iso檔案) **output**(生成用於輸出後iso檔案)
        - `bash 1_iso_deploy.sh`
    -   切換chroot (進行iso內部部屬階段可以在內部寫入檔案 建立python專案位於此區)
        - `bash 2_boot_into_chroot.sh`

## Chroot 內部部屬階段
- 設定 config 檔案 
    - `cd /opt/iso_build/iso_scripts`
    - 這裡開始內部執行與設定
    - 部屬完離開 chroot
    - `exit`

## 回到原本系統後，壓回filesystem.squashfs並製作全新ISO

- `bash 3_burn.sh`<br>

# 待優化
  <!-- *(備註：之後若只是更動 **grub.cfg**、**txt.cfg**、**user-data**等非chroot下的檔案。可直接下`bash 3_1_burn_only.sh`單純燒錄就好)*
<!-- - 完成後，可在 output 目錄找到完成的iso檔。iso_build 即 --> -->



### 編輯 boot/grub/grub.cfg

#### 在 `set menu_color_highlight=black/light-gray` 和 `menuentry "Install Ubuntu Server" {` 之間，新增以下內容。

- set timeout=10: 代表十秒沒有選定，系統即會自動載入游標所在處的選單(即第一個)。
- linux	/casper/hwe-vmlinuz...:<br>
  *(備註：特別注意 ds=nocloud\;s=/cdrom/server/ 這行設定。它代表，系統會事先讀取 server 裡的 user-data 設定。)*
    - **傳統Legacy**
        - `quiet autoinstall ds=nocloud;s=/cdrom/server/ ---`
    - **UEFI** <br> 
       *(備註：需`特別注意分號;`UEFI 如無用跳脫字元會吃不到後面的設定)*
         - `quiet autoinstall ds=nocloud\;s=/cdrom/server/ ---`
    - **UEFI和傳統Legacy通用寫法** <br>
       *(備註：使用單引號包覆。理論: 可能在shell script 中 `單引號`包覆，`不論任何字元變數都會視為純字串輸出`。)*
         - `quiet autoinstall ds='nocloud\;s=/cdrom/server/' ---`

<br>

```bash
set timeout=10
menuentry "Autoinstall Server (HWE Kernel, NVIDIA, NetworkManager)" {
	set gfxpayload=keep
	linux	/casper/hwe-vmlinuz   quiet autoinstall ds='nocloud;s=/cdrom/server/' ---
	initrd	/casper/hwe-initrd
}
```

### 編輯 isolinux/txt.cfg

#### 在 `default ...` 和 `label live` 之間新增以下內容
- default autoinstall-server: 代表我預設載入選單為 autoinstall-server
- 基本上 menu label 和 menuentry 名稱內容相同

<br>

```bash
label autoinstall-server
  menu label ^Autoinstall Server (HWE Kernel, NVIDIA, NetworkManager)
  kernel /casper/hwe-vmlinuz
  append   initrd=/casper/hwe-initrd quiet autoinstall ds='nocloud;s=/cdrom/server/' ---
```

### 建置 user-data 和 meta-data 

- user-data: 為cloud-init，可參考 [ubuntu server/Automated Server Installs Config File Reference](https://ubuntu.com/server/docs/install/autoinstall-reference) 介紹，
- meta-data: 目前不知道在幹麼，需要存在，但內容空著 autoinstall 也能正常運行。
