<template>
  <div class="bg-gray-50 min-h-screen py-8">
    <div class="container-custom">
      <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-2">My Applications</h1>
        <p class="text-gray-600">Track and manage your job applications</p>
      </div>

      <!-- Filters -->
      <BaseCard class="p-6 mb-6">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
          <!-- Search -->
          <div class="md:col-span-2">
            <BaseInput
              v-model="filters.search"
              type="text"
              placeholder="Search by job title or company..."
              @input="handleFilterChange"
            >
              <template #prefix>
                <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
              </template>
            </BaseInput>
          </div>

          <!-- Status Filter -->
          <div>
            <select
              v-model="filters.status"
              @change="handleFilterChange"
              class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            >
              <option value="">All Status</option>
              <option value="pending">Pending</option>
              <option value="reviewed">Reviewed</option>
              <option value="accepted">Accepted</option>
              <option value="rejected">Rejected</option>
            </select>
          </div>
        </div>
      </BaseCard>

      <!-- Loading State -->
      <div v-if="loading" class="space-y-4">
        <BaseCard v-for="i in 3" :key="i" class="p-6">
          <div class="animate-pulse flex gap-4">
            <div class="w-16 h-16 bg-gray-200 rounded-lg"></div>
            <div class="flex-1">
              <div class="h-6 bg-gray-200 rounded w-1/2 mb-3"></div>
              <div class="h-4 bg-gray-200 rounded w-1/3 mb-2"></div>
              <div class="h-4 bg-gray-200 rounded w-1/4"></div>
            </div>
          </div>
        </BaseCard>
      </div>

      <!-- No Applications -->
      <div v-else-if="applications.length === 0" class="text-center py-16">
        <BaseCard class="p-12">
          <svg class="h-16 w-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
          <h2 class="text-2xl font-bold text-gray-900 mb-2">No Applications Yet</h2>
          <p class="text-gray-600 mb-6">
            {{ filters.search || filters.status ? 'No applications match your filters.' : "You haven't applied to any jobs yet." }}
          </p>
          <BaseButton variant="primary" @click="router.push('/jobs')">
            Browse Jobs
          </BaseButton>
        </BaseCard>
      </div>

      <!-- Applications List -->
      <div v-else class="space-y-4">
        <BaseCard v-for="application in applications" :key="application.id" hoverable class="p-6">
          <div class="flex items-start gap-4">
            <!-- Company Logo -->
            <div 
              class="w-16 h-16 flex-shrink-0 bg-gradient-to-br from-primary-100 to-secondary-100 rounded-lg flex items-center justify-center cursor-pointer"
              @click="router.push(`/jobs/${application.job?.slug}`)"
            >
              <img 
                v-if="application.job?.company?.logo?.path" 
                :src="getLogoUrl(application.job.company.logo.path)" 
                :alt="application.job.company.name"
                class="w-full h-full object-contain rounded-lg"
              />
              <span v-else class="text-2xl font-bold text-primary-600">
                {{ application.job?.company?.name?.[0] || '?' }}
              </span>
            </div>

            <!-- Application Details -->
            <div class="flex-1 min-w-0">
              <div class="flex items-start justify-between gap-4 mb-2">
                <div class="flex-1 min-w-0">
                  <h3 
                    class="text-xl font-bold text-gray-900 hover:text-primary-600 cursor-pointer mb-1 truncate"
                    @click="router.push(`/jobs/${application.job?.slug}`)"
                  >
                    {{ application.job?.title }}
                  </h3>
                  <p 
                    class="text-gray-600 hover:text-primary-600 cursor-pointer mb-2"
                    @click="router.push(`/companies/${application.job?.company?.slug}`)"
                  >
                    {{ application.job?.company?.name }}
                  </p>
                </div>

                <!-- Status Badge -->
                <BaseBadge :variant="getStatusVariant(application.status)">
                  {{ formatStatus(application.status) }}
                </BaseBadge>
              </div>

              <!-- Job Meta -->
              <div class="flex flex-wrap gap-3 text-sm text-gray-600 mb-4">
                <span class="flex items-center gap-1">
                  <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                  </svg>
                  {{ application.job?.location }}
                </span>
                <span class="flex items-center gap-1">
                  <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                  </svg>
                  {{ application.job?.employment_type }}
                </span>
                <span class="flex items-center gap-1">
                  <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                  </svg>
                  Applied {{ formatDate(application.applied_at) }}
                </span>
              </div>

              <!-- Cover Letter Preview -->
              <div v-if="application.cover_letter" class="bg-gray-50 rounded-lg p-3 mb-4">
                <p class="text-sm text-gray-700 line-clamp-2">
                  {{ application.cover_letter }}
                </p>
              </div>

              <!-- Actions -->
              <div class="flex gap-3">
                <BaseButton
                  variant="outline"
                  size="sm"
                  @click="router.push(`/jobs/${application.job?.slug}`)"
                >
                  View Job
                </BaseButton>
                
                <BaseButton
                  v-if="application.cv"
                  variant="outline"
                  size="sm"
                  @click="router.push(`/my-cvs/view/${application.cv.id}`)"
                >
                  View CV
                </BaseButton>

                <BaseButton
                  v-if="application.status === 'pending'"
                  variant="danger"
                  size="sm"
                  @click="confirmWithdraw(application)"
                  :disabled="withdrawing === application.id"
                >
                  <span v-if="withdrawing === application.id" class="flex items-center gap-2">
                    <svg class="animate-spin h-4 w-4" fill="none" viewBox="0 0 24 24">
                      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    Withdrawing...
                  </span>
                  <span v-else>Withdraw</span>
                </BaseButton>
              </div>
            </div>
          </div>
        </BaseCard>
      </div>

      <!-- Pagination -->
      <div v-if="pagination && pagination.last_page > 1" class="mt-8 flex justify-center">
        <nav class="flex items-center gap-2">
          <BaseButton
            variant="outline"
            size="sm"
            :disabled="pagination.current_page === 1"
            @click="goToPage(pagination.current_page - 1)"
          >
            Previous
          </BaseButton>

          <template v-for="page in getPageNumbers()" :key="page">
            <BaseButton
              v-if="page !== '...'"
              :variant="pagination.current_page === page ? 'primary' : 'outline'"
              size="sm"
              @click="goToPage(page as number)"
            >
              {{ page }}
            </BaseButton>
            <span v-else class="px-2 text-gray-500">...</span>
          </template>

          <BaseButton
            variant="outline"
            size="sm"
            :disabled="pagination.current_page === pagination.last_page"
            @click="goToPage(pagination.current_page + 1)"
          >
            Next
          </BaseButton>
        </nav>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { jobApplicationService } from '@/services/jobApplication.service'
