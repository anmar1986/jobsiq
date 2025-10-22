<template>
  <div class="bg-gray-50 min-h-screen">
    <!-- Page Header -->
    <div class="bg-white border-b border-gray-200">
      <div class="container-custom py-8">
        <h1 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Discover Top Companies</h1>
        <p class="text-lg text-gray-600">Browse leading companies hiring on JobsIQ</p>
      </div>
    </div>

    <!-- Search Bar -->
    <div class="bg-white border-b border-gray-200">
      <div class="container-custom py-4">
        <div class="flex gap-4">
          <BaseInput
            v-model="searchQuery"
            type="text"
            placeholder="Search companies..."
            size="md"
            show-clear-button
            class="flex-1"
            @keyup.enter="handleSearch"
          >
            <template #icon-left>
              <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </template>
          </BaseInput>
          <BaseButton variant="primary" size="md" @click="handleSearch">
            Search
          </BaseButton>
        </div>
      </div>
    </div>

    <!-- Companies Grid -->
    <div class="container-custom py-8">
      <!-- Loading State -->
      <div v-if="isLoading" class="text-center py-12">
        <div class="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
        <p class="mt-4 text-gray-600">Loading companies...</p>
      </div>

      <!-- Empty State -->
      <div v-else-if="companies.length === 0" class="text-center py-12">
        <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
        </svg>
        <h3 class="mt-4 text-lg font-medium text-gray-900">No companies found</h3>
        <p class="mt-2 text-gray-600">Try adjusting your search criteria</p>
      </div>

      <!-- Companies Grid -->
      <div v-else class="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <BaseCard
          v-for="company in companies"
          :key="company.id"
          hoverable
          clickable
          @click="$router.push(`/companies/${company.slug}`)"
        >
          <div class="p-6">
            <div class="w-20 h-20 bg-gradient-to-br from-primary-100 to-secondary-100 rounded-xl flex items-center justify-center mb-4">
              <span class="text-3xl font-bold text-primary-600">{{ company.name[0] }}</span>
            </div>
            
            <h3 class="text-xl font-semibold text-gray-900 mb-2">{{ company.name }}</h3>
            <p class="text-gray-600 text-sm mb-4 line-clamp-2">{{ company.description }}</p>
            
            <div v-if="company.city || company.country" class="flex items-center gap-4 text-sm text-gray-600 mb-4">
              <span class="flex items-center gap-1">
                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                </svg>
                {{ company.city }}{{ company.city && company.country ? ', ' : '' }}{{ company.country }}
              </span>
            </div>
            
            <div class="flex items-center justify-between pt-4 border-t border-gray-100">
              <span class="text-sm font-medium text-gray-900">{{ company.jobs_count || 0 }} open jobs</span>
              <BaseBadge v-if="company.industry" variant="primary" size="sm">{{ company.industry }}</BaseBadge>
            </div>
          </div>
        </BaseCard>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { companyService } from '@/services/cv.service'
import type { Company } from '@/types'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseBadge from '@/components/base/BaseBadge.vue'
import { useToast } from '@/composables/useToast'

const toast = useToast()
const searchQuery = ref('')
const companies = ref<Company[]>([])
const isLoading = ref(false)
const currentPage = ref(1)
const totalPages = ref(1)

const loadCompanies = async () => {
  isLoading.value = true
  try {
    const response = await companyService.getCompanies({
      search: searchQuery.value || undefined,
      page: currentPage.value,
      per_page: 12,
    })
    
    if (response.success && response.data) {
      companies.value = response.data.data
      currentPage.value = response.data.current_page
      totalPages.value = response.data.last_page
    }
  } catch (error) {
    console.error('Failed to load companies:', error)
    const err = error as { response?: { data?: { message?: string } } }
    toast.error(err.response?.data?.message || 'Failed to load companies')
  } finally {
    isLoading.value = false
  }
}

const handleSearch = () => {
  currentPage.value = 1
  loadCompanies()
}

// Load companies on mount
onMounted(() => {
  loadCompanies()
})
</script>
