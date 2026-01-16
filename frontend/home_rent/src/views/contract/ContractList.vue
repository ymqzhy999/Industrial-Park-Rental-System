<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Document, Download, Search, Wallet, Delete, FolderChecked, Clock, CircleCheck } from '@element-plus/icons-vue'

const router = useRouter()

// --- 数据定义 ---
const activeTab = ref('active')
const tableData = ref([])
const loading = ref(false)
const total = ref(0)
const selectedIds = ref<number[]>([])

// 查询参数 (包含分页)
const queryParams = reactive({
  page: 1,
  pageSize: 10,
  username: ''
})

const userStore = JSON.parse(localStorage.getItem('user') || '{}')
const payDialogVisible = ref(false)
const currentPayContract = ref<any>({})
const payLoading = ref(false)

// --- 核心逻辑 ---

const fetchList = async () => {
  loading.value = true
  const payload = {
    page: queryParams.page,
    pageSize: queryParams.pageSize,
    username: userStore.role !== 0 ? userStore.username : '',
    tab: activeTab.value
  }

  try {
    const res = await axios.post('http://127.0.0.1:5000/api/contract/list', payload)
    if (res.data.code === 200) {
      tableData.value = res.data.data
      total.value = res.data.total
    }
  } catch (error) {
    ElMessage.error('数据加载失败')
  } finally {
    loading.value = false
    selectedIds.value = []
  }
}

const handleTabChange = (newTabName: any) => {
  activeTab.value = newTabName
  queryParams.page = 1
  fetchList()
}

const handlePageChange = (val: number) => { queryParams.page = val; fetchList() }
const handleSizeChange = (val: number) => { queryParams.pageSize = val; queryParams.page = 1; fetchList() }
const formatDate = (dateStr: string) => { if (!dateStr) return '--'; return dateStr.split(' ')[0] }

const handleBatchExport = async () => {
  if (selectedIds.value.length === 0) return
  try {
    ElMessage.info('正在打包下载...')
    const res = await axios.post('http://127.0.0.1:5000/api/contract/export/batch',
      { ids: selectedIds.value }, { responseType: 'blob' }
    )
    const url = window.URL.createObjectURL(new Blob([res.data]))
    const link = document.createElement('a')
    link.href = url
    link.setAttribute('download', `合同批量导出_${new Date().getTime()}.zip`)
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    ElMessage.success('下载成功')
  } catch (e) { ElMessage.error('导出失败') }
}

const executeDelete = async (ids: number[]) => {
  try {
    await axios.post('http://127.0.0.1:5000/api/contract/delete', { ids })
    ElMessage.success('删除成功'); fetchList()
  } catch(e) { ElMessage.error('删除失败') }
}

const handleBatchDelete = () => {
  ElMessageBox.confirm('确定要删除选中项吗？', '警告', { type: 'warning' }).then(() => executeDelete(selectedIds.value))
}

const handleSelectionChange = (selection: any[]) => { selectedIds.value = selection.map(item => item.id) }
const handleDetail = (row: any) => router.push(`/contract/${row.id}`)
const openPayDialog = (row: any) => { currentPayContract.value = row; payDialogVisible.value = true }
const handlePay = async () => {
  payLoading.value = true
  try {
    await axios.post('http://127.0.0.1:5000/api/payment/pay', { contract_id: currentPayContract.value.id })
    ElMessage.success('支付成功'); payDialogVisible.value = false; fetchList()
  } catch(e) { ElMessage.error('支付失败') } finally { payLoading.value = false }
}

onMounted(() => { fetchList() })
</script>

