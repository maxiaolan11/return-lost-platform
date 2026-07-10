<template>
  <div class="dashboard-content">
    <el-card class="dashboard-card">
      <template #header>
        <h2>📊 仪表盘</h2>
      </template>
      
      <div class="stats-grid">
        <el-card shadow="hover" class="stat-card">
          <div class="stat-item">
            <h3>👤 用户总数</h3>
            <p class="stat-number">{{ userCount }}</p>
          </div>
        </el-card>
        
        <el-card shadow="hover" class="stat-card">
          <div class="stat-item">
            <h3>📋 招领信息</h3>
            <p class="stat-number">{{ noticeCount }}</p>
          </div>
        </el-card>
        
        <el-card shadow="hover" class="stat-card">
          <div class="stat-item">
            <h3>📂 分类数量</h3>
            <p class="stat-number">{{ categoryCount }}</p>
          </div>
        </el-card>
        
        <el-card shadow="hover" class="stat-card">
          <div class="stat-item">
            <h3>📍 位置数量</h3>
            <p class="stat-number">{{ locationCount }}</p>
          </div>
        </el-card>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getUsers } from '@/api/user'
import { getNotices } from '@/api/notice'
import { getCategories } from '@/api/category'
import { getLocations } from '@/api/location'

const userCount = ref(0)
const noticeCount = ref(0)
const categoryCount = ref(0)
const locationCount = ref(0)

const fetchUserCount = async () => {
  try {
    const res = await getUsers({ pageNum: 1, pageSize: 1 })
    console.log('用户响应:', res)
    // ✅ 适配新格式：res.data 是完整响应，res.data.data 是实际数据
    if (res && res.data && res.data.code === 200) {
      const data = res.data.data || {}
      userCount.value = data.total || 0
    }
  } catch (error) {
    console.error('获取用户总数失败:', error)
  }
}

const fetchNoticeCount = async () => {
  try {
    const res = await getNotices({ pageNum: 1, pageSize: 1 })
    console.log('招领响应:', res)
    if (res && res.data && res.data.code === 200) {
      const data = res.data.data || {}
      noticeCount.value = data.total || 0
    }
  } catch (error) {
    console.error('获取招领信息总数失败:', error)
  }
}

const fetchCategoryCount = async () => {
  try {
    const res = await getCategories()
    console.log('分类响应:', res)
    if (res && res.data && res.data.code === 200) {
      const data = res.data.data || []
      categoryCount.value = Array.isArray(data) ? data.length : 0
    }
  } catch (error) {
    console.error('获取分类总数失败:', error)
  }
}

const fetchLocationCount = async () => {
  try {
    const res = await getLocations({ pageNum: 1, pageSize: 1 })
    console.log('位置响应:', res)
    if (res && res.data && res.data.code === 200) {
      const data = res.data.data || {}
      locationCount.value = data.total || 0
    }
  } catch (error) {
    console.error('获取位置总数失败:', error)
  }
}

onMounted(() => {
  fetchUserCount()
  fetchNoticeCount()
  fetchCategoryCount()
  fetchLocationCount()
})
</script>

<style scoped>
/* 全屏占满 */
.dashboard-content {
  width: 100%;
  height: 100%;
  padding: 0 !important;
  margin: 0 !important;
  background: #f0f2f5;
  min-height: 100%;
}

.dashboard-card {
  width: 100%;
  height: 100%;
  border-radius: 0 !important;
  margin: 0 !important;
  box-shadow: none !important;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  padding: 20px;
  width: 100%;
}

.stat-card {
  width: 100%;
  transition: transform 0.3s;
}

.stat-card:hover {
  transform: translateY(-5px);
}

.stat-item {
  text-align: center;
  padding: 30px 20px;
}

.stat-item h3 {
  margin: 0 0 10px 0;
  color: #606266;
  font-size: 16px;
  font-weight: normal;
}

.stat-number {
  margin: 0;
  font-size: 48px;
  font-weight: bold;
  color: #409EFF;
}

/* 响应式 - 平板 */
@media screen and (max-width: 1024px) {
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 15px;
    padding: 15px;
  }
}

/* 响应式 - 手机 */
@media screen and (max-width: 600px) {
  .stats-grid {
    grid-template-columns: 1fr;
    gap: 10px;
    padding: 10px;
  }
  
  .stat-number {
    font-size: 32px;
  }
}
</style>