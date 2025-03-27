#!/bin/bash

# DDNS 卸载脚本

# 加载 ddns-aliyun.sh 脚本
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
MAIN_SHELL="$SCRIPT_DIR/ddns-aliyun.sh"
source "$MAIN_SHELL"
load_config

# 删除日志目录
if [ -d "$LOG_FILE" ]; then
    rm -rf "$LOG_FILE"
    echo "日志目录 $LOG_FILE 已删除"
else
    echo "日志目录 $LOG_FILE 不存在，无需删除"
fi

# 删除缓存目录
if [ -e "$CACHE_DIR" ]; then
    rm -rf "$CACHE_DIR"
    echo "缓存目录 $CACHE_DIR 已删除"
else
    echo "缓存目录 $CACHE_DIR 不存在，无需删除"
fi

# 删除定时任务
crontab -l | grep -v "ddns-aliyun" | crontab -
echo "定时任务已删除"

echo "卸载完成"