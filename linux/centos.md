# CentOS 7 基本使用

## 1. 防火墙设置

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

