#!/bin/bash

# 等待5分钟（300秒）
sleep 300

# 目标测试地址（可以是可靠的公网地址，如谷歌DNS或百度）
TARGET="8.8.8.8"

# 日志文件路径
LOG_FILE="/var/log/network_monitor.log"

# 监控函数
monitor_network() {
    while true; do
        # 使用ping命令测试网络连通性，发送2个包，超时2秒
        ping -c 2 -W 2 $TARGET > /dev/null 2>&1

        if [ $? -eq 0 ]; then
            # 网络正常
            echo "$(date): Network is up." >> $LOG_FILE
        else
            # 网络不可达，记录日志并执行关机命令
            echo "$(date): Network is down. Shutting down..." >> $LOG_FILE
            shutdown -h now
            exit 0
        fi

        # 等待60秒后再次检查
        sleep 60
    done
}

# 启动监控
# monitor_network