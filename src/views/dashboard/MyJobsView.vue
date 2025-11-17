<template>
  <div class="bg-gray-50 min-h-screen py-6 sm:py-8">
    <div class="mx-auto px-4 w-full" style="max-width: 1200px;">
      <!-- Header -->
      <div class="mb-6 sm:mb-8">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
          <div>
            <h1 class="text-2xl sm:text-3xl font-bold text-gray-900 mb-2">{{ $t('myJobs.title') }}</h1>
            <p class="text-sm sm:text-base text-gray-600">
              {{ $t('myJobs.subtitle') }}
            </p>
          </div>
          <router-link
            v-if="hasCompany"
            to="/post-job"
            class="inline-flex items-center justify-center px-4 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700 transition-colors"
          >
            <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
            {{ $t('myJobs.postNewJob') }}
          </router-link>
        </div>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="flex justify-center items-center py-12">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="bg-red-50 border border-red-200 rounded-lg p-4 mb-6">
        <div class="flex items-start">
          <svg class="h-5 w-5 text-red-600 mt-0.5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <div>
            <h3 class="text-sm font-medium text-red-800">{{ $t('myJobs.errorLoadingJobs') }}</h3>
            <p class="text-sm text-red-700 mt-1">{{ error }}</p>
          </div>
        </div>
      </div>

      <!-- No Company State -->
      <div v-else-if="!hasCompany" class="text-center py-12">
        <svg class="mx-auto h-16 w-16 text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
        </svg>
        <h3 class="text-lg font-semibold text-gray-900 mb-2">{{ $t('myJobs.noCompanyProfile') }}</h3>
        <p class="text-gray-600 mb-6">{{ $t('myJobs.noCompanyMessage') }}</p>
        <router-link
          to="/my-companies"
          class="inline-flex items-center px-4 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700 transition-colors"
        >
          {{ $t('myJobs.createCompanyProfile') }}
        </router-link>
      </div>

      <!-- Empty State -->
      <div v-else-if="jobs.length === 0" class="text-center py-12">
        <svg class="mx-auto h-16 w-16 text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
        </svg>
        <h3 class="text-lg font-semibold text-gray-900 mb-2">{{ $t('myJobs.noJobsYet') }}</h3>
        <p class="text-gray-600 mb-6">{{ $t('myJobs.noJobsMessage') }}</p>
        <router-link
          to="/post-job"
          class="inline-flex items-center px-4 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700 transition-colors"
        >
          <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
          </svg>
          {{ $t('myJobs.postYourFirstJob') }}
        </router-link>
      </div>

      <!-- Jobs List -->
      <div v-else class="grid gap-4">
        <div
          v-for="job in jobs"
          :key="job.id"
          class="bg-white border-2 border-gray-300 rounded-lg p-6 hover:shadow-lg transition-all duration-200 hover:border-primary-400"
        >
          <div class="flex gap-4">
            <!-- Company Logo -->
            <router-link
              :to="`/companies/${job.company.slug}`"
              class="w-16 h-16 bg-gray-100 rounded-lg flex items-center justify-center flex-shrink-0 hover:bg-gray-200 transition-colors"
            >
              <img
                v-if="job.company?.logo?.url"
                :src="job.company.logo.url"
                :alt="job.company.name"
                class="w-full h-full object-contain p-2 rounded-lg"
              />
              <svg v-else class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
              </svg>
            </router-link>

            <!-- Job Info -->
            <div class="flex-1 min-w-0">
              <div class="flex items-start justify-between gap-3 mb-3">
                <div class="flex-1 min-w-0">
                  <router-link
                    :to="`/jobs/${job.slug}`"
                    class="block"
                  >
                    <h3 class="text-xl font-bold text-gray-900 hover:text-primary-600 transition-colors mb-1">
                      {{ job.title }}
                    </h3>
                  </router-link>
                  <router-link
                    :to="`/companies/${job.company.slug}`"
                    class="text-base text-gray-600 hover:text-gray-900 transition-colors"
                  >
                    {{ job.company.name }}
                  </router-link>
                </div>
              
                <!-- Status Badges -->
                <div class="flex items-center gap-2 flex-shrink-0">
                  <span
                    v-if="job.is_featured"
                    class="inline-flex items-center px-2.5 py-1 rounded-md text-xs font-semibold bg-yellow-100 text-yellow-800"
                  >
                    ⭐ {{ $t('myJobs.featured') }}
                  </span>
                  <span
                    :class="[
                      'inline-flex items-center px-2.5 py-1 rounded-md text-xs font-semibold',
                      job.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'
                    ]"
                  >
                    {{ job.is_active ? '● ' + $t('myJobs.active') : '○ ' + $t('myJobs.inactive') }}
                  </span>
                </div>
              </div>

              <!-- Tags -->
              <div class="flex flex-wrap gap-2 mb-4">
                <span class="inline-flex items-center px-3 py-1 rounded-md text-xs font-medium bg-gray-100 text-gray-800">
                  <svg class="w-3.5 h-3.5 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                  </svg>
                  {{ job.city }}, {{ job.country }}
                </span>
                <span v-if="job.employment_type" class="inline-flex items-center px-3 py-1 rounded-md text-xs font-medium bg-blue-100 text-blue-800">
                  {{ formatEmploymentType(job.employment_type) }}
                </span>
                <span v-if="job.is_remote" class="inline-flex items-center px-3 py-1 rounded-md text-xs font-medium bg-green-100 text-green-800">
                  🌐 {{ $t('jobs.remote') }}
                </span>
                <span v-if="job.category" class="inline-flex items-center px-3 py-1 rounded-md text-xs font-medium bg-purple-100 text-purple-800">
                  {{ job.category }}
                </span>
              </div>

              <!-- Salary Display -->
              <div v-if="job.salary_min && job.salary_max">
                <div class="flex items-center text-base">
                  <svg class="w-5 h-5 mr-2 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  <span class="font-semibold text-primary-600">{{ formatSalaryRange(job.salary_min, job.salary_max, job.salary_currency, job.salary_period) }}</span>
                </div>
              </div>

              <!-- Stats and Actions Row -->
              <div class="flex items-center justify-between gap-4 pt-4 border-t-2 border-gray-200">
                <div class="flex items-center gap-6 text-sm">
                  <span class="flex items-center text-gray-600">
                    <svg class="w-5 h-5 mr-2 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                    </svg>
                    <span class="font-semibold text-gray-900">{{ job.applications_count || 0 }}</span>
                    <span class="ml-1">{{ job.applications_count === 1 ? $t('myJobs.application') : $t('myJobs.applications') }}</span>
                  </span>
                  <span class="text-gray-500">
                    {{ $t('myJobs.postedOn') }} {{ formatActualDate(job.published_at || job.created_at) }}
                  </span>
                  <span v-if="job.expires_at" class="text-gray-500">
                    {{ $t('myJobs.expiresOn') }} {{ formatActualDate(job.expires_at) }}
                  </span>
                </div>

                <!-- Action Buttons -->
                <div class="flex gap-2">
                  <router-link
                    :to="`/my-companies/${job.company_id}/jobs/${job.id}/view`"
                    class="inline-flex items-center px-4 py-2 bg-white border-2 border-gray-300 rounded-lg text-sm font-semibold text-gray-700 hover:bg-gray-50 hover:border-primary-400 transition-all"
                  >
                    <svg class="h-4 w-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                    </svg>
                    {{ $t('myJobs.viewDetails') }}
                  </router-link>
                  <router-link
                    :to="`/my-companies/${job.company_id}/jobs/${job.id}/edit`"
                    class="inline-flex items-center px-4 py-2 bg-primary-600 text-white rounded-lg text-sm font-semibold hover:bg-primary-700 transition-colors"
                  >
                    <svg class="h-4 w-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                    </svg>
                    {{ $t('myJobs.editJob') }}
                  </router-link>
                  <button
                    @click="confirmDeleteJob(job)"
                    class="inline-flex items-center px-4 py-2 bg-white border-2 border-red-300 rounded-lg text-sm font-semibold text-red-700 hover:bg-red-50 hover:border-red-500 transition-all cursor-pointer"
                  >
                    <svg class="h-4 w-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                    {{ $t('myJobs.deleteJob') }}
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Delete Job Confirmation Modal -->
    <BaseModal
      v-model="showDeleteJobModal"
      :title="$t('myJobs.deleteJobTitle')"
      size="sm"
    >
      <div class="p-6">
        <p class="text-gray-700 mb-6">
          {{ $t('myJobs.deleteJobConfirm', { jobTitle: jobToDelete?.title }) }}
        </p>
        <div class="flex items-center justify-end gap-3">
          <BaseButton
            variant="outline"
            @click="showDeleteJobModal = false"
            :disabled="deletingJob"
          >
            {{ $t('myJobs.cancel') }}
          </BaseButton>
          <BaseButton
            variant="primary"
            @click="handleDeleteJob"
            :loading="deletingJob"
            class="bg-red-600 hover:bg-red-700"
          >
            {{ deletingJob ? $t('myJobs.deleting') : $t('myJobs.deleteJob') }}
          </BaseButton>
        </div>
      </div>
    </BaseModal>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useCompanyStore } from '@/stores/company'
