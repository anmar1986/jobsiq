<template>
  <div class="bg-gray-50 min-h-screen py-8">
    <div class="container-custom max-w-4xl">
      <!-- Loading State -->
      <div v-if="loading" class="animate-pulse">
        <div class="bg-white rounded-lg p-8 mb-6">
          <div class="h-8 bg-gray-200 rounded w-3/4 mb-4"></div>
          <div class="h-4 bg-gray-200 rounded w-1/2"></div>
        </div>
      </div>

      <!-- Job not found -->
      <div v-else-if="!job" class="bg-white rounded-lg p-12 text-center">
        <svg class="h-16 w-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <h2 class="text-2xl font-bold text-gray-900 mb-2">Job Not Found</h2>
        <p class="text-gray-600 mb-6">The job you're trying to apply for doesn't exist or has been removed.</p>
        <BaseButton variant="primary" @click="router.push('/jobs')">
          Browse Jobs
        </BaseButton>
      </div>

      <!-- Already Applied -->
      <div v-else-if="hasApplied && existingApplication" class="bg-white rounded-lg p-8">
        <div class="text-center mb-6">
          <div class="inline-flex items-center justify-center w-16 h-16 bg-green-100 rounded-full mb-4">
            <svg class="h-8 w-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
          </div>
          <h2 class="text-2xl font-bold text-gray-900 mb-2">Application Already Submitted</h2>
          <p class="text-gray-600 mb-4">You've already applied for this position.</p>
          <div
            class="inline-flex items-center gap-2 px-4 py-2 rounded-lg"
            :class="{
              'bg-yellow-100 text-yellow-800': existingApplication.status === 'pending',
              'bg-blue-100 text-blue-800': existingApplication.status === 'reviewed',
              'bg-green-100 text-green-800': existingApplication.status === 'accepted',
              'bg-red-100 text-red-800': existingApplication.status === 'rejected',
            }"
          >
            <span class="font-medium">Status: {{ formatStatus(existingApplication.status) }}</span>
          </div>
          <p class="text-sm text-gray-500 mt-2">
            Applied on {{ formatDate(existingApplication.applied_at) }}
          </p>
        </div>
        
        <div class="flex gap-4 justify-center">
          <BaseButton variant="outline" @click="router.push(`/jobs/${job.slug}`)">
            View Job
          </BaseButton>
          <BaseButton variant="primary" @click="router.push('/my-applications')">
            My Applications
          </BaseButton>
        </div>
      </div>

      <!-- Application Form -->
      <div v-else>
        <!-- Job Summary -->
        <BaseCard class="p-6 mb-6">
          <div class="flex items-start gap-4">
            <div class="w-16 h-16 bg-gradient-to-br from-primary-100 to-secondary-100 rounded-lg flex items-center justify-center flex-shrink-0">
              <img 
                v-if="job.company?.logo?.path" 
                :src="getLogoUrl(job.company.logo.path)" 
                :alt="job.company.name"
                class="w-full h-full object-contain rounded-lg"
              />
              <span v-else class="text-2xl font-bold text-primary-600">{{ job.company?.name?.[0] || '?' }}</span>
            </div>
            <div class="flex-1">
              <h1 class="text-2xl font-bold text-gray-900 mb-1">{{ job.title }}</h1>
              <p class="text-lg text-gray-600 mb-2">{{ job.company?.name }}</p>
              <div class="flex flex-wrap gap-3 text-sm text-gray-600">
                <span class="flex items-center gap-1">
                  <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                  </svg>
                  {{ job.location }}
                </span>
                <span class="flex items-center gap-1">
                  <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                  </svg>
                  {{ job.employment_type }}
                </span>
              </div>
            </div>
          </div>
        </BaseCard>

        <!-- Application Form -->
        <BaseCard class="p-8">
          <h2 class="text-xl font-bold text-gray-900 mb-6">Submit Your Application</h2>
          
          <form @submit.prevent="submitApplication">
            <!-- CV Selection -->
            <div class="mb-6">
              <label for="cv" class="block text-sm font-semibold text-gray-700 mb-2">
                Select Your CV <span class="text-gray-400 font-normal">(Optional)</span>
              </label>
              <select
                id="cv"
                v-model="applicationForm.cv_id"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              >
                <option value="">No CV attached</option>
                <option v-for="cv in userCvs" :key="cv.id" :value="cv.id">
                  {{ cv.full_name }} - {{ cv.title || 'Untitled' }}
                </option>
              </select>
              <p class="text-sm text-gray-500 mt-2">
                Select one of your CVs to attach to this application or apply without a CV.
                <router-link to="/my-cvs" class="text-primary-600 hover:text-primary-700">
                  Create a new CV
                </router-link>
              </p>
            </div>

            <!-- Cover Letter -->
            <div class="mb-6">
              <label for="cover_letter" class="block text-sm font-semibold text-gray-700 mb-2">
                Cover Letter <span class="text-gray-400 font-normal">(Optional)</span>
              </label>
              <textarea
                id="cover_letter"
                v-model="applicationForm.cover_letter"
                rows="8"
                maxlength="2000"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                placeholder="Explain why you're a great fit for this position..."
              ></textarea>
              <div class="flex justify-between items-center mt-2">
                <p class="text-sm text-gray-500">
                  Tell the employer why you're interested in this role and what makes you a great candidate.
                </p>
                <span class="text-sm text-gray-400">
                  {{ applicationForm.cover_letter?.length || 0 }} / 2000
                </span>
              </div>
            </div>

            <!-- Error Message -->
            <div v-if="error" class="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg">
              <p class="text-sm text-red-600">{{ error }}</p>
            </div>

            <!-- Action Buttons -->
            <div class="flex gap-4">
              <BaseButton
                type="button"
                variant="outline"
                @click="router.push(`/jobs/${job.slug}`)"
                :disabled="submitting"
              >
                Cancel
              </BaseButton>
              <BaseButton
                type="submit"
                variant="primary"
                :disabled="submitting"
                class="flex-1"
              >
                <span v-if="!submitting">Submit Application</span>
                <span v-else class="flex items-center justify-center gap-2">
                  <svg class="animate-spin h-5 w-5" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  Submitting...
                </span>
              </BaseButton>
            </div>
          </form>
        </BaseCard>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { jobService } from '@/services/job.service'
