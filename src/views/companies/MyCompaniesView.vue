<template>
  <div class="container-custom py-8">
    <!-- Header -->
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-3xl font-bold text-gray-900">My Companies</h1>
        <p class="text-gray-600 mt-2">Manage your companies and post jobs</p>
      </div>
      <BaseButton
        variant="primary"
        @click="router.push({ name: 'create-company' })"
      >
        <template #icon-left>
          <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
          </svg>
        </template>
        Add Company
      </BaseButton>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="flex items-center justify-center py-12">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
    </div>

    <!-- Empty State -->
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

    <!-- Companies List -->
    <div v-else class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div
        v-for="company in companies"
        :key="company.id"
        class="bg-white rounded-lg border-2 border-gray-200 hover:border-primary-500 hover:shadow-lg transition-all duration-300 h-[520px] flex flex-col group"
      >
        <div class="p-6 flex flex-col h-full">
          <!-- Company Logo & Info -->
          <div class="mb-4 flex-shrink-0">
            <div class="flex items-start gap-4 mb-3">
              <!-- Company Logo -->
              <div class="w-16 h-16 bg-gradient-to-br from-primary-500 to-secondary-500 rounded-lg flex items-center justify-center text-white text-2xl font-bold flex-shrink-0 ring-2 ring-primary-200 group-hover:ring-primary-300 transition-all duration-300 overflow-hidden">
                <img 
                  v-if="company.logo?.path" 
                  :src="getLogoUrl(company.logo.path)" 
                  :alt="company.name"
                  class="w-full h-full object-cover"
                />
                <span v-else>{{ company.name[0] }}</span>
              </div>
              
              <!-- Company Name & Industry -->
              <div class="flex-1 min-w-0">
                <h3 class="text-xl font-bold text-gray-900 mb-1 truncate group-hover:text-primary-600 transition-colors">
                  {{ company.name }}
                </h3>
                <p v-if="company.industry" class="text-primary-600 font-medium mb-2 truncate">
                  {{ company.industry }}
                </p>
              </div>
            </div>
          </div>

          <!-- Company Info -->
          <div class="space-y-2 mb-4 flex-shrink-0">
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
              <a :href="company.website" target="_blank" class="hover:text-primary-600 truncate">
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

          <!-- Description -->
          <p v-if="company.description" class="text-sm text-gray-600 mb-4 line-clamp-2 flex-shrink-0">
            {{ company.description }}
          </p>

          <!-- Jobs List - Scrollable Area -->
          <div class="flex-1 min-h-0 mb-4 flex flex-col">
            <div v-if="company.jobs && company.jobs.length > 0" class="flex flex-col h-full">
              <h4 class="text-sm font-semibold text-gray-900 mb-2 flex-shrink-0">Active Jobs:</h4>
              <div class="space-y-2 overflow-y-auto flex-1 pr-1 custom-scrollbar">
                <div
                  v-for="job in company.jobs.slice(0, 3)"
                  :key="job.id"
                  class="flex items-center justify-between p-2 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors cursor-pointer"
                  @click="viewJob(job)"
                >
                  <div class="flex-1 min-w-0">
                    <p class="text-sm font-medium text-gray-900 truncate">{{ job.title }}</p>
                    <p class="text-xs text-gray-600">{{ job.location }}</p>
                  </div>
                  <svg class="h-4 w-4 text-gray-400 flex-shrink-0 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                  </svg>
                </div>
                <button
                  v-if="company.jobs.length > 3"
                  class="w-full text-xs text-primary-600 hover:text-primary-700 font-medium py-1"
                  @click="viewAllJobs(company)"
                >
                  View all {{ company.jobs.length }} jobs →
                </button>
              </div>
            </div>
            <div v-else class="p-3 bg-gray-50 rounded-lg text-center flex-shrink-0">
              <p class="text-sm text-gray-600">No jobs posted yet</p>
            </div>
          </div>

          <!-- Actions -->
          <div class="flex gap-2 pt-4 border-t border-gray-200 flex-shrink-0 mt-auto">
            <BaseButton
              variant="outline"
              size="sm"
              @click="viewCompany(company)"
              class="flex-1"
            >
              <template #icon-left>
                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                </svg>
              </template>
              View
            </BaseButton>
            <BaseButton
              variant="primary"
              size="sm"
              @click="router.push({ name: 'edit-company', params: { id: company.id } })"
              class="flex-1"
            >
              <template #icon-left>
                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                </svg>
              </template>
              Edit
            </BaseButton>
            <BaseButton
              variant="outline"
              size="sm"
              @click="confirmDelete(company)"
              class="flex-1 text-red-600 hover:text-red-700 hover:border-red-600 hover:bg-red-50"
            >
              <template #icon-left>
                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                </svg>
              </template>
              Delete
            </BaseButton>
          </div>
        </div>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <BaseModal
      v-model="showDeleteModal"
      title="Delete Company"
      size="sm"
    >
      <div class="p-6">
        <p class="text-gray-700 mb-6">
          Are you sure you want to delete <strong>{{ selectedCompany?.name }}</strong>? 
          This action cannot be undone and will also delete all associated jobs.
        </p>
        <div class="flex items-center justify-end gap-3">
          <BaseButton
            variant="outline"
            @click="showDeleteModal = false"
            :disabled="deleting"
          >
            Cancel
          </BaseButton>
          <BaseButton
            variant="primary"
            @click="handleDeleteCompany"
            :loading="deleting"
            class="bg-red-600 hover:bg-red-700"
          >
            Delete Company
          </BaseButton>
        </div>
      </div>
    </BaseModal>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useToast } from '@/composables/useToast'
