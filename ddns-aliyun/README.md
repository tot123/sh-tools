


### 文件结构

```
ddns-aliyun/
├── ddns-aliyun.sh
├── install.sh
├── uninstall.sh
└── config.ini.example
```

### 前置要求

```
apt update && apt install -y curl openssl cron

```


### 使用说明

1. 将上述文件保存到对应位置
2. 重命名 `config.ini.example` 为 `config.ini` 并填写阿里云密钥
3. 运行 `install.sh` 完成安装
4. 日志文件位于 `/var/log/ddns-aliyun.log`
5. 各个文件所在位置说明：
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
