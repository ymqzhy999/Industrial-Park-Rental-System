<script setup lang="ts">
import { ref, onMounted, reactive } from 'vue'
import axios from 'axios'
import { ElMessage, ElMessageBox } from 'element-plus'
import { View, Download, EditPen, Search, Refresh } from '@element-plus/icons-vue'

const list = ref([])
const loading = ref(false)
const total = ref(0)
const selectedIds = ref<number[]>([])

const queryParams = reactive({
  page: 1,
  pageSize: 10,
  keyword: '',
  status: ''
})

const detailVisible = ref(false)
const detailLoading = ref(false)
const currentContract = ref<any>({})

const fetchContracts = async () => {
  loading.value = true
  try {
    const res = await axios.post('http://127.0.0.1:5000/api/admin/contract/list', queryParams)
    list.value = res.data.data
    total.value = res.data.total
  } finally {
    loading.value = false
  }
}

const handleSearch = () => { queryParams.page = 1; fetchContracts() }
const handleReset = () => { queryParams.keyword = ''; queryParams.status = ''; handleSearch() }
const handleSelectionChange = (val: any[]) => { selectedIds.value = val.map(item => item.id) }
const handlePageChange = (val: number) => { queryParams.page = val; fetchContracts() }

const handleBatchExport = async () => {
  if (selectedIds.value.length === 0) return ElMessage.warning('请至少选择一项')
  try {
    ElMessage.info('正在打包...')
    const res = await axios.post('http://127.0.0.1:5000/api/admin/contract/batch_export', { ids: selectedIds.value }, { responseType: 'blob' })
    const url = window.URL.createObjectURL(new Blob([res.data]))
    const link = document.createElement('a')
    link.href = url
    link.setAttribute('download', `批量合同_${Date.now()}.zip`)
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    ElMessage.success('下载成功')
  } catch (e) {
    ElMessage.error('导出失败')
  }
}

const handleView = async (row: any) => {
  detailVisible.value = true
  detailLoading.value = true
  try {
    const res = await axios.get(`http://127.0.0.1:5000/api/contract/detail/${row.id}`)
    if(res.data.code === 200) {
      currentContract.value = res.data.data
    }
  } catch(e) {
    ElMessage.error('获取详情失败')
  } finally {
    detailLoading.value = false
  }
}

const handleDownload = () => {
  if(!currentContract.value.id) return
  window.open(`http://127.0.0.1:5000/api/contract/export/${currentContract.value.id}`, '_blank')
}

const handleAudit = (id: number, action: 'pass' | 'reject') => {
  const actionText = action === 'pass' ? '通过' : '拒绝'
  ElMessageBox.confirm(`确定要 [${actionText}] 此合同吗？`, '提示', {
    type: action === 'pass' ? 'success' : 'warning'
  }).then(async () => {
    try {
      await axios.post('http://127.0.0.1:5000/api/contract/audit', { id, action })
      ElMessage.success('操作成功')
      detailVisible.value = false
      fetchContracts()
    } catch(e) {
      ElMessage.error('操作失败')
    }
  })
}

onMounted(fetchContracts)
</script>

