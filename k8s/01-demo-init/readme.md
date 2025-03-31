
### 部署流程
#### 1. 创建命名空间
```bash
kubectl create namespace demo
```

#### 2. 应用所有配置
```bash
kubectl apply -f nfs-storage.yaml
kubectl apply -f nginx-configmap.yaml
kubectl apply -f nginx-deployment.yaml
kubectl apply -f nginx-service.yaml
kubectl apply -f nginx-ingress.yaml
```

#### 3. 域名解析配置
```bash
# 获取 Minikube IP（假设为 192.168.49.2）
minikube ip

# 本地 hosts 文件添加解析（所有操作系统通用）
echo "$(minikube ip) nginx-demo-01.tangsu.icu" | sudo tee -a /etc/hosts
```

---

### 关键问题解答
#### 问题 6：`nginx-demo-01.tangsu.icu` 指向哪台服务器？
1. **开发环境**：指向 Minikube 虚拟机的 IP（通过 `minikube ip` 获取）
   ```bash
   # 示例输出
   minikube ip
   > 192.168.49.2
   ```
   - 需在访问设备的 hosts 文件添加：
     ```
     192.168.49.2 nginx-demo-01.tangsu.icu
     ```

2. **生产环境**：指向 Ingress Controller 的公网 IP
   ```bash
   # 查看实际公网 IP（需云平台负载均衡器分配）
   kubectl get svc -n ingress-nginx
### 架构示意图
```
用户访问
↓
nginx-demo-01.tangsu.icu (DNS 解析到 Minikube IP)
↓
Ingress Controller (Minikube 内置 ingress-nginx)
↓
Service: nginx-service (ClusterIP)
↓
Deployment: nginx-demo (3 个 Pod)
↓
存储：
  - 配置文件：ConfigMap → /etc/nginx/nginx.conf
  - 网站数据：NFS 共享 → /usr/share/nginx/html
``` 
## 注意：
本脚本使用到了两个域名和nfs
nfs 域名 4.tangsu.icu
所以需要再指定域名的服务器安装nfs


[Ubuntu 22.04上安装NFS服务](https://blog.csdn.net/yuyuyuliang00/article/details/131364682)
[NFS-网络文件共享服务](https://www.cnblogs.com/asheng2016/p/9613065.html)
```shell
sudo  apt install -y nfs-server
mkdir -p /home/ts/nfs
id
# uid=1000(ts) gid=1000(ts) 组=1000(ts),24(cdrom),25(floppy),27(sudo),29(audio),30(dip),44(video),46(plugdev),100(users),106(netdev),113(bluetooth),116(lpadmin),117(scanner),120(docker)
sudo cp /etc/exports /etc/exports.bak

echo '/home/ts/nfs 192.168.1.0/24(rw,sync,all_squash,anonuid=1000,anongid=1000,no_subtree_check)' | sudo tee -a /etc/exports
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
sudo systemctl restart nfs-server
sudo exportfs -v
# /home/ts/nfs    192.168.1.0/24(sync,wdelay,hide,no_subtree_check,anonuid=1000,anongid=1000,sec=sys,rw,secure,root_squash,all_squash)

# 6、查看NFS共享情况
showmount -e

```
* /home/ts/nfs：需要共享的主机目录，注意使用空格与后面的配置隔开。 
* 192.168.1.0/24：配置哪个网段或主机可以访问，其中/24是掩码，此处表示24个1，即掩码是255.255.255.0。结合前面192.168.1.0表示此处配置IP为192.168.1.*的主机均可以访问该目录，即192.168.1.*网段局域网上的所有主机。
* rw：表示客户机的权限，rw表示可读写。具体的授权还受到文件系统的rwx及用户身份影响。
* sync：资料同步写入到内存与磁盘中。
* anonuid=1000：将客户机上的用户映射成指定的本地用户ID的用户，此处1000是主机ts用户的uid，此处请根据具体的主机用户uid进行配置。
* anongid=100：将客户机上的用户映射成属于指定的本地用户组ID，此处1000是主机ts用户组gid。此处请根据具体的主机用户组gid进行配置。
* no_subtree_check：不检查子目录权限，默认配置。  
本配置中的anonuid和anongid把客户机的用户映射成本地uid/gid为1000的用户，即主机ts，那么当在客户机上使用与主机不同的用户访问NFS共享目录时，都会有ts的权限。



```shell
sudo apt-get install nfs-common
sudo showmount -e 192.168.1.102
sudo mount -t nfs 192.168.1.102:/home/ts/nfs /mnt/nfs
```
