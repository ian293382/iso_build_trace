# source  /opt/iso_build/conf/config_https.sh


# ===============【關閉全部Service】===============
echo "=============== [inactive_service] ==============="

echo "--------- SERVICE disable ---------";
sudo systemctl disable rsyslog
#For HTTP
sudo systemctl disable backend.service
sudo systemctl stop    backend.service


## postfix(電子郵件伺服器) - 停止運作和關閉開機啟動
sudo systemctl disable postfix
sudo systemctl stop    postfix