#!/bin/bash

# 获取端口号（默认8080）
PORT="${1:-8080}"

# 验证端口格式
if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
    echo "Error: Port must be a numeric value." >&2
    exit 1
fi

# 检查lsof命令是否存在
if ! command -v lsof &> /dev/null; then
    echo "Error: 'lsof' command is required but not installed. Please install lsof to proceed." >&2
    exit 1
fi

# 检查端口占用情况
pids=$(lsof -ti :$PORT)

if [ -z "$pids" ]; then
    echo "Port $PORT is not occupied."
    exit 0
else
    echo "Port $PORT is occupied by process(es): $pids"
    echo "Attempting to kill processes..."
    
    # 尝试终止进程
    kill -9 $pids 2>/dev/null
    
    # 验证处理结果
    remaining_pids=$(lsof -ti :$PORT)
    if [ -z "$remaining_pids" ]; then
        echo "Successfully killed process(es)."
        exit 0
    else
        echo "Failed to kill process(es): $remaining_pids" >&2
        echo "You might need root privileges to kill these processes." >&2
        exit 1
    fi
fi