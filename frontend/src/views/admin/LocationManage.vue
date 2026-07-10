<template>
  <div class="location-manage">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>位置管理</span>
          <el-button v-if="isAdmin" type="primary" @click="handleAdd">新增位置</el-button>
        </div>
      </template>

      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="关键词">
          <el-input v-model="searchForm.keyword" placeholder="请输入位置名称或描述" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>

      <el-table :data="tableData" border stripe style="width: 100%">
        <el-table-column prop="locationId" label="ID" width="80" />
        <el-table-column prop="locationName" label="位置名称" />
        <el-table-column prop="locationType" label="地点类型" width="120">
          <template #default="{ row }">
            <el-tag v-if="row.locationType" size="small">{{ row.locationType }}</el-tag>
            <span v-else style="color: #999;">-</span>
          </template>
        </el-table-column>
        <el-table-column prop="campusArea" label="校区" width="120">
          <template #default="{ row }">
            <el-tag v-if="row.campusArea" type="success" size="small">{{ row.campusArea }}</el-tag>
            <span v-else style="color: #999;">-</span>
          </template>
        </el-table-column>
        <el-table-column prop="isCommon" label="常用地点" width="100" align="center">
          <template #default="{ row }">
            <el-tag v-if="row.isCommon" type="warning" size="small">是</el-tag>
            <el-tag v-else type="info" size="small">否</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="locationDesc" label="描述" show-overflow-tooltip />
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

    <el-dialog v-if="isAdmin" v-model="dialogVisible" :title="dialogTitle" width="600px" @closed="handleDialogClosed">
      <el-form ref="formRef" :model="formData" :rules="formRules" label-width="100px">
        <el-form-item label="位置名称" prop="locationName">
          <el-input v-model="formData.locationName" placeholder="请输入位置名称，如：一教101教室" />
        </el-form-item>
        
        <el-form-item label="地点类型" prop="locationType">
          <el-select v-model="formData.locationType" placeholder="请选择地点类型" style="width: 100%">
            <el-option label="教学楼" value="教学楼" />
            <el-option label="图书馆" value="图书馆" />
            <el-option label="食堂" value="食堂" />
            <el-option label="宿舍" value="宿舍" />
            <el-option label="操场" value="操场" />
            <el-option label="体育馆" value="体育馆" />
            <el-option label="其他" value="其他" />
          </el-select>
        </el-form-item>
        
        <el-form-item label="校区" prop="campusArea">
          <el-select v-model="formData.campusArea" placeholder="请选择校区" style="width: 100%">
            <el-option label="本部" value="本部" />
            <el-option label="东校区" value="东校区" />
            <el-option label="西校区" value="西校区" />
            <el-option label="南校区" value="南校区" />
          </el-select>
        </el-form-item>
        
        <el-form-item label="是否常用地点">
          <el-radio-group v-model="formData.isCommon">
            <el-radio :label="true">是</el-radio>
            <el-radio :label="false">否</el-radio>
          </el-radio-group>
        </el-form-item>
        
        <el-form-item label="描述" prop="locationDesc">
          <el-input v-model="formData.locationDesc" type="textarea" :rows="3" placeholder="请输入描述" />
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
import { getLocations, addLocation, updateLocation, deleteLocation } from '@/api/location'

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
  keyword: ''
})

const pagination = reactive({
  pageNum: 1,
  pageSize: 10,
  total: 0
})

const formData = reactive({
  locationId: null,
  locationName: '',
  locationType: '',
  campusArea: '',
  isCommon: false,
  locationDesc: '',
  publishType: 'immediate',
  publishTime: null
})

const formRules = {
  locationName: [{ required: true, message: '请输入位置名称', trigger: 'blur' }],
  locationType: [{ required: true, message: '请选择地点类型', trigger: 'change' }],
  campusArea: [{ required: true, message: '请选择校区', trigger: 'change' }],
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
    const res = await getLocations({
      pageNum: pagination.pageNum,
      pageSize: pagination.pageSize,
      keyword: searchForm.keyword
    })
    
    console.log('位置列表响应:', res)
    
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
  pagination.pageNum = 1
  fetchData()
}

const handleAdd = () => {
  if (!isAdmin.value) {
    ElMessage.warning('您没有权限执行此操作')
    return
  }
  
  dialogTitle.value = '新增位置'
  Object.assign(formData, {
    locationId: null,
    locationName: '',
    locationType: '',
    campusArea: '',
    isCommon: false,
    locationDesc: '',
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
  
  dialogTitle.value = '编辑位置'
  Object.assign(formData, {
    locationId: row.locationId,
    locationName: row.locationName,
    locationType: row.locationType || '',
    campusArea: row.campusArea || '',
    isCommon: row.isCommon !== undefined ? row.isCommon : false,
    locationDesc: row.locationDesc || '',
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
    if (formData.locationId) {
      res = await updateLocation(formData.locationId, submitData)
    } else {
      res = await addLocation(submitData)
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
  
  ElMessageBox.confirm(`确定要删除「${row.locationName}」吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const res = await deleteLocation(row.locationId)
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