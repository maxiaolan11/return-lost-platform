<template>
  <div class="home-container">
    <header class="header">
      <div class="header-content">
        <h1 class="logo">🏫 校园失物招领系统</h1>
        
        <div class="nav-menu">
          <router-link to="/home" class="nav-item active">首页</router-link>
          
          <a v-if="isAdmin" @click.prevent="goToAdmin" class="nav-item" style="cursor: pointer;">
            ⚙️ 后台管理
          </a>
          
          <el-dropdown trigger="click">
            <span class="user-info">
              <el-avatar :size="32" :src="userInfo.avatar || '/default-avatar.png'" />
              <span class="username">{{ userInfo.userName || userInfo.username || '用户' }}</span>
              <el-tag size="small" :type="userInfo.role === 'admin' ? 'danger' : 'info'">
                {{ userInfo.role === 'admin' ? '管理员' : '用户' }}
              </el-tag>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="handleLogout">🚪 退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>
    </header>

    <main class="main-content">
      <el-card>
        <template #header>
          <div class="card-header">
            <span>📋 招领信息列表</span>
            <div class="header-actions">
              <el-button size="small" @click="fetchData" :loading="loading">
                <el-icon><Refresh /></el-icon> 刷新
              </el-button>
              <el-input
                v-model="searchKeyword"
                placeholder="搜索文章"
                style="width: 200px"
                clearable
                @clear="fetchData"
                @keyup.enter="fetchData"
              >
                <template #append>
                  <el-button @click="fetchData">
                    <el-icon><Search /></el-icon>
                  </el-button>
                </template>
              </el-input>
            </div>
          </div>
        </template>

        <div v-loading="loading" class="notice-list">
          <el-empty v-if="tableData.length === 0 && !loading" description="暂无招领信息" />
          
          <div v-for="notice in tableData" :key="notice.noticeId" class="notice-item">
            <div v-if="notice.isTop === 1" class="top-badge">
              <el-tag size="small" type="danger" effect="dark">📌 置顶</el-tag>
            </div>
            
            <div class="notice-cover">
              <img 
                :src="notice.imageUrl || '/default-notice.png'" 
                :alt="notice.noticeTitle"
                @error="handleImageError"
              />
            </div>
            
            <div class="notice-content">
              <h3 class="notice-title">{{ notice.noticeTitle }}</h3>
              <p class="notice-desc">{{ notice.itemDesc || notice.description || '暂无描述' }}</p>
              <div class="notice-info">
                <div class="info-row">
                  <span class="label">物品：</span>
                  <span class="value">{{ notice.itemName || '-' }}</span>
                </div>
                <div class="info-row">
                  <span class="label">类型：</span>
                  <el-tag size="small" :type="notice.noticeType === 1 ? 'warning' : 'success'">
                    {{ notice.noticeType === 1 ? '寻物启事' : '失物招领' }}
                  </el-tag>
                </div>
                <div class="info-row">
                  <span class="label">状态：</span>
                  <el-tag size="small" type="info">
                    {{ notice.statusName || '已发布' }}
                  </el-tag>
                </div>
                <div class="info-row">
                  <span class="label">发布人：</span>
                  <span class="value">{{ notice.userName || notice.publisherName || '-' }}</span>
                </div>
                <div class="info-row">
                  <span class="label">地点：</span>
                  <span class="value">{{ notice.locationName || '-' }}</span>
                </div>
                <div class="info-row">
                  <span class="label">时间：</span>
                  <span class="value">{{ formatDate(notice.createTime) }}</span>
                </div>
                <div class="info-row">
                  <span class="label">浏览：</span>
                  <span class="value">{{ notice.viewCount || 0 }}</span>
                </div>
              </div>
              
              <!-- 评论列表 -->
              <div class="comment-section">
                <div class="comment-section-header">
                  <span class="comment-label">💬 评论 ({{ getCommentCount(notice) }})</span>
                  <el-button size="small" type="primary" link @click="openCommentInput(notice)">
                    发表评论
                  </el-button>
                </div>
                
                <!-- 评论列表 -->
                <div v-if="notice.comments && notice.comments.length > 0" class="comment-list-inline">
                  <div v-for="comment in notice.comments" :key="comment.commentId" class="comment-item-inline">
                    <div class="comment-item-header">
                      <span class="comment-author">{{ comment.userName || '匿名用户' }}</span>
                      <span class="comment-time">{{ formatDateTime(comment.createTime) }}</span>
                      <el-button 
                        v-if="canDeleteComment(comment)" 
                        type="danger" 
                        size="small" 
                        link 
                        @click="handleDeleteCommentInline(notice, comment)"
                      >
                        删除
                      </el-button>
                    </div>
                    <div class="comment-text">{{ comment.content }}</div>
                  </div>
                </div>
                
                <!-- 评论输入框 -->
                <div v-if="notice.showCommentInput" class="comment-input-wrapper">
                  <el-input
                    v-model="notice.newComment"
                    type="textarea"
                    :rows="2"
                    placeholder="请输入评论..."
                    maxlength="200"
                  />
                  <div class="comment-input-actions">
                    <el-button size="small" @click="notice.showCommentInput = false">取消</el-button>
                    <el-button size="small" type="primary" @click="submitCommentInline(notice)" :loading="notice.submitting">
                      发表
                    </el-button>
                  </div>
                </div>
              </div>
              
              <div class="notice-action">
                <el-button size="small" @click="openCommentInput(notice)">
                  💬 评论 ({{ getCommentCount(notice) }})
                </el-button>
                <!-- 管理员显示置顶按钮 -->
                <el-button 
                  v-if="isAdmin"
                  size="small" 
                  :type="notice.isTop === 1 ? 'warning' : 'default'"
                  @click="handleToggleTop(notice)"
                >
                  {{ notice.isTop === 1 ? '📌 取消置顶' : '📍 置顶' }}
                </el-button>
              </div>
            </div>
          </div>
        </div>

        <el-pagination
          v-if="pagination.total > 0"
          v-model:current-page="pagination.pageNum"
          v-model:page-size="pagination.pageSize"
          :total="pagination.total"
          :page-sizes="[6, 12, 24, 48]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="fetchData"
          @current-change="fetchData"
          style="margin-top: 20px; justify-content: center"
        />
      </el-card>
    </main>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed, onActivated } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search, Refresh } from '@element-plus/icons-vue'
