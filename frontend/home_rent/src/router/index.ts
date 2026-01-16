import { createRouter, createWebHistory } from 'vue-router'
import MainLayout from '../layout/MainLayout.vue'
import AdminLayout from '../layout/AdminLayout.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    // 1. 公开页面
    { path: '/login', name: 'Login', component: () => import('../views/login/LoginView.vue') },
    { path: '/register', name: 'Register', component: () => import('../views/login/Register.vue') },

    // 2. 普通用户区域 (MainLayout)
    {
      path: '/',
      component: MainLayout,
      redirect: '/dashboard',
      meta: { requiresAuth: true, role: 1 }, // role:1 代表仅普通用户或通用
      children: [
        { path: 'dashboard', component: () => import('../views/dashboard/index.vue') },
        { path: 'factories', component: () => import('../views/factory/FactoryList.vue') },
        { path: 'factories/:id', component: () => import('../views/factory/FactoryDetail.vue') },
        { path: 'profile', component: () => import('../views/user/Profile.vue') },

        // 我的合同列表 (保持复数 contracts)
        { path: 'contracts', name: 'MyContracts', component: () => import('../views/contract/ContractList.vue') },

        // 👇👇👇【核心修复】将这里的 'contracts/:id' 改为 'contract/:id' (单数) 👇👇👇
        // 这样才能匹配 MyContracts.vue 中的 router.push('/contract/...')
        {
          path: 'contract/:id',
          name: 'ContractDetail',
          component: () => import('../views/contract/ContractDetail.vue')
        },
        // 👆👆👆 修复结束 👆👆👆

        {
          path: 'notice/:id',
          name: 'NoticeDetail',
          component: () => import('../views/notice/NoticeDetail.vue')
        }
      ]
    },

    // 3. 管理员区域 (AdminLayout)
    {
      path: '/admin',
      component: AdminLayout,
      redirect: '/admin/dashboard',
      meta: { requiresAuth: true, role: 0 },
      children: [
        {
          path: 'dashboard',
          name: 'AdminDashboard',
          component: () => import('../views/admin/AdminDashboard.vue')
        },
        {
          path: 'notice-manage',
          name: 'NoticeManage',
          component: () => import('../views/admin/NoticeManage.vue')
        },
        {
          path: 'factory-manage',
          name: 'FactoryManage',
          component: () => import('../views/admin/FactoryManage.vue')
        },
        {
          path: 'contract-audit',
          name: 'ContractAudit',
          component: () => import('../views/admin/ContractAudit.vue')
        },
        {
          path: 'user-manage',
          name: 'UserManage',
          component: () => import('../views/admin/UserManage.vue')
        },
        {
          path: 'payment-manage',
          name: 'PaymentManage',
          component: () => import('../views/admin/PaymentManage.vue')
        },
      ]
    }
  ]
})

// 全局路由守卫
router.beforeEach((to, from, next) => {
  const userStr = localStorage.getItem('user')
  const user = userStr ? JSON.parse(userStr) : null
  const isAuthenticated = !!user

  // 1. 未登录拦截
  if (to.meta.requiresAuth && !isAuthenticated) {
    return next('/login')
  }

  // 2. 权限隔离拦截
  if (isAuthenticated && to.meta.requiresAuth) {
    const requiredRole = to.meta.role

    // 如果要去管理员页面(role=0)，但当前用户是普通人(role=1) -> 踢回首页
    if (requiredRole === 0 && user.role !== 0) {
      // 避免无限循环或频繁弹窗，这里可以优化为 console.warn
      return next('/dashboard')
    }
  }

  next()
})

export default router
