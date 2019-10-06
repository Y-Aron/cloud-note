## 1. 创建Spring的Maven项目

> `pom.xml` 配置

```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context</artifactId>
    <version>5.1.6.RELEASE</version>
</dependency>
```

## 2. Bean的实例化方式

### 2.1 无参构造函数创建对象

> 对于这种方式, 注意Bean类中必须提供无参数构造
```xml
<!-- bean参数介绍:
    1. scope:
        prototype: 多例对象, 对象在IOC容器之前就已经创建
        singleton: 单例对象(默认值)，对象在使用时才创建
    2. lazy-init:
        true: 对象在使用时创建，只对单例对象有效(scope=singleton)
        false: 对象在IOC容器之前就已经创建 默认值
    3. init-method: 创建对象时初始化方法
    4. destroy-method: 执行ClassPathXmlApplicationContext.close()时执行的方法。注意当scope=prototype时，是不会执行destroy-method
-->
<bean id="user" class="org.aron.springTest.bean.User" scope="prototype" destroy-method="destroy" lazy-init="true"/>
```

### 2.2 静态工厂方式

> 需要创建一个工厂类,在工厂类中提供一个static返回bean对象的方法
```xml
<!--class: 工厂类，factory-method: 静态方法-->
<bean id="user" class="org.aron.springTest.bean.UserFactory" factory-method="createStaticUser" />
```
`UserFactory`
```java
public class UserFactory {
    public static User createStaticUser() {
        return new User();
    }
}
```

### 2.3 实例工厂方式

> 需要创建一个工厂类,在工厂类中提供一个非static的创建bean对象的方法,在配置文件中需要将工厂配置,还需要配置bean
```xml
<!--factory-bean：工厂类 factory-method: 非静态方法 -->
<bean id="userFactory" class="org.aron.springTest.bean.UserFactory"/>
<bean id="user" factory-bean="userFactory" factory-method="createUser"/>
```
`UserFactory`
```java
public class UserFactory {
    public User createUser() {
        return new User();
    }
}
```

## 3. 获取Bean对象

### 3.1 使用BeanFactory创建IOC容器,并获取bean对象

```java
public void testBeanFactory() {
    // 加载 Spring配置文件
    Resource resource = new ClassPathResource("xmlBean.xml");
    // 通过 XmlBeanFactory + 配置文件来创建IOC容器
    BeanFactory factory = new XmlBeanFactory(resource);
    // 获取User对象
    User user = factory.getBean(User.class);
    log.info("{}", user);
}
```

### 3.2 使用 ApplicationContext创建IOC容器,并获取bean对象
```java
public void testApplicationContext() {
    ApplicationContext appContext = new ClassPathXmlApplicationContext("xmlBean.xml");
    // 根据beanName 创建对象
    User user = (User) appContext.getBean("user");
    log.info("{}", user);

    // 根据Class创建对象
    user = appContext.getBean(User.class);
    log.info("{}", user);

    // 根据beanName 获取对象的class
    Class<?> type = appContext.getType("user");
    log.info("{}", type);

    // 根据class获取bean对象
    // 当class为抽象类或者接口时，获取IOC容器中所有的实现类
    Map<String, IUser> beans = appContext.getBeansOfType(IUser.class);
    log.info("{}",beans);

    // 根据Class获取beanName
    // 当class为抽象类或者接口时，获取IOC容器中所有实现类的beanName
    String[] names = appContext.getBeanNamesForType(IUser.class);
    log.info("{}", (Object) names);

    // 获取注解下所有的 bean对象
    Map<String, Object> map = appContext.getBeansWithAnnotation(Controller.class);
    log.info("{}", map);
}
```
`User.java`
```java
@Slf4j
@NoArgsConstructor
@Setter @Getter
@ToString
public class User extends IUser {
    private String username;
    private String password;
    private Role role;
    private List<String> interests;
    private Properties properties;
    private String[] array;
    private Map<String, String> map;
    private Set<String> set;

    public User(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public User(String username, String password, Role role) {
        this.username = username;
        this.password = password;
        this.role = role;
    }
}
```

