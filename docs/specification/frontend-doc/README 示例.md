# 项目简介

- Codegen ，凌久数据中台，是一个××××的项目，主要为了解决××××问题

- 前端基于 `Ant Design Pro` 定制开发

  > 1. 主体技术框架： `react + umi`
  > 2. UI 组件库： `antd`
  > 3. Ajax库： `axios`
  > 4. css处理器：`scss`

- 线上预览地址：http://www.abc.com

- 仓库地址：http://gitlab.software.dc/mp-data/codegen.git

- 接口文档：



# 项目成员

- 主负责人：黄忠浩

  > 1. 具体职责1
  > 2. 具体职责2

- 开发者

  > 张三
  >
  > 1. 具体职责1
  > 2. 具体职责2
  >
  > 李四
  >
  > 1. 具体职责1
  > 2. 具体职责2

- 测试

- 运维

- UE

- UI



# 安装和运行



## 运行环境

```markdown
node >= 10
```



## 分支说明

> - master 
> - dev-1.0：开发分支，1.0版本
> - prod-1.0：发布分支，1.0版本



## 安装

```sh
yarn install
# or
npm install
```



## 开发

```sh
yarn start
# or 
npm run start
```



## 发布

```sh
yarn build 
# or
npm run build
```



## 其它

```sh
# 代码风格检查
npm run lint

# 代码格式检查并自动修复
npm run lint -- --fix
```



# 项目目录

```markdown
├── node_modules  依赖包
├── public  模板html、ico
├── src
│    ├── api  接口请求处理统一文件
│    │     ├── request.js  基于 axios 封装请求模块
│    │     ├── index.js  对应的页面接口api
│    ├── assets  静态资源文件夹
│    │     ├── images  图片
│    │     ├── styles  css 全局css sass/less变量
│    ├── components  可复用全局组件
│    ├── router  项目路由
│    ├── store  状态管理
│    │     ├── index.js 状态管理入口文件
│    │     ├── modules 状态模块文件夹
│    ├── utils  常用全局方法文件夹
│    │     ├── const 存放常量文件夹：正则、其它变量
│    ├── pages  页面文件夹
│    │     ├── index 页面模块文件夹
│    │             ├── const.js 每个页面的常量配置，如表格的搜索条
│    │             ├── Index.vue 对应的页面 使用大写驼峰命名或者小写中划线命名name-name.vue
│    ├── App.js
│    ├── main.js 页面入口文件
├── package.json 描述应用的依赖关系和对外暴露的脚本接口
├── webpack.config.js  项目webpack配置
```



# 功能特性



## 功能说明

按模块介绍具体功能



## 路由信息

> - user  用户中心
>
>   > - user/login 登录
>   >
>   > - user/register 注册
>   >
>   > - user/password 密码服务
>   >
>   >   > - user/password/forget 忘记密码
>   >   > - user/password/modify 修改密码
>
> - system 系统设置
>
>   >- system/users 系统用户管理
>   >- system/roles 系统角色管理
>   >- system/apps 系统应用管理
>   >- system/menus 系统菜单管理
>
>   



## 存在问题

- 需要优化的功能
- 现存已知的bug

# 项目状态

- 开发阶段
- 测试阶段
- 完成阶段
- 停止维护
- 已迁移

# 版本记录

- 2.0 版本
  1. 修复了哪些问题
  2. 新加入了哪些功能
- 1.0 版本
  1. 包含哪些功能

# 文档和来源

- # Ant Design Pro

  基于 Ant Design Pro 定制开发，https://pro.ant.design/index-cn





