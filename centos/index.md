# CentOS 7 入门

## 1. 配置镜像源

- 备份 `repo`

```shell
[roo@localhost ~]$ cd /etc/yum.repos.d/
[roo@localhost yum.repos.d]$ sudo mkdir repo_bak
[roo@localhost yum.repos.d]$ sudo mv *.repo repo_bak/
```

- 配置网易开源镜像

```shell
[roo@localhost yum.repos.d]$ sudo wget http://mirrors.163.com/.help/CentOS7-Base-163.repo
[roo@localhost yum.repos.d]$ ls
CentOS7-Base-163.repo repo_bak
```

- 清除并生成新的`yum`缓存

```shell
 # 清除系统所有的yum缓存
[roo@localhost yum.repos.d]$ yum clean all
# 生成yum缓存
[roo@localhost yum.repos.d]$ yum makecache
```

## 2. 配置 `epel` 源

- 安装 `epel` 源

```shell
[root@localhost yum.repos.d]$ sudo yum install -y epel-release
[roo@localhost yum.repos.d]$ ls
CentOS7-Base-163.repo  epel.repo  epel-testing.repo  repo_bak
```

- 配置阿里镜像源

```shell
[roo@localhost yum.repos.d]$ sudo wget -O /etc/yum.repos.d/epel-7.repo http://mirrors.aliyun.com/repo/epel-7.repo
[roo@localhost yum.repos.d]$ ls
CentOS7-Base-163.repo  epel-7.repo  epel.repo  epel-testing.repo  repo_bak
```

- 重新生成 `yum` 缓存

```shell
[roo@localhost yum.repos.d]$ yum clean all
[roo@localhost yum.repos.d]$ yum makecache
```

- 查看`yum` 源 

```shell
[roo@localhost yum.repos.d]$ yum repolist enabled
[roo@localhost yum.repos.d]$ yum repolist all
```

## 3. 配置防火墙

> CentOS 7 安装 iptables 和 iptables-services

- 查看当前系统是否安装防火墙

```shell
service iptables status 
```

- 安装 iptables：`yum install -y iptables`
- 安装 iptables-services：`yum install iptables-services`
- 开启相关规则的命令：

```shell
//先允许所有,不然有可能会杯具  
iptables -P INPUT ACCEPT  
// 清空所有默认规则  
iptables -F  
// 清空所有自定义规则  
iptables -X  
// 所有计数器归0  
iptables -Z  
// 允许来自于lo接口的数据包(本地访问)  
iptables -A INPUT -i lo -j ACCEPT  
// 开放22端口  
iptables -A INPUT -p tcp --dport 22 -j ACCEPT  
// 开放21端口(FTP)  
iptables -A INPUT -p tcp --dport 21 -j ACCEPT  
// 开放80端口(HTTP)  
iptables -A INPUT -p tcp --dport 80 -j ACCEPT  
// 开放443端口(HTTPS)  
iptables -A INPUT -p tcp --dport 443 -j ACCEPT  
// 允许ping  
iptables -A INPUT -p icmp --icmp-type 8 -j ACCEPT  
// 允许接受本机请求之后的返回数据 RELATED,是为FTP设置的  
iptables -A INPUT -m state --state  RELATED,ESTABLISHED -j ACCEPT  
// 其他入站一律丢弃  
iptables -P INPUT DROP  
// 所有出站一律绿灯  
iptables -P OUTPUT ACCEPT  
// 所有转发一律丢弃  
iptables -P FORWARD DROP 
```

- 保存配置，并重启服务

```shell
service iptables save  
systemctl restart iptables.service  
```

