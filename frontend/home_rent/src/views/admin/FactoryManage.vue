<script setup lang="ts">
import { ref, onMounted, reactive } from 'vue'
import axios from 'axios'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Delete, Search, Edit } from '@element-plus/icons-vue'

const tableData = ref([])
const loading = ref(false)
const keyword = ref('')
const dialogVisible = ref(false)
const isEditMode = ref(false)
const total = ref(0)
const queryParams = reactive({ page: 1, pageSize: 10 })

// 表单数据模型
const form = reactive({
  id: null,
  title: '',
  area: 0,
  price: 0,
  address: '',
  image: '',
  floor_height: 0,
  power_supply: '',
  floor_load: 0,
  structure: '',
  tags: ''
})

// 1. 获取房源列表
const fetchList = async () => {
  loading.value = true
  try {
    const res = await axios.post('http://127.0.0.1:5000/api/admin/factory/list', {
      keyword: keyword.value,
      page: queryParams.page,
      pageSize: queryParams.pageSize
    })
    tableData.value = res.data.data
    total.value = res.data.total
  } finally {
    loading.value = false
  }
}

// 2. 打开新增弹窗
const openAddDialog = () => {
  isEditMode.value = false
  Object.assign(form, {
    id: null, title: '', area: 0, price: 0, address: '',
    floor_height: 6, power_supply: '100KVA', image: ''
  })
  dialogVisible.value = true
}

// 3. 打开编辑弹窗
const handleEdit = (row: any) => {
  isEditMode.value = true
  const rowData = { ...row }
  // 兼容处理：如果 tags 是数组，转回字符串显示
  if (Array.isArray(rowData.tags)) {
      rowData.tags = rowData.tags.join(',')
  }
  Object.assign(form, rowData)
  dialogVisible.value = true
}

// 4. 提交表单 (新增或更新)
const handleSubmit = async () => {
  if(!form.title) return ElMessage.warning('标题必填')

  const url = isEditMode.value
    ? 'http://127.0.0.1:5000/api/admin/factory/update'
    : 'http://127.0.0.1:5000/api/admin/factory/add'

  try {
    const res = await axios.post(url, form)
    if(res.data.code === 200) {
      ElMessage.success(isEditMode.value ? '更新成功' : '发布成功')
      dialogVisible.value = false
      fetchList()
    }
  } catch(e) {
    ElMessage.error('操作失败')
  }
}

// 5. 删除房源
const handleDelete = (row: any) => {
  ElMessageBox.confirm('确定要删除该房源吗？', '警告', { type: 'warning' })
    .then(async () => {
      try {
        await axios.post('http://127.0.0.1:5000/api/admin/factory/delete', { id: row.id })
        ElMessage.success('删除成功')
        fetchList()
      } catch(e) {
        ElMessage.error('删除失败')
      }
    })
}

const handlePageChange = (val: number) => { queryParams.page = val; fetchList() }
const handleSearch = () => { queryParams.page = 1; fetchList() }

onMounted(fetchList)
</script>

<template>
  <div class="admin-page">
    <div class="toolbar">
      <el-input
        v-model="keyword"
        placeholder="搜索厂房名称..."
        style="width: 300px"
        :prefix-icon="Search"
        @keyup.enter="handleSearch"
      />
      <el-button type="primary" :icon="Search" @click="handleSearch">搜索</el-button>
      <el-button type="success" :icon="Plus" @click="openAddDialog">发布新厂房</el-button>
    </div>

    <el-card shadow="never">
      <el-table
        :data="tableData"
        v-loading="loading"
        stripe
        height="calc(100vh - 340px)"
        @row-dblclick="handleEdit"
      >
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column label="图片" width="100">
          <template #default="{ row }">
            <el-image
              style="width: 50px; height: 35px; border-radius: 4px;"
              :src="row.image"
              :preview-src-list="[row.image]"
              preview-teleported
            />
          </template>
        </el-table-column>
        <el-table-column prop="title" label="厂房标题" min-width="200" show-overflow-tooltip />
        <el-table-column prop="area" label="面积(㎡)" width="100" />
        <el-table-column prop="price" label="租金" width="120" />
        <el-table-column prop="address" label="地址" show-overflow-tooltip />
        <el-table-column label="状态" width="80">
           <template #default="{ row }">
             <el-tag :type="row.status === 0 ? 'success' : 'info'">{{ row.status === 0 ? '空闲' : '已租' }}</el-tag>
           </template>
        </el-table-column>

        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link :icon="Edit" @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" link :icon="Delete" @click="handleDelete(row)">删除</el-button>
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

    <el-dialog v-model="dialogVisible" :title="isEditMode ? '编辑房源' : '发布新房源'" width="600px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="标题"> <el-input v-model="form.title" /> </el-form-item>
        <el-form-item label="地址"> <el-input v-model="form.address" /> </el-form-item>

        <el-row :gutter="20">
          <el-col :span="12"><el-form-item label="面积(㎡)"><el-input-number v-model="form.area" style="width:100%" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="租金"><el-input-number v-model="form.price" style="width:100%" /></el-form-item></el-col>
        </el-row>

        <el-divider content-position="left">工业参数</el-divider>
        <el-row :gutter="20">
          <el-col :span="12"><el-form-item label="层高(m)"><el-input-number v-model="form.floor_height" :precision="1" style="width:100%" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="承重(t)"><el-input-number v-model="form.floor_load" :precision="1" style="width:100%" /></el-form-item></el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12"><el-form-item label="配电"><el-input v-model="form.power_supply" placeholder="如: 200KVA" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="结构"><el-input v-model="form.structure" placeholder="如: 钢结构" /></el-form-item></el-col>
        </el-row>

        <el-form-item label="标签">
          <el-input v-model="form.tags" placeholder="用逗号分隔，如: 独门独院,可环评" />
        </el-form-item>

        <el-form-item label="图片URL"> <el-input v-model="form.image" /> </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.admin-page { padding: 20px; }
.toolbar { margin-bottom: 20px; display: flex; gap: 10px; }
.pagination-wrapper { margin-top: 20px; display: flex; justify-content: flex-end; }
</style>
