<template>
  <div class="container-custom py-8">
    <!-- Header -->
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-gray-900 mb-2">Saved Jobs</h1>
      <p class="text-gray-600">Jobs you've saved for later</p>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="flex justify-center items-center py-12">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
    </div>

    <!-- Error State -->
    <BaseAlert v-else-if="error" variant="error" class="mb-6">
      {{ error }}
    </BaseAlert>

    <!-- Empty State -->
    <div v-else-if="savedJobs.length === 0" class="text-center py-12">
      <div class="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
        <svg class="h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 5a2 2 0 012-2h10a2 2 0 012 2v16l-7-3.5L5 21V5z" />
        </svg>
      </div>
      <h3 class="text-xl font-semibold text-gray-900 mb-2">No Saved Jobs</h3>
      <p class="text-gray-600 mb-6">Start saving jobs to build your collection</p>
      <router-link to="/jobs" class="btn-primary">
        Browse Jobs
      </router-link>
    </div>

    <!-- Jobs Grid -->
    <div v-else class="grid gap-4">
      <BaseCard
        v-for="job in savedJobs"
        :key="job.id"
        clickable
        hoverable
        class="hover:shadow-lg transition-shadow"
        @click="viewJobDetail(job)"
      >
        <div class="flex items-start gap-4">
          <!-- Company Logo -->
          <div class="flex-shrink-0">
            <div v-if="job.company?.logo" class="w-16 h-16 rounded-lg overflow-hidden bg-white border border-gray-200">
              <img
                :src="job.company.logo.url"
                :alt="job.company.name"
                class="w-full h-full object-contain p-2"
              />
            </div>
            <div v-else class="w-16 h-16 bg-gray-100 rounded-lg flex items-center justify-center">
              <svg class="h-8 w-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
              </svg>
            </div>
          </div>

          <!-- Job Details -->
          <div class="flex-1 min-w-0">
            <h3 class="text-lg font-semibold text-gray-900 mb-1">{{ job.title }}</h3>
            <p class="text-gray-600 mb-2">{{ job.company?.name }}</p>
            
            <div class="flex flex-wrap items-center gap-3 text-sm text-gray-500">
              <div class="flex items-center gap-1">
                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                </svg>
                <span>{{ job.location }}</span>
              </div>
              
              <div class="flex items-center gap-1">
                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                </svg>
                <span>{{ formatEmploymentType(job.employment_type) }}</span>
              </div>

              <div v-if="job.salary_min && job.salary_max" class="flex items-center gap-1">
                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <span>${{ job.salary_min.toLocaleString() }} - ${{ job.salary_max.toLocaleString() }}</span>
              </div>
            </div>
          </div>

          <!-- Actions -->
          <div class="flex-shrink-0 flex items-start gap-2">
            <BaseButton
              variant="ghost"
              size="sm"
              @click.stop="handleUnsaveJob(job)"
              title="Remove from saved"
            >
              <template #icon-left>
                <svg class="h-5 w-5 text-yellow-500 fill-current" viewBox="0 0 24 24">
                  <path d="M17.593 3.322c1.1.128 1.907 1.077 1.907 2.185V21L12 17.25 4.5 21V5.507c0-1.108.806-2.057 1.907-2.185a48.507 48.507 0 0111.186 0z" />
                </svg>
              </template>
            </BaseButton>
          </div>
        </div>
      </BaseCard>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useSavedJobStore } from '@/stores/savedJob'
import { savedJobService } from '@/services/savedJob.service'
import type { Job } from '@/types'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseAlert from '@/components/base/BaseAlert.vue'
import { useToast } from '@/composables/useToast'

const router = useRouter()
const toast = useToast()
const savedJobStore = useSavedJobStore()

const savedJobs = ref<Job[]>([])
const loading = ref(true)
const error = ref('')

const formatEmploymentType = (type: string) => {
  const types: Record<string, string> = {
    'full-time': 'Full-time',
    'part-time': 'Part-time',
    'contract': 'Contract',
    'freelance': 'Freelance',
    'internship': 'Internship',
  }
  return types[type] || type
}

const fetchSavedJobs = async () => {
  try {
    loading.value = true
    error.value = ''
    const response = await savedJobService.getSavedJobs()
    if (response.success && response.data) {
      savedJobs.value = response.data
    }
  } catch (err: unknown) {
    const errorMessage = err && typeof err === 'object' && 'response' in err
      ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
      : undefined
    error.value = errorMessage || 'Failed to load saved jobs'
  } finally {
    loading.value = false
  }
}

const handleUnsaveJob = async (job: Job) => {
  try {
    await savedJobStore.unsaveJob(job.id)
    savedJobs.value = savedJobs.value.filter(j => j.id !== job.id)
    toast.success('Job removed from saved')
  } catch (err: unknown) {
    const errorMessage = err && typeof err === 'object' && 'response' in err
      ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
      : undefined
    toast.error(errorMessage || 'Failed to unsave job')
  }
}

const viewJobDetail = (job: Job) => {
  router.push({ name: 'job-detail', params: { slug: job.slug } })
}

onMounted(() => {
  fetchSavedJobs()
})
</script>
