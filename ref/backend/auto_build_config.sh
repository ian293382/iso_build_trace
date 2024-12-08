# [範本]
TEXT_TEMPLATE="# -*- mode: python ; coding: utf-8 -*-

block_cipher = None

a = Analysis(
    ['absolute_project_path'],
    pathex=['base_path'],
    binaries=[],
    datas=[('absolute_project_path', '.')],  # 將 main.py 文件加入 datas 中
    hiddenimports=[
         'fastapi',
        'h11',
        'pydantic',
        'sniffio',
        'starlette',
        'sqlalchemy',
        'uvicorn',
        'greenlet',
        'pymysql',
        'mysql.connector',
        'mysql.connector.plugins.mysql_native_password',  # 加入這個模塊
        'typing_extensions',
    ],
    hookspath=['.'],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[
        'pip._internal.utils.typing',
        'pydantic.typing',
        'pydantic.v1.typing',
        
    ],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)
pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='main',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
coll = COLLECT(
    exe,
    a.binaries,
    a.zipfiles,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='output_dist_name',
)

"


# [建置專案流程]

BASE_PATH=${1:-/home/ian};
AIDC_BACKEND_PATH="${BASE_PATH}/backend"
DIST_PATH="${BASE_PATH}/backend/dist"


# [專案路徑設定]
declare -A PROJECT_PATHS
PROJECT_PATHS["python_demo"]="${BASE_PATH}/backend/python_demo/main.py"

# [專案服務設定]
declare -A PROJECT_SERVICES
PROJECT_SERVICES["python_demo"]="web_backend"


# - $1: 專案絕對路徑 (e.g., /home/ian/backend/python_demo/main.py)
# - $2: 輸出dist目錄名稱 (e.g., python_demo)
function run_build() {
    # Step 1: 檢查 PyInstaller 是否安裝
    if pip show "pyinstaller" >/dev/null 2>&1; then
        echo "pyinstaller is already installed."
    else
        echo "pyinstaller is not installed. Installing..."
        sudo yes | pip3 install pyinstaller==5.13.0
    fi

    # Step 2: 初始化變量
    absolute_project_path=$1
    output_dist_name=$2

    echo "[DEBUG] absolute_project_path       : $absolute_project_path"
    echo "[DEBUG] output_dist_name            : $output_dist_name"

    # 檢查專案主文件是否存在
    if [ ! -f "$absolute_project_path" ]; then
        echo "[ERROR] No value found for \"$absolute_project_path\""
        return   # 強制停止當前函數繼續執行
    fi

    # Step 3: 設定專案路徑變量
    base_path=$(dirname "$absolute_project_path")
    file_name=$(basename "$absolute_project_path")
    file_name_without_extension="${file_name%.*}"

    echo "[DEBUG] base_path                   : $base_path"
    echo "[DEBUG] file_name                   : $file_name"
    echo "[DEBUG] file_name_without_extension : $file_name_without_extension"

    # Step 4: 清除之前已建立的 build / dist 內專案目錄
    echo "--- Cleaning previous builds ---"
    sudo rm -rf /home/ian/backend/{build,dist}/${output_dist_name}

    # Step 5: 清除之前已建立的 spec 檔
    echo "--- Removing old spec file ---"
    rm -f /home/ian/backend/${output_dist_name}.spec

    # Step 6: 使用 TEXT_TEMPLATE 生成新的 spec 文件
    echo "--- Generating new spec file ---"
    new_text=$TEXT_TEMPLATE
    new_text="$(echo "$new_text" | sed "s|absolute_project_path|${absolute_project_path}|g")"
    new_text="$(echo "$new_text" | sed "s|base_path|/home/ian/backend|g")"
    new_text="$(echo "$new_text" | sed "s|output_dist_name|${output_dist_name}|g")"

    # 將修改後的內容輸出到 spec 文件
    spec_file="/home/ian/backend/${output_dist_name}.spec"
    output_content "$new_text" "$spec_file"

    # Step 7: 執行 PyInstaller 打包
    echo "--- Running PyInstaller ---"
    sudo pyinstaller --distpath /home/ian/backend/dist "$spec_file"

    # Step 8: 解決 PyInstaller 打包 FastAPI 後啟動報錯的問題（如果是 FastAPI 專案）
    if [[ "$output_dist_name" =~ (^web_backend|^upgrade_gv_system_backend) ]]; then
        echo "--- Copying main.py to dist directory ---"
        cp "$absolute_project_path" "/home/ian/backend/dist/${output_dist_name}"
    fi

    # Step 9: 檢查打包結果並提供反饋
    if [ -d "/home/ian/backend/dist/${output_dist_name}" ]; then
        echo "[INFO] Build completed successfully. Output can be found in /home/ian/backend/dist/${output_dist_name}"
    else
        echo "[ERROR] Build failed. Please check logs for details."
    fi
}

# [輸出內容流程]
# - $1: 輸入內文
# - $2: 輸出檔案
function output_content() {
    import_context=$1
    output_file=$2
    echo "--- Outputting content to file ---"
    echo "[DEBUG] output_file: $output_file"

    # 檔案不存在時，會自動建立檔案
    if [ ! -f "$output_file" ]; then
        touch $output_file
    fi

    # 重置輸出檔案
    if [ -s "$output_file" ]; then
        rm -f "$output_file"
    fi

    # 輸出內文檔案
    while IFS='' read -r text; do
        echo "$text" >> "$output_file"
    done <<< "$import_context"
}
