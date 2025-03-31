#!/bin/bash
set -e  # 遇到错误立即退出
cd /opt/prometheus-monitor
docker-compose -f prometheus_grafana_exporter_alertmanager.yaml down
sleep 10
rm -rf /opt/prometheus-monitor