# 1. 创建Maven项目

> `pom.xml` 配置

```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context</artifactId>
    <version>5.1.6.RELEASE</version>
</dependency>
<!-- https://mvnrepository.com/artifact/org.springframework/spring-jdbc -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-jdbc</artifactId>
    <version>5.1.6.RELEASE</version>
</dependency>
<!-- https://mvnrepository.com/artifact/mysql/mysql-connector-java -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.15</version>
</dependency>

<!-- https://mvnrepository.com/artifact/com.zaxxer/HikariCP -->
<dependency>
    <groupId>com.zaxxer</groupId>
    <artifactId>HikariCP</artifactId>
    <version>3.3.1</version>
</dependency>
```

# 2. 整合 `HikariCP`

## 2.1 `jdbc.xml`配置

```xml
<context:property-placeholder location="classpath:/app.properties" />

<bean id="dataSource" class="com.zaxxer.hikari.HikariDataSource">
    <property name="jdbcUrl" value="${jdbc.url}" />
    <property name="driverClassName" value="${jdbc.driver}" />
    <property name="username" value="${jdbc.user}" />
    <property name="password" value="${jdbc.password}" />
    <property name="maximumPoolSize" value="10" />
    <property name="minimumIdle" value="3" />
    <property name="dataSourceProperties" value="#{{cachePrepStmts: true, prepStmtCacheSize: 250, prepStmtCacheSqlLimit: 2048}}" />
</bean>

<bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
    <property name="dataSource" ref="dataSource" />
</bean>
```

## 2.2 `app.properties`

```properties
jdbc.url=jdbc:mysql://127.0.0.1:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=GMT
jdbc.user=root
jdbc.password=123456
jdbc.driver=com.mysql.cj.jdbc.Driver
```

## 2.3 `curd` 测试

```java
package org.aron.springTest;

import lombok.extern.slf4j.Slf4j;
import org.aron.springTest.bean.TestTable;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import java.util.ArrayList;
import java.util.List;

@Slf4j
public class TestJDBCTemplate {

    private JdbcTemplate jdbcTemplate;

    @Before
    public void init() {
        ApplicationContext context = new ClassPathXmlApplicationContext("jdbc.xml");
        this.jdbcTemplate = (JdbcTemplate) context.getBean("jdbcTemplate");
    }

    @Test
    public void testInsert() {
        String sql = "insert into tb_test(`name`, `desc`, `nickname`) values(?,?,?)";
        int row = jdbcTemplate.update(sql, "name2", "desc2", "nickname2");
        log.info("{}", row);

        List<Object[]> list = new ArrayList<>();
        for (int i = 0; i < 10; i++) {
            list.add(new Object[]{"name" + i, "desc" + i, "nickname" + i});
        }
        int[] rows = this.jdbcTemplate.batchUpdate(sql, list);
        log.info("rows: {}", rows);
    }

    @Test
    public void testUpdate() {
        String sql = "UPDATE tb_test SET `name`=? where id=?";
        int row = jdbcTemplate.update(sql, "name2_update", 1);
        log.info("{}", row);
    }

    @Test
    public void testDelete() {
        String sql = "DELETE FROM tb_test where id=?";
        int row = jdbcTemplate.update(sql, 1);
        log.info("{}", row);
    }

    @Test
    public void testQuery() {
        String sql = "select * from tb_test";
        RowMapper<TestTable> rowMapper = new BeanPropertyRowMapper<>(TestTable.class);
        List<TestTable> testList = this.jdbcTemplate.query(sql, rowMapper);
        log.info("{}", testList);
    }
}
```

# 3. Spring事务管理

## 3.1 `xml`配置方式