`IUser.java`
```java
public abstract class IUser {}
```

## 4. 属性注入

### 4.1 构造器注入

```xml
<bean id="role" class="org.aron.springTest.bean.Role" />
<bean id="user" class="org.aron.springTest.bean.User" >
    <!-- index: 参数在构造方法上的位置 -->
    <!-- name: 参数名称 -->
    <!-- type: 参数类型 -->
    <!-- value: 参数值 -->
    <constructor-arg index="0" name="username" type="java.lang.String" value="user" />
    <constructor-arg index="1" name="password" type="java.lang.String" value="passwd" />
    <!-- 当构造函数的值是一个对象，而不是一个普通类型的值时，使用ref属性关联bean对象 -->
    <constructor-arg index="2" name="role" type="org.aron.springTest.bean.Role" ref="role" />
</bean>
```

### 4.2 `setter`方法注入

```xml
<!--普通值类型-->
<property name="password" value="密码"/>
<!--特殊字符-->
<property name="username">
    <value><![CDATA[测试]]></value>
</property>
<!--引用类型-->
<property name="role" ref="role" />
```

### 4.3 使用名称空间p和c进行属性注入

- c命名空间

使用c名称空间来解决构造器注入

```xml
<!--
    使用c名称空间进行参数赋值
    1. 导入c命名空间：<beans xmlns:c="http://www.springframework.org/schema/c"></beans>
    2. 使用c命名空间配置构造函数的参数
    3. c命名空间无法装配集合
-->
<bean id="user1" class="org.aron.springTest.bean.User"
      c:password="passwd"
      c:role-ref="role"
      c:username="admin"/>
```

- p命名空间

```xml
<!--
    p命名空间注入参数,
    1. 导入p命名空间: <beans xmlns:p="http://www.springframework.org/schema/p"></beans>
    2. 使用p:属性完整注入
        |-值类型: p:属性名="值"
        |-对象类型: p:属性名-ref="bean名称" -->
<bean id="sysadmin" class="org.aron.springTest.bean.Sysadmin"
      p:nickname="昵称"
      p:role-ref="role" />
```

### 4.4 集合属性注入
- 使用<array></array>或<list></list>标签注入数组
```xml
<!-- 装配数组 -->
<property name="array">
    <!-- 标签定义数组 -->
    <list>
        <value>array 111</value>
        <value>array 222</value>
        <value>array 333</value>
    </list>
</property>
```

- 使用<list></list>注入 `java.util.List`
```xml
<!-- 装配 List -->
<property name="interests" >
    <list>
        <value>list aaa</value>
        <value>list bbb</value>
        <value>list ccc</value>
    </list>
</property>
```

- 使用<set></set>注入 `java.util.Set`
```xml
<!-- 装配 Set -->
<property name="set" >
    <set>
        <value>set 123</value>
        <value>set 456</value>
        <value>set 789</value>
    </set>
</property>
```

- 使用<map></map>注入 `java.util.Map`
```xml
<!-- 装配 Map -->
<property name="map">
    <map>
        <entry key="key1" value="value1" />
        <entry key="key2" value="value2" />
        <entry key="key3" value="value3" />
    </map>
</property>
```

- 使用<props></props>注入 `java.util.Properties`
```xml
<!-- 装配 Properties -->
<property name="properties">
    <props>
        <prop key="propKet1">propValue1</prop>
        <prop key="propKet2">propValue2</prop>
        <prop key="propKet3">propValue3</prop>
    </props>
</property>
```

- 通过util命名空间配置集合类型的bean

```xml
<!-- 
    util命名空间定义 
    1. 导入util命名空间: <beans xmlns:util="http://www.springframework.org/schema/util" 
            xsi:schemaLocation="http://www.springframework.org/schema/util http://www.springframework.org/schema/util/spring-util.xsd"></beans>
    2. Array/List/Set/Map/Properties等,用法与上述相同 -->
<util:list id="roleArray" value-type="java.lang.Integer">
    <value>1</value>
    <value>2</value>
</util:list>

<!-- 使用array-ref引用集合对象 -->
<bean id="role" class="org.aron.springTest.bean.Role" c:roleName="roleName" c:array-ref="roleArray"/>
```

