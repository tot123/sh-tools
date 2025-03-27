# sh-tools
sh常用脚本与部分配置
chmod +x  main.sh
sudo sh main.sh


每个文件夹对应一个功能  
每个文件夹提供一个install.sh脚本，执行install.sh脚本即可完成安装  
每个文件夹提供一个uninstall.sh脚本，执行uninstall.sh脚本即可完成卸载  
每个文件夹提供一个config.ini，内部编写对应配置信息  

### network_monitor   
使用要求：  
> apt intall -y wget curl  net-tools
 
功能描述：  
> 监控网络状态，当网络不通时自动关机    
> 通过脚本将功能注册成服务，开机延时自启，默认延时300s启动，此后每分钟运行一次      
> 可配合ups使用    
> intall.sh 安装  uninstall.sh 卸载  可以单独执行install.sh和uninstall.sh脚本    
 
### network_monitor  
使用要求：
> apt update && apt install -y curl openssl cron  
> sh ddns-aliyun/install.sh



要求如下：
    1、脚本命名符合脚本功能。
    2、脚本1功能: 手动执行时候可以接受入参，并执行对应功能。如果不传入参数那么有默认值。脚本要提供清除maven未下载成功的jar包。
    3、脚本2功能:  手动执行时候可以接受入参，并执行对应功能。如果不传入参数那么有默认值8080。检查指定端口是否被占用，如果占用则杀掉进程。如果不占用则打印端口未被占用。


git clone https://ghfast.top/https://github.com/tot123/doc.git


注意：sh脚本因该按照标准格式编写，并使用注释说明功能，并生成对应使用文档，以及文件夹结构说明。


要求如下：
    1、脚本及文件夹命名符合脚本功能。
    2、脚本提供安装和卸载功能，提供install.sh和uninstall.sh脚本。
    3、提供config.ini配置文件。
    4、提供日志记录功能，日志文件位置通过crontab生成，并且记录报错信息。日志格式要有日期时间，精确到秒。yyyy-mm-dd hh:mm:ss message。
    5、每天6：00自动执行，配置文件中指定集合路径下的git仓库是否有未提交内容，如果自动提交则提交，并推送至远程仓库。不执行也记录日志，提交也记录日志。
    6、commit符合https://doris.apache.org/zh-CN/community/how-to-contribute/commit-format-specification 定义的规范

注意：sh脚本因该按照标准格式编写，并使用注释说明功能，并生成对应使用文档，以及文件夹结构说明。


##### ddns-aliyun
现在要求实现ddns-aliyun脚本  
内部提供install.sh和uninstall.sh脚本。  
每分钟进行查询本机ip地址，并更新到阿里云dns中  
提供config.ini配置文件，配置阿里云dns信息  
可以查询本地ipv4和ipv6地址,并更新到对应api  
默认可以选择是否开启ipv4和ipv6更新  
使用缓存记录上次ip地址，避免频繁更新  
corntab 定时任务实现每分钟更新一次  
注意：sh脚本因该按照标准格式编写，并使用注释说明功能  
4.tangsu.icu  
6.tangsu.icu  



##### network_monitor  
系统版本：debian系统  
功能描述：  
1、shell脚本实现通过监听网络，当网络不通时自动关机。在每次运行后打印日子记录运行状态和日期精确到秒。  
2、使用crontab实现定时操作，并将日志保存在合适的位置，conrntab命令在一行直接生成。  
3、日志文件位置通过 crontab生成，并且记录报错信息  

4、提供一个初始化功能脚本，能将  