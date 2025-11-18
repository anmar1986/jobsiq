<template>
  <div class="container-custom py-8">
    <!-- Header -->
    <div class="mb-8">
      <button @click="router.back()" class="flex items-center gap-2 text-gray-600 hover:text-gray-900 mb-4 transition-colors">
        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
        </svg>
        Back
      </button>
      <h1 class="text-3xl font-bold text-gray-900">Edit Job</h1>
      <p class="text-gray-600 mt-2">Update the details below to modify your job posting</p>
    </div>

    <!-- Loading State -->
    <div v-if="loadingJob" class="flex items-center justify-center py-12">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
    </div>

    <!-- Job Form -->
    <BaseCard v-else-if="job" class="max-w-4xl">
      <div class="p-6 md:p-8">
        <JobForm
          :job="job"
          :user-companies="userCompanies"
          :loading="submitting"
          @submit="handleSubmit"
          @cancel="handleCancel"
        />
      </div>
    </BaseCard>

    <!-- Error State (no job found) -->
    <BaseCard v-else class="max-w-4xl p-12 text-center">
      <svg class="h-16 w-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
      </svg>
      <h2 class="text-2xl font-bold text-gray-900 mb-2">Job Not Found</h2>
      <p class="text-gray-600 mb-6">The job you are trying to edit does not exist or you don't have permission to edit it.</p>
      <BaseButton variant="primary" @click="router.push({ name: 'my-companies' })">
        Go to My Companies
      </BaseButton>
    </BaseCard>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useToast } from '@/composables/useToast'
import { companyService } from '@/services/cv.service'
import { jobService } from '@/services/job.service'
import type { Company, Job } from '@/types'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import JobForm from '@/views/jobs/JobForm.vue'

const router = useRouter()
const route = useRoute()
const toast = useToast()

const loadingJob = ref(false)
const loadingCompanies = ref(false)
const submitting = ref(false)
const job = ref<Job | null>(null)
const userCompanies = ref<Company[]>([])

const loadJob = async () => {
  loadingJob.value = true
  try {
    // Handle both route parameter names: 'id' and 'jobId'
    const jobId = parseInt((route.params.jobId || route.params.id) as string)
    const response = await jobService.getJob(jobId)
    
    if (response.success && response.data) {
      job.value = response.data
      
      // Verify user has permission to edit this job
      // Load companies to check ownership
      await loadCompanies()
      
      const userCompanyIds = userCompanies.value.map(c => c.id)
      
      if (job.value && !userCompanyIds.includes(job.value.company_id)) {
        toast.error('You do not have permission to edit this job')
        job.value = null
      }
    }
  } catch (error) {
    console.error('Failed to load job:', error)
    const err = error as { response?: { data?: { message?: string } } }
    toast.error(err.response?.data?.message || 'Failed to load job')
    job.value = null
  } finally {
    loadingJob.value = false
  }
}

const loadCompanies = async () => {
  loadingCompanies.value = true
  try {
    const response = await companyService.getMyCompanies()
    if (response.success && response.data) {
      userCompanies.value = response.data
    }
  } catch (error) {
    console.error('Failed to load companies:', error)
    const err = error as { response?: { data?: { message?: string } } }
    toast.error(err.response?.data?.message || 'Failed to load your companies')
  } finally {
    loadingCompanies.value = false
  }
}

const handleSubmit = async (jobData: Record<string, unknown>) => {
  if (!job.value) return
  
  submitting.value = true
  try {
    const response = await jobService.updateJob(job.value.id, jobData)
    if (response.success && response.data) {
      job.value = response.data
      toast.success('Job updated successfully')
      router.push({ name: 'my-companies' })
    }
  } catch (error) {
    console.error('Failed to update job:', error)
    const err = error as { response?: { data?: { message?: string; errors?: Record<string, string[]> } } }
    
    // Show validation errors if available
    if (err.response?.data?.errors) {
      const errors = err.response.data.errors
      const firstError = Object.values(errors)[0]?.[0]
      toast.error(firstError || 'Please check your input and try again')
    } else {
      // Show generic error message
      const message = err.response?.data?.message || 'Failed to update job'
      toast.error(message)
    }
  } finally {
    submitting.value = false
  }
}

const handleCancel = () => {
  router.back()
}

onMounted(() => {
  loadJob()
})
</script>