### 4.5 使用外部属性文件

```xml
<!--
    1. 导入context命名空间: <beans xmlns:context="http://www.springframework.org/schema/context"
           xsi:schemaLocation="http://www.springframework.org/schema/context
           http://www.springframework.org/schema/context/spring-context.xsd">
    2. 加载外部属性文件
    3. 使用 ${} 获取属性
-->
<context:property-placeholder location="classpath:/app.properties" />

<bean id="jdbcBean" class="org.aron.springTest.bean.JDBCBean">
    <constructor-arg name="username" value="${jdbc.username}"/>
    <constructor-arg name="url" value="${jdbc.url}" />
    <constructor-arg name="password" value="${jdbc.password}" />
</bean>
```

`app.properties`
```properties
jdbc.url=127.0.0.1
jdbc.username=root
jdbc.password=123456
```

## 5. SPEL的使用

> 定义字面量

- 整数: `<property name="count" value="#{5}" />`
- 小数: `<property name="frequency" value="#{89.7}" />`
- 科学计算法: `<property name="capacity" value="#{1e4}" />`
- string可以使用单引号或双引号作为字符串的定界符号
```xml
<property name="name" value="#{'Chuck'}" />

<property name="name" value='#{"Chuck"}' />
```
- Boolean: `<property name="enabled" value="#{false}" />`
- Array/List/Set: `<property name="name" value="#{{'set1', 'set2', 'set3'}}" />`
- Map/Properties: `<property name="map" value="#{{'k1': 'v1', k2: 'v2'}}">`


> 引用Bean/属性/方法

- 引用其他对象
```xml
<!-- 通过value属性和spel配置bean之间的应用关系 -->
<property name="prefix" value="#{prefixGenerator}" />
```
- 引用其他对象的属性
```xml
<!-- 通过value属性和spel配置suffix属性值为另一个bean的suffix属性值 -->
<property name="suffix" value="#{prefixGenerator.suffix}" />
```
- 调用其他方法,还可以进行链式调用
```xml
<!-- 通过value属性值和spel配置suffix属性值为另一个bean的方法的返回值 -->
<property name="suffix" value="#{prefixGenerator.toString()}" />

<!-- 方法连调 -->
<property name="suffix" value="#{prefixGenerator.toString().toUpperCase()}" />
```

> 支持的运算符号

- 算数运算符: +, -, *, /, %, ^

```xml
<property name="adjustedAmount" value="#{counter.total + 42}" />
<property name="adjustedAmount" value="#{counter.total - 20}" />
<property name="circumference" value="#{2 * T(java.lang.Math).PI * circle.radius}" />
<property name="average" value="#{counter.total / counter.count}" />
<property name="remainder" value="#{counter.total % counter.count}" />
<property name="area" value="#{T(java.lang.Math).PI * circle.radius ^ 2}" />
```
- 加号还可以用作字符串连接
```xml
<constructor-arg value="#{performer.firstName + ' ' + performer.lastName}" />
```
- 比较运算符: <, >, ==, <=, >=, lt, gt, eq, le, ge
```xml
<property name="equal" value="#{counter.total == 100}" />
<property name="hasCapacity" value="#{counter.total le 1000}" />
```
- 逻辑运算符号: and, or, not, !
```xml
<property name="large" value="#{shape.kind == shape.perimeter}" />
<property name="outOfStock" value="#{!product.available}" />
<property name="outOfStock" value="#{not product.available}" />
```
- if-else运算符: ?:(elvis)
```xml
<constructor-arg value="#{songSelect? 'jelly': 'jack'}" />
```
- if-else的变体

```xml
<constructor-arg value="#{songSelect?: 'jack'}" />
```
- 正则表达式:matches

```xml
<constructor-arg value="#{admin.email matches '[a-zA]'}" />
```
- 调用静态方法和静态属性
通过T()调用一个类的静态方法,它将返回一个Class Object,然后再调用相应的方法或属性

```xml
<property name="initValue" value="#{T(java.lang.Math).PT}" />
```