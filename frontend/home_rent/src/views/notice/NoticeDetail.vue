<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'
import { ArrowLeft, Clock } from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()
const notice = ref<any>({})
const loading = ref(false)

const fetchDetail = async () => {
  loading.value = true
  try {
    const res = await axios.get(`http://127.0.0.1:5000/api/notice/detail/${route.params.id}`)
    if (res.data.code === 200) {
      notice.value = res.data.data
    }
  } catch(e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

onMounted(fetchDetail)
</script>

<template>
  <div class="notice-detail-page">
    <div class="container">
      <div class="nav-header">
        <el-button link :icon="ArrowLeft" @click="router.back()">返回上一页</el-button>
      </div>

      <el-card shadow="never" class="content-card" v-loading="loading">
        <div class="n-header">
          <h1 class="n-title">{{ notice.title }}</h1>
          <div class="n-meta">
            <el-icon><Clock /></el-icon>
            <span>发布时间：{{ notice.time }}</span>
            <span class="publisher">发布人：园区管理中心</span>
          </div>
        </div>

        <el-divider />

        <div class="n-body">
          <div class="text-content">{{ notice.content }}</div>
        </div>
      </el-card>
    </div>
  </div>
</template>

<style scoped>
.notice-detail-page {
  background-color: #f5f7fa;
  min-height: 100vh;
  padding: 20px;
}

.container {
  max-width: 900px;
  margin: 0 auto;
}

.nav-header { margin-bottom: 20px; }

.content-card {
  min-height: 500px;
  padding: 20px;
}

.n-title {
  text-align: center;
  font-size: 26px;
  color: #303133;
  margin-bottom: 20px;
}

.n-meta {
  text-align: center;
  color: #909399;
  font-size: 13px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 5px;
}
.publisher { margin-left: 15px; }

.n-body {
  padding: 20px 40px;
  font-size: 16px;
  line-height: 1.8;
  color: #606266;
}
.text-content {
  white-space: pre-wrap; /* 关键：保留数据库里的换行格式 */
  text-align: justify;
}
</style>
