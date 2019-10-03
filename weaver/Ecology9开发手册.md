## E9开发手册

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
> ![1570108368860](.\asset\1570108368860.png)

- 方法体中存在多行代码时，每个语句必须以`;`结尾；否则会报错！

- `params`的值等于 ` ‘field1+field2+field3’` 这个值是一个字符串

- `id`指的是数据`ID`

> 前端显示

![1570109435919](.\asset\1570109435919.png)

- **配置`ecode`使用**

> 新建前置文件 `index.js`并将方法挂到全局对象 `window.g` 下

<img src=".\asset\1570109735133.png" alt="1570109735133"  />

> 新建自定义按钮

![1570109991787](.\asset\1570109991787.png)

![1570110063242](.\asset\1570110063242.png)

#### 3.2.3 页面扩展

> 后端应用中心 -> 建模引擎 -> 模块
>
> 任选一个模块 -> 页面扩展 -> 右键 -> 新建
>
> ![1570110626080](.\asset\1570110626080.png)

- 扩展用途：卡片页面、查询列表（批量操作）、卡片页面和查询列表
  - 卡片页面：可以设置页面扩展显示在卡片信息页面，可以选择在新建页面、编辑页面、查看页面显示页面扩展。
  - 查询列表（批量操作）：设置在查询列表时，则会在引用该模块的查询列表的批量操作中显示页面扩展项，在批量操作中勾选后会在前台列表中显示对应的页面扩展项。
  - 卡片页面和查询列表：可以设置页面扩展项既显示在对应的卡片页面又显示在查询列表（批量操作）中。
- `javascript:test()`: 该方法可以在 `建模引擎 -> 查询 -> 该模块的查询列表 -> 编辑代码块` 中定义

![1570110945435](.\asset\1570110945435.png)

![1570110988895](.\asset\1570110988895.png)

> 前端按钮测试如下

![1570110886190](.\asset\1570110886190.png)

- 页面扩展同样可以配置 `ecode`使用，将**链接目标地址**改成: `javascript: window.g.test()`即可，建议这样做，方便后续代码维护。

## 3.3 [E9组件库](http://203.110.166.60:8087/spa/coms/index.html#/pc/doc/common-index)