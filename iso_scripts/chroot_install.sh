# source ./../conf/config_https.sh https 設定


# ===============【安裝專案相關執行套件】===============
echo "=============== [chroot_install] ==============="

## 取得遠端更新伺服器的套件檔案清單
sudo apt update

## 安裝 網路加密通訊工具(備註：ubuntu 20.04 server 已安裝預設，但desktop版沒有)
sudo apt install openssh-server -y --reinstall
## 可啟動 ifconfig & netstat 相關指令套件 (常用指令：`netstat -plutn` 可查詢port是否有LISTEN)
sudo apt install net-tools -y --reinstall
## 可啟動 iwconfig 相關指令套件
sudo apt install wireless-tools -y --reinstall
## 自動化輸入 套件 (DB 自動化建立會用到)
sudo apt install expect -y --reinstall
## 安裝 Python 套件管理工具
sudo apt install python3-pip -y
## 安裝 mosquitto(MQTT) 工具
sudo apt install mosquitto -y --reinstall
sudo apt install mosquitto-clients -y --reinstall
## 安裝 Ubuntu Wifi 網卡WPA 連線設定
sudo apt install wpasupplicant -y --reinstall
# ## 安裝 nodeJS 14.x (移除之前版本->下載新版本->安裝新版本)前端工具
# sudo apt remove nodejs -y
# curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
# sudo apt install nodejs -y

# # https套件
# # 安裝Certbot/python3-certbot-nginx套件。
# sudo apt-get install certbot python3-certbot-nginx -y
# if [ "$IS_HTTPS" == 1 ]; then
#     sudo systemctl enable nginx.service
# else
#     sudo systemctl disable nginx.service
# fi
# sudo systemctl stop nginx.service


# 更新Python管理套件的工具
sudo python3 -m pip3 install --upgrade pip

# 安裝 後端加密套件 _P.S. pyinstaller最新版本6.1.0加密完成會影響service配置，故鎖版_
sudo yes | pip3 install pyinstaller==5.13.0

## 安裝 資料庫相關套件
sudo apt install mariadb-server -y
## 安裝 Python 連結資料庫套件
sudo yes | pip3 install mysql-connector-python==8.2.0

## 安裝 upgrade_gv_system/檔案串流套件版本更新動態套件
sudo yes | pip3 install streaming-form-data==1.13.0

## 安裝虛擬 環境版本控制庫 
sudo apt install python3-venv