import { jobApplicationService } from '@/services/jobApplication.service'
import { userCvService } from '@/services/userCv.service'
import { useToast } from '@/composables/useToast'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import type { Job, UserCv, JobApplication } from '@/types'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const toast = useToast()

const job = ref<Job | null>(null)
const userCvs = ref<UserCv[]>([])
const loading = ref(true)
const submitting = ref(false)
const error = ref('')
const hasApplied = ref(false)
const existingApplication = ref<JobApplication | null>(null)

const applicationForm = ref({
  cv_id: '' as number | string,
  cover_letter: '',
})

// Check if user is authenticated
if (!authStore.isAuthenticated) {
  router.push({
    path: '/login',
    query: { redirect: route.fullPath }
  })
}

const fetchJobAndCheckApplication = async () => {
  loading.value = true
  try {
    const jobSlug = route.params.slug as string
    
    // Fetch job details
    const jobResponse = await jobService.getJob(jobSlug)
    if (jobResponse.success && jobResponse.data) {
      job.value = jobResponse.data
    }

    // Check if user already applied
    const checkResponse = await jobApplicationService.checkApplication(jobSlug)
    if (checkResponse.success && checkResponse.data) {
      hasApplied.value = checkResponse.data.has_applied
      existingApplication.value = checkResponse.data.application
    }

    // Fetch user's CVs
    const cvsResponse = await userCvService.getMyCvs()
    if (cvsResponse.success && cvsResponse.data) {
      userCvs.value = cvsResponse.data
      
      // Auto-select primary CV if available
      const primaryCv = userCvs.value.find(cv => cv.is_primary)
      if (primaryCv) {
        applicationForm.value.cv_id = primaryCv.id
      }
    }
  } catch (err) {
    console.error('Error loading job:', err)
    toast.error('Failed to load job details')
  } finally {
    loading.value = false
  }
}

const submitApplication = async () => {
  if (!job.value) return

  submitting.value = true
  error.value = ''

  try {
    const response = await jobApplicationService.applyForJob(job.value.slug, {
      cv_id: applicationForm.value.cv_id ? Number(applicationForm.value.cv_id) : undefined,
      cover_letter: applicationForm.value.cover_letter || undefined,
    })

    if (response.success) {
      toast.success('Application submitted successfully!')
      router.push('/my-applications')
    }
  } catch (err) {
    console.error('Error submitting application:', err)
    const errorMessage = (err as { response?: { data?: { message?: string } } }).response?.data?.message
    error.value = errorMessage || 'Failed to submit application. Please try again.'
  } finally {
    submitting.value = false
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
  return new Date(date).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

onMounted(() => {
  fetchJobAndCheckApplication()
})
</script>
