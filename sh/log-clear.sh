#!/bin/bash

# 定义日志目录和保留天数
log_dir="/var/log"
keep_days=7

# 查找并删除过期日志文件
find $log_dir -type f -mtime +$keep_days -exec rm -f {} \;

echo "日志清理完成！"
