<template>
  <div class="bg-gray-50 min-h-screen">
    <!-- Loading State -->
    <div v-if="loading" class="container-custom py-8">
      <div class="animate-pulse space-y-8">
        <div class="h-32 bg-gray-200 rounded-lg"></div>
        <div class="bg-white rounded-lg p-8">
          <div class="h-6 bg-gray-200 rounded w-1/2 mb-4"></div>
          <div class="space-y-2">
            <div class="h-4 bg-gray-200 rounded w-full"></div>
            <div class="h-4 bg-gray-200 rounded w-5/6"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Error State -->
    <div v-else-if="!job || accessDenied" class="container-custom py-16">
      <BaseCard class="p-12 text-center">
        <svg class="h-16 w-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
        </svg>
        <h2 class="text-2xl font-bold text-gray-900 mb-2">
          {{ accessDenied ? 'Access Denied' : 'Job Not Found' }}
        </h2>
        <p class="text-gray-600 mb-6">
          {{ accessDenied 
            ? 'You do not have permission to view this job.' 
            : 'The job you are looking for does not exist.' 
          }}
        </p>
        <BaseButton variant="primary" @click="goBack">
          Back to Company
        </BaseButton>
      </BaseCard>
    </div>

    <!-- Job Detail Content -->
    <div v-else>
      <!-- Header -->
      <div class="bg-white border-b border-gray-200">
        <div class="container-custom py-6">
          <button @click="goBack" class="flex items-center gap-2 text-gray-600 hover:text-gray-900 mb-4 transition-colors">
            <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
            Back to {{ company?.name }}
          </button>
          
          <div class="flex items-start justify-between">
            <div class="flex-1">
              <h1 class="text-3xl font-bold text-gray-900 mb-3">{{ job.title }}</h1>
              <div class="flex flex-wrap gap-4 text-gray-600">
                <span class="flex items-center gap-2">
                  <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                  </svg>
                  {{ job.location }}
                </span>
                <span class="flex items-center gap-2">
                  <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                  </svg>
                  {{ formatEmploymentType(job.employment_type) }}
                </span>
                <span class="flex items-center gap-2">
                  <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  Posted {{ formatJobDate(job.created_at) }}
                </span>
              </div>
            </div>
            
            <!-- Action Buttons -->
            <div class="flex gap-2 ml-4">
              <BaseButton
                variant="outline"
                size="sm"
                @click="editJob"
              >
                <svg class="h-4 w-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                </svg>
                Edit Job
              </BaseButton>
              <BaseButton
                variant="outline"
                size="sm"
                @click="viewPublicJob"
              >
                <svg class="h-4 w-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                </svg>
                Public View
              </BaseButton>
            </div>
          </div>
        </div>
      </div>

      <!-- Main Content -->
      <div class="container-custom py-8">
        <div class="grid lg:grid-cols-3 gap-8">
          <!-- Main Content -->
          <div class="lg:col-span-2">
            <BaseCard class="p-8 mb-6">
              <h2 class="text-xl font-bold text-gray-900 mb-4">Job Description</h2>
              <div class="prose prose-gray max-w-none">
                <p class="text-gray-700 whitespace-pre-line">{{ job.description }}</p>
              </div>
            </BaseCard>

            <BaseCard v-if="job.requirements" class="p-8 mb-6">
              <h2 class="text-xl font-bold text-gray-900 mb-4">Requirements</h2>
              <div class="prose prose-gray max-w-none">
                <p class="text-gray-700 whitespace-pre-line">{{ job.requirements }}</p>
              </div>
            </BaseCard>

            <BaseCard v-if="job.benefits" class="p-8">
              <h2 class="text-xl font-bold text-gray-900 mb-4">Benefits</h2>
              <div class="prose prose-gray max-w-none">
                <p class="text-gray-700 whitespace-pre-line">{{ job.benefits }}</p>
              </div>
            </BaseCard>
          </div>

          <!-- Sidebar -->
          <div class="lg:col-span-1">
            <BaseCard class="p-6 mb-6">
              <h3 class="font-semibold text-gray-900 mb-4">Job Details</h3>
              <div class="space-y-4">
                <div v-if="job.salary_min && job.salary_max">
                  <p class="text-sm text-gray-600 mb-1">Salary Range</p>
                  <p class="text-lg font-semibold text-primary-600">
                    {{ formatSalary(job.salary_min, job.salary_max) }}
                  </p>
                  <p class="text-xs text-gray-500">{{ job.salary_currency }}</p>
                </div>

                <div>
                  <p class="text-sm text-gray-600 mb-1">Experience Level</p>
                  <BaseBadge :variant="getBadgeVariant(job.experience_level)">
                    {{ formatExperienceLevel(job.experience_level) }}
                  </BaseBadge>
                </div>

                <div v-if="job.category">
                  <p class="text-sm text-gray-600 mb-1">Category</p>
                  <p class="text-gray-900">{{ job.category }}</p>
                </div>

                <div v-if="job.is_remote">
                  <p class="text-sm text-gray-600 mb-1">Remote Work</p>
                  <BaseBadge variant="success">Remote Friendly</BaseBadge>
                </div>

                <div>
                  <p class="text-sm text-gray-600 mb-1">Job Type</p>
                  <p class="text-gray-900">{{ formatEmploymentType(job.employment_type) }}</p>
                </div>

                <div>
                  <p class="text-sm text-gray-600 mb-1">Status</p>
                  <BaseBadge :variant="job.is_active ? 'success' : 'danger'">
                    {{ job.is_active ? 'Active' : 'Inactive' }}
                  </BaseBadge>
                </div>
              </div>
            </BaseCard>

            <BaseCard class="p-6">
              <h3 class="font-semibold text-gray-900 mb-4">Quick Actions</h3>
              <div class="space-y-2">
                <BaseButton
                  variant="outline"
                  class="w-full justify-start"
                  @click="editJob"
                >
                  <svg class="h-4 w-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                  </svg>
                  Edit Job
                </BaseButton>
                <BaseButton
                  variant="outline"
                  class="w-full justify-start"
                  @click="viewPublicJob"
                >
                  <svg class="h-4 w-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                  </svg>
                  View Public Page
                </BaseButton>
                <BaseButton
                  variant="outline"
                  class="w-full justify-start text-red-600 hover:text-red-700 hover:border-red-600"
                  @click="confirmDelete"
                >
                  <svg class="h-4 w-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                  </svg>
                  Delete Job
                </BaseButton>
              </div>
            </BaseCard>
          </div>
        </div>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <BaseModal
      v-model="showDeleteModal"
      title="Delete Job"
      size="sm"
    >
      <div class="p-6">
        <p class="text-gray-700 mb-6">
          Are you sure you want to delete <strong>{{ job?.title }}</strong>? 
          This action cannot be undone.
        </p>
        <div class="flex items-center justify-end gap-3">
          <BaseButton
            variant="outline"
            @click="showDeleteModal = false"
            :disabled="deleting"
          >
            Cancel
          </BaseButton>
          <BaseButton
            variant="primary"
            @click="handleDelete"
            :loading="deleting"
            class="bg-red-600 hover:bg-red-700"
          >
            Delete Job
          </BaseButton>
        </div>
      </div>
    </BaseModal>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { companyService } from '@/services/cv.service'
