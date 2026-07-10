<template>
  <div class="forbidden-container">
    <div class="forbidden-content">
      <h1>403</h1>
      <p>抱歉，您没有权限访问此页面</p>
      <el-button type="primary" @click="goBack">返回首页</el-button>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'

const router = useRouter()

const goBack = () => {
  router.push('/home')
}
</script>

<style scoped>
.forbidden-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: #f5f7fa;
}

.forbidden-content {
  text-align: center;
  padding: 40px;
}

.forbidden-content h1 {
  font-size: 120px;
  color: #e74c3c;
  margin: 0;
  line-height: 1;
}

.forbidden-content p {
  font-size: 24px;
  color: #666;
  margin: 20px 0 40px;
}
</style>
