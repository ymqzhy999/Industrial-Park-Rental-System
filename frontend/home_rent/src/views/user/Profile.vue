<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'

const router = useRouter()
// 当前登录信息
const currentUser = JSON.parse(localStorage.getItem('user') || '{}')

// 表单数据
const userInfo = ref({
  username: '',
  real_name: '',
  role: 1
})

const pwdForm = reactive({
  old_password: '',
  new_password: '',
  confirm_password: ''
})

const loading = ref(false)
const activeTab = ref('info') // 默认选中的标签页

// 1. 加载最新用户信息
const fetchUserInfo = async () => {
  try {
    const res = await axios.post('http://127.0.0.1:5000/api/user/info', {
      username: currentUser.username
    })
    if (res.data.code === 200) {
      userInfo.value = res.data.data
    }
  } catch (e) {
    console.error(e)
  }
}

// 2. 修改基本信息
const handleUpdateInfo = async () => {
  loading.value = true
  try {
    const res = await axios.post('http://127.0.0.1:5000/api/user/update_info', {
      username: userInfo.value.username,
      real_name: userInfo.value.real_name
    })
    if (res.data.code === 200) {
      ElMessage.success('个人信息保存成功！')
      // 更新本地缓存显示的名称
      const newUser = { ...currentUser, real_name: userInfo.value.real_name }
      localStorage.setItem('user', JSON.stringify(newUser))
      // 稍微延迟一下刷新，让用户看到提示
      setTimeout(() => location.reload(), 1000)
    }
  } catch (e) {
    ElMessage.error('保存失败')
  } finally {
    loading.value = false
  }
}

// 3. 修改密码
const handleChangePwd = async () => {
  if (!pwdForm.old_password || !pwdForm.new_password) {
    return ElMessage.warning('请填写完整密码信息')
  }
  if (pwdForm.new_password !== pwdForm.confirm_password) {
    return ElMessage.warning('两次新密码输入不一致')
  }

  try {
    const res = await axios.post('http://127.0.0.1:5000/api/user/change_password', {
      username: userInfo.value.username,
      old_password: pwdForm.old_password,
      new_password: pwdForm.new_password
    })

    if (res.data.code === 200) {
      ElMessage.success('密码修改成功！请重新登录')
      localStorage.removeItem('user')
      localStorage.removeItem('token')
      router.push('/login')
    }
  } catch (error: any) {
    const msg = error.response?.data?.msg || '请求失败'
    ElMessage.error(msg)
  }
}

onMounted(() => {
  if (currentUser.username) {
    fetchUserInfo()
  }
})
</script>

<template>
  <div class="profile-page">
    <div class="container">
      <el-row :gutter="20">

        <el-col :span="8" :xs="24">
          <el-card class="user-card" shadow="hover">
            <div class="avatar-wrapper">
              <el-avatar :size="100" class="user-avatar">
                {{ userInfo.real_name?.[0]?.toUpperCase() || userInfo.username?.[0]?.toUpperCase() }}
              </el-avatar>
            </div>

            <div class="user-meta">
              <h2>{{ userInfo.username }}</h2>
              <div class="roles">
                <el-tag v-if="userInfo.role === 0" type="danger" effect="dark">超级管理员</el-tag>
                <el-tag v-else type="primary" effect="dark">企业租户</el-tag>
              </div>
            </div>

            <el-divider />

            <div class="user-desc">
              <p><el-icon><User /></el-icon> 真实姓名：{{ userInfo.real_name || '未设置' }}</p>
              <p><el-icon><Monitor /></el-icon> 注册时间：2026-01-12</p>
            </div>
          </el-card>
        </el-col>

        <el-col :span="16" :xs="24">
          <el-card class="settings-card" shadow="hover">
            <el-tabs v-model="activeTab">

              <el-tab-pane label="基本资料" name="info">
                <div class="form-wrapper">
                  <el-form label-position="top">
                    <el-form-item label="登录账号">
                      <el-input v-model="userInfo.username" disabled>
                        <template #prefix><el-icon><UserFilled /></el-icon></template>
                      </el-input>
                      <div class="tips">账号用于登录，不可修改</div>
                    </el-form-item>

                    <el-form-item label="企业名称 / 真实姓名">
                      <el-input v-model="userInfo.real_name" placeholder="请输入您的称呼" />
                    </el-form-item>

                    <el-form-item>
                      <el-button type="primary" :loading="loading" @click="handleUpdateInfo">
                        保存更改
                      </el-button>
                    </el-form-item>
                  </el-form>
                </div>
              </el-tab-pane>

              <el-tab-pane label="安全设置" name="security">
                <div class="form-wrapper">
                  <el-alert
                    title="定期修改密码可以保护您的账号安全"
                    type="info"
                    show-icon
                    :closable="false"
                    style="margin-bottom: 20px"
                  />

                  <el-form label-position="top">
                    <el-form-item label="当前旧密码">
                      <el-input v-model="pwdForm.old_password" type="password" show-password />
                    </el-form-item>

                    <el-form-item label="新密码">
                      <el-input v-model="pwdForm.new_password" type="password" show-password />
                    </el-form-item>

                    <el-form-item label="确认新密码">
                      <el-input v-model="pwdForm.confirm_password" type="password" show-password />
                    </el-form-item>

                    <el-form-item>
                      <el-button type="danger" @click="handleChangePwd">确认修改密码</el-button>
                    </el-form-item>
                  </el-form>
                </div>
              </el-tab-pane>

            </el-tabs>
          </el-card>
        </el-col>

      </el-row>
    </div>
  </div>
</template>

<style scoped>
.profile-page {
  padding: 40px 20px;
  background-color: transparent; /* 背景色由MainLayout决定 */
}

.container {
  max-width: 1000px;
  margin: 0 auto;
}

/* 左侧卡片 */
.user-card {
  text-align: center;
  padding: 20px 0;
}
.user-avatar {
  background: #409eff;
  font-size: 40px;
  margin-bottom: 15px;
  border: 4px solid #ecf5ff;
}
.user-meta h2 {
  margin: 10px 0;
  font-size: 22px;
  color: #303133;
}
.user-desc {
  text-align: left;
  padding: 0 20px;
  color: #606266;
  font-size: 14px;
}
.user-desc p {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 10px;
}

/* 右侧卡片 */
.settings-card {
  min-height: 400px;
}
.form-wrapper {
  padding: 10px 0;
  max-width: 500px; /* 表单不用太宽，为了美观 */
}
.tips {
  font-size: 12px;
  color: #909399;
  margin-top: 5px;
}
</style>
