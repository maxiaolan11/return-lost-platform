<template>
  <div class="user-manage">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>用户管理</span>
          <el-button v-if="isAdmin" type="primary" @click="handleAdd">新增用户</el-button>
        </div>
      </template>

      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="关键词">
          <el-input v-model="searchForm.keyword" placeholder="用户名/学号/邮箱" clearable />
        </el-form-item>
        <el-form-item label="角色">
          <el-select v-model="searchForm.role" placeholder="请选择角色" clearable>
            <el-option label="管理员" value="admin" />
            <el-option label="普通用户" value="user" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="请选择状态" clearable>
            <el-option label="启用" value="active" />
            <el-option label="禁用" value="inactive" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>

      <el-table :data="tableData" border stripe style="width: 100%">
        <!-- 头像列 -->
        <el-table-column label="头像" width="80" align="center">
          <template #default="{ row }">
            <el-avatar 
              :size="40" 
              :src="row.avatar || getDefaultAvatar(row.userName)"
              :alt="row.userName"
            />
          </template>
        </el-table-column>

        <el-table-column prop="userId" label="ID" width="80" />
        <el-table-column prop="userName" label="用户名" />
        <el-table-column prop="userNo" label="学号" />
        <el-table-column prop="email" label="邮箱" />
        <el-table-column prop="role" label="角色" width="100">
          <template #default="{ row }">
            <el-tag :type="row.role === 'admin' ? 'danger' : 'success'">
              {{ row.role === 'admin' ? '管理员' : '普通用户' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 'active' ? 'success' : 'info'">
              {{ row.status === 'active' ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="注册时间" width="180" />
        <el-table-column label="发布类型" width="120" align="center">
          <template #default="{ row }">
            <el-tag :type="row.publishType === 'scheduled' ? 'warning' : 'success'" size="small">
              {{ row.publishType === 'scheduled' ? '定时发布' : '立即发布' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="发布时间" width="180" align="center">
          <template #default="{ row }">
            <span v-if="row.publishType === 'scheduled' && row.publishTime">
              {{ formatDate(row.publishTime) }}
            </span>
            <span v-else style="color: #999;">-</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <template v-if="isAdmin">
              <el-button size="small" @click="handleEdit(row)">编辑</el-button>
              <el-button size="small" type="danger" @click="handleDelete(row)">删除</el-button>
            </template>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        v-model:current-page="pagination.pageNum"
        v-model:page-size="pagination.pageSize"
        :total="pagination.total"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="fetchData"
        @current-change="fetchData"
        style="margin-top: 20px; justify-content: flex-end"
      />
    </el-card>

    <!-- 新增/编辑对话框 -->
    <el-dialog v-if="isAdmin" v-model="dialogVisible" :title="dialogTitle" width="500px" @closed="handleDialogClosed">
      <el-form ref="formRef" :model="formData" :rules="formRules" label-width="100px">
        <el-form-item label="用户名" prop="userName">
          <el-input v-model="formData.userName" placeholder="请输入用户名" />
        </el-form-item>
        <el-form-item label="密码" prop="password" v-if="!formData.userId">
          <el-input v-model="formData.password" type="password" placeholder="请输入密码" show-password />
        </el-form-item>
        <el-form-item label="学号" prop="userNo">
          <el-input v-model="formData.userNo" placeholder="请输入学号" />
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="formData.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="角色" prop="role">
          <el-select v-model="formData.role" placeholder="请选择角色">
            <el-option label="管理员" value="admin" />
            <el-option label="普通用户" value="user" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="formData.status">
            <el-radio label="active">启用</el-radio>
            <el-radio label="inactive">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="头像">
          <el-upload
            class="avatar-uploader"
            action="/file/upload"
            :show-file-list="false"
            :on-success="handleAvatarSuccess"
            :on-error="handleAvatarError"
            :before-upload="beforeAvatarUpload"
            :headers="uploadHeaders"
            name="file"
          >
            <img v-if="formData.avatar" :src="formData.avatar" class="avatar" />
            <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
          </el-upload>
          <div class="upload-tip">支持 jpg/png 格式，大小不超过 2MB</div>
        </el-form-item>
        <el-form-item label="发布类型">
          <el-radio-group v-model="formData.publishType">
            <el-radio label="immediate">立即发布</el-radio>
            <el-radio label="scheduled">定时发布</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item v-if="formData.publishType === 'scheduled'" label="发布时间" prop="publishTime">
          <el-date-picker
            v-model="formData.publishTime"
            type="datetime"
            placeholder="请选择发布时间"
            format="YYYY-MM-DD HH:mm:ss"
            value-format="YYYY-MM-DDTHH:mm:ss"
            style="width: 100%"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import { getUsers, addUser, updateUser, deleteUser } from '@/api/user'

// 用户权限
const getUserInfo = () => {
  const userStr = localStorage.getItem('user') || sessionStorage.getItem('user')
  if (userStr) {
    try {
      return JSON.parse(userStr)
    } catch (e) {
      return null
    }
  }
  return null
}

const isAdmin = computed(() => {
  const user = getUserInfo()
  return user && user.role === 'admin'
})

const tableData = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)

// 上传请求头（携带token）
const uploadHeaders = computed(() => ({
  Authorization: 'Bearer ' + (localStorage.getItem('token') || '')
}))

const searchForm = reactive({
  keyword: '',
  role: '',
  status: ''
})

const pagination = reactive({
  pageNum: 1,
  pageSize: 10,
  total: 0
})

const formData = reactive({
  userId: null,
  userName: '',
  password: '',
  userNo: '',
  email: '',
  role: 'user',
  status: 'active',
  avatar: '',
  publishType: 'immediate',
  publishTime: null
})

const formRules = {
  userName: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
  userNo: [{ required: true, message: '请输入学号', trigger: 'blur' }],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '邮箱格式不正确', trigger: 'blur' }
  ],
  role: [{ required: true, message: '请选择角色', trigger: 'change' }],
  publishTime: [{ required: true, message: '请选择发布时间', trigger: 'change' }]
}

const formatDate = (date) => {
  if (!date) return '-'
  try {
    const d = new Date(date)
    return d.toLocaleString('zh-CN', {
      year: 'numeric', month: '2-digit', day: '2-digit',
      hour: '2-digit', minute: '2-digit', second: '2-digit'
    })
  } catch {
    return date
  }
}

// 获取默认头像（根据用户名生成不同颜色 + 首字母）
const getDefaultAvatar = (userName) => {
  const colors = ['#409EFF', '#67C23A', '#E6A23C', '#F56C6C', '#909399', '#9B59B6', '#1ABC9C', '#E67E22']
  const index = userName ? userName.length % colors.length : 0
  const color = colors[index]
  const firstChar = userName ? userName.charAt(0).toUpperCase() : '?'
  return `data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='40' height='40'%3E%3Crect width='40' height='40' fill='${encodeURIComponent(color)}'/%3E%3Ctext x='20' y='26' text-anchor='middle' fill='white' font-size='18' font-weight='bold' font-family='Arial'%3E${firstChar}%3C/text%3E%3C/svg%3E`
}

// 头像上传成功回调
const handleAvatarSuccess = (res) => {
  console.log('上传返回:', res)
  if (res.success === true || res.code === 200) {
    const avatarUrl = res.filePath || res.data
    if (avatarUrl) {
      formData.avatar = avatarUrl
      ElMessage.success(res.message || '头像上传成功')
    } else {
      ElMessage.error('上传成功但未返回图片地址')
    }
  } else {
    ElMessage.error(res.message || '上传失败')
  }
}

// 头像上传失败回调
const handleAvatarError = (error) => {
  console.error('上传失败:', error)
  ElMessage.error('头像上传失败，请检查网络或联系管理员')
}

// 头像上传前校验
const beforeAvatarUpload = (file) => {
  const isImage = file.type === 'image/jpeg' || file.type === 'image/png' || file.type === 'image/gif'
  const isLt2M = file.size / 1024 / 1024 < 2
  
  if (!isImage) {
    ElMessage.error('只能上传 jpg/png/gif 格式的图片')
    return false
  }
  if (!isLt2M) {
    ElMessage.error('图片大小不能超过 2MB')
    return false
  }
  return true
}

// 数据获取
const fetchData = async () => {
  try {
    const res = await getUsers({
      pageNum: pagination.pageNum,
      pageSize: pagination.pageSize,
      keyword: searchForm.keyword,
      role: searchForm.role,
      status: searchForm.status
    })
    
    console.log('用户列表响应:', res)
    
    if (res && res.data && res.data.code === 200) {
      const data = res.data.data || {}
      tableData.value = data.records || data.list || []
      pagination.total = data.total || 0
    } else {
      ElMessage.error(res?.data?.message || '获取数据失败')
    }
  } catch (error) {
    console.error(error)
    ElMessage.error('获取数据失败')
  }
}

const handleSearch = () => {
  pagination.pageNum = 1
  fetchData()
}

const handleReset = () => {
  searchForm.keyword = ''
  searchForm.role = ''
  searchForm.status = ''
  pagination.pageNum = 1
  fetchData()
}

const handleAdd = () => {
  if (!isAdmin.value) {
    ElMessage.warning('您没有权限执行此操作')
    return
  }
  
  dialogTitle.value = '新增用户'
  Object.assign(formData, {
    userId: null,
    userName: '',
    password: '',
    userNo: '',
    email: '',
    role: 'user',
    status: 'active',
    avatar: '',
    publishType: 'immediate',
    publishTime: null
  })
  dialogVisible.value = true
}

const handleEdit = (row) => {
  if (!isAdmin.value) {
    ElMessage.warning('您没有权限执行此操作')
    return
  }
  
  dialogTitle.value = '编辑用户'
  Object.assign(formData, {
    userId: row.userId,
    userName: row.userName,
    password: '',
    userNo: row.userNo || '',
    email: row.email || '',
    role: row.role || 'user',
    status: row.status || 'active',
    avatar: row.avatar || '',
    publishType: row.publishType || 'immediate',
    publishTime: row.publishTime || null
  })
  dialogVisible.value = true
}

const handleSubmit = async () => {
  try {
    await formRef.value.validate()
  } catch (error) {
    return
  }

  if (formData.publishType === 'scheduled' && !formData.publishTime) {
    ElMessage.warning('请选择发布时间')
    return
  }

  const submitData = { ...formData }
  if (submitData.publishType === 'immediate') {
    submitData.publishTime = null
  }
  
  try {
    let res
    if (formData.userId) {
      res = await updateUser(submitData)
    } else {
      res = await addUser(submitData)
    }
    
    if (res && res.data && res.data.code === 200) {
      ElMessage.success(res.data.message || '操作成功')
      dialogVisible.value = false
      setTimeout(() => {
        fetchData()
      }, 300)
    } else {
      ElMessage.error(res?.data?.message || '操作失败')
    }
  } catch (error) {
    console.error(error)
  }
}

const handleDialogClosed = () => {
  formRef.value?.resetFields()
}

const handleDelete = (row) => {
  if (!isAdmin.value) {
    ElMessage.warning('您没有权限执行此操作')
    return
  }
  
  ElMessageBox.confirm(`确定要删除「${row.userName}」吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const res = await deleteUser(row.userId)
      if (res && res.data && res.data.code === 200) {
        ElMessage.success('删除成功')
        setTimeout(() => {
          fetchData()
        }, 300)
      } else {
        ElMessage.error(res?.data?.message || '删除失败')
      }
    } catch (error) {
      console.error(error)
      ElMessage.error('删除失败')
    }
  }).catch(() => {})
}

onMounted(() => {
  fetchData()
})
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-form {
  margin-bottom: 20px;
}

/* 头像上传样式 */
.avatar-uploader :deep(.el-upload) {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: all 0.3s;
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100px;
  height: 100px;
}

.avatar-uploader :deep(.el-upload:hover) {
  border-color: #409EFF;
}

.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 100px;
  height: 100px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.avatar {
  width: 100px;
  height: 100px;
  object-fit: cover;
  border-radius: 6px;
}

.upload-tip {
  font-size: 12px;
  color: #999;
  margin-top: 5px;
}
</style>