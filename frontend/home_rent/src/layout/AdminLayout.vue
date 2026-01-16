<script setup lang="ts">
import { useRouter, useRoute } from 'vue-router'
import { computed } from 'vue'
// 👇👇👇 关键点：确保引入了 Money 图标
import { Management, Bell, Odometer, OfficeBuilding, DocumentChecked, User, ArrowDown, Money } from '@element-plus/icons-vue'

const router = useRouter()
const route = useRoute()

// 获取路由标题，用于面包屑
const currentRouteName = computed(() => route.meta.title || '管理后台')

const handleLogout = () => {
  if (confirm('确认退出系统？')) {
    localStorage.removeItem('user')
    localStorage.removeItem('token')
    router.replace('/login')
  }
}
</script>

<template>
  <el-container class="layout-container">
    <el-aside width="200px" class="sidebar-container">
      <div class="logo">
        <el-icon><Management /></el-icon>
        <span>厂房租赁管理后台</span>
      </div>

      <el-menu
        active-text-color="#409EFF"
        background-color="#304156"
        text-color="#bfcbd9"
        :default-active="route.path"
        class="el-menu-vertical"
        router
      >
        <el-menu-item index="/admin/dashboard">
          <el-icon><Odometer /></el-icon>
          <span>首页概览</span>
        </el-menu-item>

        <el-menu-item index="/admin/notice-manage">
          <el-icon><Bell /></el-icon>
          <span>公告管理</span>
        </el-menu-item>

        <el-menu-item index="/admin/factory-manage">
          <el-icon><OfficeBuilding /></el-icon>
          <span>房源管理</span>
        </el-menu-item>

        <el-menu-item index="/admin/contract-audit">
          <el-icon><DocumentChecked /></el-icon>
          <span>合同审核</span>
        </el-menu-item>

        <el-menu-item index="/admin/payment-manage">
          <el-icon><Money /></el-icon>
          <span>支付管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/user-manage">
          <el-icon><User /></el-icon>
          <span>用户管理</span>
        </el-menu-item>
      </el-menu>
    </el-aside>

    <el-container>
      <el-header class="navbar">
        <div class="header-left">
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/admin/dashboard' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>{{ currentRouteName }}</el-breadcrumb-item>
          </el-breadcrumb>
        </div>

        <div class="header-right">
          <el-dropdown>
            <span class="el-dropdown-link">
              <el-avatar :size="30" src="https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png" />
              <span class="admin-name">管理员</span>
              <el-icon class="el-icon--right"><arrow-down /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="handleLogout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>

      <el-main class="app-main">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<style scoped>
.layout-container { height: 100vh; }

.sidebar-container {
  background-color: #304156;
  transition: width 0.28s;
  overflow: hidden;
}

.logo {
  height: 50px;
  line-height: 50px;
  text-align: center;
  color: #fff;
  font-weight: 600;
  font-size: 14px;
  background-color: #2b2f3a;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.el-menu-vertical { border-right: none; }

.navbar {
  height: 50px;
  background: #fff;
  box-shadow: 0 1px 4px rgba(0,21,41,.08);
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
}

.el-dropdown-link {
  display: flex;
  align-items: center;
  cursor: pointer;
  color: #5a5e66;
}
.admin-name { margin: 0 8px; font-size: 14px; }

.app-main {
  background-color: #f0f2f5;
  padding: 20px;
}
</style>
