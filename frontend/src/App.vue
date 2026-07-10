<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script setup>
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

#app {
  font-family: 'Helvetica Neue', Helvetica, 'PingFang SC', 'Hiragino Sans GB',
    'Microsoft YaHei', Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  width: 100%;
  height: 100vh;
}

/* ===== 新增：让所有管理页面全屏 ===== */

/* 1. 覆盖 Element Plus 的 main 内边距 */
.el-main {
  padding: 0 !important;
}

/* 2. 去掉卡片圆角和边距 */
.el-card {
  border-radius: 0 !important;
  margin: 0 !important;
  box-shadow: none !important;
}

/* 3. 卡片内容保留一点内边距 */
.el-card__body {
  padding: 20px !important;
}

/* 4. 所有管理页面的容器占满 */
[class*="Manage"],
.dashboard-content,
.location-manage,
.notice-manage,
.category-manage,
.status-manage,
.user-manage {
  width: 100%;
  height: 100%;
  min-height: 100%;
  padding: 0 !important;
  margin: 0 !important;
  background: #f0f2f5;
}
</style>