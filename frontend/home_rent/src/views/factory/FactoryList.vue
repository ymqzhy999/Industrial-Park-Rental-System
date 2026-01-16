<script setup lang="ts">
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
// 👇 引入 User 图标用于推荐栏
import { Search, Location, Crop, House, Lightning, Star, StarFilled, User } from '@element-plus/icons-vue'

const router = useRouter()
const list = ref<any[]>([])
const total = ref(0)
const loading = ref(false)

// 👇👇👇 新增：推荐相关变量 👇👇👇
const recommendList = ref<any[]>([])
const recommendDebugMsg = ref('')

// 获取当前登录用户
const userStr = localStorage.getItem('user')
const userStore = userStr ? JSON.parse(userStr) : {}
const currentUserId = userStore.user_id

const query = ref<any>({
  page: 1,
  pageSize: 10,
  keyword: '',
  userId: currentUserId
})

// 👇👇👇 新增：获取推荐数据函数 👇👇👇
const fetchRecommend = async () => {
  if (!currentUserId) return // 没登录就不推
  try {
    const res = await axios.get('http://127.0.0.1:5000/api/recommend/list', {
      params: { userId: currentUserId }
    })
    if (res.data.code === 200) {
      recommendList.value = res.data.data
      recommendDebugMsg.value = res.data.msg
    }
  } catch (e) {
    console.error('获取推荐失败', e)
  }
}

