[TOC]

## 1. 环境搭建

### 1.1 Ecology安装和启动

- 准备 `ecology` | `resin` | `jdk1.8[可直接使用已安装的]`
- 修改resin配置 `resin/config/resin.conf`

```xml
// 修改jdk路径：相对路径或者绝对路径
<javac compiler="C:\Program Files\Java\jdk1.8.0_151\bin\javac" args="-encoding UTF-8"/>

// 修改ecology路径
<web-app id="/" root-directory="F:\WEAVER\ecology">
```

- 修改resin启动配置 `resin/resinstart.bat`

其中`java_home` 为`jdk`的路径，可以是相对路径也可以是绝对路径

```properties
set java_home=C:\Program Files\Java\jdk1.8.0_151
```

- 启动`resin` 点击`resinstart.bat`
- 初始验证码文件路径 `ecology/WEB-INF/code.key`

### 1.2 主要目录介绍

- `ecology/classbean`：存放编译后的class文件
- `ecology/log`：系统中日志存放目录
- `ecology/WEB-INF/prop`：`web`配置文件目录
- `ecology/WEB-INF/lib`：系统`jar`包路径 

### 1.3 数据库配置

> 如果数据库与Ecology不在同一台服务器上，则可以修改数据库配置文件中的数据库配置。
>
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

## 2. E9常见表结构

### 2.1 流程相关数据存储表

| 数据库表名               | 中文说明         | 备注                           |
| ------------------------ | ---------------- | ------------------------------ |
| workflow_base            | 流程基本信息     | isbill=1                       |
| workflow_bill            | 流程表单信息     | id > 0固定表名 id < 0 动态生成 |
| workflow_billfield       | 表单字段信息     |                                |
| workflow_billdetailtable | 表单明细表       |                                |
| workflow_nodebase        | 节点信息         |                                |
| workflow_flownode        | 流程节点信息     |                                |
| workflow_nodelink        | 流程出口信息     |                                |
| workflow_nodegroup       | 节点操作人信息   |                                |
| workflow_groupdetail     | 节点操作人详情   |                                |
| workflow_requestbase     | 请求基本信息     |                                |
| workflow_currentoperator | 请求节点操作人   |                                |
| workflow_requestlog      | 请求签字意见     |                                |
| workflow_nownode         | 请求当前节点     |                                |
| workflow_browserurl      | 系统浏览按钮信息 |                                |
| workflow_selectitem      | 下拉框信息       |                                |

### 2.2 人力资源相关数据存储

| 表名                 | 说明                         | 备注 |
| -------------------- | ---------------------------- | ---- |
| HrmResource          | 人力资源基本信息表           | -    |
| HrmResource_online   | 人员在线信息表               | -    |
| HrmResourceManager   | 系统管理员信息表             | -    |
| HrmDepartment        | 人力资源部门表               | -    |
| HrmDepartmentDefined | 人力资源部门自定义字段信息表 | -    |
| HrmSubCompany        | 人力资源分部表               | -    |
| hrmroles             | 角色信息表                   | -    |
| hrmrolemembers       | 角色人员                     | -    |
| hrmjobtitles         | 岗位信息表                   | -    |

## 3. 前端开发

> `ecology9`前端上采用`react`+`antd`+`mobx`+`react-router`等框架实现的单页面应用

### 3.1 流程开发

> 流程表单前端接口

