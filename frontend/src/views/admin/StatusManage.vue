<template>
  <div class="status-manage">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>状态管理</span>
          <el-button v-if="isAdmin" type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon> 新增状态
          </el-button>
        </div>
      </template>

      <!-- 搜索栏 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="关键词">
          <el-input
            v-model="searchForm.keyword"
            placeholder="请输入状态名称或描述"
            clearable
            @keyup.enter="handleSearch"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 数据表格 -->
      <el-table
        :data="tableData"
        border
        stripe
        style="width: 100%"
        v-loading="loading"
      >
        <el-table-column prop="statusId" label="ID" width="80" sortable />
        <el-table-column prop="statusName" label="状态名称" min-width="120" />
        <el-table-column prop="statusCode" label="状态编码" min-width="120" />
        <el-table-column prop="statusDesc" label="描述" min-width="150" show-overflow-tooltip />
        <el-table-column prop="sort" label="排序" width="80" align="center" />
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
        <el-table-column prop="createTime" label="创建时间" width="180" align="center">
          <template #default="{ row }">
            {{ formatDate(row.createTime) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150" fixed="right" align="center">
          <template #default="{ row }">
            <template v-if="isAdmin">
              <el-button size="small" type="primary" link @click="handleEdit(row)">编辑</el-button>
              <el-button size="small" type="danger" link @click="handleDelete(row)">删除</el-button>
            </template>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-wrapper">
        <el-pagination
          v-model:current-page="pagination.page"
          v-model:page-size="pagination.size"
          :total="pagination.total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next"
          @size-change="onPageSizeChange"
          @current-change="onPageChange"
          background
        />
        <span class="page-info">
          共 {{ pagination.total }} 条，第 {{ pagination.page }} / {{ totalPages }} 页
        </span>
      </div>
    </el-card>

    <!-- 新增/编辑对话框 -->
    <el-dialog
      v-if="isAdmin"
      v-model="dialogVisible"
      :title="dialogTitle"
      width="500px"
      @closed="handleDialogClosed"
    >
      <el-form ref="formRef" :model="formData" :rules="formRules" label-width="100px">
        <el-form-item label="状态名称" prop="statusName">
          <el-input v-model="formData.statusName" placeholder="请输入状态名称" />
        </el-form-item>
        <el-form-item label="状态编码" prop="statusCode">
          <el-input v-model="formData.statusCode" placeholder="请输入状态编码" />
        </el-form-item>
        <el-form-item label="描述" prop="statusDesc">
          <el-input v-model="formData.statusDesc" type="textarea" :rows="3" placeholder="请输入描述" />
        </el-form-item>
        <el-form-item label="排序" prop="sort">
          <el-input-number v-model="formData.sort" :min="0" :max="999" controls-position="right" />
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
        <el-button type="primary" @click="handleSubmit" :loading="submitLoading">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import { getStatuses, addStatus, updateStatus, deleteStatus } from '@/api/status'

// ==================== 用户权限 ====================
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

// ==================== 数据 ====================
const tableData = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)
const loading = ref(false)
const submitLoading = ref(false)

const searchForm = reactive({
  keyword: ''
})

const pagination = reactive({
  page: 1,
  size: 10,
  total: 0
})

const formData = reactive({
  statusId: null,
  statusName: '',
  statusCode: '',
  statusDesc: '',
  sort: 0,
  publishType: 'immediate',
  publishTime: null
})

const formRules = {
  statusName: [{ required: true, message: '请输入状态名称', trigger: 'blur' }],
  statusCode: [{ required: true, message: '请输入状态编码', trigger: 'blur' }]
}

// ==================== 计算属性 ====================
const totalPages = computed(() => {
  return Math.ceil(pagination.total / pagination.size) || 1
})

// ==================== 工具方法 ====================
const formatDate = (date) => {
  if (!date) return '-'
  try {
    const d = new Date(date)
    return d.toLocaleString('zh-CN', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit'
    })
  } catch {
    return date
  }
}

