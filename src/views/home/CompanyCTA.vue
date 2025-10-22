<template>
  <section v-if="isAuthenticated" class="bg-gradient-to-r from-primary-600 to-secondary-600 border-b border-primary-700">
    <div class="container-custom py-8">
      <div class="flex flex-col md:flex-row items-center justify-between gap-4">
        <div class="text-white text-center md:text-left">
          <h3 class="text-2xl font-bold mb-2">Looking to Hire?</h3>
          <p class="text-primary-100">Manage your companies and post jobs to reach thousands of qualified candidates</p>
        </div>
        <router-link to="/my-companies" class="btn bg-white text-primary-600 hover:bg-gray-100 px-8 py-3 text-lg whitespace-nowrap">
          <svg class="h-5 w-5 mr-2 inline" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
          </svg>
          For Companies
        </router-link>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { useAuthStore } from '@/stores/auth'
import { computed } from 'vue'

const authStore = useAuthStore()
const isAuthenticated = computed(() => authStore.isAuthenticated)
</script>
