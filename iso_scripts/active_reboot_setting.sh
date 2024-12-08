
LOG_FILE="/opt/iso_build_settings/active_reboot_cron.log"
exec >> $LOG_FILE 2>&1
echo "Starting active_reboot_settings.sh at $(date)"

# ===============【建立開機執行程序區】===============
echo "=============== [active_reboot_settings] ==============="

echo "Waiting for 30 seconds to ensure all services are up..." >> $LOG_FILE
sleep 5

MISSION_DELAY_COUNT=5
echo '----------------------------------------------'
echo "|THIS MESSAGE WILL SELF-DESTRUCT IN ${MISSION_DELAY_COUNT} SECONDS|"
echo '----------------------------------------------'
echo '[MISSION: DESTROY MODE]  '
# echo -n '[MISSION: DESTROY MODE]  '

# while [[ "${BOOT_DELAY_COUNT}" -ge 0 ]]
# do
#     echo -ne "\b${BOOT_DELAY_COUNT}"
#     read -t 1
#     ((BOOT_DELAY_COUNT--))
# done

# echo "DETICTIVE extraction file "
# if [ -f "/home/mwg/mwg_prj.tar.gz" ]; then
#     echo "--------- UNPACK mwg_prj.tar.gz ---------" >> $LOG_FILE
#     cd /home/mwg
#     tar zxvf /home/mwg/mwg_prj.tar.gz >> $LOG_FILE 2>&1
#     if [ $? -eq 0 ]; then
#         echo "Extraction of mwg_prj.tar.gz succeeded at $(date)" >> $LOG_FILE
#         rm -rf /home/mwg/mwg_prj.tar.gz
#         echo "--------- REMOVE /home/mwg/mwg_prj.tar.gz ---------" >> $LOG_FILE
#     else
#         echo "Extraction of mwg_prj.tar.gz failed at $(date)" >> $LOG_FILE
#         exit 1
#     fi
# else
#     echo "/home/mwg/mwg_prj.tar.gz not found at $(date)" >> $LOG_FILE
# fi

# For mysql_secure_installation to execute only once
if [ ! -f "/opt/iso_build_settings/iso_build_process.log" ]; then
# if [ ! -f "/opt/iso_build_settings/active_db.conf" ]; then
    echo "--------- [START] SQL SETTINGS ---------"
    # --- rc.local改為crontab後，這部分可取消掉 ---
    # # 確保 service 和 環境設定跑完再運行以下指令，避免像 expect 裡 mysql 運行失敗 _P.S. 10秒 ok_
    sleep 10s

    # --- 回到iso build/iso_scripts執行目錄，進行以下操作 ---
    cd /opt/iso_build/iso_scripts;
    # 部署資料庫
    bash active_db.sh;
    # 部署service
    bash active_service.sh;
    # # 部署網路
    # bash active_net.sh;

    # --- 回到iso build執行目錄，進行以下操作 ---
    cd /opt/iso_build;
    # 進行active相關腳本 _P.S. 目前針對 修補程式/修改系統設定_
    bash main_iso_build_active_scripts.sh;

    # # 此步驟，是為了rc-local.service識別已進行過，避免反覆執行 active_reboot_settings
    #touch /opt/iso_build_settings/active_db.conf
    #echo "Database is already active." > /opt/iso_build_settings/active_db.conf
    touch /opt/iso_build_settings/iso_build_process.log
    echo "Starting Database." > /opt/iso_build_settings/iso_build_process.log
    echo "Starting Services." >> /opt/iso_build_settings/iso_build_process.log
    echo "Starting Network." >> /opt/iso_build_settings/iso_build_process.log
    echo "--------- [END] SQL SETTINGS ---------"
fi


# Clean up folders/files you no longer need
# if [ -d "/home/mwg/backend/db" ]; then
#     sudo rm -rf /home/mwg/backend/db
#     echo "--------- REMOVE backend db---------"
# fi

if [ -d "/etc/skel/backend" ]; then
    sudo rm -rf /etc/skel/backend
    echo "--------- REMOVE backend ---------"
fi


if [ -d "/opt/ian" ]; then
    sudo rm -rf /opt/ian
    echo "--------- REMOVE opt/ian project ---------"
fi

if [ -d "/opt/iso_build" ]; then
    sudo rm -rf /opt/iso_build
    echo "--------- REMOVE iso_build ---------"
fi

if [ -d "/opt/scripts" ]; then
    sudo rm -rf /opt/scripts
    echo "--------- REMOVE scripts ---------"
fi


# To prevent execution of admin.py features to fail
if [ -f "/etc/netplan/00-installer-config-wifi.yaml" ]; then
    sudo rm -rf /etc/netplan/00-installer-config-wifi.yaml
    echo "--------- REMOVE 00-installer-config-wifi.yaml ---------"
fi


# crontab/刪除的iso_build重開機腳本
sed -i '/^@reboot/d' /etc/crontab
# # FINAL CLEANING (務必放置最後執行) _P.S. 取消rc.local改由crontab操作_
# echo "--------- REMOVAL MISSION ---------"
# echo '#!/bin/sh
# exit 0' > /etc/rc.local

rm -f /opt/iso_build_settings/active_reboot_settings.sh

echo '[MISSION: COMPLETE DESTRUCTION]'

