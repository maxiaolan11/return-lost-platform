<template>
  <div class="category-manage">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>分类管理</span>
          <el-button v-if="isAdmin" type="primary" @click="handleAdd">新增分类</el-button>
        </div>
      </template>

      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="分类名称">
          <el-input v-model="searchForm.categoryName" placeholder="请输入分类名称" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>

      <el-table :data="tableData" border stripe style="width: 100%">
        <el-table-column prop="categoryId" label="ID" width="80" />
        <el-table-column prop="categoryName" label="分类名称" />
        <el-table-column prop="categoryDesc" label="描述" show-overflow-tooltip />
        <el-table-column prop="sort" label="排序" width="80" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 'active' ? 'success' : 'info'">
              {{ row.status === 'active' ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
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
        <el-table-column prop="createTime" label="创建时间" width="180" />
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

    <el-dialog v-if="isAdmin" v-model="dialogVisible" :title="dialogTitle" width="500px" @closed="handleDialogClosed">
      <el-form ref="formRef" :model="formData" :rules="formRules" label-width="100px">
        <el-form-item label="分类名称" prop="categoryName">
          <el-input v-model="formData.categoryName" placeholder="请输入分类名称" />
        </el-form-item>
        <el-form-item label="描述" prop="categoryDesc">
          <el-input v-model="formData.categoryDesc" type="textarea" :rows="3" placeholder="请输入描述" />
        </el-form-item>
        <el-form-item label="排序" prop="sort">
          <el-input-number v-model="formData.sort" :min="0" :max="999" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="formData.status">
            <el-radio label="active">启用</el-radio>
            <el-radio label="inactive">禁用</el-radio>
          </el-radio-group>
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
import { getCategories, addCategory, updateCategory, deleteCategory } from '@/api/category'

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

const searchForm = reactive({
  categoryName: ''
})

const pagination = reactive({
  pageNum: 1,
  pageSize: 10,
  total: 0
})

const formData = reactive({
  categoryId: null,
  categoryName: '',
  categoryDesc: '',
  sort: 0,
  status: 'active',
  publishType: 'immediate',
  publishTime: null
})

const formRules = {
  categoryName: [{ required: true, message: '请输入分类名称', trigger: 'blur' }],
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

const fetchData = async () => {
  try {
    const res = await getCategories({
      categoryName: searchForm.categoryName
    })
    
    console.log('分类列表响应:', res)
    
    if (res && res.data && res.data.code === 200) {
      const data = res.data.data || []
      tableData.value = Array.isArray(data) ? data : []
      pagination.total = tableData.value.length
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
  searchForm.categoryName = ''
  pagination.pageNum = 1
  fetchData()
}

const handleAdd = () => {
  if (!isAdmin.value) {
    ElMessage.warning('您没有权限执行此操作')
    return
  }
  
  dialogTitle.value = '新增分类'
  Object.assign(formData, {
    categoryId: null,
    categoryName: '',
    categoryDesc: '',
    sort: 0,
    status: 'active',
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
  
  dialogTitle.value = '编辑分类'
  Object.assign(formData, {
    categoryId: row.categoryId,
    categoryName: row.categoryName,
    categoryDesc: row.categoryDesc || '',
    sort: row.sort || 0,
    status: row.status || 'active',
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
    if (formData.categoryId) {
      res = await updateCategory(formData.categoryId, submitData)
    } else {
      res = await addCategory(submitData)
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
  
  ElMessageBox.confirm(`确定要删除「${row.categoryName}」吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const res = await deleteCategory(row.categoryId)
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
</style>