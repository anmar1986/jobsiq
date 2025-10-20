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

    <!-- Company Not Found -->
    <div v-else-if="!company" class="container-custom py-16">
      <BaseCard class="p-12 text-center">
        <svg class="h-16 w-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
        </svg>
        <h2 class="text-2xl font-bold text-gray-900 mb-2">Company Not Found</h2>
        <p class="text-gray-600 mb-6">The company you're looking for doesn't exist or has been removed.</p>
        <BaseButton variant="primary" @click="router.push('/companies')">Browse All Companies</BaseButton>
      </BaseCard>
    </div>

    <!-- Company Detail Content -->
    <div v-else>
      <!-- Hero Banner -->
      <div class="bg-gradient-to-br from-primary-600 to-secondary-600 text-white">
        <div class="container-custom py-12">
          <button @click="router.back()" class="flex items-center gap-2 text-white/80 hover:text-white mb-6 transition-colors">
            <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
            Back to Companies
          </button>

          <div class="flex items-start gap-6">
            <!-- Company Logo -->
            <div class="w-24 h-24 rounded-2xl bg-white/10 backdrop-blur-sm flex items-center justify-center text-white text-3xl font-bold flex-shrink-0 border-2 border-white/20">
              {{ company.name.charAt(0) }}
            </div>

            <div class="flex-1">
              <h1 class="text-4xl md:text-5xl font-bold mb-3">{{ company.name }}</h1>
              <div class="flex flex-wrap gap-4 text-white/90 mb-4">
                <span v-if="company.city" class="flex items-center gap-1.5">
                  <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                  </svg>
                  {{ company.city }}, {{ company.country }}
                </span>
                <span v-if="company.website" class="flex items-center gap-1.5">
                  <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9" />
                  </svg>
                  <a :href="company.website" target="_blank" class="hover:underline">
                    {{ formatWebsite(company.website) }}
                  </a>
                </span>
              </div>
              <p v-if="company.description" class="text-lg text-white/90 leading-relaxed max-w-3xl">
                {{ company.description }}
              </p>
            </div>
          </div>
        </div>
      </div>

      <!-- Stats Bar -->
      <div class="bg-white border-b border-gray-200 shadow-sm">
        <div class="container-custom">
          <div class="grid grid-cols-2 md:grid-cols-4 gap-4 py-6">
            <div class="text-center">
              <p class="text-3xl font-bold text-primary-600">{{ company.jobs_count || 0 }}</p>
              <p class="text-sm text-gray-600 mt-1">Open Positions</p>
            </div>
            <div class="text-center">
              <p class="text-3xl font-bold text-primary-600">{{ formatDate(company.created_at) }}</p>
              <p class="text-sm text-gray-600 mt-1">On JobsIQ Since</p>
            </div>
            <div v-if="company.city" class="text-center">
              <p class="text-3xl font-bold text-primary-600">1</p>
              <p class="text-sm text-gray-600 mt-1">Location</p>
            </div>
            <div class="text-center">
              <p class="text-3xl font-bold text-primary-600">{{ company.is_active ? 'Active' : 'Inactive' }}</p>
              <p class="text-sm text-gray-600 mt-1">Status</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Main Content -->
      <div class="container-custom py-8">
        <div class="flex flex-col lg:flex-row gap-8">
          <!-- Left Content -->
          <div class="flex-1">
            <!-- About Section -->
            <BaseCard class="p-8 mb-8">
              <h2 class="text-2xl font-bold text-gray-900 mb-6">About {{ company.name }}</h2>
              <div class="prose prose-gray max-w-none">
                <p class="text-gray-700 leading-relaxed">
                  {{ company.description || 'No detailed description available for this company.' }}
                </p>
              </div>
            </BaseCard>

            <!-- Open Positions -->
            <BaseCard class="p-8">
              <div class="flex items-center justify-between mb-6">
                <h2 class="text-2xl font-bold text-gray-900">Open Positions ({{ jobs.length }})</h2>
                <BaseButton v-if="jobs.length > 0" variant="outline" size="sm" @click="viewAllJobs">
                  View All
                </BaseButton>
              </div>

              <!-- Jobs List -->
              <div v-if="loadingJobs" class="space-y-4">
                <div v-for="i in 3" :key="i" class="animate-pulse border border-gray-200 rounded-lg p-6">
                  <div class="h-5 bg-gray-200 rounded w-3/4 mb-3"></div>
                  <div class="h-4 bg-gray-200 rounded w-1/2"></div>
                </div>
              </div>

              <div v-else-if="jobs.length > 0" class="space-y-4">
                <router-link
                  v-for="job in jobs"
                  :key="job.id"
                  :to="`/jobs/${job.slug}`"
                  class="block border border-gray-200 rounded-lg p-6 hover:border-primary-500 hover:shadow-md transition-all group"
                >
                  <div class="flex items-start justify-between mb-3">
                    <div class="flex-1">
                      <h3 class="text-lg font-semibold text-gray-900 group-hover:text-primary-600 transition-colors mb-2">
                        {{ job.title }}
                      </h3>
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
                          {{ formatEmploymentType(job.employment_type) }}
                        </span>
                        <span class="flex items-center gap-1">
                          <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                          </svg>
                          {{ formatJobDate(job.created_at) }}
                        </span>
                      </div>
                    </div>
                    <div v-if="job.salary_min && job.salary_max" class="text-right ml-4">
                      <p class="text-lg font-bold text-primary-600">
                        {{ formatSalary(job.salary_min, job.salary_max) }}
                      </p>
                      <p class="text-xs text-gray-500">{{ job.salary_currency }}</p>
                    </div>
                  </div>

                  <div class="flex flex-wrap gap-2">
                    <BaseBadge :variant="getBadgeVariant(job.experience_level)">
                      {{ formatExperienceLevel(job.experience_level) }}
                    </BaseBadge>
                    <BaseBadge v-if="job.is_remote" variant="success">Remote</BaseBadge>
                    <BaseBadge v-if="job.category" variant="info">{{ job.category }}</BaseBadge>
                  </div>
                </router-link>
              </div>

              <div v-else class="text-center py-12">
                <svg class="h-16 w-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                </svg>
                <h3 class="text-lg font-semibold text-gray-900 mb-2">No Open Positions</h3>
                <p class="text-gray-600">This company doesn't have any active job postings at the moment.</p>
              </div>
            </BaseCard>
          </div>

          <!-- Right Sidebar -->
          <aside class="lg:w-80 flex-shrink-0">
            <!-- Contact Information -->
            <BaseCard class="p-6 mb-6">
              <h3 class="font-semibold text-gray-900 mb-4">Contact Information</h3>
              <div class="space-y-4">
                <div v-if="company.email" class="flex items-start gap-3">
                  <svg class="h-5 w-5 text-gray-400 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                  </svg>
                  <div class="flex-1 min-w-0">
                    <p class="text-sm text-gray-600 mb-1">Email</p>
                    <a :href="`mailto:${company.email}`" class="text-sm text-primary-600 hover:text-primary-700 break-all">
                      {{ company.email }}
                    </a>
                  </div>
                </div>

                <div v-if="company.phone" class="flex items-start gap-3">
                  <svg class="h-5 w-5 text-gray-400 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                  </svg>
                  <div class="flex-1 min-w-0">
                    <p class="text-sm text-gray-600 mb-1">Phone</p>
                    <a :href="`tel:${company.phone}`" class="text-sm text-primary-600 hover:text-primary-700">
                      {{ company.phone }}
                    </a>
                  </div>
                </div>

                <div v-if="company.website" class="flex items-start gap-3">
                  <svg class="h-5 w-5 text-gray-400 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9" />
                  </svg>
                  <div class="flex-1 min-w-0">
                    <p class="text-sm text-gray-600 mb-1">Website</p>
                    <a :href="company.website" target="_blank" class="text-sm text-primary-600 hover:text-primary-700 break-all">
                      {{ formatWebsite(company.website) }}
                    </a>
                  </div>
                </div>

                <div v-if="company.address || company.city" class="flex items-start gap-3">
                  <svg class="h-5 w-5 text-gray-400 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                  </svg>
                  <div class="flex-1 min-w-0">
                    <p class="text-sm text-gray-600 mb-1">Address</p>
                    <p class="text-sm text-gray-900">
                      <span v-if="company.address">{{ company.address }}<br /></span>
                      <span v-if="company.city">{{ company.city }}, </span>
                      <span v-if="company.state">{{ company.state }} </span>
                      <span v-if="company.postal_code">{{ company.postal_code }}<br /></span>
                      <span v-if="company.country">{{ company.country }}</span>
                    </p>
                  </div>
                </div>
              </div>
            </BaseCard>

            <!-- Share Company -->
            <BaseCard class="p-6">
              <h3 class="font-semibold text-gray-900 mb-4">Share this company</h3>
              <div class="flex gap-2">
                <button @click="shareCompany('twitter')" class="flex-1 px-4 py-2 bg-blue-400 hover:bg-blue-500 text-white rounded-lg transition-colors">
                  <svg class="h-5 w-5 mx-auto" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M23 3a10.9 10.9 0 01-3.14 1.53 4.48 4.48 0 00-7.86 3v1A10.66 10.66 0 013 4s-4 9 5 13a11.64 11.64 0 01-7 2c9 5 20 0 20-11.5a4.5 4.5 0 00-.08-.83A7.72 7.72 0 0023 3z" />
                  </svg>
                </button>
                <button @click="shareCompany('linkedin')" class="flex-1 px-4 py-2 bg-blue-700 hover:bg-blue-800 text-white rounded-lg transition-colors">
                  <svg class="h-5 w-5 mx-auto" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z" />
                  </svg>
                </button>
                <button @click="copyCompanyLink" class="flex-1 px-4 py-2 bg-gray-600 hover:bg-gray-700 text-white rounded-lg transition-colors">
                  <svg class="h-5 w-5 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                  </svg>
                </button>
              </div>
            </BaseCard>
          </aside>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useCompanyStore } from '@/stores/company'
