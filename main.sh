#!/bin/bash


# 获取当前脚本的绝对路径
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# 函数：搜索并赋予 .sh 文件执行权限
grant_exec_permission() {
    echo "Searching for .sh files in $SCRIPT_DIR and subdirectories..."
    
    # 使用 find 命令查找所有 .sh 文件
    find "$SCRIPT_DIR" -type f -name "*.sh" | while read -r file; do
        # 检查文件是否已经有执行权限
        if [ ! -x "$file" ]; then
            echo "Granting execute permission to: $file"
            chmod +x "$file"
        else
            echo "Execute permission already granted for: $file"
        fi
    done

    echo "All .sh files have been processed."
}

# 调用函数，赋予执行权限
grant_exec_permission


# 定义 init_monitor_network.sh 的路径
INIT_SCRIPT="$SCRIPT_DIR/network_monitor/install.sh"

# 检查 init_monitor_network.sh 是否存在
if [ ! -f "$INIT_SCRIPT" ]; then
    echo "Error: init_monitor_network.sh not found at $INIT_SCRIPT"
    exit 1
fi

# 调用 init_monitor_network.sh
bash "$INIT_SCRIPT" 
# 调用 init_monitor_network.sh 并传递当前目录路径
# bash "$INIT_SCRIPT" "$SCRIPT_DIR"