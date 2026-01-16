<script setup lang="ts">
import { useRouter, useRoute } from 'vue-router'
import { computed } from 'vue'

const router = useRouter()
const route = useRoute()

const userStr = localStorage.getItem('user')
const userInfo = userStr ? JSON.parse(userStr) : { username: 'Guest', role: 1 }

// 角色名称
const roleName = computed(() => userInfo.role === 0 ? '管理员' : '企业租户')

// 退出登录
const handleLogout = () => {
  if (confirm('确定要退出系统吗？')) {
    localStorage.removeItem('user')
    localStorage.removeItem('token')
    router.replace('/login')
  }
}
</script>

<template>
  <el-container class="layout-wrapper">
    <el-header class="portal-header">
      <div class="header-inner">
        <div class="logo">
          <el-icon :size="24" color="#409eff"><OfficeBuilding /></el-icon>
          <span class="title">工业园区租赁平台</span>
        </div>

        <el-menu
          :default-active="route.path"
          mode="horizontal"
          router
          class="nav-menu"
          :ellipsis="false"
        >
          <el-menu-item index="/dashboard">首页</el-menu-item>
          <el-menu-item index="/factories">找厂房</el-menu-item>
          <el-menu-item index="/contracts">我的合同</el-menu-item>
          <el-menu-item index="/profile">个人中心</el-menu-item>
        </el-menu>

        <div class="user-area">
          <el-button
            v-if="userInfo.role === 0"
            type="primary"
            size="small"
            round
            @click="router.push('/admin/dashboard')"
            style="margin-right: 15px;"
          >
            返回后台
          </el-button>

          <el-dropdown>
            <span class="el-dropdown-link">
              <el-avatar :size="32" style="background:#409eff">{{ userInfo.username[0].toUpperCase() }}</el-avatar>
              <span class="username">{{ userInfo.username }}</span>
              <el-tag size="small" effect="plain" round>{{ roleName }}</el-tag>
              <el-icon class="el-icon--right"><arrow-down /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="router.push('/profile')">个人资料</el-dropdown-item>
                <el-dropdown-item divided @click="handleLogout" style="color:#f56c6c">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>
    </el-header>

    <el-main class="portal-main">
      <router-view />
    </el-main>

    <el-footer class="portal-footer">
      <p>&copy; 2026 Industrial Park Management System. All rights reserved.</p>
    </el-footer>
  </el-container>
</template>

<style scoped>
.layout-wrapper {
  min-height: 100vh;
  background-color: #f5f7fa; /* 全局浅灰背景，不刺眼 */
  display: flex;
  flex-direction: column;
}

/* 顶部导航样式 */
.portal-header {
  background: #ffffff;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
  position: sticky;
  top: 0;
  z-index: 100;
  padding: 0;
}

.header-inner {
  max-width: 1200px; /* 内容居中限制宽度 */
  margin: 0 auto;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
}

.logo {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 18px;
  font-weight: bold;
  color: #303133;
}

.nav-menu {
  border-bottom: none !important;
  flex: 1;
  justify-content: center;
  background: transparent;
}
/* 菜单项悬停样式 */
:deep(.el-menu-item) {
  font-size: 15px;
  font-weight: 500;
}
:deep(.el-menu-item.is-active) {
  border-bottom: 2px solid #409eff !important;
  color: #409eff !important;
}

.user-area {
  display: flex;
  align-items: center;
}
.el-dropdown-link {
  display: flex;
  align-items: center;
  cursor: pointer;
  gap: 8px;
}
.username {
  font-weight: 500;
  color: #606266;
}

/* 主体区域 */
.portal-main {
  padding: 0; /* 去掉默认padding，由子页面自己控制，方便做全屏Banner */
  flex: 1;
  display: flex;
  flex-direction: column;
}

/* 底部 */
.portal-footer {
  background: #2b2f3a;
  color: #909399;
  text-align: center;
  line-height: 60px;
  font-size: 13px;
}
</style>