// ==================== 数据获取 ====================
const fetchData = async () => {
  loading.value = true
  try {
    const res = await getStatuses({
      page: pagination.page,
      size: pagination.size,
      keyword: searchForm.keyword
    })

    console.log('状态列表响应:', res)

    if (res && res.data && res.data.code === 200) {
      const data = res.data.data || {}
      tableData.value = data.list || data.records || []
      pagination.total = data.total || 0
    } else {
      ElMessage.error(res?.data?.message || '获取数据失败')
    }
  } catch (error) {
    console.error(error)
    ElMessage.error('获取数据失败')
  } finally {
    loading.value = false
  }
}

// ==================== 分页 ====================
const onPageChange = (page) => {
  console.log('📄 切换到第 ' + page + ' 页')
  pagination.page = page
  setTimeout(() => {
    fetchData()
  }, 300)
}

const onPageSizeChange = (size) => {
  console.log('📄 每页显示 ' + size + ' 条')
  pagination.size = size
  pagination.page = 1
  setTimeout(() => {
    fetchData()
  }, 300)
}

// ==================== 搜索/重置 ====================
const handleSearch = () => {
  pagination.page = 1
  setTimeout(() => {
    fetchData()
  }, 300)
}

const handleReset = () => {
  searchForm.keyword = ''
  pagination.page = 1
  setTimeout(() => {
    fetchData()
  }, 300)
}

// ==================== 新增 ====================
const handleAdd = () => {
  if (!isAdmin.value) {
    ElMessage.warning('您没有权限执行此操作')
    return
  }

  dialogTitle.value = '新增状态'
  Object.assign(formData, {
    statusId: null,
    statusName: '',
    statusCode: '',
    statusDesc: '',
    sort: 0,
    publishType: 'immediate',
    publishTime: null
  })
  dialogVisible.value = true
}

// ==================== 编辑 ====================
const handleEdit = (row) => {
  if (!isAdmin.value) {
    ElMessage.warning('您没有权限执行此操作')
    return
  }

  dialogTitle.value = '编辑状态'
  Object.assign(formData, {
    statusId: row.statusId,
    statusName: row.statusName,
    statusCode: row.statusCode,
    statusDesc: row.statusDesc || '',
    sort: row.sort || 0,
    publishType: row.publishType || 'immediate',
    publishTime: row.publishTime || null
  })
  dialogVisible.value = true
}

// ==================== 提交表单 ====================
const handleSubmit = async () => {
  try {
    await formRef.value.validate()
  } catch {
    return
  }

  if (formData.publishType === 'scheduled' && !formData.publishTime) {
    ElMessage.warning('请选择发布时间')
    return
  }

  submitLoading.value = true
  try {
    let res
    const submitData = { ...formData }
    if (submitData.publishType === 'immediate') {
      submitData.publishTime = null
    }

    if (formData.statusId) {
      res = await updateStatus(formData.statusId, submitData)
    } else {
      res = await addStatus(submitData)
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
    ElMessage.error('操作失败')
  } finally {
    submitLoading.value = false
  }
}

// ==================== 对话框关闭 ====================
const handleDialogClosed = () => {
  formRef.value?.resetFields()
}

// ==================== 单条删除 ====================
const handleDelete = (row) => {
  if (!isAdmin.value) {
    ElMessage.warning('您没有权限执行此操作')
    return
  }

  ElMessageBox.confirm(`确定要删除「${row.statusName}」吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const res = await deleteStatus(row.statusId)
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

// ==================== 生命周期 ====================
onMounted(() => {
  fetchData()
})
</script>

<style scoped>
.status-manage {
  padding: 4px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-form {
  margin-bottom: 20px;
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 4px;
}

.search-form .el-form-item {
  margin-bottom: 0;
}

.pagination-wrapper {
  margin-top: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.page-info {
  font-size: 14px;
  color: #909399;
}

@media (max-width: 768px) {
  .search-form {
    flex-direction: column;
    align-items: stretch;
  }
  .search-form .el-form-item {
    width: 100%;
  }
  .search-form .el-input {
    width: 100% !important;
  }
  .pagination-wrapper {
    flex-direction: column;
    gap: 10px;
  }
}
</style>