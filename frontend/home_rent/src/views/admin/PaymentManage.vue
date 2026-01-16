<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import axios from 'axios'
import { Money, Refresh } from '@element-plus/icons-vue'

const tableData = ref([])
const loading = ref(false)
const total = ref(0)
const queryParams = reactive({ page: 1, pageSize: 10 })

// 获取支付流水列表
const fetchList = async () => {
  loading.value = true
  try {
    const res = await axios.post('http://127.0.0.1:5000/api/payment/admin/list', queryParams)
    if (res.data.code === 200) {
      tableData.value = res.data.data
      total.value = res.data.total
    }
  } finally {
    loading.value = false
  }
}

const handlePageChange = (val: number) => {
  queryParams.page = val
  fetchList()
}

onMounted(fetchList)
</script>

<template>
  <div class="admin-page">
    <div class="toolbar">
      <h2>
        <el-icon style="vertical-align: middle; margin-right:5px"><Money /></el-icon>
        财务支付流水
      </h2>
      <el-button :icon="Refresh" circle @click="fetchList" />
    </div>

    <el-card shadow="never">
      <el-table :data="tableData" v-loading="loading" stripe style="width: 100%">
        <el-table-column prop="id" label="流水号" width="80" align="center" />

        <el-table-column prop="contract_no" label="合同编号" min-width="180">
          <template #default="{row}">
             <span style="font-family: monospace; background: #f4f4f5; padding: 2px 5px;">
               {{ row.contract_no }}
             </span>
          </template>
        </el-table-column>

        <el-table-column prop="payer" label="付款人/企业" min-width="150" />

        <el-table-column prop="amount" label="支付金额" width="150">
          <template #default="{row}">
            <span style="color: #67c23a; font-weight: bold;">+ ¥{{ row.amount.toLocaleString() }}</span>
          </template>
        </el-table-column>

        <el-table-column prop="pay_method" label="支付方式" width="120">
          <template #default="{row}">
            <el-tag effect="plain">{{ row.pay_method }}</el-tag>
          </template>
        </el-table-column>

        <el-table-column prop="pay_time" label="支付时间" width="180" />
      </el-table>

      <div style="margin-top: 20px; text-align: right;">
        <el-pagination
          background
          layout="total, prev, pager, next"
          :total="total"
          :page-size="queryParams.pageSize"
          @current-change="handlePageChange"
        />
      </div>
    </el-card>
  </div>
</template>

<style scoped>
.admin-page { padding: 20px; }
.toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
h2 { font-size: 20px; margin: 0; color: #303133; }
</style>
