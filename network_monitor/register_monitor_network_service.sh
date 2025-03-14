#!/bin/bash
# TARGET_SERVICE_FILE="/etc/systemd/system/network-monitor.service"
################################## SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "=========Script directory: $SCRIPT_DIR"


# 如果没有父进程传递值，则使用默认值
if [ ! -f "$SOURCE_FILE" ]; then
    SOURCE_FILE="$SCRIPT_DIR/config.ini"
fi

echo "==Script directory: $SOURCE_FILE"
TARGET_SERVICE_FILE=$(sed -n 's/^TARGET_SERVICE_FILE=\(.*\)$/\1/p' $SOURCE_FILE)
# 获取当前脚本所在的文件夹路径的父级路径 绝对路径
# case:
#      sh ~/home/network_monitor/register_monitor_network_service.sh
# return: 
#      ~/home/

# SCRIPT_DIR=$(cd "$(dirname "$1")" && pwd)



# 获取当前脚本所在的文件夹路径 绝对路径
# case:
#      sh ~/home/network_monitor/register_monitor_network_service.sh
# return: 
#      ~/home/network_monitor
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
echo "Script directory: $SCRIPT_DIR"


# 定义服务文件和脚本路径
SERVICE_FILE="$SCRIPT_DIR/network-monitor.service"
NETWORK_SCRIPT="$SCRIPT_DIR/monitor_network.sh"

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
echo "========================="
# 复制服务文件到系统目录
sudo cp "$SERVICE_FILE" "$TARGET_SERVICE_FILE" 

# 重新加载systemd配置
sudo systemctl daemon-reload

# 启用并启动服务
sudo systemctl enable network-monitor.service
sudo systemctl start network-monitor.service

# 检查服务状态
echo "Service status:"
sudo systemctl status network-monitor.service