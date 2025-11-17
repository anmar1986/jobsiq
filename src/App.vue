<template>
  <div id="app" class="min-h-screen flex flex-col">
    <AppHeader />
    <main class="flex-1">
      <RouterView />
    </main>
    <AppFooter />
    <ToastContainer />
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { RouterView } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useRTL } from '@/composables/useRTL'
import AppHeader from '@/components/layout/AppHeader.vue'
import AppFooter from '@/components/layout/AppFooter.vue'
import ToastContainer from '@/components/base/ToastContainer.vue'

const authStore = useAuthStore()

// Initialize RTL support
useRTL()

onMounted(() => {
  // Initialize auth state from localStorage
  authStore.initializeAuth()
})
</script>
