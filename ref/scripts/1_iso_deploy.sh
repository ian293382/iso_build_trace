
# # ===============〖引進共用資料〗===============
. ./0_config # 等同 source 跟source不同之處，可用sh驅動


# ===============〖工作區和Autoinstall部署〗===============
# (此步驟非必要做_若輸出檔案想保留請將下面指令註解掉) 清除之前不需要檔案 source-files、output/4.0test*
echo "--------- [1_iso_deploy] REMOVE output/4.0test*, $UNPACK_OUTPUT_FILENAME ---------"
rm -rf ../{output/4.0test*,$UNPACK_OUTPUT_FILENAME}


# 建立工作區並改變使用者為mwg (備註：tool(放置原生iso檔) output(放置輸出後的iso檔))
mkdir -p ../{tool,output}; chown ian ../{tool,output}

# 下載 ubuntu server 20.04.x 版的iso。(也可以從現有硬碟使用 Filezilla 傳輸)
function downloadSelectMenu() {
    echo "Please download images from list of urls:"
    options=(
        "ubuntu (國外穏定網站)"
        "ubuntu-tw (ubuntu台灣)"
        "nctu (交通大學)"
        "nchc (國家高速網路與計算中心) 私心推薦download最快！"
    )

    select opt in "${options[@]}": 
    do
    case $REPLY in
        1)  
            # wget 'https://releases.ubuntu.com/focal/ubuntu-20.04.6-live-server-amd64.iso'
            wget $DOWNLOAD_STABLE_URL
            break
        ;;
        2)
            # wget https://ftp.ubuntu-tw.org/ubuntu-releases/20.04.4/ubuntu-20.04.4-live-server-amd64.iso
            wget $DOWNLOAD_URL_UBUNTU_TW
            break
        ;;
        3)
            # wget http://ubuntu.cs.nctu.edu.tw/ubuntu-release/20.04.4/ubuntu-20.04.4-live-server-amd64.iso
            wget $DOWNLOAD_URL_NCTU_TW
            break
        ;;
        4)
            # wget https://free.nchc.org.tw/ubuntu-cd/20.04.4/ubuntu-20.04.4-live-server-amd64.iso
            wget $DOWNLOAD_URL_NCHC_TW
            break
        ;;
        *) echo "please choose 1-3"
        ;;
    esac
    done
}

# if [ ! -f "./../tool/${INSTALL_ISO_FILENAME}" ]; then # ERROR: 字串無法順利讀取到路徑檔案存在與否
if [ ! -f ./../tool/${INSTALL_ISO_FILENAME} ]; then # 會檢查目錄是否有*.iso存在。沒有就會進行自動下載
    downloadSelectMenu
else
    # echo "--------- THE FILE EXISTS ---------"
    read -p "File already exists. Do you want to download it again? (y/n)" isDownloadAgain
    isDownloadAgain=${isDownloadAgain:-n} # 預設值為 n
    isDownloadAgainToLowercase=${isDownloadAgain,,} # 將值轉為小寫

    if [ $isDownloadAgainToLowercase == y ]; then
        # ---------〖重新下載iso〗---------
        rm -f ./../tool/${INSTALL_ISO_FILENAME}
        downloadSelectMenu
    fi
fi


# 移動下載完的iso移到tool目錄下
mv *.iso ./../tool

# 完全粹取出該iso檔案後，再進行移除source-files/[BOOT]目錄的動作
7z -y x "./../tool/${INSTALL_ISO_FILENAME}" -o"./../${UNPACK_OUTPUT_FILENAME}" && rm -rf "./../${UNPACK_OUTPUT_FILENAME}/[BOOT]/"

# Ubuntu: Cloud-init 與 autoinstall 配置

echo "Please select the mode to set GRUB boot:"
options=(
    "Legacy"
    "UEFI"
    "(TEST PHASE) UEFI"
)

select opt in "${options[@]}": 
do
case $REPLY in
    1)
        cp -p ./../iso_build_trace/ref/Boot_Legacy/grub.cfg "./../${UNPACK_OUTPUT_FILENAME}/boot/grub/grub.cfg"
        cp -p ./../iso_build_trace/ref/Boot_Legacy/txt.cfg "./../${UNPACK_OUTPUT_FILENAME}/isolinux/txt.cfg"
        break
    ;;
    2)
        cp -p ./../iso_build_trace/ref/Boot_UEFI/grub.cfg "./../${UNPACK_OUTPUT_FILENAME}/boot/grub/grub.cfg"
        cp -p ./../iso_build_trace/ref/Boot_UEFI/txt.cfg "./../${UNPACK_OUTPUT_FILENAME}/isolinux/txt.cfg"
        break
    ;;
    3)
        cp -p ./../iso_build_trace/ref/Boot_UEFI_Test_Phase/grub.cfg "./../${UNPACK_OUTPUT_FILENAME}/boot/grub/grub.cfg"
        cp -p ./../iso_build_trace/ref/Boot_UEFI_Test_Phase/txt.cfg "./../${UNPACK_OUTPUT_FILENAME}/isolinux/txt.cfg"
        break
    ;;
    *) echo "please choose 1-3"
    ;;
esac
done

# 將燒錄的腳本複製到 /home/mwg/
echo "--------- [1_iso_deploy] COPY THE ${AUTOINSTALL_FILENAME} TO $UNPACK_OUTPUT_FILENAME ---------"
cp -rp "./../iso_build_trace/ref/${AUTOINSTALL_FILENAME}" "./../${UNPACK_OUTPUT_FILENAME}"

# 假如目錄名稱不是 server 則系統自動更改為 server
if [ $AUTOINSTALL_FILENAME != "server" ]; then
    mv "./../${UNPACK_OUTPUT_FILENAME}/${AUTOINSTALL_FILENAME}" "./../${UNPACK_OUTPUT_FILENAME}/server"    
fi

# 此處為解決離線安裝出現 FAIL: installing kernel 的問題
# 掛接 ubuntu-20.04.5-live-server-amd64.iso 
# 發現 /pool/main/l/linux-hwe-5.15 發現 linux-modules-extra-5.15.0-46-generic_5.15.0-46.49~20.04.1_am.deb 因檔名問題導致 kernel 安裝失敗
# 這是因為7z在解壓縮iso時，若檔名超過64個字元，會導致檔名無法完整呈現。
# 故此處把 _am.deb 檔名 _amd64.deb 即可正常安裝
echo "--------- [1_iso_deploy] MODIFY FILENAME ---------"
LINUX_HWE_PATH=./../${UNPACK_OUTPUT_FILENAME}/pool/main/l/linux-hwe-5.15/*
for path in $LINUX_HWE_PATH; do 
    if [[ $path =~ _am\.deb ]]; then
        rename.ul "_am.deb" "_amd64.deb" $path
    fi
done