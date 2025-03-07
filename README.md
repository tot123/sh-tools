# sh-tools
sh常用脚本与部分配置
chmod +x  main.sh
sudo sh main.sh



init services 中服务进行命令注册
services 服务
sh 脚本





系统版本：debian系统
功能描述：
1、shell脚本实现通过监听网络，当网络不通时自动关机。在每次运行后打印日子记录运行状态和日期精确到秒。
2、使用crontab实现定时操作，并将日志保存在合适的位置，conrntab命令在一行直接生成。
3、日志文件位置通过 crontab生成，并且记录报错信息

4、提供一个初始化功能脚本，能将