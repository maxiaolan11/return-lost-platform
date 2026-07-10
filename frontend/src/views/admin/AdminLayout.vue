<template>
  <div class="admin-layout">
    <el-aside width="200px" class="sidebar">
      <div class="logo">
        <h2>校园失物招领</h2>
      </div>
      
      <el-menu
        :default-active="activeMenu"
        router
        background-color="#304156"
        text-color="#bfcbd9"
        active-text-color="#409EFF"
      >
        <el-menu-item index="/admin/dashboard">
          <el-icon><Odometer /></el-icon>
          <span>仪表盘</span>
        </el-menu-item>
        
        <el-menu-item index="/admin/notices">
          <el-icon><Document /></el-icon>
          <span>招领管理</span>
        </el-menu-item>
        
        <el-menu-item index="/admin/categories">
          <el-icon><Folder /></el-icon>
          <span>分类管理</span>
        </el-menu-item>
        
        <el-menu-item index="/admin/statuses">
          <el-icon><Flag /></el-icon>
          <span>状态管理</span>
        </el-menu-item>
        
        <el-menu-item index="/admin/users">
          <el-icon><User /></el-icon>
          <span>用户管理</span>
        </el-menu-item>
        
        <el-menu-item index="/admin/locations">
          <el-icon><Location /></el-icon>
          <span>位置管理</span>
        </el-menu-item>
      </el-menu>
    </el-aside>

    <el-container>
      <el-header class="header">
        <div class="header-left">
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/admin/dashboard' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>{{ currentRoute.meta.title || '页面' }}</el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        
        <div class="header-right">
          <el-dropdown @command="handleCommand">
            <span class="user-info">
              <el-avatar :size="32" :src="userAvatar" />
              <span class="username">{{ username }}</span>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <!-- ⭐ 个人中心改为首页 -->
                <el-dropdown-item command="home">
                  <el-icon><House /></el-icon> 首页
                </el-dropdown-item>
                <el-dropdown-item divided command="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>

      <el-main class="main-content">
        <router-view />
      </el-main>
    </el-container>
  </div>
</template>

<script setup>
import { computed, ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessageBox } from 'element-plus'
import { Odometer, Document, Folder, Flag, User, Location, House } from '@element-plus/icons-vue'

const router = useRouter()
const route = useRoute()

const userInfo = ref({
  userName: '',
  username: '',
  avatar: '',
  role: ''
})

const username = computed(() => {
  return userInfo.value.userName || userInfo.value.username || '管理员'
})

const userAvatar = computed(() => {
  return userInfo.value.avatar || 'https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png'
})

const activeMenu = computed(() => route.path)
const currentRoute = computed(() => route)

onMounted(() => {
  const userStr = localStorage.getItem('user') || sessionStorage.getItem('user')
  if (userStr) {
    try {
      const parsed = JSON.parse(userStr)
      userInfo.value = {
        userName: parsed.userName || parsed.username || '',
        username: parsed.username || parsed.userName || '',
        avatar: parsed.avatar || '',
        role: parsed.role || ''
      }
      console.log('[AdminLayout] 用户信息:', userInfo.value)
    } catch (error) {
      console.error('[AdminLayout] 解析用户信息失败:', error)
    }
  }
})

// ⭐ 处理下拉菜单点击
const handleCommand = (command) => {
  if (command === 'home') {
    router.push('/home')
  } else if (command === 'logout') {
    handleLogout()
  }
}

const handleLogout = async () => {
  try {
    await ElMessageBox.confirm('确定要退出登录吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    localStorage.removeItem('token')
    sessionStorage.removeItem('token')
    localStorage.removeItem('user')
    sessionStorage.removeItem('user')
    router.push('/login')
  } catch (error) {
    console.log('取消退出')
  }
}
</script>

<style scoped>
.admin-layout {
  display: flex;
  height: 100vh;
  width: 100%;
}

.sidebar {
  background-color: #304156;
  color: #fff;
  overflow-y: auto;
  flex-shrink: 0;
}

.logo {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #2b3a4a;
}

.logo h2 {
  margin: 0;
  font-size: 18px;
  color: #fff;
  white-space: nowrap;
}

.el-menu {
  border-right: none;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #fff;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
  padding: 0 20px;
  height: 60px;
}

.header-left {
  display: flex;
  align-items: center;
}

.header-right {
  display: flex;
  align-items: center;
}

.user-info {
  display: flex;
  align-items: center;
  cursor: pointer;
}

.username {
  margin-left: 8px;
  font-size: 14px;
  color: #333;
}

.main-content {
  background-color: #f0f2f5;
  padding: 0 !important;
  margin: 0;
  width: 100%;
  overflow: auto;
  height: calc(100vh - 60px);
}

.main-content::-webkit-scrollbar {
  width: 6px;
}

.main-content::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 3px;
}

.main-content::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}

@media screen and (max-width: 768px) {
  .sidebar {
    width: 60px !important;
  }
  
  .logo h2 {
    font-size: 12px;
  }
  
  .el-menu-item span {
    display: none;
  }
}
</style>