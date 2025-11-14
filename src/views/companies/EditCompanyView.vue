<template>
  <div class="container-custom py-8">
    <!-- Header -->
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-gray-900">Edit Company</h1>
      <p class="text-gray-600 mt-2">Update your company information</p>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="flex items-center justify-center py-12">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
    </div>

    <!-- Company Form -->
    <BaseCard v-else-if="company" class="max-w-4xl">
      <div class="p-6 md:p-8">
        <CompanyForm
          :company="company"
          :loading="submitting"
          @submit="handleSubmit"
          @cancel="handleCancel"
        />
      </div>
    </BaseCard>

    <!-- Error State -->
    <div v-else class="text-center py-12">
      <p class="text-gray-600 mb-4">Company not found</p>
      <BaseButton variant="primary" @click="handleCancel">
        Go Back
      </BaseButton>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useToast } from '@/composables/useToast'
import { companyService } from '@/services/cv.service'
import type { Company } from '@/types'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import CompanyForm from '@/views/companies/CompanyForm.vue'

const router = useRouter()
const route = useRoute()
const toast = useToast()

const loading = ref(false)
const submitting = ref(false)
const company = ref<Company | null>(null)

const loadCompany = async () => {
  const id = route.params.id
  console.log('Loading company with ID:', id)
  if (!id) {
    router.push({ name: 'dashboard' })
    return
  }

  loading.value = true
  try {
    const response = await companyService.getCompany(id as string)
    console.log('Company response:', response)
    if (response.success && response.data) {
      company.value = response.data
      console.log('Company loaded successfully:', company.value)
    } else {
      console.error('Response not successful:', response)
      toast.error('Failed to load company details')
    }
  } catch (error) {
    console.error('Failed to load company:', error)
    const err = error as { response?: { data?: { message?: string } } }
    toast.error(err.response?.data?.message || 'Failed to load company details')
  } finally {
    loading.value = false
  }
}

const handleSubmit = async (formData: FormData) => {
  if (!company.value) return
  
  submitting.value = true
  try {
    console.log('Submitting company update for ID:', company.value.id)
    const response = await companyService.updateCompany(company.value.id, formData)
    console.log('Update response received:', response)
    
    if (response.success && response.data) {
      console.log('Update successful, showing toast and redirecting')
      toast.success('Company updated successfully!')
      // Update the local company data with the response
      company.value = response.data
      // Redirect back to the company profile using the updated slug
      router.push({ name: 'view-my-company', params: { slug: response.data.slug } })
    } else {
      console.log('Response not successful or no data:', response)
      toast.error(response.message || 'Failed to update company')
    }
  } catch (error) {
    console.error('Failed to update company:', error)
    const err = error as { response?: { data?: { message?: string, errors?: Record<string, string[]> } } }
    // Check for validation errors
    if (err.response?.data?.errors) {
      const firstError = Object.values(err.response.data.errors)[0]?.[0]
      toast.error(firstError || 'Failed to update company')
    } else {
      toast.error(err.response?.data?.message || 'Failed to update company')
    }
  } finally {
    submitting.value = false
  }
}

const handleCancel = () => {
  // Go back to the company profile if we have a company, otherwise to dashboard
  if (company.value) {
    router.push({ name: 'view-my-company', params: { slug: company.value.slug } })
  } else {
    router.push({ name: 'dashboard' })
  }
}

onMounted(() => {
  loadCompany()
})
</script>
