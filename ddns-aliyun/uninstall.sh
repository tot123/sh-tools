#!/bin/bash

# DDNS 卸载脚本

if [ "$(id -u)" -ne 0 ]; then
    echo "请使用 root 权限运行此脚本"
    exit 1
fi

# 删除文件
rm -f /usr/local/bin/ddns-aliyun
rm -rf /etc/ddns-aliyun
rm -rf /var/cache/ddns-aliyun

# 删除定时任务
crontab -l | grep -v "ddns-aliyun" | crontab -

echo "卸载完成"