<template>
  <div class="container-custom py-8">
    <!-- Header -->
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-gray-900">Post a Job</h1>
      <p class="text-gray-600 mt-2">Fill out the details below to create a new job posting</p>
    </div>

    <!-- Loading State -->
    <div v-if="loadingCompanies" class="flex items-center justify-center py-12">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
    </div>

    <!-- Job Form -->
    <BaseCard v-else class="max-w-4xl">
      <div class="p-6 md:p-8">
        <JobForm
          :user-companies="userCompanies"
          :loading="submitting"
          @submit="handleSubmit"
          @cancel="handleCancel"
        />
      </div>
    </BaseCard>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useToast } from '@/composables/useToast'
import { companyService } from '@/services/cv.service'
import { jobService } from '@/services/job.service'
import type { Company } from '@/types'
import BaseCard from '@/components/base/BaseCard.vue'
import JobForm from '@/views/jobs/JobForm.vue'

const router = useRouter()
const toast = useToast()

const loadingCompanies = ref(false)
const submitting = ref(false)
const userCompanies = ref<Company[]>([])

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
  submitting.value = true
  try {
    const response = await jobService.createJob(jobData as never)
    if (response.success && response.data) {
      toast.success('New job created successfully!')
      // Redirect to My Companies page
      router.push({ name: 'my-companies' })
    }
  } catch (error) {
    console.error('Failed to create job:', error)
    const err = error as { response?: { data?: { message?: string; errors?: Record<string, string[]> } } }
    const message = err.response?.data?.message || 'Failed to post job'
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
  router.push({ name: 'my-companies' })
}

onMounted(() => {
  loadCompanies()
})
</script>
