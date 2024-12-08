#!/bin/sh
# ===============【請更改輸入帳號密碼】===============
DB_USER="root" # DB - User Root Account
# DB_PWD="bds316" # DB - User Root Password
DB_PWD="jms112" # DB - User Root Password
# --- helper _P.S. 協助 log 壓縮和套件升級。但不具備DB操作權限_ ---
DB_HELPER_ACCT="debian-sys-maint"
DB_HELPER_PWD="helper940"

# ===============【DataBase名稱】===============
DB_PATH="/home/ian/backend/db/" # DB路徑 切記要使用 *****/db/ 才能讀取內部文件
DB_NORMAL="database.sql" # (Schema+Data)
DB_ONLY_SCHEMA="schema.sql" # Schema Only

# ===============【Chroot部署指定SQL資料庫】===============
# 因為 chroot 下無法使用 mysql 指令，故需在此事先指定預安裝資料庫
# 1. Schema+Data: "database.sql"
# 2. Schema Only: "schema.sql"
DB_CHROOT_OPTION="2"