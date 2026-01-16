<script setup lang="ts">
import { ref, onMounted, nextTick } from 'vue'
import axios from 'axios'
import * as echarts from 'echarts'
import { User, House, Ticket, Money } from '@element-plus/icons-vue'

const stats = ref({
  users: 0,
  factories: 0,
  contracts: 0,
  income: 0
})

const pieChartRef = ref(null)
const lineChartRef = ref(null)

const fetchData = async () => {
  try {
    const res = await axios.get('http://127.0.0.1:5000/api/dashboard/stats')
    if(res.data.code === 200) {
      const data = res.data.data
      stats.value = data.card

      // 确保 DOM 更新后初始化图表
      nextTick(() => {
        initPieChart(data.pie)
        initLineChart(data.line)
      })
    }
  } catch(e) {
    console.error(e)
  }
}

const initPieChart = (data: any[]) => {
  if(!pieChartRef.value) return
  const chart = echarts.init(pieChartRef.value)
  chart.setOption({
    title: { text: '房源出租率统计', left: 'center' },
    tooltip: { trigger: 'item' },
    legend: { bottom: '0%' },
    color: ['#91cc75', '#ee6666'],
    series: [{
      name: '房源状态',
      type: 'pie',
      radius: ['40%', '70%'],
      avoidLabelOverlap: false,
      itemStyle: { borderRadius: 10, borderColor: '#fff', borderWidth: 2 },
      label: { show: false, position: 'center' },
      emphasis: { label: { show: true, fontSize: 20, fontWeight: 'bold' } },
      data: data.length ? data : [{value:0, name:'暂无数据'}]
    }]
  })
}

const initLineChart = (data: any) => {
  if(!lineChartRef.value) return
  const chart = echarts.init(lineChartRef.value)
  chart.setOption({
    title: { text: '近半年园区营收趋势', left: 'left' },
    tooltip: { trigger: 'axis' },
    grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
    xAxis: { type: 'category', boundaryGap: false, data: data.x },
    yAxis: { type: 'value' },
    series: [{
      name: '营收金额',
      type: 'line',
      stack: 'Total',
      smooth: true,
      data: data.y,
      areaStyle: { opacity: 0.3, color: '#409eff' },
      itemStyle: { color: '#409eff' }
    }]
  })
}

onMounted(() => {
  fetchData()
})
</script>

<template>
  <div class="dashboard-container">
    <el-row :gutter="20" class="card-row">
      <el-col :span="6">
        <el-card shadow="hover" class="data-card">
          <div class="card-content">
            <div class="icon-box blue"><el-icon><User /></el-icon></div>
            <div class="info">
              <div class="label">租户总数</div>
              <div class="num">{{ stats.users }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" class="data-card">
          <div class="card-content">
            <div class="icon-box green"><el-icon><House /></el-icon></div>
            <div class="info">
              <div class="label">房源总数</div>
              <div class="num">{{ stats.factories }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" class="data-card">
          <div class="card-content">
            <div class="icon-box orange"><el-icon><Ticket /></el-icon></div>
            <div class="info">
              <div class="label">待审合同</div>
              <div class="num">{{ stats.contracts }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" class="data-card">
          <div class="card-content">
            <div class="icon-box red"><el-icon><Money /></el-icon></div>
            <div class="info">
              <div class="label">总营收</div>
              <div class="num">¥{{ stats.income.toLocaleString() }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" class="chart-row">
      <el-col :span="14">
        <el-card shadow="never">
          <div ref="lineChartRef" style="height: 350px;"></div>
        </el-card>
      </el-col>
      <el-col :span="10">
        <el-card shadow="never">
          <div ref="pieChartRef" style="height: 350px;"></div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<style scoped>
.dashboard-container { padding: 20px; }
.card-row { margin-bottom: 20px; }
.data-card { cursor: pointer; transition: transform 0.3s; }
.data-card:hover { transform: translateY(-5px); }

.card-content { display: flex; align-items: center; }
.icon-box {
  width: 60px; height: 60px; border-radius: 8px; display: flex;
  align-items: center; justify-content: center; font-size: 30px; color: #fff; margin-right: 15px;
}
.blue { background: #409eff; }
.green { background: #67c23a; }
.orange { background: #e6a23c; }
.red { background: #f56c6c; }

.info .label { color: #909399; font-size: 14px; margin-bottom: 5px; }
.info .num { font-size: 24px; font-weight: bold; color: #303133; }
</style>
