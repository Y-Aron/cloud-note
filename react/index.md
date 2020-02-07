# React 入门

## 1. 创建 `React` 脚手架

> `yarn add global create-react-app` 全局创建`create-react-app`

- 使用 `create-react-app` 创建 `react` 脚手架 > `create-react-app react-admin`
- `cd react-admin`  进去项目目录
- `yarn start` 启动现目服务器

## 2. 使用装饰器模式

- `yarn add global react-app-rewired mobx mobx-react customize-cra @babel/plugin-proposal-decorators`
- 在项目根目录下创建 `config-overrides.js`

```javascript
const { override, addDecoratorsLegacy, disableEsLint, addWebpackAlias } = require("customize-cra");
const path = require('path');

const resolve = dir => path.join(__dirname, '.', dir);

/* config-overrides.js */
module.exports = override(
  // 开启装饰器模式
  addDecoratorsLegacy(),
  // 禁用eslint
  disableEsLint(),
  // 配置路径别名
  addWebpackAlias({
    '@': resolve('src')
  })
);
```

## 3. 安装使用 antd 

> yarn add antd



## 4. 国际化

> 吐槽下 `react-intl`与`react-i18next`这两个国际化的包。可能是外国人的思想跟中国人不一样。妈蛋的都是基于视图层定制的。用的简直想吐血！还是用阿里妈妈家的`react-intl-universal`舒服！

- `yarn add global react-intl-universal` 
- 初始化 => 加载数据

```javascript
import zh from '@/locales/zh-CN'
import Cookies from 'js-cookie'

// 这里可以导入json文件的数据
const en = {
  "username": "admin"
}
const zh = {
  "username": "管理员"
}

const locales = {
  "en-US": en,
  "zh-CN": zh
}
// 加载多语言数据
loadLocales = () => {
    const lang = Cookies.get('lang') || navigator.language || 'zh-CN';
    return intl.init({
        currentLocale: lang,
        locales
    })
}
```

- 使用 `init.get('username')` 获取数据