- `jdbc.xml`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:tx="http://www.springframework.org/schema/tx"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
            http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd
            http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx.xsd
            http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop.xsd">

    <!-- 加载数据库参数配置文件 -->
    <context:property-placeholder location="classpath:/app.properties" />

    <!-- 初始化数据源 -->
    <bean id="dataSource" class="com.zaxxer.hikari.HikariDataSource">
        <property name="jdbcUrl" value="${jdbc.url}" />
        <property name="driverClassName" value="${jdbc.driver}" />
        <property name="username" value="${jdbc.user}" />
        <property name="password" value="${jdbc.password}" />
        <property name="maximumPoolSize" value="10" />
        <property name="minimumIdle" value="3" />
        <property name="dataSourceProperties" value="#{{cachePrepStmts: true, prepStmtCacheSize: 250, prepStmtCacheSqlLimit: 2048}}" />
    </bean>

    <bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
        <property name="dataSource" ref="dataSource" />
    </bean>

    <bean id="userRepository" class="org.aron.springTest.repository.UserRepository">
        <property name="jdbcTemplate" ref="jdbcTemplate" />
    </bean>

    <bean class="org.aron.springTest.service.impl.UserServiceImpl" id="userService">
        <property name="userRepository" ref="userRepository" />
    </bean>

    <!-- 1.配置事务管理器 -->
    <bean id="txManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="dataSource"/>
    </bean>

    <!-- 2.配置事务管理增强 -->
    <tx:advice id="txAdvice" transaction-manager="txManager" >
        <tx:attributes>
            <tx:method name="*"/>
        </tx:attributes>
    </tx:advice>

    <!-- 3.配置AOP，拦截什么方法(切入点表达) + 应用事务管理增强 -->
    <aop:config>
        <aop:pointcut id="pointcut" expression="execution(* org.aron.springTest.service..*())" />
        <aop:advisor advice-ref="txAdvice" pointcut-ref="pointcut"/>
    </aop:config>
</beans>
```
- `Dao层`
```java
public class UserRepository {

    @Setter
    private JdbcTemplate jdbcTemplate;

    public int save(String sql, Object ... args) {
        return jdbcTemplate.update(sql, args);
    }
}
```
- `Service`层
```java
public class UserServiceImpl implements UserService {

    @Setter
    private UserRepository userRepository;

    @Override
    public void save() {
        log.info("UserServiceImpl: save");
        String sql = "insert into tb_user(`name`, `desc`, `nickname`) values(?,?,?)";
        int row = userRepository.save(sql, "name" + Math.random(), "desc" + Math.random(), "nickname" + Math.random());
        log.info("{}", row);
        int c = 1/0;
        row = userRepository.save(sql, "name" + Math.random(), "desc" + Math.random(), "nickname" + Math.random());
        log.info("{}", row);
    }
}
```
- 测试
```java
@Test
public void testInsert() {
    ApplicationContext context = new ClassPathXmlApplicationContext("jdbc.xml");
    UserService userService = context.getBean(UserService.class);
    userService.save();
}
```

==使用xml配置事务,当方法体中出现异常自动回滚操作==

## 3.2 注解方式

> `jdbc-anno.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:tx="http://www.springframework.org/schema/tx"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
            http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd
            http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx.xsd">

    <!-- 加载数据库参数配置文件 -->
    <context:property-placeholder location="classpath:/app.properties" />

    <!-- 初始化数据源 -->
    <bean id="dataSource" class="com.zaxxer.hikari.HikariDataSource">
        <property name="jdbcUrl" value="${jdbc.url}" />
        <property name="driverClassName" value="${jdbc.driver}" />
        <property name="username" value="${jdbc.user}" />
        <property name="password" value="${jdbc.password}" />
        <property name="maximumPoolSize" value="10" />
        <property name="minimumIdle" value="3" />
        <property name="dataSourceProperties" value="#{{cachePrepStmts: true, prepStmtCacheSize: 250, prepStmtCacheSqlLimit: 2048}}" />
    </bean>

    <bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
        <property name="dataSource" ref="dataSource" />
    </bean>

    <!-- 1.配置事务管理器 -->
    <bean id="txManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="dataSource"/>
    </bean>

    <!-- 2.配置事务管理增强 -->
    <tx:annotation-driven transaction-manager="txManager" />

    <context:component-scan base-package="org.aron.springTest.*" />
</beans>
```
- `Dao层`

```java
@Repository
@Slf4j
public class UserRepository {

    private final JdbcTemplate jdbcTemplate;

    public UserRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public int save(String sql, Object ... args) {
        return jdbcTemplate.update(sql, args);
    }
}
```

- `Service层`
```java
@Service
@Slf4j
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    @Autowired
    public UserServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    @Transactional
    public void save() {
        log.info("UserServiceImpl: save");
        String sql = "insert into tb_user(`name`, `desc`, `nickname`) values(?,?,?)";
        int row = userRepository.save(sql, "name" + Math.random(), "desc" + Math.random(), "nickname" + Math.random());
        log.info("{}", row);
        int c = 1/0;
        row = userRepository.save(sql, "name" + Math.random(), "desc" + Math.random(), "nickname" + Math.random());
        log.info("{}", row);
    }
}
```

- 测试

```java
@Test
public void testInsert() {
    ApplicationContext context = new ClassPathXmlApplicationContext("jdbc-anno.xml");
    UserService userService = context.getBean(UserService.class);
    userService.save();
}
```