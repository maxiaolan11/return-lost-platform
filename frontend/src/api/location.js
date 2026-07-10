// src/api/location.js
import request from '@/utils/request'

export function getLocations(params) {
  return request({
    url: '/locations',  // ✅ 去掉 /api
    method: 'get',
    params
  })
}

export function addLocation(data) {
  return request({
    url: '/locations',  // ✅ 去掉 /api
    method: 'post',
    data
  })
}

export function updateLocation(id, data) {
  return request({
    url: `/locations/${id}`,  // ✅ 去掉 /api
    method: 'put',
    data
  })
}

export function deleteLocation(id) {
  return request({
    url: `/locations/${id}`,  // ✅ 去掉 /api
    method: 'delete'
  })
}