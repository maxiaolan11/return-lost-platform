// src/api/auth.js
import request from '@/utils/request'

/**
 * 用户登录
 */
export function login(data) {
  return request.post('/api/auth/login', data)
}

/**
 * 用户退出
 */
export function logout() {
  return request.post('/api/auth/logout')
}

/**
 * 获取当前用户信息
 */
export function getCurrentUser() {
  return request.get('/api/auth/current-user')
}
