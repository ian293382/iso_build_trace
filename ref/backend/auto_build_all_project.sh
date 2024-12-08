#!/bin/bash

# 確保配置文件存在
source ./auto_build_config.sh

# 循環遍歷所有定義的專案
for project_name in "${!PROJECT_PATHS[@]}"; do
    # 確認檔案存在再進行打包
    if [ ! -f "${PROJECT_PATHS[$project_name]}" ]; then
        echo "[INFO] Skipping $project_name because file does not exist."
        continue
    fi
    echo "[INFO] Building $project_name..."
    run_build "${PROJECT_PATHS[$project_name]}" "$project_name"
done
