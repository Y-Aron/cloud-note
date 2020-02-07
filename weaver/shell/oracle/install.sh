if [ ! -f "oracle_tag" ];then
  yum -y install binutils compat-libstdc++-33 compat-libstdc++-33.i686 elfutils-libelf elfutils-libelf-devel gcc gcc-c++ glibc glibc.i686 glibc-common glibc-devel glibc-devel.i686 glibc-headers ksh libaio libaio.i686 libaio-devel libaio-devel.i686 libgcc libgcc.i686 libstdc++ libstdc++.i686 libstdc++-devel make sysstat unixODBC unixODBC
  # 创建 oinstall 用户组
  groupadd oinstall
  # 创建 dba 用户组
  groupadd dba 
  # 创建 oracle 用户
  useradd -g oinstall -G dba oracle
  echo '创建oracle用户完毕！'
  # 设置密码
  # passwd oracle
  # oracle: 安装目录
  mkdir -p /usr/local/oracle/product/11.2.0/db_1 | echo "创建/usr/local/oracle/product/11.2.0/db_1完毕！"
  # oradata: 数据存储目录
  mkdir /usr/local/oracle/oradata | echo "创建/usr/local/oracle/oradata完毕！"
  # flash_recovery_area: 恢复目录
  mkdir /usr/local/oracle/flash_recovery_area | echo "创建/usr/local/oracle/flash_recovery_area完毕！"
  # oraInventory: 清单目录
  mkdir /usr/local/oraInventory | echo '创建/usr/local/oraInventory完毕！'
  chown -R oracle:oinstall /usr/local/oracle
  chown -R oracle:oinstall /usr/local/oraInventory
  chmod -R 775 /usr/local/oracle
  chmod -R 775 /usr/local/oraInventory
  # 开始压缩文件
  if [ ! -d '/home/database'];then
    yum install unzip
    unzip linux.x64_11gR2_database_1of2.zip
    unzip linux.x64_11gR2_database_2of2.zip
  fi
  touch oracle_tag
fi

# 修改kernel内核参数
if [ ! -f "/etc/sysctl_bak.conf" ];then
  cp /etc/sysctl.conf /etc/sysctl_bak.conf
else
  cp /etc/sysctl_bak.conf /etc/sysctl.conf
fi
echo '
# 配置文件内加入 修改以下参数。如果没有可以自己添加，如果默认值比参考值大，则不需要修改。
# 这个内核参数用于设置系统范围内共享内存段的最大数量。该参数的默认值是 4096 。通常不需要更改。
kernel.shmmni = 4096
# 该参数定义了共享内存段的最大尺寸（以字节为单位）。缺省为32M，对于oracle来说，该缺省值太低了，# 通常将其设置为2G。
kernel.shmmax = 2147483648
# 该参数表示系统一次可以使用的共享内存总量（以页为单位）。缺省值就是2097152，通常不需要修改。
kernel.shmall = 2097152
kernel.sem = 250 32000 100 128
fs.aio-max-nr = 1048576
# 设置最大打开文件数
fs.file-max = 65536
# 可使用的IPv4端口范围
net.ipv4.ip_local_port_range = 9000 65500
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048586
' >> /etc/sysctl.conf
# 保存退出后设置立刻生效
sysctl -p | echo "修改kernel内核参数完毕！"

# 修改系统资源限制
if [ ! -f "/etc/security/limits_bak.conf" ];then
  cp /etc/security/limits.conf /etc/security/limits_bak.conf
else
  cp /etc/security/limits_bak.conf /etc/security/limits.conf
fi
echo '
oracle soft nproc 2047
oracle hard nproc 16384
oracle soft nofile 1024
oracle hard nofile 65536
oracle soft stack  10240
' >> /etc/security/limits.conf | echo "修改系统资源限制完毕！"

# 修改用户验证选项 关联设置
if [ ! -f "/etc/pam.d/login_bak" ];then
  cp /etc/pam.d/login /etc/pam.d/login_bak
else
  cp /etc/pam.d/login_bak /etc/pam.d/login
fi
sed -i "s/-session/session    required     \/lib64\/security\/pam_limits.so\n-session/g" /etc/pam.d/login
sed -i "s/-session/session    required     pam_limits.so\n-session/g" /etc/pam.d/login

echo "修改用户验证选项完毕！"

# 设置应答模版
cd /home/database/response
if [ ! -f "db_install_bak.rsp" ];then
  cp db_install.rsp db_install_bak.rsp
else
  cp db_install_bak.rsp db_install.rsp
fi
sed -i "s/oracle.install.option=/oracle.install.option=INSTALL_DB_SWONLY/g" db_install.rsp
sed -i "s/UNIX_GROUP_NAME=/UNIX_GROUP_NAME=oinstall/g" db_install.rsp
sed -i "s/INVENTORY_LOCATION=/INVENTORY_LOCATION=\/usr\/local\/oraInventory/g" db_install.rsp
sed -i "s/SELECTED_LANGUAGES=/SELECTED_LANGUAGES=en,zh_CN/g" db_install.rsp
sed -i "s/ORACLE_HOME=/ORACLE_HOME=\/usr\/local\/oracle\/product\/11.2.0\/db_1/g" db_install.rsp
sed -i "s/ORACLE_BASE=/ORACLE_BASE=\/usr\/local\/oracle/g" db_install.rsp
sed -i "s/oracle.install.db.InstallEdition=/oracle.install.db.InstallEdition=EE/g" db_install.rsp
sed -i "s/oracle.install.db.DBA_GROUP=/oracle.install.db.DBA_GROUP=dba/g" db_install.rsp
sed -i "s/oracle.install.db.OPER_GROUP=/oracle.install.db.OPER_GROUP=dba/g" db_install.rsp
sed -i "s/DECLINE_SECURITY_UPDATES=/DECLINE_SECURITY_UPDATES=true/g" db_install.rsp
cp /home/database/response/* /usr/local/oracle/ | echo 'copy /home/database/response/* -> /usr/local/oracle/ 完毕！'
 
cd /home
if [ -f 'run.sh' ];then
  rm -rf run.sh
fi
echo 'cd /home/database/
unset DISPLAY
./runInstaller -silent -ignorePrereq -responseFile /usr/local/oracle/db_install.rsp
'>run.sh
chmod +x ./run.sh
# 开始安装
path1='/usr/local/oraInventory/orainstRoot.sh'
path2='/usr/local/oracle/product/11.2.0/db_1/root.sh'
if [ -f $path1 -a -f $path2 ]; then
  exit;
else
  su - oracle -s /bin/sh /home/run.sh
fi

chmod +x /home/new_sid.sh