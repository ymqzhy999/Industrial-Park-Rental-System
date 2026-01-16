import { createApp } from 'vue'
import App from './App.vue'
import router from './router'

// 1. 引入 Element Plus
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
// 引入中文语言包 (否则日历等组件会显示英文)
import zhCn from 'element-plus/es/locale/lang/zh-cn'
// 引入图标
import * as ElementPlusIconsVue from '@element-plus/icons-vue'


const app = createApp(App)

// 2. 注册图标
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

app.use(router)
// 3. 使用 Element Plus
app.use(ElementPlus, {
  locale: zhCn,
})

app.mount('#app')
