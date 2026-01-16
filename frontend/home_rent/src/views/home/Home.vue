<script setup lang="ts">
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router' // 1. 引入路由
import { Bell } from '@element-plus/icons-vue'

const router = useRouter() // 2. 获取路由实例
const notices = ref([])

// 获取公告
const fetchNotices = async () => {
  try {
    const res = await axios.get('http://127.0.0.1:5000/api/notice/list')
    // 只取最新的前 3 条显示
    notices.value = res.data.data.slice(0, 3)
  } catch(e) {}
}

// 3. 跳转函数
const goToDetail = (id: number) => {
  router.push(`/notice/${id}`)
}

onMounted(() => {
  fetchNotices()
})
</script>

<template>
  <div class="home-page">
    <div class="notice-bar" v-if="notices.length > 0">
      <div class="notice-title"><el-icon><Bell /></el-icon> 最新公告：</div>
      <div class="notice-content">
        <el-carousel height="30px" direction="vertical" indicator-position="none" :interval="3000">
          <el-carousel-item v-for="item in notices" :key="item.id">
            <span class="n-text" @click="goToDetail(item.id)">
              [{{ item.time.split(' ')[0] }}] {{ item.title }}
            </span>
          </el-carousel-item>
        </el-carousel>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* 公告栏样式 */
.notice-bar {
  background: #fff;
  padding: 0 20px;
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  border-bottom: 1px solid #eee;
  height: 50px;
}
.notice-title {
  display: flex; align-items: center; gap: 5px;
  font-weight: bold; color: #e6a23c; margin-right: 20px;
}
.notice-content { flex: 1; }
.n-text { font-size: 14px; color: #666; cursor: pointer; display: block; line-height: 30px; }
.n-text:hover { color: #409eff; text-decoration: underline; }
</style>
