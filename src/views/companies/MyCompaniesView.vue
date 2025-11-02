<template>
  <div class="container-custom py-8">
    <!-- Loading State - Always show loading while checking for redirect -->
    <div v-if="loading" class="flex items-center justify-center py-12">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
    </div>

    <!-- Empty State - Only shown if user has no company -->
    <div v-else-if="!companies || companies.length === 0" class="text-center py-16">
      <svg class="h-24 w-24 mx-auto text-gray-400 mb-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
      </svg>
      <h2 class="text-2xl font-semibold text-gray-900 mb-2">No Companies Yet</h2>
      <p class="text-gray-600 mb-6">Create your first company to start posting jobs</p>
      <BaseButton
        variant="primary"
        @click="router.push({ name: 'create-company' })"
      >
        Create Your First Company
      </BaseButton>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useToast } from '@/composables/useToast'
import { companyService } from '@/services/cv.service'
import type { Company } from '@/types'
import BaseButton from '@/components/base/BaseButton.vue'

const router = useRouter()
const toast = useToast()

const loading = ref(true)
const companies = ref<Company[]>([])

const loadCompanies = async () => {
  loading.value = true
  try {
    const response = await companyService.getMyCompanies()
    
    if (response.success && response.data) {
      companies.value = response.data
      
      // If user has a company, redirect to company profile immediately
      if (companies.value.length > 0) {
        router.replace({ 
          name: 'view-my-company', 
          params: { slug: companies.value[0].slug } 
        })
        return
      }
    }
  } catch (error) {
    console.error('Failed to load companies:', error)
    const err = error as { response?: { data?: { message?: string } } }
    toast.error(err.response?.data?.message || 'Failed to load companies')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadCompanies()
})
</script>