import { jobService } from '@/services/job.service'
import { formatSalaryRange } from '@/utils/currency'
import { useToast } from '@/composables/useToast'
import type { Job } from '@/types'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseModal from '@/components/base/BaseModal.vue'

const _router = useRouter()
const _authStore = useAuthStore()
const companyStore = useCompanyStore()
const toast = useToast()

const jobs = ref<Job[]>([])
const loading = ref(true)
const error = ref<string | null>(null)
const showDeleteJobModal = ref(false)
const deletingJob = ref(false)
const jobToDelete = ref<Job | null>(null)

const hasCompany = computed(() => companyStore.myCompanies.length > 0)

const fetchJobs = async () => {
  try {
    loading.value = true
    error.value = null
    
    // Get all jobs posted by the company owner
    const response = await jobService.getMyJobs()
    
    console.log('Jobs response:', response)
    jobs.value = response.data || []
  } catch (err: unknown) {
    console.error('Error fetching jobs:', err)
    const errorObj = err as { response?: { data?: { message?: string } }; message?: string }
    console.error('Error response:', errorObj.response)
    error.value = errorObj.response?.data?.message || errorObj.message || 'Failed to load jobs'
  } finally {
    loading.value = false
  }
}

const confirmDeleteJob = (job: Job) => {
  jobToDelete.value = job
  showDeleteJobModal.value = true
}

