import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { login as apiLogin, logout as apiLogout, getCurrentUser } from '@/api/auth'
import router from '@/router'
import { ElMessage } from 'element-plus'

export const useUserStore = defineStore('user', () => {
  const token = ref(localStorage.getItem('token') || '')
  const userInfo = ref(JSON.parse(localStorage.getItem('user') || '{}'))
  
  const isLoggedIn = computed(() => !!token.value)
  const isAdmin = computed(() => userInfo.value.role === 'admin')
  
  function setToken(newToken) {
    token.value = newToken
    if (newToken) {
      localStorage.setItem('token', newToken)
    } else {
      localStorage.removeItem('token')
    }
  }
  
  function setUserInfo(info) {
    userInfo.value = info
    if (info && Object.keys(info).length > 0) {
      localStorage.setItem('user', JSON.stringify(info))
    } else {
      localStorage.removeItem('user')
    }
  }
  
  // ✅ 新增：登录方法
  const loginUser = async (loginData) => {
    try {
      const res = await apiLogin(loginData)
      console.log('登录响应:', res)
      
      // ✅ 修复：处理后端返回的标准格式 { code, message, data: { token, user } }
      if (!res || res.code !== 200) {
        throw new Error(res.message || '登录失败')
      }
      
      // 从 data 中提取 token 和 user
      const { token, user } = res.data || {}
      
      if (!token || !user) {
        throw new Error('响应数据格式错误')
      }
      
      // 保存 token 和用户信息
      setToken(token)
      setUserInfo(user)
      
      ElMessage.success('登录成功')
      return true
    } catch (error) {
      console.error('登录失败:', error)
      ElMessage.error(error.message || '登录失败')
      return false
    }
  }
  
  const getUserInfo = async () => {
    if (!token.value) return null
    try {
      const res = await getCurrentUser()
      // ✅ 修复：现在 res 是完整响应对象，用户信息在 res.data 中（假设其他接口有 data 字段）
      // 如果后端其他接口也使用相同结构，请根据实际情况调整
      userInfo.value = res.data || res.user || res
      return userInfo.value
    } catch (error) {
      // ✅ 修复：使用 logout 方法而不是未定义的 logoutUser
      await logout()
      return null
    }
  }
  
  async function logout() {
    try {
      await apiLogout()
    } catch (error) {
      console.error('退出登录失败:', error)
    } finally {
      setToken('')
      setUserInfo({})
      ElMessage.success('退出成功')
      router.push('/login')
    }
  }
  
  function clearAuth() {
    setToken('')
    setUserInfo({})
  }
  
  return {
    token,
    userInfo,
    isLoggedIn,
    isAdmin,
    setToken,
    setUserInfo,
    loginUser,      // ✅ 新增：导出 loginUser 方法
    getUserInfo,
    logout,
    clearAuth
  }
})