import { useToast } from '@/composables/useToast'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseBadge from '@/components/base/BaseBadge.vue'
import type { JobApplication, PaginatedResponse } from '@/types'

const router = useRouter()
const toast = useToast()

const applications = ref<JobApplication[]>([])
const loading = ref(true)
const withdrawing = ref<number | null>(null)
const pagination = ref<PaginatedResponse<JobApplication> | null>(null)

const filters = ref({
  search: '',
  status: '',
  page: 1,
  per_page: 10,
})

const fetchApplications = async () => {
  loading.value = true
  try {
    const response = await jobApplicationService.getMyApplications(filters.value)
    if (response.success && response.data) {
      applications.value = response.data.data
      pagination.value = response.data
    }
  } catch (error) {
    console.error('Error fetching applications:', error)
    toast.error('Failed to load applications')
  } finally {
    loading.value = false
  }
}

const handleFilterChange = () => {
  filters.value.page = 1
  fetchApplications()
}

const goToPage = (page: number) => {
  filters.value.page = page
  fetchApplications()
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

const getPageNumbers = (): (number | string)[] => {
  if (!pagination.value) return []
  
  const current = pagination.value.current_page
  const last = pagination.value.last_page
  const pages: (number | string)[] = []
  
  if (last <= 7) {
    for (let i = 1; i <= last; i++) {
      pages.push(i)
    }
  } else {
    if (current <= 3) {
      for (let i = 1; i <= 4; i++) pages.push(i)
      pages.push('...')
      pages.push(last)
    } else if (current >= last - 2) {
      pages.push(1)
      pages.push('...')
      for (let i = last - 3; i <= last; i++) pages.push(i)
    } else {
      pages.push(1)
      pages.push('...')
      for (let i = current - 1; i <= current + 1; i++) pages.push(i)
      pages.push('...')
      pages.push(last)
    }
  }
  
  return pages
}

const confirmWithdraw = async (application: JobApplication) => {
  if (!confirm(`Are you sure you want to withdraw your application for ${application.job?.title}?`)) {
    return
  }
  
  await withdrawApplication(application)
}

const withdrawApplication = async (application: JobApplication) => {
  withdrawing.value = application.id
  try {
    const response = await jobApplicationService.withdrawApplication(application.id)
    if (response.success) {
      toast.success('Application withdrawn successfully')
      // Remove from list
      applications.value = applications.value.filter(app => app.id !== application.id)
    }
  } catch (error) {
    console.error('Error withdrawing application:', error)
    const errorMessage = (error as { response?: { data?: { message?: string } } }).response?.data?.message
    toast.error(errorMessage || 'Failed to withdraw application')
  } finally {
    withdrawing.value = null
  }
}

const getLogoUrl = (path: string): string => {
  if (!path) return ''
  if (path.startsWith('data:') || path.startsWith('blob:') || path.startsWith('http')) {
    return path
  }
  if (path.startsWith('/storage/')) {
    return path
  }
  const cleanPath = path.replace(/^\/+/, '')
  return `/storage/${cleanPath}`
}

const getStatusVariant = (status: string): 'primary' | 'secondary' | 'success' | 'warning' | 'danger' | 'info' => {
  const variants: Record<string, 'primary' | 'secondary' | 'success' | 'warning' | 'danger' | 'info'> = {
    'pending': 'warning',
    'reviewed': 'info',
    'accepted': 'success',
    'rejected': 'danger',
  }
  return variants[status] || 'secondary'
}

const formatStatus = (status: string): string => {
  const statusMap: Record<string, string> = {
    'pending': 'Pending Review',
    'reviewed': 'Reviewed',
    'accepted': 'Accepted',
    'rejected': 'Rejected',
  }
  return statusMap[status] || status
}

const formatDate = (date: string): string => {
  const now = new Date()
  const appliedDate = new Date(date)
  const diffTime = Math.abs(now.getTime() - appliedDate.getTime())
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
  
  if (diffDays === 0) return 'today'
  if (diffDays === 1) return 'yesterday'
  if (diffDays < 7) return `${diffDays} days ago`
  if (diffDays < 30) return `${Math.floor(diffDays / 7)} weeks ago`
  if (diffDays < 365) return `${Math.floor(diffDays / 30)} months ago`
  
  return appliedDate.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}

onMounted(() => {
  fetchApplications()
})
</script>
