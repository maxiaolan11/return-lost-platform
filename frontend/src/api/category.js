// src/api/category.js
import request from '@/utils/request'

export function getCategories(params) {
  return request({
    url: '/categories',  // ✅ 去掉 /api
    method: 'get',
    params
  })
}

export function addCategory(data) {
  return request({
    url: '/categories',  // ✅ 去掉 /api
    method: 'post',
    data
  })
}

export function updateCategory(id, data) {
  return request({
    url: `/categories/${id}`,  // ✅ 去掉 /api
    method: 'put',
    data
  })
}

export function deleteCategory(id) {
  return request({
    url: `/categories/${id}`,  // ✅ 去掉 /api
    method: 'delete'
  })
}