import { getNotices, toggleTopNotice } from '@/api/notice'
import { getCommentsByNotice, addComment, deleteComment } from '@/api/comment'

const router = useRouter()

const userInfo = ref({
  userName: '',
  username: '',
  avatar: '',
  role: '',
  userId: null
})

const isAdmin = computed(() => {
  return userInfo.value.role === 'admin'
})

const loading = ref(false)
const searchKeyword = ref('')
const tableData = ref([])

const pagination = reactive({
  pageNum: 1,
  pageSize: 12,
  total: 0
})

// 获取评论数量
const getCommentCount = (notice) => {
  return (notice.comments && notice.comments.length) || 0
}

// 打开评论输入框
const openCommentInput = (notice) => {
  if (!notice.comments) {
    notice.comments = []
    notice.showCommentInput = true
    notice.newComment = ''
    return
  }
  notice.showCommentInput = !notice.showCommentInput
  if (notice.showCommentInput) {
    notice.newComment = ''
  }
}

// 提交评论
const submitCommentInline = async (notice) => {
  if (!notice.newComment || !notice.newComment.trim()) {
    ElMessage.warning('请输入评论内容')
    return
  }
  
  if (!userInfo.value.userId) {
    ElMessage.warning('请先登录')
    return
  }
  
  notice.submitting = true
  try {
    const res = await addComment({
      noticeId: notice.noticeId,
      userId: userInfo.value.userId,
      content: notice.newComment.trim()
    })
    
    if (res && res.data && res.data.code === 200) {
      ElMessage.success('评论成功')
      const newComment = {
        commentId: Date.now(),
        noticeId: notice.noticeId,
        userId: userInfo.value.userId,
        userName: userInfo.value.userName || userInfo.value.username || '我',
        content: notice.newComment.trim(),
        createTime: new Date().toISOString()
      }
      if (!notice.comments) {
        notice.comments = []
      }
      notice.comments.push(newComment)
      notice.newComment = ''
      notice.showCommentInput = false
      notice.commentCount = (notice.commentCount || 0) + 1
    } else {
      ElMessage.error(res?.data?.message || '评论失败')
    }
  } catch (error) {
    console.error('评论失败:', error)
    ElMessage.error('评论失败')
  } finally {
    notice.submitting = false
  }
}

