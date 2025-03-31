### 文件结构

```shell
shell-tools
├── auto-git-manager                #定时同步未提交git文件到对应仓库
│   ├── auto-git-manager.sh
│   ├── config.ini
│   ├── install.sh
│   ├── README.md
│   └── uninstall.sh
├── common
├── ddns-aliyun                     # 通过cron每5分钟监听本机公网ip是否发生变化，并更新到对应域名
│   ├── config.ini
│   ├── ddns-aliyun.sh
│   ├── install.sh
│   ├── README.md
│   └── uninstall.sh
├── dev
│   ├── check-port.bat
│   ├── check-port.sh
│   ├── clean-maven.bat
│   ├── clean-maven.sh
│   ├── del_jar.cmd
│   ├── git_auto_commit.sh
│   ├── README.md
│   └── stopProt.bat
├── init
│   ├── init_debian.sh
│   ├── init_java.sh        # 初始化java开发环境
│   └── init_maven.sh 
│   └── init_gradle.sh 
├── LICENSE           
├── main.sh
├── network_monitor                 #cron每分钟执行，不能ping通指定ip，直接执行关机               
│   ├── config.ini
│   ├── install.sh
│   ├── monitor_network.sh
│   ├── network-monitor.service
│   ├── README.md
│   ├── register_monitor_network_service.sh
│   └── uninstall.sh
├── README.md
├── sh
│   ├── backup-mysql.sh         
│   ├── backup.sh                   # 备份指定文件夹到~/backup下
│   ├── log-clear.sh
│   ├── server-health-check.sh      # 监听服务器资源消耗
│   └── sync_files.sh               # 通过rsync双向同步指定文件夹，可配置成cron  缺少前置使用说明
├── template
│   ├── config.ini
│   ├── install.sh
│   └── uninstall.sh
└── test.sh
```
