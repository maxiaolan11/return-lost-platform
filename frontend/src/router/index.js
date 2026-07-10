import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue'),
    meta: { 
      title: '登录'
    }
  },
  {
    path: '/admin',
    name: 'AdminLayout',
    component: () => import('@/views/admin/AdminLayout.vue'),
    redirect: '/admin/dashboard',
    meta: { 
      roles: ['admin', 'user']
    },
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('@/views/admin/Dashboard.vue'),
        meta: { 
          title: '仪表盘',
          roles: ['admin']
        }
      },
      {
        path: 'notices',
        name: 'NoticeManage',
        component: () => import('@/views/admin/NoticeManage.vue'),
        meta: { 
          title: '招领管理',
          roles: ['admin', 'user']
        }
      },
      {
        path: 'categories',
        name: 'CategoryManage',
        component: () => import('@/views/admin/CategoryManage.vue'),
        meta: { 
          title: '分类管理',
          roles: ['admin']
        }
      },
      {
        path: 'statuses',
        name: 'StatusManage',
        component: () => import('@/views/admin/StatusManage.vue'),
        meta: { 
          title: '状态管理',
          roles: ['admin', 'user']
        }
      },
      {
        path: 'users',
        name: 'UserManager',
        component: () => import('@/views/admin/UserManager.vue'),
        meta: { 
          title: '用户管理',
          roles: ['admin']
        }
      },
      {
        path: 'locations',
        name: 'LocationManage',
        component: () => import('@/views/admin/LocationManage.vue'),
        meta: { 
          title: '位置管理',
          roles: ['admin']
        }
      }
    ]
  },
  {
    path: '/home',
    name: 'Home',
    component: () => import('@/views/Home.vue'),
    meta: { 
      title: '首页',
      roles: ['admin', 'user']
    }
  },
  {
    path: '/403',
    name: 'Forbidden',
    component: () => import('@/views/error/403.vue'),
    meta: { 
      title: '无权限'
    }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from) => {
  const token = localStorage.getItem('token') || sessionStorage.getItem('token')
  
  console.log(`\n[路由守卫] ====================`)
  console.log(`[路由守卫] 从: ${from.path}`)
  console.log(`[路由守卫] 到: ${to.path}`)
  console.log(`[路由守卫] Token: ${token ? '存在' : '不存在'}`)
  console.log(`[路由守卫] to.meta.roles:`, to.meta.roles)
  
  if (to.meta.title) {
    document.title = `${to.meta.title} - 校园失物招领系统`
  }
  
  // ✅ 登录页特殊处理
  if (to.path === '/login') {
    console.log('[路由守卫] >>> 访问登录页')
    if (token) {
      console.log('[路由守卫] >>> 有 token，重定向到 /home')
      return '/home'
    }
    console.log('[路由守卫] >>> 无 token，允许访问')
    return true
  }
  
  // ✅ 根路径重定向
  if (to.path === '/') {
    console.log('[路由守卫] >>> 访问根路径')
    if (!token) {
      console.log('[路由守卫] >>> 无 token，重定向到 /login')
      return '/login'
    }
    
    console.log('[路由守卫] >>> 有 token，重定向到 /home')
    return '/home'
  }
  
  // ✅ 角色权限检查（所有需要权限的页面都配置了 roles）
  if (to.meta.roles && to.meta.roles.length > 0) {
    console.log('[路由守卫] >>> 进行角色权限检查')
    const userStr = localStorage.getItem('user') || sessionStorage.getItem('user')
    
    if (!userStr) {
      console.warn('[路由守卫] >>>  无用户信息，清除 token 并跳转到 /login')
      localStorage.removeItem('token')
      sessionStorage.removeItem('token')
      return '/login'
    }
    
    try {
      const user = JSON.parse(userStr)
      console.log('[路由守卫] >>> 当前用户角色:', user.role)
      console.log('[路由守卫] >>> 需要的角色:', to.meta.roles)
      
      if (!to.meta.roles.includes(user.role)) {
        console.warn(`[路由守卫] >>> ✗ 角色不匹配，重定向到 /403`)
        return '/403'
      }
      console.log('[路由守卫] >>> ✓ 角色验证通过')
    } catch (error) {
      console.error('[路由守卫] >>> ✗ 解析用户信息失败:', error)
      return '/login'
    }
  } else {
    console.log('[路由守卫] >>> 无需角色权限检查')
  }
  
  console.log('[路由守卫] >>> ✓ 允许访问')
  console.log('[路由守卫] ====================\n')
  return true
})

router.afterEach((to, from) => {
  console.log(`路由跳转: ${from.path} -> ${to.path}`)
})

export default router