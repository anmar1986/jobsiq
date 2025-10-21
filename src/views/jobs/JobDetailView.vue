<template>
  <div class="bg-gray-50 min-h-screen">
    <!-- Loading State -->
    <div v-if="loading" class="container-custom py-8">
      <div class="animate-pulse space-y-8">
        <div class="h-8 bg-gray-200 rounded w-3/4"></div>
        <div class="bg-white rounded-lg p-8">
          <div class="h-6 bg-gray-200 rounded w-1/2 mb-4"></div>
          <div class="space-y-2">
            <div class="h-4 bg-gray-200 rounded w-full"></div>
            <div class="h-4 bg-gray-200 rounded w-5/6"></div>
            <div class="h-4 bg-gray-200 rounded w-4/6"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Job Not Found -->
    <div v-else-if="!job" class="container-custom py-16">
      <BaseCard class="p-12 text-center">
        <svg class="h-16 w-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <h2 class="text-2xl font-bold text-gray-900 mb-2">Job Not Found</h2>
        <p class="text-gray-600 mb-6">The job you're looking for doesn't exist or has been removed.</p>
        <BaseButton variant="primary" @click="router.push('/jobs')">Browse All Jobs</BaseButton>
      </BaseCard>
    </div>

    <!-- Job Detail Content -->
    <div v-else>
      <!-- Header Section -->
      <div class="bg-white border-b border-gray-200">
        <div class="container-custom py-8">
          <!-- Back Button -->
          <button @click="router.back()" class="flex items-center gap-2 text-gray-600 hover:text-gray-900 mb-6 transition-colors">
            <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
            Back to Jobs
          </button>

          <div class="flex flex-col lg:flex-row gap-8">
            <!-- Job Info -->
            <div class="flex-1">
              <div class="flex items-start gap-4 mb-6">
                <!-- Company Logo -->
                <div class="w-20 h-20 rounded-xl bg-gradient-to-br from-primary-500 to-secondary-500 flex items-center justify-center text-white text-2xl font-bold flex-shrink-0">
                  {{ job.company?.name?.charAt(0) || 'C' }}
                </div>

                <div class="flex-1 min-w-0">
                  <h1 class="text-3xl md:text-4xl font-bold text-gray-900 mb-2">{{ job.title }}</h1>
                  <router-link :to="`/companies/${job.company?.slug}`" class="text-xl text-primary-600 hover:text-primary-700 font-medium mb-3 inline-block">
                    {{ job.company?.name }}
                  </router-link>
                  
                  <!-- Meta Info -->
                  <div class="flex flex-wrap gap-4 text-gray-600">
                    <span class="flex items-center gap-1.5">
                      <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                      </svg>
                      {{ job.location }}
                    </span>
                    <span class="flex items-center gap-1.5">
                      <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                      </svg>
                      {{ formatEmploymentType(job.employment_type) }}
                    </span>
                    <span class="flex items-center gap-1.5">
                      <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                      </svg>
                      {{ formatDate(job.created_at) }}
                    </span>
                  </div>
                </div>
              </div>

              <!-- Key Info Badges -->
              <div class="flex flex-wrap gap-3">
                <BaseBadge :variant="getBadgeVariant(job.experience_level)">
                  {{ formatExperienceLevel(job.experience_level) }}
                </BaseBadge>
                <BaseBadge v-if="job.is_remote" variant="success">
                  <svg class="h-4 w-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  Remote
                </BaseBadge>
                <BaseBadge v-if="job.category" variant="info">{{ job.category }}</BaseBadge>
              </div>
            </div>

            <!-- Salary & Apply Card -->
            <div class="lg:w-80 flex-shrink-0">
              <BaseCard class="p-6 sticky top-24">
                <div class="mb-6">
                  <p class="text-sm text-gray-600 mb-1">Salary Range</p>
                  <p class="text-2xl font-bold text-gray-900">
                    {{ formatSalary(job.salary_min || 0, job.salary_max || 0) }}
                  </p>
                  <p v-if="job.salary_currency !== 'USD'" class="text-sm text-gray-500">{{ job.salary_currency }}</p>
                </div>

                <BaseButton
                  variant="primary"
                  size="lg"
                  class="w-full mb-3"
                  @click="handleApply"
                  :disabled="hasApplied"
                >
                  <svg v-if="!hasApplied" class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  {{ hasApplied ? 'Already Applied' : 'Apply Now' }}
                </BaseButton>

                <BaseButton
                  variant="outline"
                  size="lg"
                  class="w-full"
                  @click="toggleSave"
                >
                  <svg :class="[isSaved ? 'fill-current' : '']" class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 5a2 2 0 012-2h10a2 2 0 012 2v16l-7-3.5L5 21V5z" />
                  </svg>
                  {{ isSaved ? 'Saved' : 'Save Job' }}
                </BaseButton>

                <!-- Job Stats -->
                <div class="mt-6 pt-6 border-t border-gray-200 space-y-3">
                  <div class="flex items-center justify-between text-sm">
                    <span class="text-gray-600">Job ID</span>
                    <span class="font-medium text-gray-900">#{{ job.id }}</span>
                  </div>
                  <div class="flex items-center justify-between text-sm">
                    <span class="text-gray-600">Posted</span>
                    <span class="font-medium text-gray-900">{{ formatDate(job.created_at) }}</span>
                  </div>
                  <div v-if="job.expires_at" class="flex items-center justify-between text-sm">
                    <span class="text-gray-600">Expires</span>
                    <span class="font-medium text-gray-900">{{ formatDate(job.expires_at) }}</span>
                  </div>
                </div>
              </BaseCard>
            </div>
          </div>
        </div>
      </div>

      <!-- Job Details Content -->
      <div class="container-custom py-8">
        <div class="flex flex-col lg:flex-row gap-8">
          <!-- Main Content -->
          <div class="flex-1">
            <BaseCard class="p-8 mb-8">
              <!-- Job Description -->
              <section class="mb-8">
                <h2 class="text-2xl font-bold text-gray-900 mb-4">Job Description</h2>
                <!-- eslint-disable-next-line vue/no-v-html -->
                <div class="prose prose-gray max-w-none" v-html="job.description"></div>
              </section>

              <!-- Requirements -->
              <section v-if="job.requirements" class="mb-8 pb-8 border-t border-gray-200 pt-8">
                <h2 class="text-2xl font-bold text-gray-900 mb-4">Requirements</h2>
                <!-- eslint-disable-next-line vue/no-v-html -->
                <div class="prose prose-gray max-w-none" v-html="job.requirements"></div>
              </section>

              <!-- Responsibilities -->
              <section v-if="job.responsibilities" class="mb-8 pb-8 border-t border-gray-200 pt-8">
                <h2 class="text-2xl font-bold text-gray-900 mb-4">Responsibilities</h2>
                <!-- eslint-disable-next-line vue/no-v-html -->
                <div class="prose prose-gray max-w-none" v-html="job.responsibilities"></div>
              </section>

              <!-- Benefits -->
              <section v-if="job.benefits" class="pb-8 border-t border-gray-200 pt-8">
                <h2 class="text-2xl font-bold text-gray-900 mb-4">Benefits</h2>
                <!-- eslint-disable-next-line vue/no-v-html -->
                <div class="prose prose-gray max-w-none" v-html="job.benefits"></div>
              </section>
            </BaseCard>

            <!-- About Company -->
            <BaseCard v-if="job.company" class="p-8">
              <h2 class="text-2xl font-bold text-gray-900 mb-6">About {{ job.company.name }}</h2>
              <div class="flex items-start gap-6">
                <div class="w-20 h-20 rounded-xl bg-gradient-to-br from-primary-500 to-secondary-500 flex items-center justify-center text-white text-2xl font-bold flex-shrink-0">
                  {{ job.company.name.charAt(0) }}
                </div>
                <div class="flex-1">
                  <p class="text-gray-700 mb-4 leading-relaxed">{{ job.company.description || 'No description available.' }}</p>
                  <div class="flex flex-wrap gap-4 text-sm text-gray-600">
                    <span v-if="job.company.city" class="flex items-center gap-1.5">
                      <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                      </svg>
                      {{ job.company.city }}, {{ job.company.country }}
                    </span>
                    <span v-if="job.company.website" class="flex items-center gap-1.5">
                      <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9" />
                      </svg>
                      <a :href="job.company.website" target="_blank" class="text-primary-600 hover:text-primary-700">
                        Website
                      </a>
                    </span>
                    <span v-if="job.company.jobs_count" class="flex items-center gap-1.5">
                      <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                      </svg>
                      {{ job.company.jobs_count }} open positions
                    </span>
                  </div>
                  <BaseButton variant="outline" size="sm" class="mt-4" @click="router.push(`/companies/${job.company?.slug}`)">
                    View Company Profile
                  </BaseButton>
                </div>
              </div>
            </BaseCard>
          </div>

          <!-- Sidebar -->
          <aside class="lg:w-80 flex-shrink-0">
            <!-- Share Job -->
            <BaseCard class="p-6 mb-6">
              <h3 class="font-semibold text-gray-900 mb-4">Share this job</h3>
              <div class="flex gap-2">
                <button @click="shareJob('twitter')" class="flex-1 px-4 py-2 bg-blue-400 hover:bg-blue-500 text-white rounded-lg transition-colors">
                  <svg class="h-5 w-5 mx-auto" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M23 3a10.9 10.9 0 01-3.14 1.53 4.48 4.48 0 00-7.86 3v1A10.66 10.66 0 013 4s-4 9 5 13a11.64 11.64 0 01-7 2c9 5 20 0 20-11.5a4.5 4.5 0 00-.08-.83A7.72 7.72 0 0023 3z" />
                  </svg>
                </button>
                <button @click="shareJob('linkedin')" class="flex-1 px-4 py-2 bg-blue-700 hover:bg-blue-800 text-white rounded-lg transition-colors">
                  <svg class="h-5 w-5 mx-auto" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z" />
                  </svg>
                </button>
                <button @click="copyJobLink" class="flex-1 px-4 py-2 bg-gray-600 hover:bg-gray-700 text-white rounded-lg transition-colors">
                  <svg class="h-5 w-5 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                  </svg>
                </button>
              </div>
            </BaseCard>

            <!-- Similar Jobs -->
            <BaseCard v-if="similarJobs.length > 0" class="p-6">
              <h3 class="font-semibold text-gray-900 mb-4">Similar Jobs</h3>
              <div class="space-y-4">
                <router-link
                  v-for="similarJob in similarJobs"
                  :key="similarJob.id"
                  :to="`/jobs/${similarJob.slug}`"
                  class="block group"
                >
                  <h4 class="font-medium text-gray-900 group-hover:text-primary-600 transition-colors mb-1">
                    {{ similarJob.title }}
                  </h4>
                  <p class="text-sm text-gray-600">{{ similarJob.company?.name }}</p>
                  <p class="text-sm text-gray-500">{{ similarJob.location }}</p>
                  <p v-if="similarJob.salary_min && similarJob.salary_max" class="text-sm font-medium text-primary-600 mt-1">
                    {{ formatSalary(similarJob.salary_min || 0, similarJob.salary_max || 0) }}
                  </p>
                </router-link>
              </div>
            </BaseCard>
          </aside>
        </div>
      </div>
    </div>

    <!-- Apply Modal -->
    <BaseModal
      v-model="showApplyModal"
      title="Apply for this position"
    >
      <form @submit.prevent="submitApplication" class="space-y-6">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Full Name *</label>
          <BaseInput
            v-model="applicationForm.full_name"
            type="text"
            placeholder="Enter your full name"
            required
          />
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Email *</label>
          <BaseInput
            v-model="applicationForm.email"
            type="email"
            placeholder="your.email@example.com"
            required
          />
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Phone Number *</label>
          <BaseInput
            v-model="applicationForm.phone"
            type="tel"
            placeholder="+1 (555) 000-0000"
            required
          />
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Resume/CV *</label>
          <input
            type="file"
            accept=".pdf,.doc,.docx"
            @change="handleFileUpload"
            class="block w-full text-sm text-gray-500
              file:mr-4 file:py-2 file:px-4
              file:rounded-lg file:border-0
              file:text-sm file:font-semibold
              file:bg-primary-50 file:text-primary-700
              hover:file:bg-primary-100
              cursor-pointer"
            required
          />
          <p class="mt-1 text-xs text-gray-500">PDF, DOC, or DOCX (Max 5MB)</p>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Cover Letter</label>
          <textarea
            v-model="applicationForm.cover_letter"
            rows="4"
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
            placeholder="Tell us why you're a great fit for this role..."
          ></textarea>
        </div>

        <div class="flex gap-3">
          <BaseButton type="button" variant="outline" @click="showApplyModal = false" class="flex-1">
            Cancel
          </BaseButton>
          <BaseButton type="submit" variant="primary" :loading="submitting" class="flex-1">
            Submit Application
          </BaseButton>
        </div>
      </form>
    </BaseModal>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useJobStore } from '@/stores/job'