// 删除评论
const handleDeleteCommentInline = (notice, comment) => {
  ElMessageBox.confirm('确定要删除这条评论吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const res = await deleteComment(comment.commentId)
      if (res && res.data && res.data.code === 200) {
        ElMessage.success('删除成功')
        if (notice.comments) {
          const index = notice.comments.findIndex(c => c.commentId === comment.commentId)
          if (index > -1) {
            notice.comments.splice(index, 1)
            notice.commentCount = Math.max(0, (notice.commentCount || 1) - 1)
          }
        }
      } else {
        ElMessage.error(res?.data?.message || '删除失败')
      }
    } catch (error) {
      console.error('删除失败:', error)
      ElMessage.error('删除失败')
    }
  }).catch(() => {})
}

// 判断是否可以删除评论
const canDeleteComment = (comment) => {
  const currentUserId = userInfo.value.userId
  return currentUserId && (comment.userId === currentUserId || isAdmin.value)
}

// 加载评论
const loadCommentsForNotice = async (notice) => {
  try {
    const res = await getCommentsByNotice(notice.noticeId, 1, 100)
    if (res && res.data && res.data.code === 200) {
      const data = res.data.data || {}
      notice.comments = data.records || []
      notice.commentCount = notice.comments.length
    }
  } catch (error) {
    console.error('加载评论失败:', error)
  }
}

// 切换置顶状态
const handleToggleTop = async (notice) => {
  try {
    const res = await toggleTopNotice(notice.noticeId)
    
    if (res && res.data && res.data.code === 200) {
      notice.isTop = notice.isTop === 1 ? 0 : 1
      
      tableData.value = tableData.value.sort((a, b) => {
        if (a.isTop === 1 && b.isTop !== 1) return -1
        if (a.isTop !== 1 && b.isTop === 1) return 1
        return 0
      })
      
      ElMessage.success(notice.isTop === 1 ? '置顶成功' : '取消置顶成功')
    } else {
      ElMessage.error(res?.data?.message || '操作失败')
    }
  } catch (error) {
    console.error('置顶操作失败:', error)
    ElMessage.error('操作失败，请重试')
  }
}

const fetchData = async () => {
  loading.value = true
  try {
    const res = await getNotices({
      pageNum: pagination.pageNum,
      pageSize: pagination.pageSize,
      keyword: searchKeyword.value,
      _t: Date.now()
    })
    
    console.log('===== 招领列表响应 =====')
    console.log(res)
    
    if (res && res.data && res.data.code === 200) {
      const data = res.data.data || {}
      const records = data.records || []
      tableData.value = records.sort((a, b) => {
        if (a.isTop === 1 && b.isTop !== 1) return -1
        if (a.isTop !== 1 && b.isTop === 1) return 1
        return 0
      })
      pagination.total = data.total || 0
      
      for (const notice of tableData.value) {
        notice.comments = []
        notice.showCommentInput = false
        notice.newComment = ''
        notice.submitting = false
        await loadCommentsForNotice(notice)
      }
    } else {
      console.warn('获取数据失败:', res?.data?.message)
    }
  } catch (error) {
    console.error('获取数据失败:', error)
  } finally {
    loading.value = false
  }
}

const refreshData = () => {
  pagination.pageNum = 1
  fetchData()
}

onMounted(() => {
  const userStr = localStorage.getItem('user') || sessionStorage.getItem('user')
  console.log('===== Home页面加载 =====')
  
  if (userStr) {
    try {
      const parsed = JSON.parse(userStr)
      userInfo.value = {
        userName: parsed.userName || parsed.username || '',
        username: parsed.username || parsed.userName || '',
        avatar: parsed.avatar || '',
        role: parsed.role || '',
        userId: parsed.userId || parsed.id || null
      }
      console.log('用户信息:', userInfo.value)
    } catch (error) {
      console.error('解析用户信息失败:', error)
    }
  }
  
  setTimeout(() => {
    fetchData()
  }, 100)
})

onActivated(() => {
  console.log('===== Home页面激活，刷新数据 =====')
  refreshData()
})

const handleImageError = (e) => {
  e.target.src = '/default-notice.png'
}

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
}

