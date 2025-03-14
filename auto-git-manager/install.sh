#!/bin/bash

CONFIG_FILE="/etc/auto-git-manager/config.ini"
# 初始化配置
init_log() {
    source <(grep = "$CONFIG_FILE" | sed 's/ *= */=/g')
}
# 安装脚本
if [ "$(id -u)" -ne 0 ]; then
    echo "请使用root权限运行"
    exit 1
fi

# 创建目录
mkdir -p /etc/auto-git-manager
mkdir -p /var/log/auto-git-manager

# 复制文件
cp auto-git-manager.sh /usr/local/bin/auto-git-manager
chmod +x /usr/local/bin/auto-git-manager

# 配置文件
if [ ! -f "/etc/auto-git-manager/config.ini" ]; then
    cp config.ini.example /etc/auto-git-manager/config.ini
    chmod 600 /etc/auto-git-manager/config.ini
    echo "请编辑配置文件：/etc/auto-git-manager/config.ini"
fi

# 添加定时任务
(crontab -l 2>/dev/null; echo "$EXPRESSION /usr/local/bin/auto-git-manager") | crontab -

echo "安装完成"