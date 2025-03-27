# Desc: 服务器健康检查脚本
# Usage: sh server-health-check.sh
# Update: 2021-08-10
#!/bin/bash

# 获取CPU使用率
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')

# 获取内存使用率
mem_usage=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')

# 获取磁盘使用率
disk_usage=$(df -h | awk '$NF=="/"{printf "%s", $5}')

# 获取网络连接数
net_connections=$(netstat -ant | wc -l)

# 检查关键服务状态
service_status=$(systemctl is-active nginx)

# 输出结果
echo "CPU使用率: $cpu_usage%"
echo "内存使用率: $mem_usage"
echo "磁盘使用率: $disk_usage"
echo "网络连接数: $net_connections"
echo "Nginx服务状态: $service_status"