- 所有接口统一封装在全局对象`window.WfForm`中
- 表单字段相关操作，不推荐使用jQuery，禁止原生JS直接操作DOM结构！
- 在开发过程中，推荐都使用API接口操作，由产品统一运维；同时使用API才能完整的兼容移动终端
- [E9流程表单前端接口API]([https://e-cloudstore.com/ecode/doc?appId=98cb7a20fae34aa3a7e3a3381dd8764e&tdsourcetag=s_pctim_aiomsg#E9%E6%B5%81%E7%A8%8B%E8%A1%A8%E5%8D%95%E5%89%8D%E7%AB%AF%E6%8E%A5%E5%8F%A3API](https://e-cloudstore.com/ecode/doc?appId=98cb7a20fae34aa3a7e3a3381dd8764e&tdsourcetag=s_pctim_aiomsg#E9流程表单前端接口API))

### 3.2 建模开发

#### 3.2.1 布局代码块

> 建模布局代码块使用上与流程表单的代码块基本一致，区别在于接口的SDK不同，建模表单的所有接口统一封装在全局对象 `window.ModeForm`中。

#### 3.2.2 自定义按钮

> 后端应用中心 -> 建模引擎 -> 查询
>
> 任选一个查询页面 -> 自定义按钮 -> 右键 -> 新建
>
> <img src=".\asset\1570108368860.png" alt="1570108368860"  />

- 方法体中存在多行代码时，每个语句必须以`;`结尾；否则会报错！

- `params`的值等于 ` ‘field1+field2+field3’` 这个值是一个字符串

- `id`指的是数据`ID`

> 前端显示

<img src=".\asset\1570109435919.png" alt="1570109435919"  />

- **配置`ecode`使用**

> 新建前置文件 `index.js`并将方法挂到全局对象 `window.g` 下

<img src=".\asset\1570109735133.png" alt="1570109735133"  />

> 新建自定义按钮

<img src=".\asset\1570109991787.png" alt="1570109991787"  />

<img src=".\asset\1570110063242.png" alt="1570110063242"  />

#### 3.2.3 页面扩展

> 后端应用中心 -> 建模引擎 -> 模块
>
> 任选一个模块 -> 页面扩展 -> 右键 -> 新建
>
> <img src=".\asset\1570110626080.png" alt="1570110626080"  />

- 扩展用途：卡片页面、查询列表（批量操作）、卡片页面和查询列表
  - 卡片页面：可以设置页面扩展显示在卡片信息页面，可以选择在新建页面、编辑页面、查看页面显示页面扩展。
  - 查询列表（批量操作）：设置在查询列表时，则会在引用该模块的查询列表的批量操作中显示页面扩展项，在批量操作中勾选后会在前台列表中显示对应的页面扩展项。
  - 卡片页面和查询列表：可以设置页面扩展项既显示在对应的卡片页面又显示在查询列表（批量操作）中。
- `javascript:test()`: 该方法可以在 `建模引擎 -> 查询 -> 该模块的查询列表 -> 编辑代码块` 中定义

<img src=".\asset\1570110945435.png" alt="1570110945435"  />

<img src=".\asset\1570110988895.png" alt="1570110988895"  />

> 前端按钮测试如下

<img src=".\asset\1570110886190.png" alt="1570110886190"  />

- 页面扩展同样可以配置 `ecode`使用，将**链接目标地址**改成: `javascript: window.g.test()`即可，建议这样做，方便后续代码维护。

### 3.3 [Ecode在线编辑](https://e-cloudstore.com/ecode/doc)

> 使用已经封装好的[E9组件库](http://203.110.166.60:8087/spa/coms/index.html#/pc/doc/common-index)进行页面开发或者页面改写会更加便捷迅速。

### 3.4 [前端脚手架开发](https://note.youdao.com/ynoteshare1/index.html?id=a890388bdc726d017c0460d56b8b22e2&type=note)

---

## 4. 后端开发

### 4.1 `Java`项目环境搭建

#### 4.1.1 `web.xml` 配置部分介绍

> `API` 接口的`xml`配置

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

#### 4.1.2 项目环境搭建

> 使用 `IDEA` 编辑器

- 创建`Java`项目
- 添加所需依赖

**File -> Project Structure -> Project Settings -> Libraries**

需要添加的`ecology`的依赖路径有: `ecology/WEB-INF/lib`; `resin/lib`; `ecology/classbean`;

其中`classbean`是必须要引入的, 其他两个按需引入

- 编译`Java`文件将编译后的`class`文件放入`ecology/classbean/`目录下即可

==注意:== `ecology/classbean` 最好备份, 因为`IDEA`在编译的时候可能会清除掉已有的`classbean`

后端项目结构以及开发案例详见手册: [E9后端开发指南](https://e-cloudstore.com/e9/file/E9BackendDdevelopmentGuide.pdf)

#### 4.1.3 Java项目结构

> 一般情况下遵循以下项目结构进行后端开发

其中，`com.api.aron`和`com.engine.aron`中的 `aron`为自定义包名，不与已有的包重复即可。

```xml-dtd
com.api.aron			
		|-- web			接口定义层
com.engine.aron
		|-- web 		接口实现层
		|-- service 	服务定义层
			|-- impl 	服务实现层
		|-- domain		数据层
			|-- cmd		原子操作层定义
			|-- dao		Dao层
		|-- mapper		mapper接口定义层
```

### 4.2 后端API路径规范

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

### 4.3 其他接口

#### 4.3.1 流程节点前后附加操作

> 在节点前后附加操作中可设置接口动作，完成流程自定义附加操作
>
> 接口动作标识不能重复；接口动作类文件必须是类全名，该类必须实现接 `weaver.interfaces.workflow.action` 方法 `public String execute(RequestInfo request)`

参考代码如下

```java
package com.api.aron;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import weaver.general.Util;
import weaver.hrm.User;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.*;

/**
 * @author: Y-Aron
 * @create: 2018-12-03 10:37
 **/
public class TestAction implements Action {

    private String customParam; //自定义参数
    private final Logger logger = LoggerFactory.getLogger(TestAction.class);

    @Override
    public String execute(RequestInfo requestInfo) {
		logger.debug("进入action requestid = {}", requestInfo.getRequestid());
        showCurrentForm(requestInfo);

        showFormProperty(requestInfo);

        showDetailsTables(requestInfo);

        logger.debug("Action 执行完成，传入自定义参数：{}", this.getCustomParam());
//        requestInfo.getRequestManager().setMessagecontent("返回自定义的错误消息");
//        requestInfo.getRequestManager().setMessageid("自定义消息ID");
//        return FAILURE_AND_CONTINUE;  // 注释的三句话一起使用才有效果！
        return SUCCESS;
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

        logger.debug("requestid: {}", requestid);
        logger.debug("requestLevel: {}", requestLevel);
        logger.debug("src: {}", src);
        logger.debug("workFlowId: {}", workFlowId);
        logger.debug("tableName: {}", tableName);
        logger.debug("bill_id: {}", bill_id);
        logger.debug("user: {}", user);
        logger.debug("requestName: {}", requestName);
        logger.debug("remark: {}", remark);
        logger.debug("form_id: {}", form_id);
        logger.debug("isbill: {}", isbill);
    }
    /**
     * 获取主表数据
     */
    private void showFormProperty(RequestInfo requestInfo) {
        logger.debug("获取主表数据 ...");
        // 获取表单主字段值
        Property[] properties = requestInfo.getMainTableInfo().getProperty();
        for (Property property : properties) {
            // 主字段名称
            String name = property.getName();
            // 主字段对应的值
            String value = Util.null2String(property.getValue());
            logger.debug("name: {}, value: {}", name, value);
        }
    }

    /**
     * 取明细数据
     */
    private void showDetailsTables(RequestInfo requestInfo) {
        logger.debug("获取所有明细表数据 ...");
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
                        logger.debug("name: {}, value: {}", name, value);
                    }
                }
            }
        }
    }

    public String getCustomParam() {
        return customParam;
    }

    public void setCustomParam(String customParam) {
        this.customParam = customParam;
    }
}
```

> 配置：后端应用中心 -> 流程引擎 -> 路径管理 -> 路径设置
>
> 任选一个流程 -> 流程设置 -> 节点信息 
>
> 任选一个节点 -> 节点前 / 节点后附加操作 
>
> <img src=".\asset\1570114991641.png" alt="1570114991641"  />

<img src=".\asset\1570114849402.png" alt="1570114849402"  />

####  4.3.2  页面扩展接口



#### 4.3.3 计划任务