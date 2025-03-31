

### 文件结构

```
network_monitor/
├── config.ini
├── install.sh
├── monitor_network.sh
├── network-monitor.service
├── README.md
├── register_monitor_network_service.sh
└── uninstall.sh
```

### 前置要求

```
apt update && apt install -y sed net-tools
```


### 使用说明
1. 运行install.sh 脚本将[network-monitor.service](network-monitor.service)注册成服务。 
2. 可单独运行[monitor_network.sh](monitor_network.sh) 一般使用`source`命令  
