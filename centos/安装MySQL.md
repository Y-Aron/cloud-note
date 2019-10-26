# CentOS 7 安装 MySQL

## 1. 卸载MySQL

- 查询已有的`MySQL`软件包和依赖包

```bash
rpm -pa | grep mysql
```

- 如果查询结果如下

```bash
mysql80-community-release-el7-1.noarch
mysql-community-server-8.0.11-1.el7.x86_64
mysql-community-common-8.0.11-1.el7.x86_64
mysql-community-libs-8.0.11-1.el7.x86_64
mysql-community-client-8.0.11-1.el7.x86_64
```

- 使用以下命令依次删除上面的程序

```bash
yum remove mysql-xxx-xxx-
```

- 删除已有的`MySQL`配置文件

```bash
find / -name mysql
```

- 可能显示结果如下

```bash
/etc/logrotate.d/mysql
/etc/selinux/targeted/active/modules/100/mysql
/etc/selinux/targeted/tmp/modules/100/mysql
/var/lib/mysql
/var/lib/mysql/mysql
/usr/bin/mysql
/usr/lib64/mysql
/usr/local/mysql
```

- 使用以下命令删除配置文件

```bash
rm -rf /var/lib/mysql
```

## 2.  **卸载MariaDB** 

> 由于MySQL在CentOS7中收费了，所以已经不支持MySQL了，取而代之在CentOS7内部集成了mariadb，而安装MySQL的话会和MariaDB的文件冲突，所以需要先卸载掉MariaDB

-  使用rpm 命令查找出要删除的mariadb文件 

```bash
rpm -pa | grep mariadb
```

- 可能会显示的结果如下

```bash
mariadb-libs-5.5.56-2.el7.x86_64
```

- 删除上面的程序

```bash
rpm -e --nodeps mariadb-libs-5.5.56-2.el7.x86_64
```

## 3. 安装 MySQL

> centos的yum 源中默认是没有mysql的，所以我们需要先去官网下载mysql的repo源并安装

- 下载 [MySQL yum 源](https://dev.mysql.com/downloads/repo/yum/)

```bash
wget https://repo.mysql.com//mysql80-community-release-el7-3.noarch.rpm
```

- 安装 `yum` 源

```bash
yum localinstall mysql80-community-release-el7-3.noarch.rpm
```

- 更新 `yum` 源

```bash
yum clean all
yum makecache
```

- 安装 `MySQL`

```bash
yum install mysql-community-server
```

- 启动 `MySQL`

```bash
systemctl start mysqld
```

- 查看初始化密码

```bash
calhost code]# cat /var/log/mysqld.log | grep password
2019-10-25T08:51:42.371990Z 5 [Note] [MY-010454] [Server] A temporary password is generated for root@localhost: hWdlJqe#k7nh
```

- 重置密码

```bash
[root@localhost roo]# mysql_secure_installation
Set root password? [Y/n] y                          [设置root用户密码]
New password:                                                   [新密码]
Re-enter new password:                                 [重新输入密码]
Remove anonymous users? [Y/n] y                     [删除匿名用户]
Disallow root login remotely? [Y/n] n               [禁止root远程登录]
Remove test database and access to it? [Y/n] y      [删除test数据库]
Reload privilege tables now? [Y/n] y                [刷新权限]
```

- 登录`MySQL`

```mysql
[root@localhost roo]# mysql -u root -p
mysql> use mysql
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> update user set host='%' where user='root';
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> select host, user from user;
+-----------+------------------+
| host      | user             |
+-----------+------------------+
| %         | root             |
| localhost | mysql.infoschema |
| localhost | mysql.session    |
| localhost | mysql.sys        |
+-----------+------------------+
4 rows in set (0.00 sec)
mysql> create user 'root'@'%' identified '1';
# 赋予任何主机访问数据的权限
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'WITH GRANT OPTION;
```