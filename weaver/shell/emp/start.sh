emp_tomcat_path="/usr/local/emp/tomcat"
emp_app_work="/usr/local/emp/work"
emp_app_custom_prop="$emp_app_work/config/application-custom.properties"

activemqText="
# activemq配置
emobile.activemq.enabled=$EMP_ACTIVEMQ_ENABLED
# activemq服务连接url
spring.activemq.broker-url=failover:(tcp://$EMP_ACTIVEMQ_IP:$EMP_ACTIVEMQ_PORT)?startupMaxReconnectAttempts=3
spring.activemq.user=$EMP_ACTIVEMQ_USER
spring.activemq.password=$EMP_ACTIVEMQ_PASSWORD"

jtaText="
# 禁用掉JTA事务，强制使用本地事务
spring.jta.enabled=$EMP_JTA_ENABLED"

mysqlText="
# MySQL数据库
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.datasource.url=jdbc:mysql://$EMP_DB_IP:$EMP_DB_PORT/$EMP_DB_NAME?autoReconnect=true&characterEncoding=UTF-8&failOverReadOnly=false&serverTimezone=GMT%2B8&useSSL=true&useUnicode=true&verifyServerCertificate=false&zeroDateTimeBehavior=convertToNull
spring.datasource.username=$EMP_DB_USERNAME
spring.datasource.password=$EMP_DB_PASSWORD
spring.datasource.druid.connection-properties=config.decrypt=false"

oracleText="
# Oracle数据库
spring.datasource.driver-class-name=oracle.jdbc.OracleDriver
spring.datasource.url=jdbc:oracle:thin:@$EMP_DB_IP:$EMP_DB_PORT:$EMP_DB_SID
spring.datasource.username=$EMP_DB_USERNAME
spring.datasource.password=$EMP_DB_PASSWORD
spring.datasource.druid.connection-properties=config.decrypt=false"

redisText="
# redis配置
emobile.redis.enabled=$EMP_REDIS_ENABLED
spring.redis.host=$EMP_REDIS_HOST
spring.redis.port=$EMP_REDIS_PORT
spring.redis.password=$EMP_REDIS_PASSWORD
spring.redis.database=$EMP_REDIS_DB"

if [ -z "$EMP_SESSION_STORE_TYPE" ];then
  $EMP_SESSION_STORE_TYPE="none"
fi

if [ -z "$EMP_SESSION_TIMEOUT" ];then
  $EMP_SESSION_TIMEOUT="7d"
fi

if [ -z "$EMP_BASE_CACHE_TYPE" ];then
  $EMP_BASE_CACHE_TYPE="ehcache"
fi

if [ -z "$EMP_LOG_RETAIN_DAYS" ];then
  $EMP_LOG_RETAIN_DAYS="30"
fi

if [ -z "$EMP_DOWNLOAD_RETAIN_DAYS" ];then
  $EMP_DOWNLOAD_RETAIN_DAYS="10"
fi

echo "$activemqText
$jtaText
$redisText

# httpclient代理配置
httpclient.proxy.host=
httpclient.proxy.port=
httpclient.proxy.username=
httpclient.proxy.password=

# session配置 
# session有效期默认7天
server.servlet.session.timeout=$EMP_SESSION_TIMEOUT
# session存储介质，支持none、jdbc和redis，其中none表示session存储在servlet容器（即原生session）
# jdbc表示session存储在数据库，redis表示session存储在redis里面（需配置redis数据源）
spring.session.store-type=$EMP_SESSION_STORE_TYPE

# jackson配置
spring.jackson.date-format=yyyy-MM-dd HH:mm:ss
spring.jackson.time-zone=GMT+8

# 其他配置
# 基本信息缓存方式，支持none、ehcache和redis，其中none表示不缓存数据，ehcache表示数据缓存在ehcache里面，redis表示数据缓存在redis里面（需配置redis数据源）
emobile.base-setting.cache-type=$EMP_BASE_CACHE_TYPE
# 从OA下载的文件保留期限（天），小于或者等于0表示不清理
emobile.download.retain-days-threshold=$EMP_DOWNLOAD_RETAIN_DAYS
# MQ队列名称
emobile.log.destination=log.queue
# 操作日志保留期限（天），小于或者等于0表示不清理
emobile.log.retain-days-threshold=$EMP_LOG_RETAIN_DAYS" > $emp_app_custom_prop

if [ -n "$EMP_CDN_URL" ];then
echo "
# CDN地址
emobile.cdnurl=$EMP_CDN_URL" >> $emp_app_custom_prop
fi

if [ -n "$EMP_CLUSTER_NODE_ID" ];then
echo "
# 集群配置
# 集群节点ID:全局唯一
info.cluster.nodeId=$EMP_CLUSTER_NODE_ID" >> $emp_app_custom_prop
fi

if echo "$EMP_DB_TYPE" | grep -qwi "mysql"
then
echo "$mysqlText" >> $emp_app_custom_prop
fi

if echo "$EMP_DB_TYPE" | grep -qwi "oracle"
then
echo "$oracleText" >> $emp_app_custom_prop
fi

echo "user.dir=$emp_app_work" > "$emp_tomcat_path/webapps/ROOT/WEB-INF/classes/config/application-inner-custom.properties"

cd $emp_tomcat_path/bin
./catalina.sh run