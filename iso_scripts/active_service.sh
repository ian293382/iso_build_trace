source  /opt/iso_build/conf/config_https.sh


# ===============【啟動全部Service】===============
echo "=============== [active_service] ==============="

# sudo systemctl daemon-reload

# systemctl status mosquitto.service
# systemctl status rsyslog


sudo systemctl enable  rsyslog
# sudo systemctl restart rsyslog
#For HTTP
sudo systemctl enable  backend.service
# sudo systemctl restart mwg_api.service

echo "--------- SERVICE RESTART ---------";
#For HTTPS 