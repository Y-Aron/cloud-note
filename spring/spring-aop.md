# 1. 创建Spring的Maven项目

> `pom.xml` 配置

```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context</artifactId>
    <version>5.1.6.RELEASE</version>
</dependency>
<dependency>
    <groupId>org.aspectj</groupId>
    <artifactId>aspectjweaver</artifactId>
    <version>1.9.3</version>
</dependency>
```

# 2. 使用*.xml进行AOP配置

## 2.1 导入aop命名空间

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
            http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop.xsd" ></beans>
```
## 2.2 定义通知类

```java
@Slf4j
public class TestXmlAop {

    public void before(JoinPoint joinPoint) {
        log.info("---------- 前置通知开始 ----------");
        // 获取拦截对象
        Signature signature = joinPoint.getSignature();
        log.info("拦截的目标类: {}", signature.getDeclaringTypeName());
        log.info("拦截的方法名称: {}", signature.getName());
        log.info("输入的参数: {}", Arrays.asList(joinPoint.getArgs()));
        log.info("---------- 前置通知结束 ----------");
    }

    public Object around(ProceedingJoinPoint pjp) throws Throwable {
        log.info("---------- 环绕通知开始 ----------");
        Signature signature = pjp.getSignature();
        log.info("拦截的目标类: {}", signature.getDeclaringType());
        log.info("拦截的方法名称: {}", signature.getName());
        log.info("输入的参数: {}", Arrays.asList(pjp.getArgs()));
        Object proceed = pjp.proceed();
        log.info("拦截的方法的返回值: {}", proceed);
        log.info("---------- 环绕通知结束! ----------");
        return proceed;
    }

    public void afterReturning(JoinPoint joinPoint, Object val) {
        log.info("---------- 后置通知(如果出现异常不会调用)开始 ----------");
        log.info("{}", joinPoint);
        log.info("拦截的方法的返回值: {}", val);
        log.info("---------- 后置通知(如果出现异常不会调用)结束! ----------");
    }

    public void afterException(JoinPoint joinPoint, Exception e) {
        log.info("---------- 异常通知开始 ----------");
        log.info("{}", joinPoint);
        log.info("异常信息: {}", e.getMessage());
        log.info("---------- 异常通知结束! ----------");
    }

    public void after(JoinPoint joinPoint) {
        log.info("---------- 后置通知(如果出现异常也会调用)开始 ----------");
        Signature signature = joinPoint.getSignature();
        log.info("拦截的目标类: {}", signature.getDeclaringTypeName());
        log.info("拦截的方法名称: {}", signature.getName());
        log.info("输入的参数: {}", Arrays.asList(joinPoint.getArgs()));
        log.info("---------- 后置通知(如果出现异常也会调用)结束! ----------");
    }
}
```

## 2.3 `xml`配置
```xml
<!-- 配置通知对象 -->
<bean id="xmlAop" class="org.aron.springTest.aop.TestXmlAop"/>

<!-- 配置aop
    proxy-target-class=true: 指定cglib代理
    关于 execution 语法:
        1.execution(public * *()) 所有的public的方法
        2.execution(* cn.study.aop.*(..)) 所有的aop包下的所有类的方法(不包含子包)
        3.execution(* cn.study.aop..*(..)) 所有的aop包及其子包下的所有类的方法
        4.execution(* cn.study.aop.IOrderService.*(..)) IOrderService接口中定义的所有方法
        5.execution(* cn.study.aop.IOrderService+.*(..)) 匹配实现特定接口所有类的方法
        6.execution(* save*(..)) 区配所有的以save开头的方法
-->
<aop:config proxy-target-class="true">
    <aop:pointcut id="pointcut" expression="execution(* org.aron.springTest.bean.User.*(..))" />
    <aop:aspect ref="xmlAop">
        <!-- 定义一个切点 expression：指定切入点表达式-->
        <!-- 前置通知 -->
        <aop:before method="before" pointcut-ref="pointcut"/>
        <!-- 环绕通知 -->
        <aop:around method="around" pointcut-ref="pointcut"/>
        <!-- 后置通知(如果出现异常不会调用) returning: 返回值 -->
        <aop:after-returning method="afterReturning" pointcut-ref="pointcut" returning="val" />
        <!-- 后置通知(出现异常时调用) throwing: 异常参数 -->
        <aop:after-throwing method="afterException" pointcut-ref="pointcut" throwing="e"/>
        <!-- 后置通知 -->
        <aop:after method="after" pointcut-ref="pointcut" />
    </aop:aspect>
