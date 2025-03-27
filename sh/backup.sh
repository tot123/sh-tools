#!/bin/bash

# 定义备份目录和备份文件名
backup_dir="/backup"
backup_file="backup_$(date +%Y%m%d).tar.gz"

# 创建备份目录
mkdir -p $backup_dir

# 打包备份文件
tar -czf $backup_dir/$backup_file /etc /var/www

echo "备份完成！"
