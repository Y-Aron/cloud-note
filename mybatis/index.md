# 1. 创建Maven项目

```xml
<!-- 日志框架 -->
<dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-classic</artifactId>
    <version>1.2.3</version>
</dependency>
<!-- mybatis -->
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis</artifactId>
    <version>3.5.1</version>
</dependency>
<!-- Mysql驱动 -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.15</version>
</dependency>
<!-- 数据库连接池 -->
<dependency>
    <groupId>com.zaxxer</groupId>
    <artifactId>HikariCP</artifactId>
    <version>3.3.1</version>
</dependency>
```

# 2. 配置 `mybatis.xml`

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <!-- 加载配置文件 -->
    <properties resource="jdbc.properties" />
    <environments default="development">
        <environment id="development">
            <!-- 使用jdbc事务管理，事务控制由mybatis -->
            <transactionManager type="JDBC"/>
            <!-- 使用Mybatis自带的连接池 -->
            <dataSource type="POOLED">
                <!-- 使用${}获取配置文件的参数 -->
                <property name="driver" value="${jdbc.driver}"/>
                <property name="url" value="${jdbc.url}"/>
                <property name="username" value="${jdbc.username}"/>
                <property name="password" value="${jdbc.password}"/>
            </dataSource>
        </environment>
    </environments>
    <!-- 加载映射文件 -->
    <mappers>
        <mapper resource="mapper/UserMapper.xml"/>
    </mappers>
</configuration>
```

# 3. 配置`jdbc.properties`

```properties
jdbc.url=jdbc:mysql://127.0.0.1:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC
jdbc.username=root
jdbc.password=123456
jdbc.driver=com.mysql.cj.jdbc.Driver
```

# 4. 整合 `HikariCP`

## 4.1 配置数据源

> `xml`文件配置

```xml
<!-- 整合HikariCP连接池 -->
<dataSource type="org.aron.mybatisTest.datasource.HikariCPDataSourceFactory">
    <!-- 使用${}获取配置文件的参数 -->
    <property name="driver" value="${jdbc.driver}"/>
    <property name="url" value="${jdbc.url}"/>
    <property name="username" value="${jdbc.username}"/>
    <property name="password" value="${jdbc.password}"/>
</dataSource>
```
> `Java`代码配置

```java
public class HikariCPDataSourceFactory implements DataSourceFactory {

    private Properties props;

    @Override
    public void setProperties(Properties properties) {
        this.props = properties;
    }

    @Override
    public DataSource getDataSource() {
        // 初始化HikariDataSource
        HikariDataSource dataSource = new HikariDataSource();
        // url/username/password/driver 
        // 对应 mybatis.xml中的 <property name="driver" value=".."> name属性
        dataSource.setJdbcUrl(this.props.getProperty("url"));
        dataSource.setUsername(this.props.getProperty("username"));
        dataSource.setPassword(this.props.getProperty("password"));
        dataSource.setDriverClassName(this.props.getProperty("driver"));
        return dataSource;
    }
}
```

## 4.2 配置映射文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<!--
  namespace: 命名空间, 作用是对sql进行分类化管理
  使用mapper代理方法开发时, namespace就是mapper的类名
 -->
<mapper namespace="org.aron.mybatisTest.domain.dao.UserMapper">
  <!--  结果集映射: pojo的字段类型与数据库字段类型映射; 字段名与列名映射; 一条记录对应一个pojo-->
  <resultMap id="BaseResultMap" type="org.aron.mybatisTest.domain.pojo.User">
    <id column="id" jdbcType="INTEGER" property="id" />
    <result column="name" jdbcType="VARCHAR" property="name" />
    <result column="desc" jdbcType="VARCHAR" property="desc" />
  </resultMap>
  <!-- sql片段 -->
  <sql id="Base_Column_List">
    id, `name`, `desc`
  </sql>
  <!--
      select语句
      id: 标识映射文件中的sql, 称为statement的id
      parameterType: 指定输入参数的类型, 可以是Java数据类型,也可以是数据库的数据类型
      resultMap: 结果集映射id
      resultType: 指定sql输出结果的映射的Java对象类型, 可以是简单类型，也可以是pojo
      #{}: 表示占位符
   -->
  <select id="selectByPrimaryKey" parameterType="java.lang.Integer" resultMap="BaseResultMap">
    select
    <!-- 引用sql片段 -->
    <include refid="Base_Column_List" />
    from tb_test
    where id = #{id,jdbcType=INTEGER}
  </select>
</mapper>
```

## 4.3 实现CURD操作

> **初始化 `SqlSession`**
```java
private SqlSession sqlSession;

@Before
public void init() throws IOException {
    Reader reader = Resources.getResourceAsReader("mybatis.xml");
    SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);
    this.sqlSession = sqlSessionFactory.openSession();
}
```

