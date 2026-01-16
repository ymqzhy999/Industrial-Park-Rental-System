<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'

const router = useRouter()
const username = ref('')
const password = ref('')
const isLoading = ref(false)

const handleLogin = async () => {
  if (!username.value || !password.value) {
    alert('请输入账号和密码')
    return
  }

  isLoading.value = true

  try {
    const res = await axios.post('http://127.0.0.1:5000/api/login', {
      username: username.value,
      password: password.value
    })

    if (res.data.code === 200) {
      const userInfo = res.data.data

      // 1. 存入本地缓存
      localStorage.setItem('user', JSON.stringify(userInfo))

      // 2. 【核心修改】根据角色跳转不同页面
      // 假设数据库里 role: 0 是管理员，1 是普通用户
      if (userInfo.role === 0) {
        // -> 跳转到管理员面板 (也就是我们刚才写的房源管理页)
        router.push('/admin/factory-manage');
      } else {
        // -> 跳转到普通用户首页
        router.push('/dashboard')
      }

    }
  } catch (error: any) {
    if (error.response) {
       alert(error.response.data.msg)
    } else {
       alert('登录请求失败')
    }
  } finally {
    isLoading.value = false
  }
}
</script>

<template>
  <div class="login-container">
    <div class="overlay"></div>

    <div class="login-box">
      <div class="brand-strip"></div>

      <div class="header">
        <h1>🏭 工业园区</h1>
        <p class="subtitle">厂房租赁与合同管理控制台</p>
      </div>

      <div class="form-content">
        <div class="form-item">
          <label>管理账号</label>
          <input v-model="username" type="text" placeholder="请输入用户名" @keyup.enter="handleLogin"/>
        </div>

        <div class="form-item">
          <label>登录密码</label>
          <input v-model="password" type="password" placeholder="请输入密码" @keyup.enter="handleLogin"/>
        </div>

        <button @click="handleLogin" :disabled="isLoading" class="login-btn">
          {{ isLoading ? '系统连接中...' : '进入工作台 →' }}
        </button>

        <div class="footer-links">
          <router-link to="/register" class="link">注册新企业入驻</router-link>
          <span class="divider">|</span>
          <a href="#" class="link help">联系园区物业</a>
        </div>
      </div>
    </div>

    <div class="system-copyright">
      &copy; 2026 Industrial Park Management System. All Rights Reserved.
    </div>
  </div>
</template>

<style scoped>
/* 1. 背景设计 */
.login-container {
  height: 100vh;
  width: 100vw;
  display: flex;
  justify-content: center;
  align-items: center;
  /* 这里的 URL 是一个免费商用的现代化工厂内部图片 */
  background-image: url('https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?q=80&w=2070&auto=format&fit=crop');
  background-size: cover;
  background-position: center;
  position: relative;
}

/* 2. 深色遮罩 */
.overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(18, 28, 45, 0.8); /* 稍微加深了一点遮罩，让文字更白 */
  z-index: 1;
}

/* 3. 登录卡片 */
.login-box {
  position: relative;
  z-index: 2;
  width: 420px;
  background: #ffffff;
  border-radius: 2px; /* 极小的圆角，硬朗风格 */
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.6);
  overflow: hidden;
}

/* 4. 顶部装饰条：【修改点】改为纯深蓝色 */
.brand-strip {
  height: 8px; /* 稍微加厚一点，增加厚重感 */
  width: 100%;
  background: #1a3b5d; /* 纯深蓝，不再有橙色渐变 */
}

.header {
  padding: 40px 40px 20px;
  text-align: left;
  border-bottom: 1px solid #eee;
}

.header h1 {
  margin: 0;
  font-size: 26px;
  color: #1a3b5d; /* 标题也用深蓝色呼应 */
  font-weight: 800;
  letter-spacing: 1px;
}

.subtitle {
  margin: 8px 0 0;
  color: #7f8c8d;
  font-size: 14px;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.form-content {
  padding: 30px 40px 40px;
}

.form-item {
  margin-bottom: 25px;
}

.form-item label {
  display: block;
  margin-bottom: 8px;
  color: #34495e;
  font-weight: 600;
  font-size: 14px;
}

input {
  width: 100%;
  padding: 12px 15px;
  border: 2px solid #e0e6ed;
  border-radius: 2px;
  background-color: #f8f9fa;
  font-size: 15px;
  transition: all 0.3s;
  box-sizing: border-box;
}

input:focus {
  border-color: #1a3b5d; /* 聚焦也是深蓝 */
  background-color: #fff;
  outline: none;
}

/* 5. 按钮 */
.login-btn {
  width: 100%;
  padding: 14px;
  background-color: #1a3b5d; /* 实业深蓝 */
  color: white;
  border: none;
  border-radius: 2px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  letter-spacing: 1px;
  transition: background 0.3s;
}

.login-btn:hover {
  background-color: #132a44; /* 悬停变黑一点点 */
}

.login-btn:disabled {
  background-color: #95a5a6;
  cursor: not-allowed;
}

.footer-links {
  margin-top: 25px;
  text-align: center;
  font-size: 14px;
  color: #95a5a6;
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 10px;
}

.divider {
  color: #e0e0e0;
}

.link {
  color: #34495e;
  text-decoration: none;
  font-weight: 500;
  transition: color 0.2s;
}

/* 【修改点】悬停颜色改为亮蓝色，去掉橙色 */
.link:hover {
  color: #3498db;
  text-decoration: underline;
}

.system-copyright {
  position: absolute;
  bottom: 20px;
  color: rgba(255, 255, 255, 0.4);
  font-size: 12px;
  z-index: 2;
  letter-spacing: 0.5px;
  font-family: monospace;
}
</style>