import { useAuthStore } from '@/stores/auth'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseBadge from '@/components/base/BaseBadge.vue'
import BaseModal from '@/components/base/BaseModal.vue'
import type { Job } from '@/types'

const router = useRouter()
const route = useRoute()
const jobStore = useJobStore()
const authStore = useAuthStore()

const loading = ref(true)
const job = ref<Job | null>(null)
const similarJobs = ref<Job[]>([])
const isSaved = ref(false)
const hasApplied = ref(false)
const showApplyModal = ref(false)
const submitting = ref(false)

const applicationForm = ref({
  full_name: authStore.user?.name || '',
  email: authStore.user?.email || '',
  phone: '',
  cover_letter: '',
  resume: null as File | null,
})

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

const formatDate = (date: string): string => {
  const now = new Date()
  const postDate = new Date(date)
  const diffTime = Math.abs(now.getTime() - postDate.getTime())
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
  
  if (diffDays === 0) return 'Today'
  if (diffDays === 1) return 'Yesterday'
  if (diffDays < 7) return `${diffDays} days ago`
  if (diffDays < 30) return `${Math.floor(diffDays / 7)} weeks ago`
  if (diffDays < 365) return `${Math.floor(diffDays / 30)} months ago`
  return `${Math.floor(diffDays / 365)} years ago`
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

const handleApply = () => {
  if (!authStore.isAuthenticated) {
    router.push(`/login?redirect=/jobs/${route.params.slug}`)
    return
  }
  showApplyModal.value = true
}

const toggleSave = async () => {
  if (!authStore.isAuthenticated) {
    router.push(`/login?redirect=/jobs/${route.params.slug}`)
    return
  }
  
  isSaved.value = !isSaved.value
  // TODO: Call API to save/unsave job
  console.log('Toggle save job:', job.value?.id)
}

const handleFileUpload = (event: Event) => {
  const target = event.target as HTMLInputElement
  if (target.files && target.files[0]) {
    applicationForm.value.resume = target.files[0]
  }
}

const submitApplication = async () => {
  submitting.value = true
  try {
    // TODO: Call API to submit application
    console.log('Submit application:', applicationForm.value)
    
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 1500))
    
    hasApplied.value = true
    showApplyModal.value = false
    alert('Application submitted successfully!')
  } catch (error) {
    console.error('Failed to submit application:', error)
    alert('Failed to submit application. Please try again.')
  } finally {
    submitting.value = false
  }
}

