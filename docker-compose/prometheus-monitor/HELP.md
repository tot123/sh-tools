其中配置可以按照需要修改   
192.168.1.102 改为自己ip  
默认会将项目部署到`/opt/prometheus-monitor`目录

快速安装
```shell
cd sh-tools/docker-compose/prometheus-monitor
sudo bash install.sh
```

快速卸载
```shell
cd sh-tools/docker-compose/prometheus-monitor
sudo bash uninstall.sh
```

使用到的账号密码均为 admin/tangsu@10086
无账号密码访问，因为您未能提供有效的用户名和密码。401 Unauthorized
curl --head http://localhost:9090/graph
使用账号密码访问
curl -u admin http://localhost:9090/metrics
curl --head http://localhost:9100/
curl --head http://localhost:9200/graph

[Docker 安装node_exporter](https://www.cnblogs.com/weifeng1463/p/12828961.html)
[Docker 安装node_exporter](https://github.com/prometheus/node_exporter#using-docker)
[Prometheus Node Export 基于用户名密码访问](https://blog.csdn.net/qq_34556414/article/details/113106095)




docker 快速安装grafana
[运行 Grafana Docker 映像](https://grafana.com/docs/grafana/latest/setup-grafana/installation/docker/)
```shell
docker run -d -p 3000:3000 --name=grafana \
  -e "GF_PLUGINS_PREINSTALL=grafana-clock-panel, grafana-simple-json-datasource" \
  grafana/grafana-enterprise
```

