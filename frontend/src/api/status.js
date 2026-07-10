import request from '@/utils/request'

export function getStatuses(params) {
  return request({
    url: 'statuses',
    method: 'get',
    params
  })
}

export function getStatusById(id) {
  return request({
    url: `statuses/${id}`,
    method: 'get'
  })
}

export function addStatus(data) {
  return request({
    url: 'statuses',
    method: 'post',
    data
  })
}

export function updateStatus(id, data) {
  return request({
    url: `statuses/${id}`,
    method: 'put',
    data
  })
}

export function deleteStatus(id) {
  return request({
    url: `statuses/${id}`,
    method: 'delete'
  })
}