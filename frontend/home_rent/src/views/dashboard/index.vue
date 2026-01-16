<script setup lang="ts">
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router' // 1. 引入路由钩子
// 引入需要的图标
import { Search, OfficeBuilding, DocumentChecked, Service } from '@element-plus/icons-vue'

const router = useRouter() // 2. 获取路由实例
// 公告数据列表
const notices = ref([])

// 获取最新公告
const fetchNotices = async () => {
  try {
    const res = await axios.get('http://127.0.0.1:5000/api/notice/list')
    if (res.data.code === 200) {
      // 截取最新的 5 条显示
      notices.value = res.data.data.slice(0, 5).map((item: any) => {
        return {
          id: item.id,
          title: item.title,
          // 后端返回的是 'YYYY-MM-DD HH:MM'，我们只取日期部分 'YYYY-MM-DD'
          date: item.time ? item.time.split(' ')[0] : ''
        }
      })
    }
  } catch(e) {
    console.error('获取公告失败', e)
  }
}

// 3. 跳转详情页函数
const goToDetail = (id: number) => {
  router.push(`/notice/${id}`)
}

onMounted(() => {
  fetchNotices()
})
</script>

<template>
  <div class="dashboard-page">
    <div class="hero-banner">
      <div class="hero-content">
        <h1>智慧园区，赋能未来产业</h1>
        <p>提供优质厂房租赁、一站式合同管理与智能化服务</p>
        <el-button type="primary" size="large" round @click="$router.push('/factories')">
          立即找房 <el-icon class="el-icon--right"><Search /></el-icon>
        </el-button>
      </div>
    </div>

    <div class="main-container">

      <el-row :gutter="20" class="feature-cards">
        <el-col :span="8">
          <el-card shadow="hover" class="feature-item" @click="$router.push('/factories')">
            <el-icon :size="40" color="#409eff"><OfficeBuilding /></el-icon>
            <h3>海量房源</h3>
            <p>实时更新，VR看房，精准匹配您的需求</p>
          </el-card>
        </el-col>
        <el-col :span="8">
          <el-card shadow="hover" class="feature-item" @click="$router.push('/contracts')">
            <el-icon :size="40" color="#67c23a"><DocumentChecked /></el-icon>
            <h3>电子签约</h3>
            <p>流程透明，在线签署，合同永久存证</p>
          </el-card>
        </el-col>
        <el-col :span="8">
          <el-card shadow="hover" class="feature-item" @click="$router.push('/profile')">
            <el-icon :size="40" color="#e6a23c"><Service /></el-icon>
            <h3>贴心服务</h3>
            <p>专属管家，报修维护，全天候响应</p>
          </el-card>
        </el-col>
      </el-row>

      <div class="section-title">
        <h2>最新公告</h2>
        <span class="more">查看更多 ></span>
      </div>

      <el-card shadow="never" class="notice-card">
        <div v-if="notices.length > 0">
          <div
            v-for="item in notices"
            :key="item.id"
            class="notice-item"
            @click="goToDetail(item.id)"
          >
            <span class="notice-tag">通知</span>
            <span class="notice-title">{{ item.title }}</span>
            <span class="notice-date">{{ item.date }}</span>
          </div>
        </div>
        <el-empty v-else description="暂无最新公告" :image-size="60" />
      </el-card>

    </div>
  </div>
</template>

<style scoped>
.dashboard-page {
  min-height: 100%;
}

/* Banner 样式 */
.hero-banner {
  height: 400px;
  /* 使用稍微深一点的遮罩，让文字更清晰 */
  background-image: linear-gradient(rgba(0, 33, 64, 0.7), rgba(0, 33, 64, 0.7)), url('https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80');
  background-size: cover;
  background-position: center;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  color: white;
}

.hero-content h1 { font-size: 3rem; margin-bottom: 10px; font-weight: 700; letter-spacing: 2px; }
.hero-content p { font-size: 1.2rem; margin-bottom: 30px; opacity: 0.9; }

/* 内容容器 */
.main-container {
  max-width: 1200px;
  margin: -60px auto 40px; /* 负margin让卡片往上浮动，压住Banner */
  position: relative;
  z-index: 10;
  padding: 0 20px;
}

.feature-cards { margin-bottom: 40px; }
.feature-item {
  text-align: center;
  padding: 20px 0;
  cursor: pointer;
  transition: transform 0.3s;
  height: 100%;
  border: none;
}
.feature-item:hover { transform: translateY(-5px); }
.feature-item h3 { margin: 15px 0 10px; font-size: 18px; color: #303133; }
.feature-item p { color: #909399; font-size: 14px; margin: 0; }

/* 公告样式 */
.section-title {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
.section-title h2 { font-size: 24px; color: #303133; border-left: 5px solid #409eff; padding-left: 15px; }
.more { color: #909399; cursor: pointer; font-size: 14px; }

.notice-card { border-radius: 8px; }
.notice-item {
  display: flex;
  align-items: center;
  padding: 15px 0;
  border-bottom: 1px solid #ebeef5;
  cursor: pointer; /* 5. 添加鼠标手型 */
  transition: background-color 0.2s; /* 6. 添加过渡效果 */
}
.notice-item:hover {
  background-color: #f9fafc; /* 7. 添加悬停高亮 */
}
.notice-item:last-child { border-bottom: none; }
.notice-tag {
  background: #ecf5ff; color: #409eff;
  padding: 2px 8px; border-radius: 4px; font-size: 12px; margin-right: 15px;
  flex-shrink: 0; /* 防止标签被压缩 */
}
.notice-title { flex: 1; color: #606266; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-right: 10px; }
.notice-title:hover { color: #409eff; }
.notice-date { color: #c0c4cc; font-size: 13px; flex-shrink: 0; }
</style>
