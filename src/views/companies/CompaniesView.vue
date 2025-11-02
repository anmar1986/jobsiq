<template>
  <div class="bg-gray-50 min-h-screen">
    <!-- Page Header -->
    <div class="bg-white border-b border-gray-200">
      <div class="container-custom py-6 sm:py-8">
        <h1 class="text-2xl sm:text-3xl md:text-4xl font-bold text-gray-900 mb-2 sm:mb-4">Discover Top Companies</h1>
        <p class="text-base sm:text-lg text-gray-600">Browse leading companies hiring on JobsIQ</p>
      </div>
    </div>

    <!-- Search Bar -->
    <div class="bg-white border-b border-gray-200">
      <div class="mx-auto px-4 py-4 w-full max-w-[900px]">
        <div class="flex flex-col sm:flex-row gap-3 sm:gap-4">
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
          <BaseButton variant="primary" size="md" class="w-full sm:w-auto" @click="handleSearch">
            Search
          </BaseButton>
        </div>
      </div>
    </div>

    <!-- Companies Grid -->
    <div class="container-custom py-6 sm:py-8">
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
      <div v-else class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 sm:gap-6">
        <div
          v-for="company in companies"
          :key="company.id"
          class="bg-white rounded-lg border-2 border-gray-200 hover:border-primary-500 hover:shadow-lg transition-all duration-300 flex flex-col group overflow-hidden cursor-pointer"
          @click="viewCompanyProfile(company)"
        >
          <!-- Cover Image with Logo -->
          <div class="w-full h-32 sm:h-40 bg-gradient-to-br from-primary-500 to-secondary-500 flex-shrink-0 relative overflow-hidden">
            <img 
              v-if="company.cover?.path" 
              :src="getLogoUrl(company.cover.path)" 
              :alt="company.name"
              class="w-full h-full object-cover"
            />
            
            <!-- Company Logo - Positioned at bottom left -->
            <div class="absolute bottom-3 left-3 sm:bottom-4 sm:left-4 w-16 h-16 sm:w-20 sm:h-20 bg-white rounded-lg flex items-center justify-center text-white text-xl sm:text-2xl font-bold shadow-lg ring-4 ring-white overflow-hidden">
              <img 
                v-if="company.logo?.path" 
                :src="getLogoUrl(company.logo.path)" 
                :alt="company.name"
                class="w-full h-full object-cover"
              />
              <span v-else class="text-primary-600">{{ company.name?.[0] || '?' }}</span>
            </div>
          </div>

          <div class="p-4 sm:p-6 flex flex-col flex-1">
            <!-- Company Name & Industry -->
            <div class="mb-3 sm:mb-4 flex-shrink-0">
              <h3 class="text-lg sm:text-xl font-bold text-gray-900 mb-1 truncate group-hover:text-primary-600 transition-colors">
                {{ company.name || 'Unknown Company' }}
              </h3>
              <p v-if="company.industry" class="text-sm sm:text-base text-primary-600 font-medium mb-2 truncate">
                {{ company.industry }}
              </p>
            </div>

            <!-- Company Info -->
            <div class="space-y-2 mb-3 sm:mb-4 flex-shrink-0">
              <div v-if="company.city || company.country" class="flex items-center gap-2 text-sm text-gray-600">
                <svg class="h-4 w-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                </svg>
                <span class="truncate">{{ [company.city, company.country].filter(Boolean).join(', ') }}</span>
              </div>
              
              <div v-if="company.website" class="flex items-center gap-2 text-sm text-gray-600 min-w-0">
                <svg class="h-4 w-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9" />
                </svg>
                <a :href="company.website" target="_blank" class="hover:text-primary-600 truncate" @click.stop>
                  {{ company.website.replace(/^https?:\/\//, '') }}
                </a>
              </div>

              <div class="flex items-center gap-2 text-sm text-gray-600">
                <svg class="h-4 w-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                </svg>
                <span>{{ company.jobs_count || 0 }} active job{{ (company.jobs_count || 0) !== 1 ? 's' : '' }}</span>
              </div>
            </div>

            <!-- View Profile Button -->
            <div class="flex gap-2 pt-4 border-t border-gray-200 flex-shrink-0 mt-auto">
              <BaseButton
                variant="primary"
                size="sm"
                class="flex-1"
                @click="viewCompanyProfile(company)"
              >
                <template #icon-left>
                  <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                  </svg>
                </template>
                View Profile
              </BaseButton>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { companyService } from '@/services/cv.service'
import type { Company } from '@/types'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import { useToast } from '@/composables/useToast'

const router = useRouter()
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

// Navigate to company profile
const viewCompanyProfile = (company: Company) => {
  router.push(`/companies/${company.slug}`)
}

// Get logo URL
const getLogoUrl = (path: string): string => {
  if (!path) return ''
  
  // Handle different path formats
  if (path.startsWith('data:') || path.startsWith('blob:') || path.startsWith('http')) {
    return path
  }
  
  if (path.startsWith('/storage/')) {
    return path
  }
  
  // Remove leading slashes and construct clean path
  const cleanPath = path.replace(/^\/+/, '')
  return `/storage/${cleanPath}`
}

// Load companies on mount
onMounted(() => {
  loadCompanies()
})
</script>
