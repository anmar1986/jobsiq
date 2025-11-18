<template>
  <div id="app" class="min-h-screen flex flex-col" :dir="localeStore.direction">
    <AppHeader />
    <main class="flex-1">
      <RouterView :key="$route.fullPath" />
    </main>
    <AppFooter />
    <ToastContainer />
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { RouterView, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useLocaleStore } from '@/stores/locale'
import { useRTL } from '@/composables/useRTL'
import AppHeader from '@/components/layout/AppHeader.vue'
import AppFooter from '@/components/layout/AppFooter.vue'
import ToastContainer from '@/components/base/ToastContainer.vue'

const $route = useRoute()
const authStore = useAuthStore()
const localeStore = useLocaleStore()

// Initialize RTL support
useRTL()

// SEO meta tags are initialized per-route in useSEO composable
// useSEO() is called automatically on route changes

onMounted(() => {
  // Initialize auth state from localStorage
  authStore.initializeAuth()
  
  // Locale initialization is handled by the router guard to avoid race conditions
})
</script>