const handleDeleteJob = async () => {
  if (!jobToDelete.value) return

  try {
    deletingJob.value = true
    const response = await jobService.deleteJob(jobToDelete.value.id)
    
    if (response.success) {
      // Remove job from the list
      jobs.value = jobs.value.filter(j => j.id !== jobToDelete.value!.id)
      
      showDeleteJobModal.value = false
      jobToDelete.value = null
      toast.success('Job deleted successfully!')
    } else {
      toast.error(response.message || 'Failed to delete job. Please try again.')
    }
  } catch (err: unknown) {
    console.error('Error deleting job:', err)
    const error = err as { response?: { data?: { message?: string }, status?: number }; message?: string }
    
    if (error.response?.status === 404) {
      // Job already deleted, remove from list
      jobs.value = jobs.value.filter(j => j.id !== jobToDelete.value!.id)
      showDeleteJobModal.value = false
      jobToDelete.value = null
      toast.error('Job not found. It may have been already deleted.')
    } else {
      toast.error(error.response?.data?.message || error.message || 'Failed to delete job. Please try again.')
    }
  } finally {
    deletingJob.value = false
  }
}

const formatEmploymentType = (type: string) => {
  const types: Record<string, string> = {
    'full-time': 'Full Time',
    'part-time': 'Part Time',
    'contract': 'Contract',
    'freelance': 'Freelance',
    'internship': 'Internship'
  }
  return types[type] || type
}

const formatActualDate = (dateString: string) => {
  const date = new Date(dateString)
  const day = String(date.getDate()).padStart(2, '0')
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const year = date.getFullYear()
  return `${day}.${month}.${year}`
}

const _formatPostedDate = (dateString: string) => {
  const date = new Date(dateString)
  const now = new Date()
  const diffTime = now.getTime() - date.getTime()
  const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24))
  
  if (diffDays === 0) return 'Today'
  if (diffDays === 1) return 'Yesterday'
  if (diffDays < 7) return `${diffDays} days ago`
  if (diffDays < 30) return `${Math.floor(diffDays / 7)} weeks ago`
  if (diffDays < 365) return `${Math.floor(diffDays / 30)} months ago`
  
  return date.toLocaleDateString('en-US', { 
    year: 'numeric', 
    month: 'short', 
    day: 'numeric' 
  })
}

const _formatExpiryDate = (dateString: string) => {
  const date = new Date(dateString)
  const now = new Date()
  const diffTime = date.getTime() - now.getTime()
  const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24))
  
  // Future dates (not yet expired)
  if (diffTime > 0) {
    if (diffDays === 0) return 'Today'
    if (diffDays === 1) return 'Tomorrow'
    if (diffDays < 7) return `in ${diffDays} days`
    if (diffDays < 30) return `in ${Math.floor(diffDays / 7)} weeks`
    if (diffDays < 365) return `in ${Math.floor(diffDays / 30)} months`
  }
  
  // Show actual date (for far future or already expired)
  return date.toLocaleDateString('en-US', { 
    year: 'numeric', 
    month: 'short', 
    day: 'numeric' 
  })
}

const _formatDate = (dateString: string) => {
  const date = new Date(dateString)
  const now = new Date()
  const diffTime = now.getTime() - date.getTime()
  const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24))
  
  // For past dates (posted date)
  if (diffTime >= 0) {
    if (diffDays === 0) return 'Today'
    if (diffDays === 1) return 'Yesterday'
    if (diffDays < 7) return `${diffDays} days ago`
    if (diffDays < 30) return `${Math.floor(diffDays / 7)} weeks ago`
    if (diffDays < 365) return `${Math.floor(diffDays / 30)} months ago`
  }
  
  // For future dates (expiry date) or old dates, show actual date
  return date.toLocaleDateString('en-US', { 
    year: 'numeric', 
    month: 'short', 
    day: 'numeric' 
  })
}

onMounted(async () => {
  await companyStore.fetchMyCompanies()
  if (hasCompany.value) {
    await fetchJobs()
  } else {
    loading.value = false
  }
})
</script>
