// src/api/user.js
import request from '@/utils/request'

export function getUsers(params) {
  return request({
    url: '/users/list',  // ✅ 去掉 /api
    method: 'get',
    params
  })
}

export function getUserById(id) {
  return request({
    url: `/users/${id}`,  // ✅ 去掉 /api
    method: 'get'
  })
}

export function addUser(data) {
  return request({
    url: '/users/add',  // ✅ 去掉 /api
    method: 'post',
    data
  })
}

export function updateUser(data) {
  return request({
    url: '/users/update',  // ✅ 去掉 /api
    method: 'put',
    data
  })
}

export function deleteUser(id) {
  return request({
    url: `/users/delete/${id}`,  // ✅ 去掉 /api
    method: 'delete'
  })
}