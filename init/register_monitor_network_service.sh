#!/bin/bash

# 获取当前脚本的绝对路径 上级不传递路径使用
SCRIPT_DIR=$(cd "$(dirname "$1")" && pwd)

# 获取当前脚本的绝对路径 上级传递路径使用
# SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
echo "Script directory: $SCRIPT_DIR"


# 定义服务文件和脚本路径
SERVICE_FILE="$SCRIPT_DIR/services/network-monitor.service"
NETWORK_SCRIPT="$SCRIPT_DIR/sh/monitor_network.sh"

# 检查服务文件是否存在
if [ ! -f "$SERVICE_FILE" ]; then
    echo "Error: Service file not found at $SERVICE_FILE"
    exit 1
fi

# 检查监控脚本是否存在
if [ ! -f "$NETWORK_SCRIPT" ]; then
    echo "Error: Network monitor script not found at $NETWORK_SCRIPT"
    exit 1
fi

# 替换服务文件中的脚本路径
sed -i "s|ExecStart=.*|ExecStart=$NETWORK_SCRIPT|" "$SERVICE_FILE"

# 复制服务文件到系统目录
sudo cp "$SERVICE_FILE" /etc/systemd/system/network-monitor.service

# 重新加载systemd配置
sudo systemctl daemon-reload

# 启用并启动服务
sudo systemctl enable network-monitor.service
sudo systemctl start network-monitor.service

# 检查服务状态
echo "Service status:"
sudo systemctl status network-monitor.service