const shareJob = (platform: string) => {
  const url = window.location.href
  const title = job.value?.title || 'Check out this job'
  
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

const copyJobLink = async () => {
  try {
    await navigator.clipboard.writeText(window.location.href)
    alert('Link copied to clipboard!')
  } catch (error) {
    console.error('Failed to copy link:', error)
  }
}

const fetchJobDetail = async () => {
  loading.value = true
  try {
    const slug = route.params.slug as string
    
    // Fetch job by slug - use fetchJob which accepts slug or id
    await jobStore.fetchJob(slug)
    job.value = jobStore.currentJob
    
    // Fetch similar jobs if category exists
    if (job.value && job.value.category) {
      await jobStore.fetchJobs({
        category: job.value.category || '',
        per_page: 3,
      })
      similarJobs.value = jobStore.jobs.filter((j: Job) => j.id !== job.value?.id).slice(0, 3)
    }
  } catch (error) {
    console.error('Failed to fetch job:', error)
    job.value = null
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchJobDetail()
})
</script>

<style scoped>
.prose {
  color: rgb(55 65 81);
  line-height: 1.75;
}

.prose h3 {
  font-size: 1.125rem;
  font-weight: 600;
  color: rgb(17 24 39);
  margin-top: 1.5rem;
  margin-bottom: 0.75rem;
}

.prose ul {
  list-style-type: disc;
  padding-left: 1.5rem;
  margin-top: 0.5rem;
  margin-bottom: 0.5rem;
}

.prose ol {
  list-style-type: decimal;
  padding-left: 1.5rem;
  margin-top: 0.5rem;
  margin-bottom: 0.5rem;
}

.prose li {
  color: rgb(55 65 81);
  margin-top: 0.5rem;
  margin-bottom: 0.5rem;
}

.prose p {
  margin-bottom: 1rem;
}

.prose strong {
  font-weight: 600;
  color: rgb(17 24 39);
}
</style>