import { jobService } from '@/services/job.service'
import { useToast } from '@/composables/useToast'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseBadge from '@/components/base/BaseBadge.vue'
import BaseModal from '@/components/base/BaseModal.vue'
import type { Company, Job } from '@/types'

const router = useRouter()
const route = useRoute()
const toast = useToast()

const loading = ref(true)
const job = ref<Job | null>(null)
const company = ref<Company | null>(null)
const accessDenied = ref(false)
const showDeleteModal = ref(false)
const deleting = ref(false)

const formatEmploymentType = (type: string): string => {
  const types: Record<string, string> = {
    'full-time': 'Full-time',
    'part-time': 'Part-time',
    'contract': 'Contract',
    'freelance': 'Freelance',
    'internship': 'Internship',
  }
  return types[type] || type
}

const formatExperienceLevel = (level: string): string => {
  const levels: Record<string, string> = {
    'entry': 'Entry Level',
    'mid': 'Mid Level',
    'senior': 'Senior',
    'lead': 'Lead',
    'executive': 'Executive',
  }
  return levels[level] || level
}

const formatJobDate = (date: string): string => {
  const now = new Date()
  const postDate = new Date(date)
  const diffTime = Math.abs(now.getTime() - postDate.getTime())
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
  
  if (diffDays === 0) return 'Today'
  if (diffDays === 1) return 'Yesterday'
  if (diffDays < 7) return `${diffDays} days ago`
  if (diffDays < 30) return `${Math.floor(diffDays / 7)} weeks ago`
  return `${Math.floor(diffDays / 30)} months ago`
}

const formatNumber = (num: number): string => {
  if (num >= 1000000) return (num / 1000000).toFixed(1) + 'M'
  if (num >= 1000) return (num / 1000).toFixed(1) + 'K'
  return num.toString()
}

const formatSalary = (min: number, max: number): string => {
  if (!min && !max) return 'Competitive'
  if (min && max) {
    return `$${formatNumber(min)} - $${formatNumber(max)}`
  }
  if (min) return `From $${formatNumber(min)}`
  if (max) return `Up to $${formatNumber(max)}`
  return 'Competitive'
}

const getBadgeVariant = (level: string): 'primary' | 'secondary' | 'success' | 'warning' | 'danger' | 'info' => {
  const variants: Record<string, 'primary' | 'secondary' | 'success' | 'warning' | 'danger' | 'info'> = {
    'entry': 'success',
    'mid': 'info',
    'senior': 'warning',
    'lead': 'secondary',
    'executive': 'primary',
  }
  return variants[level] || 'info'
}

const goBack = () => {
  router.push({
    name: 'view-my-company',
    params: { id: route.params.companyId }
  })
}

const editJob = () => {
  router.push({
    name: 'edit-company-job',
    params: { 
      companyId: route.params.companyId,
      jobId: route.params.jobId 
    }
  })
}

const viewPublicJob = () => {
  if (job.value?.slug) {
    window.open(`/jobs/${job.value.slug}`, '_blank')
  }
}

const confirmDelete = () => {
  showDeleteModal.value = true
}

const handleDelete = async () => {
  if (!job.value) return
  
  deleting.value = true
  try {
    const response = await jobService.deleteJob(job.value.id)
    if (response.success) {
      toast.success('Job deleted successfully!')
      goBack()
    }
  } catch (error) {
    console.error('Failed to delete job:', error)
    const err = error as { response?: { data?: { message?: string } } }
    toast.error(err.response?.data?.message || 'Failed to delete job')
  } finally {
    deleting.value = false
  }
}

const fetchJobAndCompany = async () => {
  loading.value = true
  accessDenied.value = false
  
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
          
          // Verify job belongs to this company
          if (job.value.company_id !== foundCompany.id) {
            accessDenied.value = true
            toast.error('This job does not belong to the selected company')
          }
        }
      } else {
        accessDenied.value = true
        toast.error('You do not have permission to view this company')
      }
    }
  } catch (error) {
    console.error('Failed to fetch job:', error)
    const err = error as { response?: { data?: { message?: string } } }
    toast.error(err.response?.data?.message || 'Failed to load job details')
    job.value = null
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchJobAndCompany()
})
</script>
