<script setup lang="ts">
import { ref, onMounted, reactive } from 'vue'
import axios from 'axios'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Delete } from '@element-plus/icons-vue'

const list = ref([])
const loading = ref(false)
const dialogVisible = ref(false)
const form = reactive({ title: '', content: '' })

// 1. 获取公告列表
const fetchList = async () => {
  loading.value = true
  try {
    const res = await axios.get('http://127.0.0.1:5000/api/notice/list')
    list.value = res.data.data
  } finally {
    loading.value = false
  }
}

// 2. 发布公告
const handleSubmit = async () => {
  if(!form.title || !form.content) return ElMessage.warning('请填写完整')
  try {
    await axios.post('http://127.0.0.1:5000/api/notice/add', form)
    ElMessage.success('发布成功')
    dialogVisible.value = false
    form.title = ''; form.content = ''
    fetchList()
  } catch(e) {
    ElMessage.error('发布失败')
  }
}

// 3. 删除公告
const handleDelete = (id: number) => {
  ElMessageBox.confirm('确定删除该公告吗？', '提示', { type: 'warning' })
    .then(async () => {
      await axios.post('http://127.0.0.1:5000/api/notice/delete', { id })
      ElMessage.success('删除成功')
      fetchList()
    })
}

onMounted(fetchList)
</script>

<template>
  <div class="admin-page">
    <div class="toolbar">
      <h2>公告通知管理</h2>
      <el-button type="primary" :icon="Plus" @click="dialogVisible = true">发布新公告</el-button>
    </div>

    <el-card shadow="never">
      <el-table :data="list" v-loading="loading" stripe>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="title" label="公告标题" min-width="200" />
        <el-table-column prop="content" label="内容摘要" show-overflow-tooltip />
        <el-table-column prop="time" label="发布时间" width="180" />
        <el-table-column label="操作" width="100" fixed="right">
          <template #default="{ row }">
            <el-button type="danger" link :icon="Delete" @click="handleDelete(row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="dialogVisible" title="发布新公告" width="500px">
      <el-form label-position="top">
        <el-form-item label="标题" required>
          <el-input v-model="form.title" placeholder="如：关于园区停电的通知" />
        </el-form-item>
        <el-form-item label="内容" required>
          <el-input v-model="form.content" type="textarea" rows="5" placeholder="请输入详细内容..." />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">立即发布</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.admin-page { padding: 20px; }
.toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
h2 { margin: 0; font-size: 20px; color: #303133; }
</style>
