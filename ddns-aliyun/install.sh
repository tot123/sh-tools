#!/bin/bash

# DDNS 安装脚本

# 检查是否已安装
SERVER_NUM=$(crontab -l | grep "ddns-aliyun"  | wc -l)
if [ $SERVER_NUM -gt 0 ]; then
    echo "定时任务已存在"
    exit 1
fi

# 加载 ddns-aliyun.sh 脚本
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
MAIN_SHELL="$SCRIPT_DIR/ddns-aliyun.sh"
source "$MAIN_SHELL"
# 调用 load_config 方法
load_config

# # 添加定时任务
(crontab -l 2>/dev/null; echo "*/10 * * * * /bin/bash $MAIN_SHELL") | crontab -

echo "安装完成"
log "INFO" "ddns-aliyun服务安装完成"