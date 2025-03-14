#!/bin/bash

# Git仓库自动提交脚本
# 功能：每日检查指定目录下的Git仓库并自动提交
# 符合Apache Doris提交规范

CONFIG_FILE="/etc/auto-git-manager/config.ini"

# 初始化日志功能
init_log() {
    source <(grep = "$CONFIG_FILE" | sed 's/ *= */=/g')
    LOG_TIMESTAMP=$(date "+%Y%m%d")
    LOG_PATH="${LOG_DIR}/git-commit_${LOG_TIMESTAMP}.log"
}

# 带时间的日志记录
log() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $1" | tee -a "$LOG_PATH"
}

# 检查配置文件
check_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        log "错误：配置文件 $CONFIG_FILE 不存在"
        exit 1
    fi

    required_vars=(
        REPOS_DIR AUTO_COMMIT COMMIT_TEMPLATE
        LOG_DIR COMMIT_TYPES COMMIT_MODULES
    )

    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ]; then
            log "配置错误：$var 未设置"
            exit 1
        fi
    done
}

# 生成合规的commit message
generate_message() {
    local change_type=$1
    local change_module=$2
    local datetime=$(date "+%Y-%m-%d %H:%M:%S")
    
    # 从预定义列表随机选择类型/模块（示例实现）
    local type=$(shuf -n1 -e $(echo $COMMIT_TYPES | tr ',' ' '))
    local module=$(shuf -n1 -e $(echo $COMMIT_MODULES | tr ',' ' '))
    
    echo "${COMMIT_TEMPLATE}" | sed "
        s/{type}/$type/g;
        s/{module}/$module/g;
        s/{datetime}/$datetime/g
    "
}

# 处理单个仓库
process_repo() {
    local repo_path=$1
    cd "$repo_path" || return
    
    # 检查是否有修改
    if [ -z "$(git status --porcelain)" ]; then
        log "[$repo_path] 无未提交修改"
        return
    fi

    # 生成提交信息
    local commit_msg=$(generate_message)
    
    if [ "$AUTO_COMMIT" = "true" ]; then
        git add . >/dev/null 2>&1
        if git commit -m "$commit_msg" >/dev/null 2>&1; then
            log "[$repo_path] 提交成功: $commit_msg"
            if git push >/dev/null 2>&1; then
                log "[$repo_path] 推送成功"
            else
                log "[$repo_path] 错误：推送失败"
            fi
        else
            log "[$repo_path] 错误：提交失败"
        fi
    else
        log "[$repo_path] 发现未提交修改（自动提交已禁用）"
    fi
}

main() {
    source "$CONFIG_FILE"
    init_log
    check_config
    
    log "===== 开始扫描 ====="
    find "$REPOS_DIR" -type d -name ".git" -print0 | while IFS= read -r -d '' gitdir; do
        repo_dir=$(dirname "$gitdir")
        process_repo "$repo_dir"
    done
    log "===== 扫描完成 ====="
}

main