#!/bin/bash

# 获取Maven仓库路径（默认~/.m2/repository）
MAVEN_REPO="${1:-~/.m2/repository}"
MAVEN_REPO="${MAVEN_REPO/#\~/$HOME}" # 处理波浪号扩展

# 检查目录是否存在
if [ ! -d "$MAVEN_REPO" ]; then
    echo "Error: Maven repository directory does not exist: $MAVEN_REPO" >&2
    exit 1
fi

# 查找所有.lastUpdated文件
echo "Searching for .lastUpdated files in $MAVEN_REPO..."
last_updated_files=$(find "$MAVEN_REPO" -type f -name '*.lastUpdated')

if [ -z "$last_updated_files" ]; then
    echo "No .lastUpdated files found. Nothing to clean."
    exit 0
fi

# 提取需要清理的目录
dirs_to_clean=$(echo "$last_updated_files" | xargs -I {} dirname {} | sort | uniq)

# 确认操作
echo "The following directories will be removed:"
echo "$dirs_to_clean"
read -p "Proceed with deletion? [y/N] " confirmation
confirmation=${confirmation,,}

if [[ "$confirmation" != "y" && "$confirmation" != "yes" ]]; then
    echo "Cleanup aborted."
    exit 0
fi

# 执行清理操作
echo "$dirs_to_clean" | xargs -I {} rm -rf "{}"
if [ $? -eq 0 ]; then
    echo "Cleanup completed successfully."
else
    echo "An error occurred during cleanup." >&2
    exit 1
fi