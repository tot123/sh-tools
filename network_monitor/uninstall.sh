#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
SOURCE_FILE="$SCRIPT_DIR/config.ini"
echo "Script directory: $SOURCE_FILE"

source "$SOURCE_FILE"  # 读取配置
SERVICE_NAME="network-monitor.service"

echo "Stopping and disabling service: $SERVICE_NAME..."
sudo systemctl stop "$SERVICE_NAME"
sudo systemctl disable "$SERVICE_NAME"

echo "Removing service file: $TARGET_SERVICE_FILE..."
sudo rm -f "$TARGET_SERVICE_FILE"

# 删除服务文件后，需要让 systemd 重新加载配置：
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "Checking if service still exists..."
systemctl list-units --type=service | grep "$SERVICE_NAME"

echo "Uninstall complete!"

