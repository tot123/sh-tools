#!/bin/bash
INIT_SLEEP=$(sed -n 's/^INIT_SLEEP=\(.*\)$/\1/p' config.ini)
TARGET_IP=$(sed -n 's/^TARGET_IP=\(.*\)$/\1/p' config.ini)
LOG_FILE=$(sed -n 's/^LOG_FILE=\(.*\)$/\1/p' config.ini)


# 等待5分钟（300秒）
sleep "$INIT_SLEEP"

# 目标测试地址（可以是可靠的公网地址，如谷歌DNS或百度）
TARGET_IP="$TARGET_IP"

# 日志文件路径
LOG_FILE="$LOG_FILE"

# 监控函数
monitor_network() {
    while true; do
        # 使用ping命令测试网络连通性，发送2个包，超时2秒
        ping -c 2 -W 2 $TARGET_IP > /dev/null 2>&1

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