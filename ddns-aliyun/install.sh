#!/bin/bash

# DDNS 安装脚本

if [ "$(id -u)" -ne 0 ]; then
    echo "请使用 root 权限运行此脚本"
    exit 1
fi

# 创建目录
mkdir -p /etc/ddns-aliyun
mkdir -p /var/cache/ddns-aliyun
chmod 700 /var/cache/ddns-aliyun

# 复制文件
cp ddns-aliyun.sh /usr/local/bin/ddns-aliyun
chmod +x /usr/local/bin/ddns-aliyun

# 配置文件
if [ ! -f "/etc/ddns-aliyun/config.ini" ]; then
    cp config.ini /etc/ddns-aliyun/config.ini
    echo "请先编辑配置文件: /etc/ddns-aliyun/config.ini"
fi

# 添加定时任务
(crontab -l 2>/dev/null; echo "* * * * * /usr/local/bin/ddns-aliyun") | crontab -

echo "安装完成"