// src/utils/request.js
import axios from 'axios'

const request = axios.create({
  baseURL: 'http://localhost:8080/api',
  timeout: 10000
})

// 请求拦截器
request.interceptors.request.use(
  config => {
    const token = localStorage.getItem('token') || sessionStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
      console.log('[请求拦截器] URL:', config.url)
      console.log('[请求拦截器] Token 存在')
    } else {
      console.warn('[请求拦截器] ⚠️ 无 Token - URL:', config.url)
    }
    return config
  },
  error => Promise.reject(error)
)

// ✅ 响应拦截器 - 返回完整响应
request.interceptors.response.use(
  response => {
    console.log('[API响应]', response.config.url, response.data)
    return response
  },
  error => {
    console.error('[API错误]', error)
    
    if (error.response?.status === 401) {
      console.warn('===== 收到 401 响应 =====')
      console.warn('请求URL:', error.config?.url)
      console.warn('Token:', localStorage.getItem('token') ? '存在' : '不存在')
      
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      sessionStorage.removeItem('token')
      sessionStorage.removeItem('user')
      
      setTimeout(() => {
        window.location.href = '/login'
      }, 500)
    }
    return Promise.reject(error)
  }
)

export default request