const formatDateTime = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')} ${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`
}

const handleLogout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('user')
  sessionStorage.removeItem('token')
  sessionStorage.removeItem('user')
  ElMessage.success('退出成功')
  router.push('/login')
}

const goToAdmin = () => {
  const token = localStorage.getItem('token') || sessionStorage.getItem('token')
  const userStr = localStorage.getItem('user') || sessionStorage.getItem('user')
  
  if (!token) {
    ElMessage.warning('请先登录')
    router.push('/login')
    return
  }
  
  if (!userStr) {
    ElMessage.warning('用户信息缺失，请重新登录')
    router.push('/login')
    return
  }
  
  try {
    const user = JSON.parse(userStr)
    if (user.role !== 'admin') {
      ElMessage.warning('您没有权限访问管理后台')
      return
    }
    router.push('/admin/dashboard')
  } catch (e) {
    ElMessage.error('用户信息异常，请重新登录')
    router.push('/login')
  }
}
</script>

<style scoped>
.home-container {
  min-height: 100vh;
  background-color: #f5f7fa;
}

.header {
  background-color: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 1000;
}

.header-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.logo {
  font-size: 20px;
  font-weight: bold;
  color: #409EFF;
  margin: 0;
}

.nav-menu {
  display: flex;
  align-items: center;
  gap: 20px;
}

.nav-item {
  text-decoration: none;
  color: #606266;
  font-size: 14px;
  padding: 8px 12px;
  border-radius: 4px;
  transition: all 0.3s;
}

.nav-item:hover,
.nav-item.active {
  color: #409EFF;
  background-color: #ecf5ff;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
}

.username {
  font-size: 14px;
  color: #606266;
}

.main-content {
  max-width: 1200px;
  margin: 20px auto;
  padding: 0 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.notice-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.notice-item {
  display: flex;
  background: #fff;
  border: 1px solid #ebeef5;
  border-radius: 8px;
  overflow: hidden;
  transition: all 0.3s;
  position: relative;
}

.notice-item:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.top-badge {
  position: absolute;
  top: 10px;
  right: 10px;
  z-index: 10;
}

.notice-cover {
  width: 200px;
  min-height: 180px;
  flex-shrink: 0;
  background-color: #f5f7fa;
  overflow: hidden;
}

.notice-cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.notice-content {
  flex: 1;
  padding: 16px 20px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.notice-title {
  font-size: 18px;
  font-weight: bold;
  color: #303133;
  margin: 0 0 8px 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.notice-desc {
  font-size: 14px;
  color: #909399;
  margin: 0 0 12px 0;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.notice-info {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  gap: 4px 16px;
  margin-bottom: 12px;
}

.info-row {
  font-size: 13px;
  color: #606266;
  display: flex;
  align-items: center;
  gap: 4px;
}

.info-row .label {
  color: #909399;
  flex-shrink: 0;
}

.info-row .value {
  color: #303133;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.comment-section {
  margin-top: 10px;
  padding-top: 10px;
  border-top: 1px solid #ebeef5;
}

.comment-section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.comment-label {
  font-size: 13px;
  color: #909399;
}

.comment-list-inline {
  margin-top: 6px;
}

.comment-item-inline {
  padding: 6px 0;
  border-bottom: 1px dashed #f0f0f0;
}

.comment-item-inline:last-child {
  border-bottom: none;
}

.comment-item-header {
  display: flex;
  align-items: center;
  gap: 8px;
}

.comment-author {
  font-size: 13px;
  font-weight: bold;
  color: #409EFF;
}

.comment-time {
  font-size: 11px;
  color: #909399;
}

.comment-text {
  font-size: 13px;
  color: #606266;
  padding-left: 4px;
}

.comment-input-wrapper {
  margin-top: 8px;
}

.comment-input-actions {
  margin-top: 6px;
  display: flex;
  gap: 8px;
  justify-content: flex-end;
}

.notice-action {
  display: flex;
  gap: 10px;
  margin-top: 8px;
}

@media (max-width: 768px) {
  .notice-item {
    flex-direction: column;
  }
  .notice-cover {
    width: 100%;
    height: 160px;
  }
  .notice-info {
    grid-template-columns: 1fr 1fr;
  }
}
</style>