// 获取普通列表
const fetchList = async () => {
  loading.value = true
  try {
    const res = await axios.post('http://127.0.0.1:5000/api/factory/list', query.value)
    if (res.data.code === 200) {
      list.value = res.data.data
      total.value = res.data.total
    }
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}

// 收藏逻辑
const toggleCollection = async (item: any) => {
  if (!currentUserId) {
    ElMessage.warning('请先登录')
    return
  }
  try {
    const res = await axios.post('http://127.0.0.1:5000/api/factory/collect', {
      factory_id: item.id,
      action: item.is_collected ? 'remove' : 'add',
      user_id: currentUserId
    })
    if (res.data.code === 200) {
      item.is_collected = !item.is_collected
      ElMessage.success(item.is_collected ? '已加入收藏' : '已取消收藏')
      // 收藏变动后，刷新一下推荐，因为喜好变了
      fetchRecommend()
    }
  } catch (e) {
    ElMessage.error('操作失败')
  }
}

const handleSearch = () => {
  query.value.page = 1
  fetchList()
}

const goToDetail = (id: number) => {
  router.push(`/factories/${id}`)
}

onMounted(() => {
  fetchList()
  fetchRecommend() // 👈 核心：页面加载时触发推荐算法
})
</script>

<template>
  <div class="factory-page">
    <div class="search-bar-wrapper">
      <div class="search-container">
        <el-input
          v-model="query.keyword"
          placeholder="请输入区域、厂房名称或特征..."
          size="large"
          class="search-input"
          @keyup.enter="handleSearch"
        >
          <template #append>
            <el-button :icon="Search" @click="handleSearch" class="search-btn">搜索</el-button>
          </template>
        </el-input>
      </div>
    </div>

    <div class="main-content">

      <div v-if="recommendList.length > 0" class="recommend-section">
        <div class="rec-header">
          <h3><el-icon color="#fe615a"><StarFilled /></el-icon> 猜你喜欢</h3>
          <el-tag type="warning" effect="plain" size="small">{{ recommendDebugMsg }}</el-tag>
        </div>

        <div class="rec-grid">
          <div
            v-for="item in recommendList"
            :key="item.id"
            class="rec-card"
            @click="goToDetail(item.id)"
          >
            <div class="rec-img">
              <img :src="item.image || 'https://via.placeholder.com/300x200'">
            </div>
            <div class="rec-info">
              <div class="rec-title">{{ item.title }}</div>
              <div class="rec-price">{{ item.price }} 元/月</div>
            </div>
          </div>
        </div>
      </div>
      <div class="list-header">
        <h2>全部房源 <span>(共 {{ total }} 套)</span></h2>
      </div>

      <div v-if="loading" class="loading-box">加载中...</div>

      <div class="house-list" v-else>
        <div
          v-for="item in list"
          :key="item.id"
          class="house-item"
          @click="goToDetail(item.id)"
        >
          <div class="img-wrapper">
            <img :src="item.image || 'https://via.placeholder.com/300x200'" alt="厂房图片">
            <div class="status-badge" v-if="item.status === 1">已出租</div>
          </div>

          <div class="info-wrapper">
            <h3 class="title">{{ item.title }}</h3>

            <div class="detail-row">
              <span class="icon-text"><el-icon><Crop /></el-icon> {{ item.area }}m²</span>
              <span class="divider">|</span>
              <span class="icon-text"><el-icon><House /></el-icon> 层高6米</span>
              <span class="divider">|</span>
              <span class="icon-text"><el-icon><Lightning /></el-icon> 配电100KVA</span>
            </div>

            <div class="address-row">
              <el-icon><Location /></el-icon> {{ item.address }}
            </div>

            <div class="tags-row">
              <span class="tag vr">VR看房</span>
              <span class="tag default" v-for="t in item.tags" :key="t">{{ t }}</span>
            </div>
          </div>

          <div class="price-wrapper">
            <div class="total-price">
              <span class="num">{{ item.price }}</span>
              <span class="unit">元/月</span>
            </div>
            <div class="avg-price">
              {{ (item.price / item.area).toFixed(1) }} 元/m²/月
            </div>

            <div class="action-btn">
               <el-button
                 link
                 :type="item.is_collected ? 'warning' : 'info'"
                 @click.stop="toggleCollection(item)"
               >
                 <el-icon size="18" style="margin-right: 4px;">
                   <StarFilled v-if="item.is_collected" />
                   <Star v-else />
                 </el-icon>
                 {{ item.is_collected ? '已关注' : '关注' }}
               </el-button>
            </div>

          </div>
        </div>
      </div>

      <div class="pagination-box">
        <el-pagination
          background
          layout="prev, pager, next"
          :total="total"
          :page-size="query.pageSize"
          @current-change="(val) => { query.page = val; fetchList() }"
        />
      </div>
    </div>
  </div>
</template>

<style scoped>
.factory-page { background-color: #fff; min-height: 100vh; }
.search-bar-wrapper { background: #f5f5f6; padding: 30px 0; display: flex; justify-content: center; }
.search-container { width: 700px; }
.search-btn { background-color: #3072f6; color: white; border-radius: 0 4px 4px 0; }
.search-btn:hover { background-color: #1c5fd6; }
.main-content { max-width: 1150px; margin: 0 auto; padding: 40px 0; }
.list-header { margin-bottom: 25px; border-bottom: 2px solid #3072f6; padding-bottom: 10px; width: 100%;}
.list-header h2 { font-size: 22px; color: #101d37; margin: 0; display: inline-block;}
.list-header span { font-size: 14px; color: #9399a5; font-weight: normal; margin-left: 10px; }
.house-list { display: flex; flex-direction: column; gap: 30px; }
.house-item { display: flex; cursor: pointer; border-bottom: 1px solid #f1f1f1; padding-bottom: 30px; transition: all 0.2s; }
.house-item:hover .title { color: #3072f6; }
.img-wrapper { width: 260px; height: 195px; border-radius: 8px; overflow: hidden; position: relative; margin-right: 30px; flex-shrink: 0; }
.img-wrapper img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s;}
.house-item:hover .img-wrapper img { transform: scale(1.05); }
.status-badge { position: absolute; top: 10px; left: 10px; background: #c3c3c3; color: white; padding: 4px 8px; font-size: 12px; border-radius: 2px; }
.info-wrapper { flex: 1; display: flex; flex-direction: column; justify-content: space-between; padding: 5px 0;}
.title { font-size: 20px; font-weight: bold; color: #101d37; margin: 0; line-height: 1.3; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.detail-row { display: flex; align-items: center; font-size: 14px; color: #101d37; margin-top: 15px; }
.icon-text { display: flex; align-items: center; gap: 5px; font-weight: 500;}
.divider { margin: 0 15px; color: #e1e1e1; font-size: 12px; }
.address-row { margin-top: 15px; color: #9399a5; font-size: 14px; display: flex; align-items: center; gap: 5px; }
.tags-row { margin-top: auto; display: flex; gap: 10px; }
.tag { padding: 4px 8px; font-size: 12px; border-radius: 2px; }
.tag.vr { background: #e1f5ed; color: #33be85; }
.tag.default { background: #f4f7f9; color: #849aae; }
.price-wrapper { text-align: right; display: flex; flex-direction: column; justify-content: center; min-width: 150px; }
.total-price { color: #fe615a; font-weight: bold; }
.total-price .num { font-size: 26px; }
.total-price .unit { font-size: 14px; margin-left: 4px; }
.avg-price { color: #9399a5; font-size: 12px; margin-top: 8px; }
.pagination-box { margin-top: 50px; display: flex; justify-content: center; }
.action-btn { margin-top: 15px; }

/* 👇👇👇 新增：推荐栏样式 👇👇👇 */
.recommend-section {
  margin-bottom: 40px;
  background: linear-gradient(to bottom, #fffaf9, #fff); /* 淡淡的暖色渐变 */
  border: 1px solid #ffeceb;
  border-radius: 8px;
  padding: 20px;
}

.rec-header {
  display: flex;
  align-items: center;
  gap: 15px;
  margin-bottom: 20px;
}
.rec-header h3 {
  margin: 0;
  color: #333;
  display: flex;
  align-items: center;
  gap: 5px;
  font-size: 18px;
}

.rec-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr); /* 一行4个 */
  gap: 20px;
}

.rec-card {
  border: 1px solid #eee;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s;
  background: #fff;
  display: flex;
  flex-direction: column;
}
.rec-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 16px rgba(0,0,0,0.1);
  border-color: #fe615a;
}

.rec-img {
  height: 140px;
  width: 100%;
  overflow: hidden;
}
.rec-img img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.rec-info {
  padding: 10px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  flex: 1;
}
.rec-title {
  font-size: 14px;
  font-weight: bold;
  color: #333;
  margin-bottom: 8px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.rec-price {
  color: #fe615a;
  font-weight: bold;
  font-size: 16px;
}
</style>