import { useJobStore } from '@/stores/job'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseBadge from '@/components/base/BaseBadge.vue'
import type { Company, Job } from '@/types'

const router = useRouter()
const route = useRoute()
const companyStore = useCompanyStore()
const jobStore = useJobStore()

const loading = ref(true)
const loadingJobs = ref(true)
const company = ref<Company | null>(null)
const jobs = ref<Job[]>([])

const formatWebsite = (url: string): string => {
  try {
    const urlObj = new URL(url)
    return urlObj.hostname.replace('www.', '')
  } catch {
    return url
  }
}

const formatDate = (dateString: string): string => {
  const date = new Date(dateString)
  return date.getFullYear().toString()
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

const viewAllJobs = () => {
  router.push(`/jobs?company=${company.value?.slug}`)
}

const shareCompany = (platform: string) => {
  const url = window.location.href
  const title = `Check out ${company.value?.name} on JobsIQ`
  
  let shareUrl = ''
  if (platform === 'twitter') {
    shareUrl = `https://twitter.com/intent/tweet?text=${encodeURIComponent(title)}&url=${encodeURIComponent(url)}`
  } else if (platform === 'linkedin') {
    shareUrl = `https://www.linkedin.com/sharing/share-offsite/?url=${encodeURIComponent(url)}`
  }
  
  if (shareUrl) {
    window.open(shareUrl, '_blank', 'width=600,height=400')
  }
}

const copyCompanyLink = async () => {
  try {
    await navigator.clipboard.writeText(window.location.href)
    alert('Link copied to clipboard!')
  } catch (error) {
    console.error('Failed to copy link:', error)
  }
}

const fetchCompanyDetail = async () => {
  loading.value = true
  try {
    const slug = route.params.slug as string
    await companyStore.fetchCompany(slug)
    company.value = companyStore.currentCompany
  } catch (error) {
    console.error('Failed to fetch company:', error)
    company.value = null
  } finally {
    loading.value = false
  }
}

const fetchCompanyJobs = async () => {
  if (!company.value) return
  
  loadingJobs.value = true
  try {
    // Use company.jobs if available from API response
    if (company.value.jobs && company.value.jobs.length > 0) {
      jobs.value = company.value.jobs.slice(0, 10)
    } else {
      // Otherwise fetch all jobs and filter client-side
      await jobStore.fetchJobs({
        per_page: 50,
      })
      jobs.value = jobStore.jobs
        .filter(job => job.company_id === company.value?.id)
        .slice(0, 10)
    }
  } catch (error) {
    console.error('Failed to fetch company jobs:', error)
  } finally {
    loadingJobs.value = false
  }
}

onMounted(async () => {
  await fetchCompanyDetail()
  if (company.value) {
    await fetchCompanyJobs()
  }
})
</script>

<style scoped>
.prose p {
  margin-bottom: 1rem;
}
</style>