> **使用mapper.xml中的namespace.id实现**
```java
@Test
public void testNamespaceId() {
    // selectList(namespace.id)
    List<User> userList = this.sqlSession.selectList("org.aron.mybatisTest.domain.dao.UserMapper.selectAll");
    System.out.println(userList);
}
```

> **使用mapper方法代理实现**

当使用mapper代理方式的话, UserMapper.xml映射文件中的`namespace`必须为接口名
```java
@Test
public void testMapper() {
    UserMapper mapper = this.sqlSession.getMapper(UserMapper.class);
    List<User> users = mapper.selectAll();
    System.out.println(users);
}
```

**`UserMapper.java`**

```java
package org.aron.mybatisTest.domain.dao;
import org.aron.mybatisTest.domain.pojo.User;
import java.util.List;

public interface UserMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(User record);

    int insertSelective(User record);

    User selectByPrimaryKey(Integer id);

    List<User> selectAll();

    int updateByPrimaryKeySelective(User record);

    int updateByPrimaryKey(User record);
}
```

# 5. Mybatis.xml详解

> **配置的内容和顺序如下：**

- [properties（属性）](#properties)
- [settings（全局配置参数）](http://www.mybatis.org/mybatis-3/zh/configuration.html#settings)
- [typeAliases（类型别名）](#typeAliases)
- [typeHandlers（类型处理器）](http://www.mybatis.org/mybatis-3/zh/configuration.html#typeHandlers)
- [objectFactory（对象工厂）](http://www.mybatis.org/mybatis-3/zh/configuration.html#objectFactory)
- [plugins（插件）](http://www.mybatis.org/mybatis-3/zh/configuration.html#plugins)
- [environments（环境集合属性对象）](http://www.mybatis.org/mybatis-3/zh/configuration.html#environments)
- [environment（环境子属性对象）](http://www.mybatis.org/mybatis-3/zh/configuration.html#environment)
- [transactionManager（事务管理）](http://www.mybatis.org/mybatis-3/zh/configuration.html#transactionManager)
- [dataSource（数据源）](http://www.mybatis.org/mybatis-3/zh/configuration.html#dataSource)
- [mappers（映射器）](#mappers)

> <span id ="properties">**Properties 属性**</span>

```xml
<!--
    加载配置文件
    1. 在properties元素体内定义的属性首先被读取
    2. 然后会读取properties元素中resource或url加载的属性，它会覆盖已读取的同名属性
-->
<properties resource="jdbc.properties">
    <!-- properties元素体内定义属性 -->
    <property name="jdbc.password" value="123456"/>
</properties>

<!-- 使用${}获取配置文件的参数 -->
<property name="driver" value="${jdbc.driver}"/>
```

> **<span id="typeAliases">typeAliases 类型别名</span>**

> 自定义别名

`mybatis.xml`

```xml
<!-- 
    类型别名
    同时定义<typeAlias type="org.aron.mybatisTest.domain.pojo.User" alias="User1"/>和
    <package name="org.aron.mybatisTest.domain.pojo"/> 时,别名以 typeAlias为准
-->
<typeAliases>
    <!-- 单个别名定义 -->
    <typeAlias type="org.aron.mybatisTest.domain.pojo.User" alias="User1" />
    <!-- 批量别名定义, 扫描整个包下的类, 别名为类名(大小写不敏感), 可定义多个package -->
    <package name="org.aron.mybatisTest.domain.pojo"/>
</typeAliases>
```

当使用`@Alias`定义别名时,覆盖其他的别名定义,以注解所定义的别名为最终标准
```java
@Alias("user2")
public class User {}
```

`UserMapper.xml`

```xml
<!-- 使用别名 -->
<insert id="insert" parameterType="User">
    insert into tb_test (`name`, `desc`) values (#{name,jdbcType=VARCHAR}, #{desc,jdbcType=VARCHAR})
</insert>
```

> **<span id="mappers">mappers 映射器</span>**

1. 通过resource加载单个映射文件
```xml
<!--通过resource方法一次加载一个映射文件 -->
<mapper resource="mapper/UserMapper.xml"/>
```
2. 通过mapper接口加载单个mapper
```xml
<mapper class="org.aron.mybatisTest.domain.dao.UserMapper" />
```

3. 批量加载mapper(推荐使用)
```xml
<package name="org.aron.mybatisTest.domain.dao"/>
```

> **当mapper加载使用2和3时,需要遵循以下规范** 

- mapper接口类名和mapper.xml映射文件名称保持一致
- 接口类与*.xml放在同一目录下
  

目录结构
```properties
org.aron.mybatisTest.domain.dao   -- 包名
    |---- UserMapper.java
    |---- UserMapper.xml
```
**注意: `maven`项目需要在pom.xml中添加如下代码, 否则会报`org.apache.ibatis.binding.BindingException: Invalid bound statement (not found)`异常**

```xml
<build>
    <resources>
        <resource>
            <directory>src/main/java</directory>
            <includes>
                <include>**/*.xml</include>
            </includes>
        </resource>
    </resources>
</build>
```