</aop:config>
```

## 2.4 执行结果

```
---------- 前置通知开始 ----------
拦截的目标类: org.aron.springTest.bean.User
拦截的方法名称: init
输入的参数: [aopName, aopPasswd]
---------- 前置通知结束 ----------
---------- 环绕通知开始 ----------
拦截的目标类: class org.aron.springTest.bean.User
拦截的方法名称: init
输入的参数: [aopName, aopPasswd]
aopName
aopPasswd
---------- 异常通知开始 ----------
execution(String org.aron.springTest.bean.User.init(String,String))
---------- 异常通知结束! ----------
---------- 后置通知(如果出现异常也会调用)开始 ----------
拦截的目标类: org.aron.springTest.bean.User
拦截的方法名称: init
输入的参数: [aopName, aopPasswd]
---------- 后置通知(如果出现异常也会调用)结束! ----------
```

# 3. 使用注解进行Aop配置

## 3.1 导入`aop`和`context`的命名空间

```xml
<beans xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop.xsd
            http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd"></beans>
```
## 3.2 开启`aop`注解扫描器
```xml
<context:component-scan base-package="org.aron.springTest.*" />
<aop:aspectj-autoproxy/>
```

## 3.3 定义Aspect切面类
```java
@Aspect
@Slf4j
@Component
public class TestAop {
    @Pointcut(value = "execution(* org.aron.springTest.bean.User.*(..))")
    public void pointcut(){}

    @Before("pointcut()")
    public void before(JoinPoint joinPoint) {
        log.info("---------- 前置通知开始 ----------");
        // 获取拦截对象
        Signature signature = joinPoint.getSignature();
        log.info("拦截的目标类: {}", signature.getDeclaringTypeName());
        log.info("拦截的方法名称: {}", signature.getName());
        log.info("输入的参数: {}", Arrays.asList(joinPoint.getArgs()));
        log.info("---------- 前置通知结束 ----------");
    }

    @Around("pointcut()")
    public Object around(ProceedingJoinPoint pjp) throws Throwable {
        log.info("---------- 环绕通知开始 ----------");
        Signature signature = pjp.getSignature();
        log.info("拦截的目标类: {}", signature.getDeclaringType());
        log.info("拦截的方法名称: {}", signature.getName());
        log.info("输入的参数: {}", Arrays.asList(pjp.getArgs()));
        Object proceed = pjp.proceed();
        log.info("拦截的方法的返回值: {}", proceed);
        log.info("---------- 环绕通知结束! ----------");
        return proceed;
    }

    @AfterReturning(pointcut = "pointcut()", returning = "val")
    public void afterReturning(JoinPoint joinPoint, Object val) {
        log.info("---------- 后置通知(如果出现异常不会调用)开始 ----------");
        log.info("{}", joinPoint);
        log.info("拦截的方法的返回值: {}", val);
        log.info("---------- 后置通知(如果出现异常不会调用)结束! ----------");
    }

    @AfterThrowing(pointcut = "pointcut()", throwing = "e")
    public void afterException(JoinPoint joinPoint, Exception e) {
        log.info("---------- 异常通知开始 ----------");
        log.info("{}", joinPoint);
        log.info("异常信息: {}", e.getMessage());
        log.info("---------- 异常通知结束! ----------");
    }

    @After("pointcut()")
    public void after(JoinPoint joinPoint) {
        log.info("---------- 后置通知(如果出现异常也会调用)开始 ----------");
        Signature signature = joinPoint.getSignature();
        log.info("拦截的目标类: {}", signature.getDeclaringTypeName());
        log.info("拦截的方法名称: {}", signature.getName());
        log.info("输入的参数: {}", Arrays.asList(joinPoint.getArgs()));
        log.info("---------- 后置通知(如果出现异常也会调用)结束! ----------");
    }
}
```