<template>
  <div class="contract-container">
    <div class="header-box">
      <div class="title">
        <el-icon><Document /></el-icon>
        <span>合同管理控制台</span>
      </div>
      <div class="header-actions">
         <el-button @click="fetchList" :icon="Search" circle title="刷新"></el-button>
      </div>
    </div>

    <el-tabs v-model="activeTab" type="card" class="contract-tabs" @tab-change="handleTabChange">
      <el-tab-pane name="active">
        <template #label><span class="custom-tab"><el-icon><CircleCheck /></el-icon> 生效中</span></template>
        <div class="tab-toolbar">
          <el-button type="primary" :icon="Download" :disabled="selectedIds.length===0" @click="handleBatchExport">批量导出 ZIP</el-button>
        </div>
      </el-tab-pane>

      <el-tab-pane name="pending">
        <template #label><span class="custom-tab"><el-icon><Clock /></el-icon> 待处理</span></template>
      </el-tab-pane>

      <el-tab-pane name="archived">
        <template #label><span class="custom-tab"><el-icon><FolderChecked /></el-icon> 已归档</span></template>
        <div class="tab-toolbar">
          <el-button type="danger" :icon="Delete" :disabled="selectedIds.length===0" @click="handleBatchDelete" plain>批量删除</el-button>
        </div>
      </el-tab-pane>
    </el-tabs>

    <el-card shadow="never" class="table-card">
      <el-table :data="tableData" v-loading="loading" style="width: 100%" stripe @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" fixed />

        <el-table-column prop="no" label="合同编号" width="220" fixed>
          <template #default="{ row }"><span class="mono-font">{{ row.no }}</span></template>
        </el-table-column>
        <el-table-column prop="factory_title" label="租赁厂房" min-width="180" show-overflow-tooltip />
        <el-table-column label="租赁周期" width="220">
          <template #default="{ row }">
            <div class="date-range"><span>{{ formatDate(row.start_date) }}</span><span class="arrow">→</span><span>{{ formatDate(row.end_date) }}</span></div>
          </template>
        </el-table-column>
        <el-table-column prop="price" label="总金额" width="120">
          <template #default="{ row }"><span class="price-text">¥{{ row.price?.toLocaleString() }}</span></template>
        </el-table-column>
        <el-table-column label="状态" width="100" align="center">
          <template #default="{ row }">
            <el-tag v-if="row.status===1" type="success" effect="dark">生效中</el-tag>
            <el-tag v-else-if="row.status===3" type="danger" effect="dark">待支付</el-tag>
            <el-tag v-else-if="row.status===0" type="warning">审核中</el-tag>
            <el-tag v-else type="info">已归档</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="220" fixed="right" align="center">
          <template #default="{ row }">
            <div class="op-btns">
              <template v-if="activeTab === 'active'">
                <el-button link type="primary" :icon="Download" @click="handleBatchExport">导出</el-button>
                <el-button link type="info" @click="handleDetail(row)">详情</el-button>
              </template>
              <template v-if="activeTab === 'pending'">
                <el-button v-if="row.status===3" type="primary" size="small" :icon="Wallet" @click="openPayDialog(row)">去支付</el-button>
                <el-button v-else link type="info" disabled>审核中</el-button>
                <el-button link type="info" @click="handleDetail(row)">详情</el-button>
              </template>
              <template v-if="activeTab === 'archived'">
                <el-button link type="info" @click="handleDetail(row)">详情</el-button>
                <el-popconfirm title="确定删除?" @confirm="executeDelete([row.id])">
                  <template #reference><el-button link type="danger" :icon="Delete">删除</el-button></template>
                </el-popconfirm>
              </template>
            </div>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination-area">
        <el-pagination
          background
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          :page-size="queryParams.pageSize"
          :current-page="queryParams.page"
          :page-sizes="[10, 20, 50]"
          @current-change="handlePageChange"
          @size-change="handleSizeChange"
        />
      </div>
      </el-card>

    <el-dialog v-model="payDialogVisible" title="收银台" width="400px" center>
      <div class="pay-container">
        <div class="pay-title">请使用 微信 或 支付宝 扫码支付</div>

        <img
          src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=HelloIndustrialPark"
          alt="支付二维码"
          class="qr-code"
        />

        <p class="pay-amount">¥ {{ currentPayContract.price?.toLocaleString() }}</p>
        <el-button type="primary" size="large" :loading="payLoading" @click="handlePay" style="width:100%">确认已支付</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<style scoped>
/* 样式保持不变 */
.contract-container { padding: 20px; max-width: 1200px; margin: 0 auto; }
.header-box { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
.title { font-size: 20px; font-weight: bold; color: #303133; display: flex; align-items: center; gap: 8px; }
.contract-tabs { margin-bottom: 0; }
.custom-tab { display: flex; align-items: center; gap: 5px; }
.tab-toolbar { padding: 10px 0; display: flex; gap: 10px; }
.table-card { border-top: none; border-radius: 0 0 8px 8px; }
.mono-font { font-family: Consolas, monospace; color: #606266; background: #f4f4f5; padding: 2px 6px; border-radius: 4px; font-size: 12px; }
.date-range { font-size: 13px; color: #606266; display: flex; align-items: center; gap: 5px; }
.price-text { color: #f56c6c; font-weight: bold; }
.op-btns { display: flex; justify-content: center; align-items: center; gap: 10px; width: 100%; }
.pagination-area { margin-top: 20px; display: flex; justify-content: flex-end; padding-bottom: 10px; }

/* 👇👇👇 支付弹窗样式优化 👇👇👇 */
.pay-container { text-align: center; padding: 10px 20px 30px; }
.pay-title { font-size: 14px; color: #606266; margin-bottom: 15px; }
.qr-code {
  width: 160px; height: 160px;
  display: block; margin: 0 auto 20px;
  border: 1px solid #eee; padding: 5px; border-radius: 4px;
}
.pay-amount { font-size: 32px; color: #f56c6c; font-weight: bold; margin-bottom: 25px; font-family: Arial, sans-serif; }
</style>
