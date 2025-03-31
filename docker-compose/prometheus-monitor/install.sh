#!/bin/bash
set -e  # 遇到错误立即退出

# 获取当前脚本所在目录的绝对路径
SRC_DIR="$(dirname "$(realpath "$0")")"
# echo $SRC_DIR
# 目标目录
DEST_DIR="/opt"
cp -r "$SRC_DIR" "$DEST_DIR"
chmod -R 755 "$DEST_DIR/prometheus-monitor"
cd /opt/prometheus-monitor
docker-compose -f prometheus_grafana_exporter_alertmanager.yaml up -d



# docker-compose -f prometheus_grafana_exporter_alertmanager.yaml stop
# docker-compose -f prometheus_grafana_exporter_alertmanager.yaml down