import { companyService } from '@/services/cv.service'
import type { Company } from '@/types'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseModal from '@/components/base/BaseModal.vue'

const router = useRouter()
const toast = useToast()

const loading = ref(false)
const deleting = ref(false)
const companies = ref<Company[]>([])
const selectedCompany = ref<Company | null>(null)
const showDeleteModal = ref(false)

const loadCompanies = async () => {
  loading.value = true
  try {
    const response = await companyService.getMyCompanies()
    
    if (response.success && response.data) {
      companies.value = response.data
      // Debug: Check if jobs are loaded
      console.log('Loaded companies:', companies.value.map(c => ({
        name: c.name,
        jobs_count: c.jobs_count,
        jobs: c.jobs?.length || 0
      })))
    }
  } catch (error) {
    console.error('Failed to load companies:', error)
    const err = error as { response?: { data?: { message?: string } } }
    toast.error(err.response?.data?.message || 'Failed to load companies')
  } finally {
    loading.value = false
  }
}

const confirmDelete = (company: Company) => {
  selectedCompany.value = company
  showDeleteModal.value = true
}

const handleDeleteCompany = async () => {
  if (!selectedCompany.value) return
  
  deleting.value = true
  try {
    const response = await companyService.deleteCompany(selectedCompany.value.id)
    if (response.success) {
      showDeleteModal.value = false
      await loadCompanies()
      toast.success('Company deleted successfully!')
    }
  } catch (error) {
    console.error('Failed to delete company:', error)
    const err = error as { response?: { data?: { message?: string } } }
    toast.error(err.response?.data?.message || 'Failed to delete company')
  } finally {
    deleting.value = false
  }
}

const viewCompany = (company: Company) => {
  router.push({
    name: 'view-my-company',
    params: { id: company.id }
  })
}

const viewJob = (job: { id: number; slug: string }) => {
  router.push({
    name: 'job-details',
    params: { slug: job.slug }
  })
}

const viewAllJobs = (company: Company) => {
  // Navigate to jobs page filtered by this company
  router.push({
    name: 'jobs',
    query: { company: company.slug }
  })
}

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

onMounted(() => {
  // Ensure body can scroll (fix for any stuck modal state)
  document.body.style.overflow = ''
  loadCompanies()
})
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 6px;
}

.custom-scrollbar::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 3px;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
  background: #cbd5e1;
  border-radius: 3px;
}

.custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background: #94a3b8;
}
</style>
