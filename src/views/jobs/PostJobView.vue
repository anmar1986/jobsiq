<template>
  <div class="container-custom py-8">
    <!-- Header -->
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-gray-900">{{ $t('jobs.postJob') }}</h1>
      <p class="text-gray-600 mt-2">{{ $t('jobs.fillDetailsToCreateJob') }}</p>
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
import { useI18n } from 'vue-i18n'
import { useToast } from '@/composables/useToast'
import { companyService } from '@/services/cv.service'
import { jobService } from '@/services/job.service'
import type { Company } from '@/types'
import BaseCard from '@/components/base/BaseCard.vue'
import JobForm from '@/views/jobs/JobForm.vue'

const router = useRouter()
const toast = useToast()
const { t } = useI18n()

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
    toast.error(err.response?.data?.message || t('jobs.failedToLoadCompanies'))
  } finally {
    loadingCompanies.value = false
  }
}

const handleSubmit = async (jobData: Record<string, unknown>) => {
  submitting.value = true
  try {
    const response = await jobService.createJob(jobData as never)
    if (response.success && response.data) {
      toast.success(t('jobs.jobCreatedSuccessfully'))
      // Redirect to My Companies page
      router.push({ name: 'my-companies' })
    }
  } catch (error) {
    console.error('Failed to create job:', error)
    const err = error as { response?: { data?: { message?: string; errors?: Record<string, string[]> } } }
    
    // Show validation errors if available
    if (err.response?.data?.errors) {
      const errors = err.response.data.errors
      const firstError = Object.values(errors)[0]?.[0]
      toast.error(firstError || t('jobs.pleaseCheckYourInput'))
    } else {
      // Show generic error message
      const message = err.response?.data?.message || t('jobs.failedToPostJob')
      toast.error(message)
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
