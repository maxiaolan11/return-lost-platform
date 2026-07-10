// src/api/comment.js
import request from '@/utils/request'

// 获取招领的评论列表
export function getCommentsByNotice(noticeId, pageNum = 1, pageSize = 10) {
  return request({
    url: `/comments/notice/${noticeId}`,
    method: 'get',
    params: { pageNum, pageSize }
  })
}

// 新增评论
export function addComment(data) {
  return request({
    url: '/comments',
    method: 'post',
    data
  })
}

// 删除评论
export function deleteComment(commentId) {
  return request({
    url: `/comments/${commentId}`,
    method: 'delete'
  })
}