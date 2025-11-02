<template>
  <div class="container-custom py-8">
    <!-- Header -->
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-gray-900">Create Company</h1>
      <p class="text-gray-600 mt-2">Fill out your company information to start posting jobs</p>
    </div>

    <!-- Company Form -->
    <BaseCard class="max-w-4xl">
      <div class="p-6 md:p-8">
        <CompanyForm
          :loading="submitting"
          @submit="handleSubmit"
          @cancel="handleCancel"
        />
      </div>
    </BaseCard>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useToast } from '@/composables/useToast'
import { companyService } from '@/services/cv.service'
import BaseCard from '@/components/base/BaseCard.vue'
import CompanyForm from '@/views/companies/CompanyForm.vue'

const router = useRouter()
const toast = useToast()
const submitting = ref(false)

const handleSubmit = async (formData: FormData) => {
  submitting.value = true
  try {
    const response = await companyService.createCompany(formData)
    
    if (response.success && response.data) {
      toast.success('Company created successfully!')
      // Redirect to the company profile using the slug
      router.push({ name: 'view-my-company', params: { slug: response.data.slug } })
    }
  } catch (error) {
    console.error('Failed to create company:', error)
    const err = error as { response?: { data?: { message?: string } } }
    toast.error(err.response?.data?.message || 'Failed to create company')
  } finally {
    submitting.value = false
  }
}

const handleCancel = () => {
  router.push({ name: 'my-companies' })
}
</script>
