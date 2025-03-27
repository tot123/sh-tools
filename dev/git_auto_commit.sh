#!/bin/bash


FIRST_PATH = $(cd "$(dirname "$0")" && pwd)

# # 配置Git项目路径数组（第一个值是当前项目路径）
# GIT_REPO_DIRS=(
#   "/path/to/your/current/git/repo"  # 当前项目路径
#     #   "/path/to/another/git/repo"       # 其他项目路径
# )

# # 遍历所有Git项目路径
# for GIT_REPO_DIR in "${GIT_REPO_DIRS[@]}"; do
#   # 进入Git项目目录
#   cd "$GIT_REPO_DIR" || { echo "Error: Git repo directory not found: $GIT_REPO_DIR"; continue; }

#   # 检查是否有未提交的更改
#   if git status --porcelain | grep -q '^ M\|^M \|^A \|^D \|^R \|^C \|^U'; then
#     # 添加所有更改到暂存区
#     git add .

#     # 提交更改，提交信息遵循规范
#     git commit -m "[corn] api 脚本自动检测提交"

#     # 推送到远程仓库（可选）
#     git push origin main  # 请根据实际分支名称修改
#     echo "Changes detected and committed successfully in $GIT_REPO_DIR."
#   else
#     echo "No changes detected in $GIT_REPO_DIR."
#   fi
# done