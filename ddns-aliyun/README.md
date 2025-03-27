


### 文件结构

```
ddns-aliyun/
├── ddns-aliyun.sh
├── install.sh
├── uninstall.sh
└── config.ini
```

### 前置要求

```
apt update && apt install -y curl openssl cron

```


### 使用说明

1. 编辑`config.ini`文件，确保正确填写了ak和sk。
2. DOMAIN_V4 对应的IPV4_ENABLED 被设置为true 并且对应域名已经在阿里云上初始化过解析了，注意ipv4解析类型为 `A`  
3. DOMAIN_V6 对应的IPV6_ENABLED 被设置为true 并且对应域名已经在阿里云上初始化过解析了，注意ipv6解析类型为 `AAAA`  
4. 运行 `install.sh` 完成安装
5. 日志文件位于 `$HOME/tmp/logs/ddns-aliyun.log`, 同时配置`$HOME/tmp/logs/ddns-aliyun.log`缓存上次成功更新的ip。
6. 各个文件所在位置说明：
    * 配置文件在：/etc/ddns-aliyun/config.ini    
    * 文件运行脚本在：/etc/ddns-aliyun/ddns-aliyun.sh    
    * 日志文件在：/etc/ddns-aliyun/ddns-aliyun.log   
### 特点

1. 双栈支持：同时支持 IPv4/IPv6 地址更新
2. 缓存机制：避免频繁调用阿里云 API
3. 安全编码：使用 HMAC-SHA1 签名算法
4. 日志记录：所有操作记录到日志文件
5. 配置分离：敏感信息独立存储在配置文件中
6. 自动安装：一键部署和卸载

### 注意事项

1. 需要提前在阿里云 DNS 控制台创建好对应的 A 和 AAAA 记录
2. 确保服务器已安装 curl 和 openssl
3. 首次使用前需修改配置文件中的 Access Key
4. 定时任务会每分钟执行一次，但实际更新频率取决于 IP 变化频率
5. 脚本仅适用于 Linux 系统
