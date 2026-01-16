<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'

const router = useRouter()
const form = ref({
  username: '',
  password: '',
  confirmPassword: '',
  real_name: '',
  captcha_code: ''
})

const isLoading = ref(false)
const captchaUrl = ref('')
const captchaId = ref('')

// 请求后端接口：注意这里路径是 /api/captcha，对应后端 auth.py 的路由
const refreshCaptcha = async () => {
  try {
    const res = await axios.get(`http://127.0.0.1:5000/api/captcha?t=${Date.now()}`, {
      responseType: 'blob'
    })
    captchaId.value = res.headers['captcha-id']
    captchaUrl.value = URL.createObjectURL(res.data)
  } catch (e) {
    console.error('验证码加载失败', e)
  }
}

onMounted(() => { refreshCaptcha() })

const handleRegister = async () => {
  if (!form.value.captcha_code) return alert('请输入验证码')

  isLoading.value = true
  try {
    const res = await axios.post('http://127.0.0.1:5000/api/register', {
      username: form.value.username,
      password: form.value.password,
      real_name: form.value.real_name,
      captcha_code: form.value.captcha_code,
      captcha_id: captchaId.value
    })

    if (res.data.code === 200) {
      alert('注册成功！')
      router.push('/login')
    } else {
      alert(res.data.msg)
      refreshCaptcha() // 失败刷新验证码
    }
  } catch (error) {
    alert('注册失败')
    refreshCaptcha()
  } finally {
    isLoading.value = false
  }
}
</script>

<template>
  <div class="register-container">
    <div class="overlay"></div>
    <div class="register-box">
      <div class="brand-strip"></div>
      <div class="header">
        <h2>企业入驻申请</h2>
        <p>INDUSTRIAL PARK REGISTRATION</p>
      </div>

      <div class="form-content">
        <div class="form-item">
          <label>账号</label>
          <input v-model="form.username" placeholder="设置管理账号" />
        </div>
        <div class="form-item">
          <label>企业/联系人名称</label>
          <input v-model="form.real_name" placeholder="请输入真实名称" />
        </div>

        <div class="form-row">
          <div class="form-item half">
            <label>密码</label>
            <input v-model="form.password" type="password" placeholder="设置密码" />
          </div>
          <div class="form-item half">
            <label>确认密码</label>
            <input v-model="form.confirmPassword" type="password" placeholder="重复密码" />
          </div>
        </div>

        <div class="form-item">
          <label>人机安全验证</label>
          <div class="captcha-group">
            <input
              v-model="form.captcha_code"
              placeholder="输入验证码"
              maxlength="4"
              class="captcha-input"
            />
            <div class="captcha-img-wrapper" @click="refreshCaptcha" title="点击刷新">
              <img v-if="captchaUrl" :src="captchaUrl" />
              <span v-else>加载中...</span>
            </div>
          </div>
        </div>

        <button @click="handleRegister" :disabled="isLoading" class="reg-btn">
          {{ isLoading ? '数据加密提交中...' : '立即注册' }}
        </button>

        <div class="footer-link">
          <router-link to="/login">返回系统登录</router-link>
        </div>
      </div>
    </div>
    <div class="system-copyright">&copy; 2026 Industrial Park System</div>
  </div>
</template>

<style scoped>
/* 复用之前的主题样式，重点修改验证码部分 */
.register-container {
  height: 100vh;
  width: 100vw;
  display: flex;
  justify-content: center;
  align-items: center;
  background-image: url('https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?q=80&w=2070&auto=format&fit=crop');
  background-size: cover;
  background-position: center;
  position: relative;
}
.overlay {
  position: absolute; top: 0; left: 0; width: 100%; height: 100%;
  background: rgba(18, 28, 45, 0.85); z-index: 1;
}
.register-box {
  position: relative; z-index: 2; width: 440px;
  background: #ffffff; border-radius: 2px;
  box-shadow: 0 20px 40px rgba(0,0,0,0.6);
}
.brand-strip { height: 6px; background: #1a3b5d; }
.header { padding: 30px 40px 10px; border-bottom: 1px solid #eee; }
.header h2 { margin: 0; color: #1a3b5d; font-size: 20px; text-transform: uppercase; letter-spacing: 1px;}
.header p { margin: 5px 0 0; color: #999; font-size: 10px; letter-spacing: 2px; }

.form-content { padding: 30px 40px 40px; }
.form-item { margin-bottom: 18px; }
.form-row { display: flex; gap: 15px; }
.half { width: 50%; }
label { display: block; margin-bottom: 6px; color: #555; font-size: 12px; font-weight: bold; }

input {
  width: 100%; padding: 10px; border: 1px solid #ddd;
  background: #f4f6f8; font-size: 14px; box-sizing: border-box;
  transition: 0.3s;
}
input:focus { border-color: #1a3b5d; background: #fff; outline: none; }

/* 【重点】验证码输入框组样式 */
.captcha-group {
  display: flex;
  border: 1px solid #ddd;
  background: #fff;
  padding: 2px;
}
.captcha-input {
  flex: 1;
  border: none !important; /* 去掉input自带边框，使用外部group的边框 */
  background: transparent !important;
  height: 40px;
}
.captcha-input:focus {
  outline: none;
}
.captcha-img-wrapper {
  width: 160px;
  height: 40px;
  cursor: pointer;
  background: #eee;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}
.captcha-img-wrapper img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  opacity: 0.9;
  transition: opacity 0.2s;
}
.captcha-img-wrapper:hover img { opacity: 1; }

.reg-btn {
  width: 100%; padding: 12px; background: #1a3b5d; color: #fff;
  border: none; font-weight: bold; cursor: pointer; margin-top: 10px;
  letter-spacing: 1px;
}
.reg-btn:hover { background: #132a44; }
.footer-link { text-align: center; margin-top: 15px; font-size: 12px; }
.footer-link a { color: #666; text-decoration: none; }
.footer-link a:hover { text-decoration: underline; color: #1a3b5d; }
.system-copyright { position: absolute; bottom: 20px; color: rgba(255,255,255,0.3); font-size: 12px; z-index: 2; font-family: monospace;}
</style>
