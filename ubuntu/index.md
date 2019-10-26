# Ubuntu入门

## 1. Vmware 安装Ubuntu

> 使用 VMware Workstation Pro 安装 Ubuntu Server 18.04.3 LTS
>
> VMware Workstation Pro 软件包：https://pan.baidu.com/s/1DhzksBM1hlogfDiTRUjtrw
>
> 镜像地址：[https://pan.baidu.com/s/1HxT_Txl_9X-aQb368sgGEA](https://pan.baidu.com/s/1HxT_Txl_9X-aQb368sgGEA)

- 安装 `VMware Workstation Pro` 
- 打开 `VMware Workstation Pro`  -> 新建虚拟机 -> 自定义（高级）

![](asset/image-20191026133849268.png)

- 硬件兼容性选择 `Workstation 15.X`

![image-20191026134720412](asset/image-20191026134720412.png)

- 选择镜像文件

![image-20191026135158059](asset/image-20191026135158059.png)

- 设置账户密码

![image-20191026135342334](asset/image-20191026135342334.png)

- 默认下一步，打开虚拟机选择语言

![image-20191026135618020](asset/image-20191026135618020.png)

- 默认下一步，修改镜像源为阿里云镜像：http://mirrors.aliyun.com/ubuntu/

![image-20191026135929942](asset/image-20191026135929942.png)

- 下一步，选择第一个，一直回车

![image-20191026140033242](asset/image-20191026140033242.png)

![image-20191026140152835](asset/image-20191026140152835.png)

- 设置服务器信息

- 勾选安装 OpenSSH server

![image-20191026140245785](asset/image-20191026140245785.png)

- 下一步，等待安装完后重启即可

![image-20191026140421837](asset/image-20191026140421837.png)

- 登录服务器

![image-20191026140757053](asset/image-20191026140757053.png)

## 2. 安装 MySQL

### 2.1 下载软件包

```bash
sudo apt-get update
sudo apt-get install wget
wget https://repo.mysql.com//mysql-apt-config_0.8.14-1_all.deb
```

### 2.2 开始安装

- 执行如下命令

```bash
sudo dpkg -i mysql-apt-config_0.8.14-1_all.deb
```

- 弹出如下界面，选择第一个

![image-20191026160213258](asset/image-20191026160213258.png)

- 选择MySQL版本，选择MySQL8

![image-20191026160326632](asset/image-20191026160326632.png)

- 回到上一个界面，选择🆗在回车

![image-20191026160656021](asset/image-20191026160656021.png)

- 更新系统和软件源并安装MySQL8

```shell
sudo apt update
sudo apt install mysql-server
```

- 等待安装，直到以下界面出现时，输入密码

![image-20191026163548739](asset/image-20191026163548739.png)

- 安装成功, 使用 root 登录 MySQL

![](asset/image-20191026163655802.png)















