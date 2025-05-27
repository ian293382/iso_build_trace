# ===============【新增新使用者】===============
NEW_USER="customer"
NEW_USER_PASSWORD="customer"

# 可以設定客製化密碼 當用戶以客戶帳戶登入時設定腳本

# ===============【時區預設】===============
TIME_ZONE="Asia/Taipei" # 預設時區

# ===============【系統預設】===============
UBUNTU_VERSION=$(lsb_release -rs 2>/dev/null)
IS_INSTALL_GUI=0
IS_ENCRYPTED=0

# ===============【系統預設 PORT】===============
declare -A PORT=(
    ["ssh"]=22                # 允許 ssh                  22    端口
    ["http_backend"]=8080     # 允許 HTTP/BackEnd         8080  端口
)
