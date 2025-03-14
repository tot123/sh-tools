#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
SOURCE_FILE="$SCRIPT_DIR/config.ini"
echo "Script directory: $SOURCE_FILE"

source "$SOURCE_FILE"  # 读取配置

INIT_SCRIPT="$SCRIPT_DIR/register_monitor_network_service.sh"

if [ ! -f "$INIT_SCRIPT" ]; then
    echo "Error: register_monitor_network_service.sh not found at $INIT_SCRIPT"
    exit 1
fi
#   source执行脚本 可以将source读取的配置文件传递到子脚本中
echo "sh: $INIT_SCRIPT"
source "$INIT_SCRIPT"