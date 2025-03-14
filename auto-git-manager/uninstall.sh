#!/bin/bash

# 卸载脚本

if [ "$(id -u)" -ne 0 ]; then
    echo "请使用root权限运行"
    exit 1
fi

# 删除文件
rm -f /usr/local/bin/auto-git-manager
rm -rf /etc/auto-git-manager

# 清除定时任务
crontab -l | grep -v "auto-git-manager" | crontab -

echo "卸载完成"