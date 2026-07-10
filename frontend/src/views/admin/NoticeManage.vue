<template>
  <div class="notice-manage">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>招领信息管理</span>
          <el-button v-if="isAdmin" type="primary" @click="handleAdd">新增</el-button>
        </div>
      </template>

      <!-- 搜索栏 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="关键词">
          <el-input v-model="searchForm.keyword" placeholder="标题/物品名称" clearable />
        </el-form-item>
        <el-form-item label="类型">
          <el-select v-model="searchForm.noticeType" placeholder="请选择类型" clearable>
            <el-option label="寻物启事" :value="1" />
            <el-option label="失物招领" :value="2" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.statusId" placeholder="请选择状态" clearable>
            <el-option label="已发布" :value="1" />
            <el-option label="待审核" :value="2" />
            <el-option label="已解决" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 数据表格 -->
      <el-table :data="tableData" border stripe style="width: 100%">
        <el-table-column prop="noticeId" label="ID" width="80" />
        <el-table-column prop="noticeTitle" label="标题" show-overflow-tooltip />
        <el-table-column prop="itemName" label="物品名称" />
        <el-table-column label="图片" width="100">
          <template #default="{ row }">
            <el-image
              v-if="row.imageUrl"
              :src="row.imageUrl"
              :preview-src-list="[row.imageUrl]"
              fit="cover"
              style="width: 60px; height: 60px; border-radius: 4px;"
            />
            <span v-else style="color: #999; font-size: 12px;">无图片</span>
          </template>
        </el-table-column>
        <el-table-column prop="userName" label="发布者" />
        <el-table-column prop="categoryName" label="分类" />
        <el-table-column prop="locationName" label="位置" />
        <el-table-column prop="noticeType" label="类型" width="100">
          <template #default="{ row }">
            <el-tag :type="row.noticeType === 1 ? 'warning' : 'success'">
              {{ row.noticeType === 1 ? '寻物启事' : '失物招领' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="statusName" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.statusId)">
              {{ row.statusName || getStatusText(row.statusId) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="viewCount" label="浏览量" width="100" />
        <el-table-column prop="createTime" label="发布时间" width="180" />
        <el-table-column label="发布类型" width="120" align="center">
          <template #default="{ row }">
            <el-tag :type="row.publishType === 'scheduled' ? 'warning' : 'success'" size="small">
              {{ row.publishType === 'scheduled' ? '定时发布' : '立即发布' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="定时发布时间" width="180" align="center">
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
              <el-button size="small" @click="handleView(row)">查看</el-button>
              <el-button size="small" @click="handleEdit(row)">编辑</el-button>
              <el-button size="small" type="danger" @click="handleDelete(row)">删除</el-button>
            </template>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
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
    <el-dialog v-if="isAdmin" v-model="dialogVisible" :title="dialogTitle" width="600px" @closed="handleDialogClosed">
      <el-form ref="formRef" :model="formData" :rules="formRules" label-width="100px">
        <el-form-item label="标题" prop="noticeTitle">
          <el-input v-model="formData.noticeTitle" placeholder="请输入标题" />
        </el-form-item>
        <el-form-item label="物品名称" prop="itemName">
          <el-input v-model="formData.itemName" placeholder="请输入物品名称" />
        </el-form-item>
        <el-form-item label="物品描述" prop="itemDesc">
          <el-input v-model="formData.itemDesc" type="textarea" :rows="3" placeholder="请输入物品描述" />
        </el-form-item>
        <el-form-item label="联系方式" prop="contactWay">
          <el-input v-model="formData.contactWay" placeholder="请输入联系方式" />
        </el-form-item>
        <el-form-item label="类型" prop="noticeType">
          <el-radio-group v-model="formData.noticeType">
            <el-radio :label="1">寻物启事</el-radio>
            <el-radio :label="2">失物招领</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="发布者" prop="userId">
          <el-select v-model="formData.userId" placeholder="请选择发布者" filterable>
            <el-option
              v-for="user in userList"
              :key="user.userId"
              :label="`${user.userName} (${user.userNo})`"
              :value="user.userId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="分类" prop="categoryId">
          <el-select v-model="formData.categoryId" placeholder="请选择分类">
            <el-option
              v-for="category in categoryList"
              :key="category.categoryId"
              :label="category.categoryName"
              :value="category.categoryId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="位置" prop="locationId">
          <el-select v-model="formData.locationId" placeholder="请选择位置">
            <el-option
              v-for="location in locationList"
              :key="location.locationId"
              :label="location.locationName"
              :value="location.locationId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="状态" prop="statusId">
          <el-select v-model="formData.statusId" placeholder="请选择状态">
            <el-option
              v-for="status in statusList"
              :key="status.statusId"
              :label="status.statusName"
              :value="status.statusId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="发布类型">
          <el-radio-group v-model="formData.publishType">
            <el-radio label="immediate">立即发布</el-radio>
            <el-radio label="scheduled">定时发布</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item v-if="formData.publishType === 'scheduled'" label="定时发布时间" prop="publishTime">
          <el-date-picker
            v-model="formData.publishTime"
            type="datetime"
            placeholder="请选择发布时间"
            format="YYYY-MM-DD HH:mm:ss"
            value-format="YYYY-MM-DDTHH:mm:ss"
            style="width: 100%"
          />
        </el-form-item>

        <!-- 图片上传 -->
        <el-form-item label="图片">
          <el-upload
            class="avatar-uploader"
            action="http://localhost:8080/api/notices/upload"
            :headers="uploadHeaders"
            :show-file-list="false"
            :on-success="handleUploadSuccess"
            :on-error="handleUploadError"
            :before-upload="beforeUpload"
          >
            <img v-if="formData.imageUrl" :src="formData.imageUrl" class="avatar" />
            <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
          </el-upload>
          <div style="font-size: 12px; color: #999; margin-top: 5px;">点击上传图片（支持 jpg/png，最大 2MB）</div>
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
import { getNotices, addNotice, updateNotice, deleteNotice } from '@/api/notice'
import { getUsers } from '@/api/user'
import { getCategories } from '@/api/category'
import { getLocations } from '@/api/location'
import { getStatuses } from '@/api/status'

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
const userList = ref([])
const categoryList = ref([])
const locationList = ref([])
const statusList = ref([])

const uploadHeaders = computed(() => ({
  Authorization: `Bearer ${localStorage.getItem('token')}`
}))

const searchForm = reactive({
  keyword: '',
  noticeType: null,
  statusId: null
})

const pagination = reactive({
  pageNum: 1,
  pageSize: 100,
  total: 0
})

const formData = reactive({
  noticeId: null,
  noticeTitle: '',
  noticeType: 1,
  userId: null,
  categoryId: null,
  locationId: null,
  itemName: '',
  itemDesc: '',
  contactWay: '',
  statusId: 1,
  imageUrl: '',
  publishType: 'immediate',
  publishTime: null
})

const formRules = {
  noticeTitle: [{ required: true, message: '请输入标题', trigger: 'blur' }],
  itemName: [{ required: true, message: '请输入物品名称', trigger: 'blur' }],
  userId: [{ required: true, message: '请选择发布者', trigger: 'change' }],
  categoryId: [{ required: true, message: '请选择分类', trigger: 'change' }],
  locationId: [{ required: true, message: '请选择位置', trigger: 'change' }],
  statusId: [{ required: true, message: '请选择状态', trigger: 'change' }],
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

const handleUploadSuccess = (response) => {
  if (response.code === 200) {
    formData.imageUrl = response.data
    ElMessage.success('图片上传成功')
  } else {
    ElMessage.error(response.message || '图片上传失败')
  }
}

const handleUploadError = (error) => {
  console.error('上传失败:', error)
  ElMessage.error('图片上传失败，请重试')
}

const beforeUpload = (file) => {
  const isImage = file.type === 'image/jpeg' || file.type === 'image/png'
  const isLt2M = file.size / 1024 / 1024 < 2

  if (!isImage) {
    ElMessage.error('只能上传 JPG/PNG 格式的图片')
    return false
  }
  if (!isLt2M) {
    ElMessage.error('图片大小不能超过 2MB')
    return false
  }
  return true
}

const fetchData = async () => {
  try {
    const res = await getNotices({
      pageNum: pagination.pageNum,
      pageSize: pagination.pageSize,
      keyword: searchForm.keyword,
      noticeType: searchForm.noticeType,
      statusId: searchForm.statusId
    })
    
    console.log('===== 招领列表响应 =====')
    console.log(res)
    
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

const fetchUserList = async () => {
  try {
    const res = await getUsers({ pageNum: 1, pageSize: 1000 })
    if (res && res.data && res.data.code === 200) {
      userList.value = res.data.data.records || []
    }
  } catch (error) {
    console.error('获取用户列表失败:', error)
  }
}

const fetchCategoryList = async () => {
  try {
    const res = await getCategories()
    if (res && res.data && res.data.code === 200) {
      categoryList.value = res.data.data || []
    }
  } catch (error) {
    console.error('获取分类列表失败:', error)
  }
}

const fetchLocationList = async () => {
  try {
    const res = await getLocations({ pageNum: 1, pageSize: 1000 })
    if (res && res.data && res.data.code === 200) {
      locationList.value = res.data.data.records || []
    }
  } catch (error) {
    console.error('获取位置列表失败:', error)
  }
}

const fetchStatusList = async () => {
  try {
    const res = await getStatuses({ page: 1, size: 1000 })
    if (res && res.data && res.data.code === 200) {
      statusList.value = res.data.data.list || []
    }
  } catch (error) {
    console.error('获取状态列表失败:', error)
  }
}

const handleSearch = () => {
  pagination.pageNum = 1
  fetchData()
}

const handleReset = () => {
  searchForm.keyword = ''
  searchForm.noticeType = null
  searchForm.statusId = null
  pagination.pageNum = 1
  fetchData()
}

const handleAdd = () => {
  if (!isAdmin.value) {
    ElMessage.warning('您没有权限执行此操作')
    return
  }
  
  dialogTitle.value = '新增招领信息'
  Object.assign(formData, {
    noticeId: null,
    noticeTitle: '',
    noticeType: 1,
    userId: null,
    categoryId: null,
    locationId: null,
    itemName: '',
    itemDesc: '',
    contactWay: '',
    statusId: 1,
    imageUrl: '',
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
  
  dialogTitle.value = '编辑招领信息'
  Object.assign(formData, {
    noticeId: row.noticeId,
    noticeTitle: row.noticeTitle,
    noticeType: row.noticeType || 1,
    userId: row.userId,
    categoryId: row.categoryId,
    locationId: row.locationId,
    itemName: row.itemName || '',
    itemDesc: row.itemDesc || '',
    contactWay: row.contactWay || '',
    statusId: row.statusId || 1,
    imageUrl: row.imageUrl || '',
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
    if (formData.noticeId) {
      res = await updateNotice(formData.noticeId, submitData)
    } else {
      res = await addNotice(submitData)
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

const handleView = (row) => {
  ElMessage.info(`查看招领信息 ID: ${row.noticeId}`)
}

const handleDelete = (row) => {
  if (!isAdmin.value) {
    ElMessage.warning('您没有权限执行此操作')
    return
  }
  
  ElMessageBox.confirm(`确定要删除「${row.noticeTitle}」吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const res = await deleteNotice(row.noticeId)
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

const getStatusType = (statusId) => {
  const typeMap = { 1: 'success', 2: 'warning', 3: 'info' }
  return typeMap[statusId] || 'info'
}

const getStatusText = (statusId) => {
  const textMap = { 1: '已发布', 2: '待审核', 3: '已解决' }
  return textMap[statusId] || '未知'
}

onMounted(() => {
  fetchData()
  fetchUserList()
  fetchCategoryList()
  fetchLocationList()
  fetchStatusList()
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

.avatar-uploader .avatar {
  width: 120px;
  height: 120px;
  display: block;
  object-fit: cover;
  border-radius: 8px;
  border: 1px solid #dcdfe6;
}

.avatar-uploader :deep(.el-upload) {
  border: 1px dashed #d9d9d9;
  border-radius: 8px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: all 0.3s;
}

.avatar-uploader :deep(.el-upload:hover) {
  border-color: #409EFF;
}

.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 120px;
  height: 120px;
  text-align: center;
  line-height: 120px;
}
</style>