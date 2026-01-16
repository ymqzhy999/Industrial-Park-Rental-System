<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'
import { Close } from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()
const contract = ref<any>({})
const loading = ref(false)

const fetchDetail = async () => {
  if (!route.params.id) return
  loading.value = true
  try {
    const res = await axios.get(`http://127.0.0.1:5000/api/contract/detail/${route.params.id}`)
    if (res.data.code === 200) {
      contract.value = res.data.data
    }
  } catch(e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

const formatMoney = (val: any) => {
  if (val === undefined || val === null) return '0.00'
  return Number(val).toLocaleString()
}

const formatDate = (val: any) => {
  if (!val) return '____-____-____'
  return val.split(' ')[0]
}

onMounted(fetchDetail)
</script>

<template>
  <div class="page-container">
    <div class="contract-paper" v-loading="loading">

      <div class="close-btn-wrapper" @click="$router.back()" title="关闭返回">
        <el-icon :size="18"><Close /></el-icon>
      </div>
      <div v-if="contract.id">
        <h1 class="main-title">工业园区厂房租赁合同</h1>

        <div class="info-header">
          <el-row :gutter="40">
            <el-col :span="12">
              <div class="info-block">
                <div class="label">出租方 (甲方)</div>
                <div class="value">{{ contract.party_a || '园区管理方' }}</div>
                <div class="sub">地址：{{ contract.factory_address || '园区管理中心' }}</div>
              </div>
            </el-col>
            <el-col :span="12">
              <div class="info-block">
                <div class="label">承租方 (乙方)</div>
                <div class="value">{{ contract.party_b }}</div>
                <div class="sub">签约时间：{{ formatDate(contract.create_time) }}</div>
              </div>
            </el-col>
          </el-row>

          <div class="summary-table">
            <div class="tr">
              <div class="th">租赁标的</div>
              <div class="td">{{ contract.factory_title }}</div>
            </div>
            <div class="tr">
              <div class="th">租赁期限</div>
              <div class="td">{{ formatDate(contract.start_date) }} 至 {{ formatDate(contract.end_date) }}</div>
            </div>
            <div class="tr">
              <div class="th">合同总金额</div>
              <div class="td highlight">¥ {{ formatMoney(contract.total_price) }} 元</div>
            </div>
          </div>
        </div>

        <el-divider />

        <div class="contract-body-title">| 合同条款详情</div>

        <div class="contract-content-box">
           <div v-if="contract.content" class="contract-text">
             {{ contract.content }}
           </div>
           <el-empty v-else description="暂无电子条款文本" :image-size="100"></el-empty>
        </div>

        <div class="stamp-area">
          <div class="party-box">
            <p>甲方（盖章）：</p>
            <div class="sign-line">___________________</div>
          </div>
          <div class="party-box">
            <p>乙方（签字）：</p>
            <div class="sign-line">___________________</div>
          </div>
        </div>
      </div>
      <el-empty v-else-if="!loading" description="未找到合同信息" />
    </div>
  </div>
</template>

<style scoped>
.page-container {
  background-color: #525659;
  min-height: 100vh;
  padding: 40px 0;
  display: flex;
  justify-content: center;
}

.contract-paper {
  position: relative; /* 1. 设为相对定位，作为按钮的参照物 */
  width: 820px;
  min-height: 1160px;
  height: auto !important; /* 允许高度撑开 */
  background: #fff;
  padding: 60px 80px;
  box-shadow: 0 8px 24px rgba(0,0,0,0.15);
  color: #333;
  font-family: "SimSun", "Songti SC", serif;
  box-sizing: border-box;
}

/* 👇👇👇 修改后的关闭按钮样式 👇👇👇 */
.close-btn-wrapper {
  position: absolute; /* 2. 绝对定位 */
  top: 15px;          /* 距离白纸顶部 15px */
  right: 15px;        /* 距离白纸右侧 15px */
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background-color: #f2f3f5; /* 浅灰底色，不抢眼 */
  color: #909399;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s;
  z-index: 10;
}
.close-btn-wrapper:hover {
  background-color: #f56c6c; /* 悬停变红 */
  color: #fff;
  transform: rotate(90deg);
}
/* 👆👆👆 修改结束 👆👆👆 */

.main-title { text-align: center; font-size: 24px; margin-bottom: 40px; font-family: "SimHei", sans-serif; }
.info-header { margin-bottom: 40px; }
.info-block { background: #f8f9fa; padding: 15px; border-radius: 4px; border-left: 4px solid #409eff; }
.info-block .label { font-size: 14px; color: #666; margin-bottom: 5px; font-family: sans-serif; }
.info-block .value { font-size: 18px; font-weight: bold; margin-bottom: 5px; font-family: sans-serif; }
.info-block .sub { font-size: 12px; color: #999; font-family: sans-serif; }

.summary-table { margin-top: 30px; border: 1px solid #dcdfe6; }
.tr { display: flex; border-bottom: 1px solid #dcdfe6; }
.tr:last-child { border-bottom: none; }
.th { width: 120px; background: #f2f6fc; padding: 12px; font-weight: bold; border-right: 1px solid #dcdfe6; display: flex; align-items: center; }
.td { flex: 1; padding: 12px; display: flex; align-items: center; }
.highlight { font-weight: bold; color: #333; font-size: 16px; }

.contract-body-title { font-size: 18px; font-weight: bold; margin: 40px 0 20px 0; border-left: 5px solid #333; padding-left: 10px; }
.contract-content-box { min-height: 200px; }

.contract-text {
  font-size: 16px;
  line-height: 1.8;
  white-space: pre-wrap;
  word-wrap: break-word;
  word-break: break-all;
  text-align: justify;
  font-family: "SimSun", serif;
}

.stamp-area { margin-top: 80px; display: flex; justify-content: space-between; padding: 0 50px; }
.sign-line { margin-top: 50px; color: #999; }
</style>
