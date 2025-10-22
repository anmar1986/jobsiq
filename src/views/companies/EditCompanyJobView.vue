<template>
  <div class="container-custom py-8">
    <!-- Header -->
    <div class="mb-8">
      <button @click="goBack" class="flex items-center gap-2 text-gray-600 hover:text-gray-900 mb-4 transition-colors">
        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
        </svg>
        Back to {{ company?.name }}
      </button>
      <h1 class="text-3xl font-bold text-gray-900">Edit Job</h1>
      <p class="text-gray-600 mt-2">Update the details below to modify your job posting</p>
    </div>

    <!-- Loading State -->
    <div v-if="loadingJob" class="flex items-center justify-center py-12">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
    </div>

    <!-- Error State -->
    <BaseCard v-else-if="!job && !loadingJob" class="max-w-4xl p-12 text-center">
      <svg class="h-16 w-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
      </svg>
      <h2 class="text-2xl font-bold text-gray-900 mb-2">Job Not Found</h2>
      <p class="text-gray-600 mb-6">The job you are trying to edit does not exist or you don't have permission to edit it.</p>
      <BaseButton variant="primary" @click="goBack">
        Back to Company
      </BaseButton>
    </BaseCard>

    <!-- Job Form -->
    <BaseCard v-else class="max-w-4xl">
      <div class="p-6 md:p-8">
        <JobForm
          v-if="company"
          :initial-data="job"
          :user-companies="[company]"
          :loading="submitting"
          :is-edit="true"
          @submit="handleSubmit"
          @cancel="handleCancel"
        />
      </div>
    </BaseCard>

    <!-- Success Modal -->
    <BaseModal
      v-model="showSuccessModal"
      title="Job Updated Successfully!"
      size="sm"
    >
      <div class="p-6 text-center">
        <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
          <svg class="h-8 w-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
          </svg>
        </div>
        <h3 class="text-lg font-semibold text-gray-900 mb-2">Your job has been updated!</h3>
        <p class="text-gray-600 mb-6">Your changes have been saved successfully.</p>
        <div class="flex flex-col gap-3">
          <BaseButton
            variant="primary"
            @click="viewJob"
            class="w-full"
          >
            View Job
          </BaseButton>
          <BaseButton
            variant="ghost"
            @click="goBack"
            class="w-full"
          >
            Back to Company
          </BaseButton>
        </div>
      </div>
    </BaseModal>
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
import BaseModal from '@/components/base/BaseModal.vue'
import JobForm from '@/views/jobs/JobForm.vue'

const router = useRouter()
const route = useRoute()
const toast = useToast()

const loadingJob = ref(false)
const submitting = ref(false)
const job = ref<Job | null>(null)
const company = ref<Company | null>(null)
const showSuccessModal = ref(false)

const goBack = () => {
  router.push({
    name: 'view-my-company',
    params: { id: route.params.companyId }
  })
}

const loadJobAndCompany = async () => {
  loadingJob.value = true
  try {
    const companyId = route.params.companyId as string
    const jobId = parseInt(route.params.jobId as string)
    
    // Fetch user's companies to verify ownership
    const companiesResponse = await companyService.getMyCompanies()
    
    if (companiesResponse.success && companiesResponse.data) {
      const foundCompany = companiesResponse.data.find((c: Company) => c.id.toString() === companyId)
      
      if (foundCompany) {
        company.value = foundCompany
        
        // Fetch job details
        const jobResponse = await jobService.getJob(jobId)
        if (jobResponse.success && jobResponse.data) {
          job.value = jobResponse.data
          
          // Verify job belongs to this company and user has permission
          if (job.value.company_id !== foundCompany.id) {
            toast.error('You do not have permission to edit this job')
            job.value = null
          }
        }
      } else {
        toast.error('Company not found or you do not have permission')
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

const handleSubmit = async (jobData: Record<string, unknown>) => {
  if (!job.value) return
  
  submitting.value = true
  try {
    const response = await jobService.updateJob(job.value.id, jobData)
    if (response.success && response.data) {
      job.value = response.data
      showSuccessModal.value = true
    }
  } catch (error) {
    console.error('Failed to update job:', error)
    const err = error as { response?: { data?: { message?: string; errors?: Record<string, string[]> } } }
    const message = err.response?.data?.message || 'Failed to update job'
    toast.error(message)
    
    // Handle validation errors if any
    if (err.response?.data?.errors) {
      console.error('Validation errors:', err.response.data.errors)
    }
  } finally {
    submitting.value = false
  }
}

const handleCancel = () => {
  goBack()
}

const viewJob = () => {
  router.push({
    name: 'view-company-job',
    params: { 
      companyId: route.params.companyId,
      jobId: route.params.jobId 
    }
  })
}

onMounted(() => {
  loadJobAndCompany()
})
</script>
