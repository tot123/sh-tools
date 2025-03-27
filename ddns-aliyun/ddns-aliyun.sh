#!/bin/bash

# DDNS 脚本，用于动态更新阿里云 DNS 记录
# 支持 IPv4 和 IPv6，使用缓存机制避免频繁更新
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
CONFIG_FILE="$SCRIPT_DIR/config.ini"
echo "$CONFIG_FILE"

# 日志函数
log() {
    local level="$1"  # 日志级别，例如 INFO、ERROR
    local message="$2"  # 日志内容
    local line_number="${BASH_LINENO[0]}"  # 获取调用该函数的行号
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")  # 获取当前时间
    echo "[$timestamp] [$level] [Line: $line_number] $message" >> "$LOG_FILE"
}

# 加载配置文件
load_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        log "ERROR" "配置文件 $CONFIG_FILE 不存在"
        exit 1
    fi
    source <(grep = "$CONFIG_FILE" | sed 's/ *= */=/g')
    # 自动创建日志目录
    log_dir=$(dirname "$LOG_FILE")
    if [ ! -d "$log_dir" ]; then
        mkdir -p "$log_dir"
        log "INFO" "日志目录 $log_dir 已创建"
    fi
    # 自动创建缓存目录
    cache_dir=$(dirname "$CACHE_DIR")
    if [ ! -d "$cache_dir" ]; then
        mkdir -p "$cache_dir"
        log "INFO" "缓存目录 $cache_dir 已创建"
    fi
}

# 校验参数
validate_params() {
    if [ -z "$ACCESS_KEY_ID" ] || [ -z "$ACCESS_KEY_SECRET" ] || [ -z "$DOMAIN_V4" ] || [ -z "$DOMAIN_V6" ] || [ -z "$CACHE_DIR" ] || [ -z "$LOG_FILE" ]; then
        log "ERROR" "配置文件不完整，请检查 ACCESS_KEY_ID、ACCESS_KEY_SECRET、DOMAIN、CACHE_DIR 和 LOG_FILE"
        exit 1
    fi
}

# URL 编码函数
urlencode() {
    local string="${1}"
    local strlen=${#string}
    local encoded=""
    local pos c o

    for (( pos=0 ; pos<strlen ; pos++ )); do
        c=${string:$pos:1}
        case "$c" in
            [-_.~a-zA-Z0-9]) o="${c}" ;;
            *) printf -v o '%%%02X' "'$c"
        esac
        encoded+="${o}"
    done
    echo "${encoded}"
}

# 阿里云 API 请求
aliyun_request() {
    local action="$1"
    local params="$2"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local nonce=$(openssl rand -hex 4)

    # 构造基础参数
    local query="AccessKeyId=$ACCESS_KEY_ID&Action=$action&Format=json&SignatureMethod=HMAC-SHA1&SignatureNonce=$nonce&SignatureVersion=1.0&Timestamp=$(urlencode "$timestamp")&Version=2015-01-09&$params"
    local sorted_query=$(echo "$query" | tr '&' '\n' | sort | tr '\n' '&' | sed 's/&$//')

    # 生成签名
    local string_to_sign="GET&%2F&$(urlencode "$sorted_query")"
    local signature=$(echo -n "$string_to_sign" | openssl dgst -hmac "$ACCESS_KEY_SECRET&" -sha1 -binary | openssl base64)
    signature=$(urlencode "$signature")

    # 发送请求
    local response=$(curl -s "http://alidns.aliyuncs.com/?$sorted_query&Signature=$signature")
    # log "INFO" "请求 URL: http://alidns.aliyuncs.com/?$sorted_query&Signature=$signature"
    echo "$response"
}

# 获取当前记录 ID
get_record_id() {
    local type="$1"
    local domain="$2"
    local rr=$(echo "$domain" | cut -d. -f1)
    local domain_name=$(echo "$domain" | cut -d. -f2-)

    local response=$(aliyun_request "DescribeDomainRecords" "DomainName=$domain_name&RRKeyWord=$rr&Type=$type")
    # log "INFO" "获取记录 ID 的响应: $response"
    echo "$response" | grep -o '"RecordId":"[^"]*' | cut -d'"' -f4
}

# 更新 DNS 记录
update_dns() {
    local type="$1"
    local domain="$2"
    local ip="$3"
    local record_id=$(get_record_id "$type" "$domain")

    if [ -z "$record_id" ]; then
        log "ERROR" "未找到 $domain 的记录"
        return 1
    fi

    local rr=$(echo "$domain" | cut -d. -f1)
    local domain_name=$(echo "$domain" | cut -d. -f2-)
    local response=$(aliyun_request "UpdateDomainRecord" "RecordId=$record_id&RR=$rr&Type=$type&Value=$ip&TTL=$TTL")
    if echo "$response" | grep -q "RecordId"; then
        log "INFO" "成功更新 $domain 为 $ip"
        return 0
    else
        log "ERROR" "更新 $domain 失败: $response"
        return 1
    fi
}

# 获取本机 IP
get_ip() {
    local type="$1"
    case "$type" in
        4) curl -4 -s http://ipv4.icanhazip.com | tr -d '\n' ;;
        6) curl -6 -s http://ipv6.icanhazip.com | tr -d '\n' ;;
    esac
}

# 主函数
main() {
    # load_config
    validate_params
    mkdir -p "$CACHE_DIR"

    # IPv4 更新
    if [ "$IPV4_ENABLED" = "true" ]; then
        current_ipv4=$(get_ip 4)
        cached_ipv4=$(cat "$CACHE_DIR/ipv4" 2>/dev/null)
        log "INFO" "当前 IPv4 地址: $current_ipv4 (缓存: $cached_ipv4)"
        if [ "$current_ipv4" != "$cached_ipv4" ]; then
            if update_dns "A" "$DOMAIN_V4" "$current_ipv4"; then
                echo "$current_ipv4" > "$CACHE_DIR/ipv4"
            fi
        fi
    fi

    # IPv6 更新
    if [ "$IPV6_ENABLED" = "true" ]; then
        current_ipv6=$(get_ip 6)
        cached_ipv6=$(cat "$CACHE_DIR/ipv6" 2>/dev/null)
        log "INFO" "当前 IPv6 地址: $current_ipv6 (缓存: $cached_ipv6)"
        if [ "$current_ipv6" != "$cached_ipv6" ]; then
            if update_dns "AAAA" "$DOMAIN_V6" "$current_ipv6"; then
                echo "$current_ipv6" > "$CACHE_DIR/ipv6"
            fi
        fi
    fi
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] 脚本执行结束" >> "$LOG_FILE"

}

# 执行主函数并记录日志\
load_config
echo "[$(date +"%Y-%m-%d %H:%M:%S")] [INFO] 脚本开始执行" >> "$LOG_FILE"
echo "$LOG_FILE" 
main >> "$LOG_FILE" 2>&1