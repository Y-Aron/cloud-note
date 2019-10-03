[环境搭建](#sysInit)
- [Ecology系统搭建](#ecology)
- [数据库配置](#dbconfig)
- [常见表介绍](#commontb)
- [开发技巧](http://note.youdao.com/noteshare?id=43b584416968ba9bb48a1558b537fd9c&sub=2219C93FB418484F90A3BB093C475643)

[前端开发](#front)
- [PC前端开发规范](http://note.youdao.com/noteshare?id=6ce9ae155aca65222896459bba18e659&sub=F75ABB6D5F1948EBABB0A57C60087154)
- [流程表单前端API](#workflowApi)
- [建模表单前端API](https://note.youdao.com/ynoteshare1/index.html?id=80b33eaf90424ed593f356f43c39021e&type=note)
- [E9门户主题事件注册](https://note.youdao.com/ynoteshare1/index.html?id=e7db8691fb5bf16e8ac292c68b6da8b1&type=note&tdsourcetag=s_pctim_aiomsg)
- [其他常用方法](#tools)
- [脚手架开发](http://note.youdao.com/noteshare?id=a890388bdc726d017c0460d56b8b22e2&sub=ABF70ED4654340C088A281CEED62F42C)
- [建模查询中自定义按钮](#customBtn)
- [Ecode在线编辑器](https://note.youdao.com/ynoteshare1/index.html?id=a5e572802b333a80eb288ac8309b6f9c&type=note)

[后端开发](#back)
- [web.xml配置](#backconfig)
- [接口白名单配置](http://note.youdao.com/noteshare?id=14e6d168a26512c0405727cd1585d9f6&sub=986DB6BD6436413F9F7F278FE94AEA2A)
- [项目结构](#construction)
- [后端API路径规范](#paths)
- [Jersey框架的使用](https://jersey.github.io/documentation/latest/index.html)
- [其他常用接口](#customBtn)
- [缓存服务SDK](#cache)
- [数据库操作](#dbtools)
- [Token认证](http://note.youdao.com/noteshare?id=29add5adc2f529ada5f2ff52e1ec9176&sub=20269BA7CA7B4A6496B63909FF564EA7)

### <span id="sysInit">一、环境搭建</span>

**<span id="ecology">Ecology系统搭建</span>**

- 准备`ecology` | `Resin` | `jdk1.8[可直接使用已安装的]`
- 修改resin配置 `F:\WEAVER\Resin\conf\resin.conf`

```xml
// 修改jdk路径：相对路径或者绝对路径
<javac compiler="C:\Program Files\Java\jdk1.8.0_151\bin\javac" args="-encoding UTF-8"/>

// 修改ecology路径
<web-app id="/" root-directory="F:\WEAVER\ecology">
```

- 修改resin启动配置 `G:\WEAVER\ecology9\Resin\resinstart.bat`

其中`java_home` 为`jdk`的路径，可以是相对路径也可以是绝对路径

```
set java_home=C:\Program Files\Java\jdk1.8.0_151
```

- 启动`resin` 点击`resinstart.bat`
- 初始验证码文件路径 `ecology/WEB-INF/code.key`

> Ecology 主要目录说明

- `ecology/classbean`：存放编译后的class文件
- `ecology/log`：系统中日志存放目录
- `ecology/WEB-INF/prop`：`web`配置文件目录
- `ecology/WEB-INF/lib`：系统`jar`包路径 

------

**<span id="dbconfig">数据库配置</span>**

如果数据库与Ecology不在同一台服务器上，则可以修改数据库配置文件中的数据库配置。

> 数据库配置文件路径：`ecology/WEB-INF/prop/weaver.properties`

```properties
# sqlServer
DriverClasses = com.microsoft.sqlserver.jdbc.SQLServerDriver
ecology.url = jdbc:sqlserver://host:port;DatabaseName=dbname
ecology.user = username
ecology.password = password
```

```properties
# oracle
DriverClasses = oracle.jdbc.OracleDriver
ecology.url = jdbc:oracle:thin:@host:port:ecology
ecology.user = username
cology.password = password
```
---

**<span id="commontb">常见表介绍</span>**

[Ecology9常见表](http://note.youdao.com/noteshare?id=d1457148b0a2e0a541d7f852fc189433&sub=0D3F6E71AC0F41569074CA7610E31C61)

------

#### <span id="front">二、前端开发</span>

`ecology9`前端上采用`react`+`antd`+`mobx`+`react-router`等框架实现的单页面应用。

**<span id="workflowApi">流程表单前端接口</span>**

- 所有接口统一封装在全局对象`window.WfForm`中
- 表单字段相关操作，不推荐使用jQuery，禁止原生JS直接操作DOM结构！
- 在开发过程中，推荐都使用API接口操作，由产品统一运维；同时使用API才能完整的兼容移动终端

详细API查看文件[E9流程表单前端接口API](https://note.youdao.com/ynoteshare1/index.html?id=c3414829ce6a65259a55d750a83ba00a&type=note#/)

**<span id="tools">其他常用方法</span>**

其中工具组件封装在 `window.ecCom.WeaTools`中

- 异步请求

参数说明如下：

| 参数   | 说明     | 类型   | 可选值        | 默认   |
| ------ | -------- | ------ | ------------- | ------ |
| url    | 接口路径 | string |               |        |
| method | 请求类型 | string | 'GET' 'POST'  | 'GET'  |
| params | 请求参数 | object |               | { }    |
| type   | 响应类型 | string | 'json' 'text' | 'json' |

```javascript
var callApi = ecCom.WeaTools.callApi;

callApi(url, method, params, type).then(data => {
    console.log('响应数据', data);
});
```

- 本地缓存

| 参数       | 说明                                 | 类型                                               |
| ---------- | ------------------------------------ | -------------------------------------------------- |
| set        | 存储到 localStorage / sessionStorage | function ( key : string , value : string / object) |
| getStr     | 以 JSON 字符串形式取出               | function ( key : string )                          |
| getJSONObj | 以 JSON 对象形式取出                 | function ( key : string )                          |

```javascript
const { ls, ss } = ecCom.WeaTools;

//设置
ls.set('test',{test:1}); // localStorage.test = '{"test":1}'

//获取字符串
ls.getStr('test'); // '{"test":1}'

// 获取json
ls.getJSONObj('test'); // {test:1}
```

- 创建React组价

| 参数     | 说明           | 类型 |
| -------- | -------------- | ---- |
| domEle   | 创建的位置     |      |
| comsName | 创建的组件     |      |
| props    | 组件的属性     |      |
| children | 组件的子节点   |      |
| callback | 创建成功的回调 |      |

```javascript
const { createReactEle } = ecCom.WeaTools.WeaTools;
function (domEle, comsName, props, children, callback) {
    return 实例对象.
}
栗子：
var dom = createReactEle(document.body, 'input', {value: 'test'});
```

**<span id="customBtn">建模查询中自定义按钮</span>**

![image](F2012337CEF94B36A2FEF999580FF2A9)

注意：

- 方法体中每个语句必须以`;`结尾；否则会报错！

- `params`的值等于 ` ‘field1+field2+field3’` 这个值是一个字符串

- `id`指的是数据`ID`

  #### <span id="back">三、后端开发</span>

  **<span id="backconfig">web.xml配置</span>**

> 配置`jersey` (正式系统已经配置)

- 引入 `jersey-bundle-1.19.1.jar` 包 到`ecology/WEB-INFO/lib`
- 在 `web.xml` 中添加以下配置 

```xml
<!-- ecology/WEB-INF/web.xml -->
<servlet>
    <servlet-name>restservlet</servlet-name>
    <servlet-class>com.sun.jersey.spi.container.servlet.ServletContainer</servlet-class>
    <init-param>
        <param-name>com.sun.jersey.config.property.packages</param-name>
        <!-- 设置jersey的扫包路径；可配置多个，以；隔开 -->
        <param-value>com.cloudstore;com.api</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>
<servlet-mapping>
    <servlet-name>restservlet</servlet-name>
    <url-pattern>/api/*</url-pattern>
    <!-- 自定义接口前缀，绕开过滤器拦截 -->
    <url-pattern>/port/*</url-pattern>
</servlet-mapping>
```

注意： /api/* 的请求必须在用户登录时才能进行访问。否则会被过滤器过滤。其 web.xml 配置 SessionFilter 实
现了过滤拦截。当然也可以自定义接口前缀，如上配置了 /port/*

```xml
<filter>
    <filter-name>SessionFilter</filter-name>
    <filter-class>com.cloudstore.dev.api.service.SessionFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>SessionFilter</filter-name>
    <!-- 拦截 /api/* 请求，做是否登录以及其他逻辑判断 -->
    <url-pattern>/api/*</url-pattern>
</filter-mapping>
<filter-mapping>
    <filter-name>SessionFilter</filter-name>
    <url-pattern>/page/interfaces/*.jsp</url-pattern>
</filter-mapping>
```

------

**<span id="construction">项目结构</span>**

> 一般情况下遵循以下项目结构进行后端开发

```xml-dtd
com.api.aron
		|-- web			接口定义层
	engine.aron
		|-- web 		接口实现层
		|-- service 	服务定义层
			|-- impl 	服务实现层
		|-- domain		数据层
			|-- cmd		原子操作层定义
			|-- dao		Dao层
		|-- mapper		mapper接口定义层
```

注意： 
- `ServiceImpl.java `必须继承 `com.engine.core.impl.Service`
- 使用 `ServiceUtil.getService(DocumentServiceImpl.class);` 即可获取自定义服务类。

**项目环境搭建**

> 使用 IDEA 开发编辑器

- 创建 `Java`项目
- 添加所需依赖
- File -> Project Structure -> Project Settings -> Libraries ecology的jar路径有: `ecology/WEB-INF/lib`; `resin/lib`; `ecology/classbean`;
- 其中`classbean`是必须要引入的, 其他两个按需引入
- 添加`ecology/classbean`到项目依赖中
- 编译`Java`文件将编译后的`class`文件放入`ecology/classbean/`目录下即可

==注意:== `ecology/classbean` 最好备份, 因为`IDEA`在编译的时候可能会清除掉已有的`classbean`

后端项目结构以及开发案例详见手册: [E9后端开发指南](https://e-cloudstore.com/e9/file/E9BackendDdevelopmentGuide.pdf)

---

**<span id="paths">后端API路径规范</span>**

| 模块     | 文件路径（含下级）  | 接口访问地址       |
| -------- | ------------------- | ------------------ |
| 流程     | com.api.workflow    | /api/workflow/…    |
| 门户     | com.api.portal      | /api/portal/…      |
| 文档     | com.api.doc         | /api/doc/…         |
| 建模     | com.api.formmode    | /api/formmode/…    |
| 移动建模 | com.api.mobilemode  | /api/mobilemode/…  |
| 会议     | com.api.meeting     | /api/meeting/…     |
| 人力     | com.api.hrm         | /api/hrm/…         |
| 财务     | com.api.fna         | /api/fna/…         |
| 项目     | com.api.prj         | /api/prj/…         |
| 公文     | com.api.odoc        | /api/odoc/…        |
| 集成     | com.api.integration | /api/integration/… |
| 微博     | com.api.blog        | /api/blog/…        |

------

**<span id="customBtn">其他常用接口</span>**

- `weaver.interfaces.workflow.action.Action`实现流程节点前后附加操作

```java
package com.api.aron.common.action;
import weaver.general.BaseBean;
import weaver.general.Util;
import weaver.hrm.User;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.*;

/**
 * @author: Y-Aron
 * @create: 2018-12-03 10:37
 **/
public class TestAction extends BaseBean implements Action {

    private String p1; //自定义参数1
    private String p2; //自定义参数2

    @Override
    public String execute(RequestInfo requestInfo) {
        this.writeLog("进入action requestid = " + requestInfo.getRequestid());

        showCurrentForm(requestInfo);

        showFormProperty(requestInfo);

        showDetailsTables(requestInfo);

        testPropValue();

        requestInfo.getRequestManager().setMessagecontent("返回自定义的错误消息");
        requestInfo.getRequestManager().setMessageid("自定义消息ID");
        this.writeLog("Action 执行完成，传入参数p1=" + this.getP1() + " p2=" + this.getP2());
        return SUCCESS;
    }
    private void testPropValue() {
        String driver = Util.null2String(getPropValue("weaver", "DriverClasses"));
        this.writeLog("driver: {}", driver);
        this.writeLog("driver: " + driver);
    }

    private void showCurrentForm(RequestInfo requestInfo) {
        String requestid = requestInfo.getRequestid(); // 请求ID
        String requestLevel = requestInfo.getRequestlevel(); // 请求紧急程度
        // 当前操作类型 submit:提交/reject:退回
        String src = requestInfo.getRequestManager().getSrc();
        // 流程ID
        String workFlowId = requestInfo.getWorkflowid();
        // 表单名称
        String tableName = requestInfo.getRequestManager().getBillTableName();
        // 表单数据ID
        int bill_id = requestInfo.getRequestManager().getBillid();
        // 获取当前操作用户对象
        User user = requestInfo.getRequestManager().getUser();
        // 请求标题
        String requestName =  requestInfo.getRequestManager().getRequestname();
        // 当前用户提交时的签字意见
        String remark = requestInfo.getRequestManager().getRemark();
        // 表单ID
        int form_id = requestInfo.getRequestManager().getFormid();
        // 是否是自定义表单
        int isbill = requestInfo.getRequestManager().getIsbill();

        this.writeLog("name = requestid, value=" + requestid);
        this.writeLog("name = requestLevel, value=" + requestLevel);
        this.writeLog("name = src, value=" + src);
        this.writeLog("name = workFlowId, value=" + workFlowId);
        this.writeLog("name = tableName, value=" + tableName);
        this.writeLog("name = bill_id, value=" + bill_id);
        this.writeLog("name = user, value=" + user);
        this.writeLog("name = requestName, value=" + requestName);
        this.writeLog("name = remark, value=" + remark);
        this.writeLog("name = form_id, value=" + form_id);
        this.writeLog("name = isbill, value=" + isbill);
    }
    /**
     * 获取主表数据
     */
    private void showFormProperty(RequestInfo requestInfo) {
        this.writeLog("获取主表数据 ...");
        // 获取表单主字段值
        Property[] properties = requestInfo.getMainTableInfo().getProperty();
        for (Property property : properties) {
            // 主字段名称
            String name = property.getName();
            // 主字段对应的值
            String value = Util.null2String(property.getValue());
            this.writeLog("name: = " + name + ", value=" + value);
        }
    }

    /**
     * 取明细数据
     */
    private void showDetailsTables(RequestInfo requestInfo) {
        this.writeLog("获取所有明细表数据 ...");
        // 获取所有明细表
        DetailTable[] detailTables = requestInfo.getDetailTableInfo().getDetailTable();
        if (detailTables.length > 0) {
            for (DetailTable table: detailTables) {
                // 当前明细表的所有数据，按行存储
                Row[] rows = table.getRow();
                for (Row row: rows) {
                    // 每行数据再按列存储
                    Cell[] cells = row.getCell();
                    for (Cell cell: cells) {
                        // 明细字段名称
                        String name = cell.getName();
                        // 明细字段的值
                        String value = cell.getValue();
                        this.writeLog("name: = " + name + ", value=" + value);
                    }
                }
            }
        }
    }

    public String getP1() {
        return p1;
    }

    public void setP1(String p1) {
        this.p1 = p1;
    }

    public String getP2() {
        return p2;
    }

    public void setP2(String p2) {
        this.p2 = p2;
    }
}
```

接口配置：

![image](F367F4D2E7934C4CAE5B8C811203127D)

------

- `weaver.interfaces.schedule.BaseCronJob`实现定时任务

```java
import weaver.interfaces.schedule.BaseCronJob;

public class TestCronJob extends BaseCronJob {

    @Override
    public void execute() {
        // ...
    }
}
```

接口配置：

![image](C57074C626CE4BE1A81905C155DAE90F)

------

**<span id="cache">缓存服务SDK</span>**

> 缓存基类：`Util_DataCache`

| 方法名称                                                 | 方法作用                                                  |
| -------------------------------------------------------- | --------------------------------------------------------- |
| getObjVal(String name)                                   | 从所有缓存获取 缓存数据 (主要函数)                        |
| setObjVal(String name, Object value)                     | 设置所有缓存数据 (主要函数)                               |
| setObjVal(String name, Object value,int seconds)         | 设置所有缓存数据 支持 超时自动消失 (主要函数)             |
| containsKey(String name)                                 | 判断该键名的所有缓存是否存在                              |
| clearVal(String name)                                    | 清除该键名的所有缓存                                      |
| setObjValWithEh(String name,Object value)                | 设置本地缓存 ( 特定情况下使用）                           |
| getObjValWithEh(String name)                             | 获取本地缓存（特定情况下使用）                            |
| setObjValWithRedis(String name,Object value)             | 设置Redis缓存 需要自己释放数据( 特定情况下使用）          |
| setObjValWithRedis(String name,Object value,int seconds) | 单独设置Redis缓存 超时时间(s)后释放数据( 特定情况下使用） |
| getObjValWithRedis(String name)                          | 单独获取Redis缓存( 特定情况下使用）                       |
| containsKeylWithEh(String name)                          | 判断本地缓存是否存在该键名( 特定情况下使用）              |
| clearValWithEh(String name)                              | 清除本地缓存( 特定情况下使用）                            |
| containsKeyWithRedis(String name)                        | 判断Redis上是否存在该键名( 特定情况下使用）               |
| clearValWithRedis(String name)                           | 清除Redis缓存                                             |

>  检查页面

`chechRedis.jsp` 检查`Redis`环境的状态

`getRedis.jsp` 检查`DataKey`的数据

注意数据变更后必须再次执行`setObjVal`把数据推送到`Redis`

```java
import com.cloudstore.dev.api.util.Util_DataCache;
public Map<String,String> refreshDataFormDB() {
    Map<String,String> map = new HashMap<String, String>();
    Map<String,String> mapdb = getSystemIfo("y");
    map.putAll(mapdb);
    if(mapdb.size()>0) {
        Util_DataCache.setObjVal(em_url, mapdb.get(em_url));
        Util_DataCache.setObjVal(em_corpid, mapdb.get(em_corpid));
        Util_DataCache.setObjVal(accesstoken,mapdb.get(accesstoken));
        Util_DataCache.setObjVal(ec_id,mapdb.get(ec_id));
        Util_DataCache.setObjVal(ec_url, mapdb.get(ec_url));
        Util_DataCache.setObjVal(ec_name, mapdb.get(ec_name));
        Util_DataCache.setObjVal(rsa_pub, mapdb.get(rsa_pub));
        Util_DataCache.setObjVal(ec_version, mapdb.get(ec_version));
        Util_DataCache.setObjVal(ec_iscluster, mapdb.get(ec_iscluster));
        Util_DataCache.setObjVal(em_url, mapdb.get(em_url));
        Util_DataCache.setObjVal(em_url_open, mapdb.get(em_url_open));
    }
    return map;
}
```
---

**<span id="dbtools">数据库操作</span>**

- 使用`weaver.conn.RecordSet`和`weaver.conn.RecordSetTrans`进行`SQL`调用

其中，`weaver.conn.RecordSetTrans`可用于事务处理，其他用法与`RecordSet`并无区别。

```java
RecordSet rs = new RecordSet();
String sql = "select loginid, lastname from hrmresource";
boolean bool = rs.execute(sql);

while (rs.next()) {
String loginid = rs.getString("loginid");
String lastname = rs.getString("lastname");
}

// 防止sql注入, objects 为动态参数
boolean queryBool = rs.executeQuery(sql, objects);
rs.executeUpdate(sql, objects);
```

```java
RecordSetTrans rst = new RecordSetTrans();
rst.setAutoCommit(false);

try {
    int a = 1/0;
    rst.executeUpdate(sql, "");
} catch (Exception e) {
    e.printStackTrace();
    rst.rollback();
}
```

- 使用`Mybatis`实现数据库操作

[ecology9使用Mybatis操作数据库.pdf](http://note.youdao.com/noteshare?id=3def149ab3b417983541a553db238fef&sub=37EBEFE3269740A993596BCF98439A30)