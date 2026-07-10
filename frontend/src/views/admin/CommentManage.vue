<template>
  <div class="home-container">
    <!-- ... 顶部导航栏不变 ... -->
    
    <main class="main-content">
      <el-card>
        <!-- ... 搜索栏不变 ... -->
        
        <div v-loading="loading" class="notice-list">
          <!-- ... 卡片列表不变 ... -->
          
          <!-- 在卡片操作区域添加评论按钮 -->
          <div class="notice-action">
            <el-button type="primary" size="small" @click="handleViewDetail(notice)">
              查看详情
            </el-button>
            <el-button size="small" @click="openCommentDialog(notice)">
              💬 评论
            </el-button>
          </div>
        </div>
        
        <!-- ... 分页不变 ... -->
      </el-card>
    </main>

    <!-- ✅ 评论对话框 -->
    <el-dialog v-model="commentDialogVisible" title="💬 评论" width="500px">
      <div class="comment-section">
        <div class="comment-info">
          <strong>{{ currentNotice?.noticeTitle }}</strong>
          <span style="color: #999; font-size: 13px; margin-left: 10px;">
            共 {{ commentList.length }} 条评论
          </span>
        </div>
        
        <!-- 评论列表 -->
        <div class="comment-list" v-loading="commentLoading">
          <div v-if="commentList.length === 0" style="text-align: center; color: #999; padding: 20px;">
            暂无评论，来说两句吧~
          </div>
          <div v-for="comment in commentList" :key="comment.commentId" class="comment-item">
            <div class="comment-avatar">
              <el-avatar :size="32" :src="comment.userAvatar || '/default-avatar.png'" />
            </div>
            <div class="comment-body">
              <div class="comment-user">{{ comment.userName || '匿名用户' }}</div>
              <div class="comment-content">{{ comment.content }}</div>
              <div class="comment-time">{{ formatDate(comment.createTime) }}</div>
            </div>
          </div>
        </div>
        
        <!-- 输入框 -->
        <div class="comment-input">
          <el-input
            v-model="commentContent"
            type="textarea"
            :rows="3"
            placeholder="请输入您的评论..."
            maxlength="500"
            show-word-limit
          />
          <el-button 
            type="primary" 
            style="margin-top: 10px; width: 100%;"
            :loading="submittingComment"
            @click="submitComment"
          >
            发布评论
          </el-button>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed, onActivated } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Search, User, Location, View, Clock, Refresh } from '@element-plus/icons-vue'
import { getNotices } from '@/api/notice'
import { getCommentsByNotice, addComment } from '@/api/comment'

const router = useRouter()

// ... 其他代码不变 ...

// ==================== 评论功能 ====================
const commentDialogVisible = ref(false)
const commentLoading = ref(false)
const submittingComment = ref(false)
const currentNotice = ref(null)
const commentList = ref([])
const commentContent = ref('')

// 打开评论对话框
const openCommentDialog = async (notice) => {
  currentNotice.value = notice
  commentContent.value = ''
  commentDialogVisible.value = true
  await loadComments(notice.noticeId)
}

// 加载评论列表
const loadComments = async (noticeId) => {
  commentLoading.value = true
  try {
    const res = await getCommentsByNotice(noticeId, 1, 100)
    if (res.code === 200) {
      commentList.value = res.data.records || []
    } else {
      ElMessage.error(res.message || '加载评论失败')
    }
  } catch (error) {
    console.error('加载评论失败:', error)
    ElMessage.error('加载评论失败')
  } finally {
    commentLoading.value = false
  }
}

// 提交评论
const submitComment = async () => {
  if (!commentContent.value.trim()) {
    ElMessage.warning('请输入评论内容')
    return
  }
  
  submittingComment.value = true
  try {
    const userStr = localStorage.getItem('user') || sessionStorage.getItem('user')
    let userId = 1
    let userName = '匿名用户'
    if (userStr) {
      try {
        const user = JSON.parse(userStr)
        userId = user.userId || 1
        userName = user.userName || user.username || '匿名用户'
      } catch (e) {}
    }
    
    const res = await addComment({
      noticeId: currentNotice.value.noticeId,
      userId: userId,
      userName: userName,
      content: commentContent.value.trim()
    })
    
    if (res.code === 200) {
      ElMessage.success('评论成功！')
      commentContent.value = ''
      await loadComments(currentNotice.value.noticeId)
    } else {
      ElMessage.error(res.message || '评论失败')
    }
  } catch (error) {
    console.error('评论失败:', error)
    ElMessage.error('评论失败，请重试')
  } finally {
    submittingComment.value = false
  }
}

// 原来的 handleComment 方法替换
const handleComment = (notice) => {
  openCommentDialog(notice)
}

// 格式化时间
const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')} ${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`
}

// ... 其他代码不变 ...
</script>

<style scoped>
/* ... 原有样式不变 ... */

/* ✅ 评论对话框样式 */
.comment-section {
  padding: 10px 0;
}

.comment-info {
  padding-bottom: 15px;
  border-bottom: 1px solid #ebeef5;
  margin-bottom: 15px;
}

.comment-list {
  max-height: 300px;
  overflow-y: auto;
  margin-bottom: 15px;
}

.comment-item {
  display: flex;
  gap: 12px;
  padding: 12px 0;
  border-bottom: 1px solid #f0f0f0;
}

.comment-item:last-child {
  border-bottom: none;
}

.comment-body {
  flex: 1;
}

.comment-user {
  font-weight: bold;
  font-size: 14px;
  color: #303133;
}

.comment-content {
  font-size: 14px;
  color: #606266;
  margin: 4px 0;
  word-break: break-all;
}

.comment-time {
  font-size: 12px;
  color: #c0c4cc;
}

.comment-input {
  padding-top: 15px;
  border-top: 1px solid #ebeef5;
}
</style>