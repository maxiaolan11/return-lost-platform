<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <h1>🏫 校园失物招领系统</h1>
        <p>登录您的账户</p>
      </div>

      <el-form
        ref="loginFormRef"
        :model="loginForm"
        :rules="loginRules"
        label-width="0"
        @submit.prevent="handleLogin"
      >
        <el-form-item prop="username">
          <el-input
            v-model="loginForm.username"
            placeholder="请输入用户名"
            size="large"
            prefix-icon="User"
            clearable
          />
        </el-form-item>

        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            type="password"
            placeholder="请输入密码"
            size="large"
            prefix-icon="Lock"
            show-password
          />
        </el-form-item>

        <el-form-item>
          <el-checkbox v-model="loginForm.remember">记住我</el-checkbox>
        </el-form-item>

        <el-form-item>
          <el-button
            type="primary"
            size="large"
            :loading="loading"
            style="width: 100%"
            @click="handleLogin"
          >
            {{ loading ? '登录中...' : '登 录' }}
          </el-button>
        </el-form-item>

        <div v-if="errorMsg" class="error-msg">
          <el-alert :title="errorMsg" type="error" :closable="false" />
        </div>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'

const router = useRouter()
const loginFormRef = ref(null)
const loading = ref(false)
const errorMsg = ref('')

const loginForm = reactive({
  username: 'admin',
  password: '123456',
  remember: true
})

const loginRules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
}

const handleLogin = async () => {
  if (!loginFormRef.value) return

  try {
    await loginFormRef.value.validate()
  } catch {
    return
  }

  loading.value = true
  errorMsg.value = ''

  try {
    const res = await fetch('http://localhost:8080/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        username: loginForm.username,
        password: loginForm.password
      })
    })

    const data = await res.json()
    console.log('===== 登录响应 =====')
    console.log(data)
    console.log('===================')

    if (data.code === 200) {
      const token = data.data.token
      const user = data.data.user

      console.log('准备保存 Token:', token)
      console.log('准备保存 User:', user)

      // ✅ 同步保存到 localStorage
      localStorage.setItem('token', token)
      localStorage.setItem('user', JSON.stringify(user))
      
      // 如果勾选了记住我，也保存到 sessionStorage
      if (loginForm.remember) {
        sessionStorage.setItem('token', token)
        sessionStorage.setItem('user', JSON.stringify(user))
      }
      
      console.log('✓ 已保存到 localStorage')

      // ✅ 立即验证
      const savedToken = localStorage.getItem('token')
      const savedUser = localStorage.getItem('user')
      
      console.log('验证 - Token:', savedToken ? '存在' : '不存在')
      console.log('验证 - User:', savedUser ? '存在' : '不存在')

      if (savedToken && savedUser) {
        ElMessage.success('登录成功！')
        
        // ✅ 使用 router.push 而不是 window.location.href
        // 这样不会刷新页面，避免时序问题
        console.log('使用 router.push 跳转到 /home')
        router.push('/home').catch(err => {
          console.error('跳转失败:', err)
          // 如果 router.push 失败，再使用 window.location
          window.location.href = '/home'
        })
      } else {
        console.error('✗ 验证失败')
        errorMsg.value = '保存失败，请重试'
      }
    } else {
      errorMsg.value = data.message || '登录失败'
    }
  } catch (err) {
    console.error('登录错误:', err)
    errorMsg.value = '网络错误'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
.login-box {
  background: white;
  padding: 40px;
  border-radius: 12px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
  width: 100%;
  max-width: 400px;
}
.login-header {
  text-align: center;
  margin-bottom: 30px;
}
.login-header h1 {
  color: #333;
  font-size: 24px;
  margin-bottom: 8px;
}
.login-header p {
  color: #999;
  font-size: 14px;
  margin: 0;
}
.error-msg {
  margin-top: 15px;
}
:deep(.el-input__wrapper) {
  border-radius: 8px;
}
:deep(.el-button) {
  border-radius: 8px;
}
</style>