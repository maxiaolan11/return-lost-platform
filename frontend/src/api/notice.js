// src/api/notice.js
import request from '@/utils/request'

// 获取招领列表
export function getNotices(params) {
  return request({
    url: '/notices',
    method: 'get',
    params
  })
}

// 获取招领详情
export function getNoticeById(id) {
  return request({
    url: `/notices/${id}`,
    method: 'get'
  })
}

// 新增招领
export function addNotice(data) {
  return request({
    url: '/notices',
    method: 'post',
    data
  })
}

// 更新招领
export function updateNotice(id, data) {
  return request({
    url: `/notices/${id}`,
    method: 'put',
    data
  })
}

// 删除招领
export function deleteNotice(id) {
  return request({
    url: `/notices/${id}`,
    method: 'delete'
  })
}

// 置顶/取消置顶
export function toggleTopNotice(id, isTop) {
  return request({
    url: `/notices/${id}/top`,
    method: 'put',
    data: { isTop }
  })
}

// 获取分类列表
export function getCategories() {
  return request({
    url: '/categories',
    method: 'get'
  })
}

// 获取位置列表
export function getLocations() {
  return request({
    url: '/locations',
    method: 'get'
  })
}