<template>
  <div class="admin-page">
    <div class="toolbar-container">
      <div class="left-filters">
        <el-input
          v-model="queryParams.keyword"
          placeholder="搜合同号/租户"
          style="width: 200px"
          :prefix-icon="Search"
          @keyup.enter="handleSearch"
          clearable
        />
        <el-select
          v-model="queryParams.status"
          placeholder="状态"
          style="width: 120px"
          clearable
          @change="handleSearch"
        >
          <el-option label="待审核" value="0" />
          <el-option label="生效中" value="1" />
          <el-option label="已拒绝" value="2" />
          <el-option label="待支付" value="3" />
        </el-select>
        <el-button type="primary" :icon="Search" @click="handleSearch">查询</el-button>
        <el-button :icon="Refresh" @click="handleReset">重置</el-button>
      </div>
      <div class="right-actions">
        <el-button type="primary" plain :icon="Download" :disabled="selectedIds.length === 0" @click="handleBatchExport">
          批量导出 Word
        </el-button>
      </div>
    </div>

    <el-card shadow="never">
      <el-table
        :data="list"
        v-loading="loading"
        stripe
        height="calc(100vh - 240px)"
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="55" />
        <el-table-column prop="no" label="合同编号" min-width="180" fixed />
        <el-table-column prop="tenant_name" label="承租方" width="120" />
        <el-table-column prop="factory_title" label="租赁厂房" min-width="200" show-overflow-tooltip />
        <el-table-column prop="total_price" label="总金额" width="140">
           <template #default="{row}">¥{{ row.total_price?.toLocaleString() }}</template>
        </el-table-column>
        <el-table-column label="状态" width="100" align="center">
          <template #default="{row}">
            <el-tag v-if="row.status===0" type="warning">待审核</el-tag>
            <el-tag v-else-if="row.status===1" type="success">生效中</el-tag>
            <el-tag v-else-if="row.status===2" type="danger">已拒绝</el-tag>
            <el-tag v-else-if="row.status===3" type="danger" effect="dark">待支付</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="160" fixed="right" align="center">
          <template #default="{row}">
            <el-button v-if="row.status===0" type="primary" link :icon="EditPen" @click="handleView(row)">审核 / 预览</el-button>
            <el-button v-else type="info" link :icon="View" @click="handleView(row)">查看合同</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination-wrapper">
        <el-pagination
          background
          layout="total, prev, pager, next"
          :total="total"
          :page-size="queryParams.pageSize"
          @current-change="handlePageChange"
        />
      </div>
    </el-card>

    <el-dialog v-model="detailVisible" title="合同文书预览" width="900px" top="5vh" class="word-dialog">
      <div class="word-preview-container" v-loading="detailLoading">
        <div class="a4-page" v-if="currentContract.id">
          <h1 class="doc-title">合同摘要与预览</h1>

          <table class="doc-table">
            <tbody>
              <tr>
                <td class="bg-gray" width="120">出租方</td>
                <td>{{ currentContract.party_a || '园区管理方' }}</td>
                <td class="bg-gray" width="120">承租方</td>
                <td>{{ currentContract.tenant_name || currentContract.party_b }}</td>
              </tr>
              <tr>
                <td class="bg-gray">租赁标的</td>
                <td>{{ currentContract.factory_title }}</td>
                <td class="bg-gray">总金额</td>
                <td class="money">¥ {{ currentContract.price?.toLocaleString() }}</td>
              </tr>
            </tbody>
          </table>

          <el-divider>以下为合同正文</el-divider>

          <div class="doc-content-text">
            {{ currentContract.content || '（暂无详细条款内容）' }}
          </div>

          <div class="doc-sign-area">
            <div class="sign-box"><p>甲方盖章：_____________</p></div>
            <div class="sign-box"><p>乙方签字：_____________</p></div>
          </div>
        </div>
      </div>

      <template #footer>
        <div class="dialog-footer">
          <el-button @click="detailVisible = false">关闭</el-button>
          <el-button type="primary" plain :icon="Download" @click="handleDownload">下载 Word</el-button>
          <template v-if="currentContract.status === 0">
            <el-button type="danger" @click="handleAudit(currentContract.id, 'reject')">拒绝</el-button>
            <el-button type="success" @click="handleAudit(currentContract.id, 'pass')">通过审核</el-button>
          </template>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.admin-page { padding: 20px; }
.toolbar-container { display: flex; justify-content: space-between; margin-bottom: 20px; background: #fff; padding: 15px; border-radius: 4px; }
.left-filters { display: flex; gap: 10px; }
.pagination-wrapper { margin-top: 20px; text-align: right; }

.word-preview-container { background: #f0f2f5; padding: 20px; height: 60vh; overflow-y: auto; display: flex; justify-content: center; align-items: flex-start; /* 关键：顶部对齐，防止高度塌陷 */ }

.a4-page {
  width: 210mm;
  min-height: 297mm; /* 最小高度 A4 */
  height: auto !important; /* 关键修复：允许高度自动增加 */
  background: white;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  padding: 25mm 20mm;
  box-sizing: border-box;
  font-family: "SimSun", serif;
  color: #000;
  margin-bottom: 20px; /* 底部留白，防止贴底 */
}

.doc-title { text-align: center; font-family: "SimHei"; font-size: 24px; margin-bottom: 30px; }
.doc-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
.doc-table td { border: 1px solid #000; padding: 8px 10px; font-size: 14px; line-height: 1.5; }
.bg-gray { background-color: #fafafa; font-weight: bold; }

/* 文本内容样式修复 */
.doc-content-text {
  font-size: 16px;
  line-height: 1.8;
  white-space: pre-wrap; /* 保留换行 */
  word-wrap: break-word;
  word-break: break-all; /* 强制长字符换行 */
  overflow-wrap: break-word;
  width: 100%;
  text-align: justify;
  font-family: "FangSong", "SimSun", serif;
  margin-top: 20px;
}

.doc-sign-area { margin-top: 60px; display: flex; justify-content: space-between; padding: 0 40px; }
</style>
