<script setup lang="ts">
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { ElMessage, ElMessageBox } from 'element-plus'

interface User {
  id: number
  username: string
  real_name: string
  role: number
}

const userList = ref<User[]>([])
const loading = ref(false)

// 1. 获取用户列表
const fetchList = async () => {
  loading.value = true
  try {
    const res = await axios.get('http://127.0.0.1:5000/api/user/list')
    if (res.data.code === 200) {
      userList.value = res.data.data
    }
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

// 2. 重置密码 (管理员功能)
const handleReset = (user: User) => {
  ElMessageBox.confirm(
    `确定要将用户 "${user.username}" 的密码重置为 123456 吗？`,
    '警告',
    { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' }
  ).then(async () => {
    const res = await axios.post('http://127.0.0.1:5000/api/user/reset_pwd', { id: user.id })
    if (res.data.code === 200) {
      ElMessage.success('密码重置成功')
    }
  })
}

// 3. 删除用户 (管理员功能)
const handleDelete = (user: User) => {
  if (user.role === 0) return ElMessage.warning('无法删除管理员')

  ElMessageBox.confirm(
    `此操作将永久删除用户 "${user.username}"，是否继续？`,
    '高危操作',
    { confirmButtonText: '删除', cancelButtonText: '取消', type: 'error' }
  ).then(async () => {
    const res = await axios.post('http://127.0.0.1:5000/api/user/delete', { id: user.id })
    if (res.data.code === 200) {
      ElMessage.success('删除成功')
      fetchList()
    }
  })
}

onMounted(() => {
  fetchList()
})
</script>

<template>
  <div class="app-container">
    <el-card class="filter-container" shadow="never">
      <div class="header-actions">
        <span class="page-title">用户管理</span>
        <el-button type="primary" :icon="'Refresh'" @click="fetchList">刷新数据</el-button>
      </div>
    </el-card>

    <el-card shadow="never" style="margin-top: 20px;">
      <el-table
        v-loading="loading"
        :data="userList"
        style="width: 100%"
        border
        stripe
        :header-cell-style="{background:'#f8f8f9', color:'#606266'}"
      >
        <el-table-column prop="id" label="ID" width="80" align="center" />

        <el-table-column prop="username" label="账号" width="150">
          <template #default="scope">
            <el-tag type="info" disable-transitions>{{ scope.row.username }}</el-tag>
          </template>
        </el-table-column>

        <el-table-column prop="real_name" label="真实姓名/企业" min-width="150" />

        <el-table-column label="角色" width="120" align="center">
          <template #default="scope">
            <el-tag v-if="scope.row.role === 0" type="danger">管理员</el-tag>
            <el-tag v-else>租户</el-tag>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="200" align="center">
          <template #default="scope">
            <el-button
              link
              type="primary"
              size="small"
              icon="Key"
              @click="handleReset(scope.row)"
            >重置密码</el-button>

            <el-button
              v-if="scope.row.role !== 0"
              link
              type="danger"
              size="small"
              icon="Delete"
              @click="handleDelete(scope.row)"
            >删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<style scoped>
.app-container { padding: 0; }
.header-actions { display: flex; justify-content: space-between; align-items: center; }
.page-title { font-size: 16px; font-weight: bold; color: #303133; }
</style>
