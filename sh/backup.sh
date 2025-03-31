#!/bin/bash

# 定义备份目录和备份文件名
backup_dir="/backup"
backup_file="backup_$(date +%Y%m%d).tar.gz"

backup_dir=$(cd "$HOME/vscode" && pwd)
target_backup_dir="$HOME/backup"

# 创建备份目录
mkdir -p $target_backup_dir

# 定义备份文件的目标目录

# 打包备份文件
echo "tar -czf $target_backup_dir/$backup_file $backup_dir"
# tar -czf $target_backup_dir/$backup_file $backup_dir
echo "正在打包备份文件到 $target_backup_dir/$backup_file"
tar -czf $target_backup_dir/$backup_file -C "$HOME" "vscode"

# 显示备份文件信息
ls -lh $target_backup_dir
echo "备份完成！"
