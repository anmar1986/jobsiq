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
import { useSEO } from '@/composables/useSEO'
import AppHeader from '@/components/layout/AppHeader.vue'
import AppFooter from '@/components/layout/AppFooter.vue'
import ToastContainer from '@/components/base/ToastContainer.vue'

const $route = useRoute()
const authStore = useAuthStore()
const localeStore = useLocaleStore()

// Initialize RTL support
useRTL()

// Initialize SEO meta tags
useSEO()

onMounted(() => {
  // Initialize auth state from localStorage
  authStore.initializeAuth()
  
  // Initialize locale
  localeStore.initializeLocale()
})
</script>
