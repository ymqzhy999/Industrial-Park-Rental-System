# 第一部分：工业园区厂房租赁与推荐平台 - 项目详解

## 1. 📋 项目功能详细介绍

本项目是一个基于 B/S 架构的前后端分离系统，旨在解决工业厂房租赁中的“信息不对称”问题，并引入了算法来辅助用户决策。

### A. 核心业务功能

1. **厂房信息展示与检索**：
* **列表展示**：分页展示所有厂房，卡片式布局，包含图片、价格、面积、标签（如独栋、高层）等信息。
* **多维筛选与搜索**：支持通过关键词（如“松山湖”、“精密制造”）模糊搜索，虽然目前主要实现了关键词搜索，但架构支持扩展更多筛选。
* **详情查阅**：点击卡片进入详情页，查看具体参数（层高、配电、承重）、详细描述及联系方式。


2. **用户交互系统**：
* **身份认证**：支持用户注册、登录，使用 Token 机制保持登录状态。
* **收藏/关注 (User Profile)**：用户可以点击“星星”收藏感兴趣的厂房。系统会在数据库记录 `(user_id, factory_id)` 关系。
* **实时反馈**：前端通过 Vue 的响应式特性，实时更新收藏按钮状态（实心/空心）。


3. **⭐ 智能推荐引擎 (核心亮点)**：
* **协同过滤 (Collaborative Filtering)**：这是本项目的技术核心。后端 `recommend.py` 会定期或实时计算用户间的**余弦相似度**。如果用户 A 和用户 B 都收藏了厂房 1 和 2，系统判定他们口味相似，就会把用户 B 收藏的但 A 还没看过的厂房 3 推荐给 A。
* **冷启动保护**：对于没有任何行为的新用户，算法会自动“降级”，推荐最新发布或最热门的厂房，保证首页推荐栏不留白。
* **随机探索**：为了避免推荐结果一成不变，系统对高匹配度的推荐结果进行了随机打乱，增加用户探索的新鲜感。



---

## 2. 📂 目录结构与文件作用解析

理解目录结构对于答辩时解释代码非常重要。

### 后端结构 (`backend/`)

基于 Flask 框架，采用了 **工厂模式 + 蓝图 (Blueprint)** 的架构。

```text
backend/
├── app/
│   ├── __init__.py       # ⭐ 核心入口：创建 Flask 实例，配置数据库，注册所有蓝图 (api)。
│   ├── models.py         # 💾 数据模型层：定义 User, FactoryInfo, Collection 等数据库表结构 (ORM)。
│   ├── extensions.py     # 🔌 扩展插件：初始化 SQLAlchemy (db) 等第三方库。
│   └── api/              # 🎮 接口层 (Controller)：处理前端请求，写业务逻辑的地方。
│       ├── user.py       # 用户登录、注册接口。
│       ├── factory.py    # 厂房列表、详情、收藏/取消收藏接口。
│       ├── recommend.py  # ⭐ 推荐算法核心：包含 Pandas 矩阵构建、余弦相似度计算逻辑。
│       └── contract.py   # (预留) 租赁合同相关接口。
│
├── run.py                # 🚀 启动脚本：python run.py 运行时的入口文件。
└── requirements.txt      # 📦 依赖清单：列出了 flask, pandas, scikit-learn, pymysql 等包。

```

### 前端结构 (`frontend/`)

基于 Vue 3 + Vite + Element Plus。

```text
frontend/
├── index.html            # 网页入口 HTML。
├── vite.config.ts        # 构建配置：配置了端口、别名、代理等。
├── src/
│   ├── main.ts           # ⭐ JS入口：挂载 Vue 应用，引入路由和 UI 库。
│   ├── App.vue           # 根组件：定义了页面的基本布局（如顶栏、侧边栏坑位）。
│   ├── router/           # 🛣️ 路由配置：定义 URL 跳转规则 (如 /list 跳转到 FactoryList.vue)。
│   ├── api/              # 📡 请求封装：封装 Axios，统一管理发给后端的 API 地址。
│   └── views/            # 🎨 页面视图 (View)：
│       ├── login/        # 登录/注册页面。
│       ├── factory/      
│       │   ├── FactoryList.vue  # ⭐ 核心页面：包含搜索栏、推荐栏(猜你喜欢)、厂房列表网格。
│       │   └── FactoryDetail.vue # 详情页：展示单一厂房的详细信息。
│       └── dashboard/    # 仪表盘/首页。

```

---

## 3. 🚀 部署文档 (Deployment Guide)

假设您要在答辩现场的新电脑演示，或者部署到服务器，请按此步骤操作。

### 环境准备

* **数据库**: MySQL 8.0+
* **后端语言**: Python 3.8+
* **前端环境**: Node.js 16+

### Step 1: 数据库初始化

1. 登录 MySQL，创建一个新数据库（例如 `rental_db`）。
2. 运行之前的 SQL 建表语句，创建 `sys_user`, `factory_info`, `sys_collection` 表。
3. **关键**：确保 `backend/app/__init__.py` (或 `config.py`) 中的数据库连接字符串是正确的：
```python
# 格式: mysql+pymysql://用户名:密码@地址:端口/数据库名
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:123456@127.0.0.1:3306/rental_db'

```



### Step 2: 后端启动

打开终端 (Terminal/CMD)，进入 `backend` 目录：

```bash
# 1. (可选) 创建虚拟环境，隔离依赖
python -m venv venv
# Windows 激活虚拟环境:
venv\Scripts\activate 
# Mac/Linux 激活虚拟环境:
source venv/bin/activate

# 2. 安装项目依赖
pip install -r requirements.txt

# 3. 启动服务
python run.py

```

*成功标志：控制台显示 `Running on http://127.0.0.1:5000*`

### Step 3: 前端启动

打开一个新的终端，进入 `frontend` 目录：

```bash
# 1. 安装依赖包 (首次运行需要)
npm install

# 2. 启动开发服务器
npm run dev

```

*成功标志：控制台显示 `Local: http://127.0.0.1:5173*`

### Step 4: 访问与测试

打开浏览器访问 `http://127.0.0.1:5173`，即可开始演示。
求一颗小星星 ❤️ ❤️ ❤️ ❤️ ❤️ 
