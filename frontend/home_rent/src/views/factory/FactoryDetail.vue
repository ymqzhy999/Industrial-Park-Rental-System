<script setup lang="ts">
import { ref, onMounted, reactive, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'
import { ElMessage } from 'element-plus'
// 👇 引入了 Plus 和 Delete 图标
import { Location, Timer, Coin, Warning, House, ArrowLeft, Check, Picture as IconPicture, Plus, Delete } from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()
const factory = ref<any>({})
const loading = ref(false)
const currentUser = JSON.parse(localStorage.getItem('user') || '{}')

const imageList = computed(() => {
  if (factory.value?.images && factory.value.images.length > 5) {
    return factory.value.images.split(',')
  }
  return []
})

const applyDialogVisible = ref(false)
const applyLoading = ref(false)

const applyForm = reactive({
  dateRange: [] as any[],
  purpose: '',
  phone: currentUser.phone || '',
  // 👇 修改：这里改成对象数组，默认给一行空数据
  termsList: [
    { value: '' }
  ]
})

const dateShortcuts = [
  { text: '租 1 年', value: () => { const s = new Date(); const e = new Date(); e.setFullYear(s.getFullYear() + 1); return [s, e] } },
  { text: '租 3 年', value: () => { const s = new Date(); const e = new Date(); e.setFullYear(s.getFullYear() + 3); return [s, e] } },
]
const disabledDate = (time: Date) => time.getTime() < Date.now() - 8.64e7

// --- 👇 新增：动态增减条款的函数 ---
const addTerm = () => {
  applyForm.termsList.push({ value: '' })
}

const removeTerm = (index: number) => {
  // 如果只剩一行，就不删了，只清空内容（或者你也可以允许删光）
  if (applyForm.termsList.length === 1) {
    applyForm.termsList[0].value = ''
    return
  }
  applyForm.termsList.splice(index, 1)
}
// ---------------------------------

const fetchDetail = async () => {
  loading.value = true
  try {
    const res = await axios.get(`http://127.0.0.1:5000/api/factory/detail/${route.params.id}`)
    if (res.data.code === 200) factory.value = res.data.data
    else ElMessage.error('厂房不存在')
  } catch(e) { ElMessage.error('网络错误') }
  finally { loading.value = false }
}

const openApply = () => {
  if (!currentUser.user_id && !currentUser.id) {
    ElMessage.warning('请先登录')
    return router.push('/login')
  }
  const s = new Date(); const e = new Date(); e.setFullYear(s.getFullYear() + 1)
  applyForm.dateRange = [s, e]
  // 重置条款列表
  applyForm.termsList = [{ value: '' }]
  applyDialogVisible.value = true
}

const submitApply = async () => {
  if (!applyForm.dateRange || applyForm.dateRange.length < 2) return ElMessage.warning('请选择周期')

  // 👇 核心修改：把数组处理成字符串发送给后端
  // 1. 过滤掉空行
  const validTerms = applyForm.termsList.filter(item => item.value.trim() !== '')
  // 2. 拼接成 "1. xxx \n 2. xxx" 的格式，看起来很正规
  let formattedTerms = '无'
  if (validTerms.length > 0) {
    formattedTerms = validTerms.map((item, index) => `${index + 1}. ${item.value}`).join('\n')
  }

  applyLoading.value = true
  try {
    const formatDate = (d: Date) => d.toISOString().split('T')[0]
    await axios.post('http://127.0.0.1:5000/api/contract/apply', {
      username: currentUser.username,
      factory_id: factory.value.id,
      start_date: formatDate(applyForm.dateRange[0]),
      end_date: formatDate(applyForm.dateRange[1]),
      purpose: applyForm.purpose,
      phone: applyForm.phone,
      terms: formattedTerms
    })

    ElMessage.success('申请提交成功！')
    applyDialogVisible.value = false
  } catch(e) { ElMessage.error('提交失败') }
  finally { applyLoading.value = false }
}

onMounted(fetchDetail)
</script>

<template>
  <div class="page-wrapper">
    <div class="top-nav">
      <div class="nav-content">
        <el-button link :icon="ArrowLeft" @click="$router.back()">返回列表</el-button>
        <span class="nav-title">房源详情</span>
      </div>
    </div>

    <div class="container" v-loading="loading">
      <div class="detail-card" v-if="factory.id">
        <div class="header-section">
          <div class="gallery-box">
            <el-image
              v-if="imageList.length > 0"
              :src="imageList[0]"
              fit="cover"
              class="main-image"
              :preview-src-list="imageList"
            />
            <div v-else class="empty-image">
              <el-icon :size="60"><IconPicture /></el-icon>
              <span>暂无实景图片</span>
            </div>
            <div class="status-tag" v-if="factory.status===1">已出租</div>
          </div>

          <div class="info-box">
            <h1 class="f-title">{{ factory.title }}</h1>
            <div class="tags-row">
              <el-tag v-for="tag in (factory.tags ? factory.tags.split(',') : [])" :key="tag" size="small" effect="plain" round>{{ tag }}</el-tag>
            </div>
            <div class="price-area">
              <div class="price-main">
                <span class="currency">¥</span>
                <span class="amount">{{ factory.price_per_month ? factory.price_per_month.toLocaleString() : '--' }}</span>
                <span class="unit">/ 月</span>
              </div>
              <div class="unit-price">
                单价约 {{ factory.price_per_month && factory.area ? (factory.price_per_month / factory.area).toFixed(1) : '--' }} 元/㎡/月
              </div>
            </div>
            <div class="params-row">
              <div class="p-item">
                <div class="p-label">建筑面积</div>
                <div class="p-value">{{ factory.area }} ㎡</div>
              </div>
              <div class="p-item">
                <div class="p-label">层高</div>
                <div class="p-value">{{ factory.floor_height }} 米</div>
              </div>
              <div class="p-item">
                <div class="p-label">供电</div>
                <div class="p-value">{{ factory.power_supply || '标准' }}</div>
              </div>
              <div class="p-item">
                <div class="p-label">承重</div>
                <div class="p-value">{{ factory.floor_load }} 吨</div>
              </div>
            </div>
            <div class="address-row">
              <el-icon><Location /></el-icon> {{ factory.address }}
            </div>
            <div class="btn-area">
              <el-button v-if="factory.status===0" type="primary" size="large" class="big-btn" @click="openApply">立即申请租赁</el-button>
              <el-button v-else type="info" disabled size="large" class="big-btn">该房源已出租</el-button>
              <div class="verify-tip"><el-icon><Check /></el-icon> 官方认证房源</div>
            </div>
          </div>
        </div>
        <el-divider />
        <div class="body-section">
          <h3><el-icon><House /></el-icon> 房源介绍</h3>
          <p class="desc-content">{{ factory.description || '暂无详细描述...' }}</p>
        </div>
      </div>
      <el-empty v-else description="数据加载失败" />
    </div>

    <el-dialog v-model="applyDialogVisible" title="填写租赁申请" width="600px">
      <el-form label-position="top">
        <el-form-item label="租赁周期">
          <el-date-picker v-model="applyForm.dateRange" type="daterange" :shortcuts="dateShortcuts" :disabled-date="disabledDate" range-separator="至" start-placeholder="开始" end-placeholder="结束" style="width:100%"/>
        </el-form-item>
        <el-form-item label="租赁用途">
          <el-input v-model="applyForm.purpose" type="textarea" placeholder="请简述用途" />
        </el-form-item>
        <el-form-item label="联系电话">
          <el-input v-model="applyForm.phone" />
        </el-form-item>

        <el-form-item label="补充条款 (可选)">
          <div class="terms-container">
            <div
              v-for="(term, index) in applyForm.termsList"
              :key="index"
              class="term-item"
            >
              <div class="term-index">条款 {{ index + 1 }}</div>
              <el-input v-model="term.value" placeholder="例如：需提前10天进场装修" />
              <el-button
                type="danger"
                circle
                plain
                :icon="Delete"
                @click="removeTerm(index)"
                v-if="applyForm.termsList.length > 1 || term.value"
              />
            </div>

            <el-button class="add-btn" plain type="primary" :icon="Plus" @click="addTerm">
              添加一条特殊需求
            </el-button>
          </div>
        </el-form-item>
        </el-form>
      <template #footer>
        <el-button @click="applyDialogVisible=false">取消</el-button>
        <el-button type="primary" :loading="applyLoading" @click="submitApply">提交申请</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
/* 保持原有样式不变 */
.page-wrapper { background: #f5f7fa; min-height: 100vh; padding-bottom: 40px; }
.top-nav { background: #fff; box-shadow: 0 1px 4px rgba(0,0,0,0.05); padding: 0 20px; height: 50px; display: flex; align-items: center; margin-bottom: 20px; }
.nav-content { max-width: 1200px; width: 100%; margin: 0 auto; display: flex; align-items: center; gap: 10px; }
.nav-title { font-size: 14px; color: #606266; border-left: 1px solid #e4e7ed; padding-left: 15px; margin-left: 5px; }

.container { max-width: 1200px; margin: 0 auto; }
.detail-card { background: #fff; border-radius: 8px; box-shadow: 0 2px 12px 0 rgba(0,0,0,0.05); padding: 30px; }

.header-section { display: flex; gap: 40px; margin-bottom: 30px; }
.gallery-box { width: 500px; height: 380px; flex-shrink: 0; position: relative; border-radius: 8px; overflow: hidden; background: #f0f2f5; }
.main-image { width: 100%; height: 100%; display: block; }
.empty-image { width: 100%; height: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #909399; }
.status-tag { position: absolute; top: 15px; left: 15px; background: rgba(0,0,0,0.6); color: #fff; padding: 4px 12px; border-radius: 4px; font-size: 12px; }

.info-box { flex: 1; display: flex; flex-direction: column; }
.f-title { font-size: 24px; color: #303133; margin: 0 0 10px 0; line-height: 1.4; }
.tags-row { display: flex; gap: 8px; margin-bottom: 20px; }

.price-area { background: #fff7f7; padding: 15px 20px; border-radius: 6px; margin-bottom: 25px; display: flex; align-items: baseline; justify-content: space-between; }
.price-main .currency { color: #f56c6c; font-size: 18px; font-weight: bold; }
.price-main .amount { color: #f56c6c; font-size: 36px; font-weight: bold; margin: 0 4px; font-family: Arial; }
.price-main .unit { color: #f56c6c; font-size: 14px; }
.unit-price { color: #909399; font-size: 13px; }

.params-row { display: flex; justify-content: space-between; margin-bottom: 25px; border-bottom: 1px solid #f0f2f5; padding-bottom: 20px; }
.p-item { text-align: center; flex: 1; border-right: 1px solid #f0f2f5; }
.p-item:last-child { border-right: none; }
.p-label { color: #909399; font-size: 13px; margin-bottom: 5px; }
.p-value { color: #303133; font-weight: 600; font-size: 16px; }

.address-row { color: #606266; margin-bottom: 30px; display: flex; align-items: center; gap: 5px; font-size: 15px; }

.btn-area { display: flex; align-items: center; gap: 15px; margin-top: auto; }
.big-btn { width: 180px; font-weight: bold; letter-spacing: 1px; }
.verify-tip { font-size: 12px; color: #67c23a; display: flex; align-items: center; gap: 4px; }

.body-section h3 { font-size: 18px; color: #303133; margin-bottom: 15px; display: flex; align-items: center; gap: 8px; }
.desc-content { line-height: 1.8; color: #606266; font-size: 15px; text-align: justify; }

/* 👇👇👇 新增的动态输入框样式 👇👇👇 */
.terms-container {
  display: flex;
  flex-direction: column;
  gap: 10px;
  width: 100%;
}
.term-item {
  display: flex;
  align-items: center;
  gap: 10px;
}
.term-index {
  font-size: 12px;
  color: #909399;
  width: 50px;
  flex-shrink: 0;
}
.add-btn {
  width: 100%;
  border-style: dashed; /* 虚线边框，看起来像添加按钮 */
}
</style>
