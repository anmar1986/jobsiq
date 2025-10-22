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

    <!-- Company Not Found or Access Denied -->
    <div v-else-if="!company || accessDenied" class="container-custom py-16">
      <BaseCard class="p-12 text-center">
        <svg class="h-16 w-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
        </svg>
        <h2 class="text-2xl font-bold text-gray-900 mb-2">
          {{ accessDenied ? 'Access Denied' : 'Company Not Found' }}
        </h2>
        <p class="text-gray-600 mb-6">
          {{ accessDenied 
            ? 'You do not have permission to view this company.' 
            : 'The company you are looking for does not exist.' 
          }}
        </p>
        <BaseButton variant="primary" @click="router.push({ name: 'my-companies' })">
          Back to My Companies
        </BaseButton>
      </BaseCard>
    </div>

    <!-- Company Detail Content -->
    <div v-else>
      <!-- Hero Banner -->
      <div class="bg-gradient-to-br from-primary-600 to-secondary-600 text-white">
        <div class="container-custom py-12">
          <button @click="router.push({ name: 'my-companies' })" class="flex items-center gap-2 text-white/80 hover:text-white mb-6 transition-colors">
            <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
            Back to My Companies
          </button>

          <div class="flex items-start gap-6">
            <!-- Company Logo -->
            <div class="w-24 h-24 rounded-2xl bg-white/10 backdrop-blur-sm flex items-center justify-center text-white text-3xl font-bold flex-shrink-0 border-2 border-white/20">
              {{ company.name.charAt(0) }}
            </div>

            <div class="flex-1">
              <div class="flex items-start justify-between">
                <div>
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
              <p class="text-sm text-gray-600 mt-1">Member Since</p>
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
        <!-- Company Details Container -->
        <BaseCard class="p-8 mb-8">
          <div class="flex flex-col lg:flex-row gap-8">
            <!-- Company Information -->
            <div class="flex-1">
              <h2 class="text-2xl font-bold text-gray-900 mb-6">Company Details</h2>
              
              <!-- Description -->
              <div class="mb-6">
                <h3 class="text-lg font-semibold text-gray-900 mb-3">About</h3>
                <p class="text-gray-700 leading-relaxed">
                  {{ company.description || 'No detailed description available for this company.' }}
                </p>
              </div>

              <!-- Company Info Grid -->
              <div class="grid md:grid-cols-2 gap-6">
                <!-- Industry -->
                <div v-if="company.industry">
                  <h3 class="text-sm font-semibold text-gray-900 mb-2">Industry</h3>
                  <p class="text-gray-700">{{ company.industry }}</p>
                </div>

                <!-- Company Size -->
                <div v-if="company.company_size">
                  <h3 class="text-sm font-semibold text-gray-900 mb-2">Company Size</h3>
                  <p class="text-gray-700">{{ company.company_size }} employees</p>
                </div>

                <!-- Founded -->
                <div v-if="company.founded_date">
                  <h3 class="text-sm font-semibold text-gray-900 mb-2">Founded</h3>
                  <p class="text-gray-700">{{ formatFoundedDate(company.founded_date) }}</p>
                </div>

                <!-- Status -->
                <div>
                  <h3 class="text-sm font-semibold text-gray-900 mb-2">Status</h3>
                  <p class="text-gray-700">
                    <span :class="company.is_active ? 'text-green-600' : 'text-red-600'" class="font-medium">
                      {{ company.is_active ? 'Active' : 'Inactive' }}
                    </span>
                  </p>
                </div>
              </div>
            </div>

            <!-- Contact Information Sidebar -->
            <div class="lg:w-80 flex-shrink-0">
              <h3 class="text-lg font-semibold text-gray-900 mb-4">Contact Information</h3>
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

              <!-- Quick Actions -->
              <div class="mt-6 pt-6 border-t border-gray-200">
                <h3 class="text-sm font-semibold text-gray-900 mb-3">Quick Actions</h3>
                <div class="space-y-2">
                  <BaseButton
                    variant="outline"
                    size="sm"
                    class="w-full justify-start"
                    @click="router.push({ name: 'edit-company', params: { id: company.id } })"
                  >
                    <svg class="h-4 w-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                    </svg>
                    Edit Company
                  </BaseButton>
                  <BaseButton
                    variant="outline"
                    size="sm"
                    class="w-full justify-start"
                    @click="viewPublicProfile"
                  >
                    <svg class="h-4 w-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                    </svg>
                    View Public Profile
                  </BaseButton>
                </div>
              </div>
            </div>
          </div>
        </BaseCard>

        <!-- Jobs Section -->
        <div>
          <div class="flex items-center justify-between mb-6">
            <h2 class="text-2xl font-bold text-gray-900">
              Posted Jobs ({{ jobs.length }})
            </h2>
            <BaseButton 
              variant="primary" 
              @click="navigateToPostJob"
            >
              <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
              </svg>
              Post New Job
            </BaseButton>
          </div>

          <!-- Jobs Loading -->
          <div v-if="loadingJobs" class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            <BaseCard v-for="i in 3" :key="i" class="p-6 animate-pulse">
              <div class="h-5 bg-gray-200 rounded w-3/4 mb-3"></div>
              <div class="h-4 bg-gray-200 rounded w-1/2 mb-4"></div>
              <div class="h-4 bg-gray-200 rounded w-full"></div>
            </BaseCard>
          </div>

          <!-- Jobs Cards Grid -->
          <div v-else-if="jobs.length > 0" class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            <BaseCard
              v-for="job in jobs"
              :key="job.id"
              class="p-6 hover:shadow-lg transition-shadow group relative"
            >
              <!-- Job Header -->
              <div class="mb-4">
                <h3 class="text-lg font-semibold text-gray-900 mb-2 line-clamp-2 pr-8">
                  {{ job.title }}
                </h3>
                <div class="flex items-center gap-2 text-sm text-gray-600">
                  <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                  </svg>
                  <span>{{ job.location }}</span>
                </div>
              </div>

              <!-- Job Details -->
              <div class="space-y-2 mb-4">
                <div class="flex items-center gap-2 text-sm text-gray-600">
                  <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                  </svg>
                  <span>{{ formatEmploymentType(job.employment_type) }}</span>
                </div>
                
                <div class="flex items-center gap-2 text-sm text-gray-600">
                  <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  <span>Posted {{ formatJobDate(job.created_at) }}</span>
                </div>

                <div v-if="job.salary_min && job.salary_max" class="flex items-center gap-2 text-sm font-semibold text-primary-600">
                  <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  <span>{{ formatSalary(job.salary_min, job.salary_max) }}</span>
                </div>
              </div>

              <!-- Badges -->
              <div class="flex flex-wrap gap-2 mb-4">
                <BaseBadge :variant="getBadgeVariant(job.experience_level)">
                  {{ formatExperienceLevel(job.experience_level) }}
                </BaseBadge>
                <BaseBadge v-if="job.is_remote" variant="success">Remote</BaseBadge>
                <BaseBadge v-if="job.category" variant="info">{{ job.category }}</BaseBadge>
              </div>

              <!-- Action Buttons -->
              <div class="flex items-center gap-2 pt-4 border-t border-gray-200">
                <BaseButton
                  variant="outline"
                  size="sm"
                  @click="viewCompanyJob(job)"
                  title="View Job"
                >
                  <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                  </svg>
                </BaseButton>
                <BaseButton
                  variant="outline"
                  size="sm"
                  @click="editCompanyJob(job)"
                  title="Edit Job"
                >
                  <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                  </svg>
                </BaseButton>
                <BaseButton
                  variant="outline"
                  size="sm"
                  @click.stop="confirmDeleteJob(job)"
                  class="text-red-600 hover:text-red-700 hover:border-red-600"
                  title="Delete Job"
                >
                  <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                  </svg>
                </BaseButton>
              </div>
            </BaseCard>
          </div>

          <!-- No Jobs -->
          <BaseCard v-else class="p-12 text-center">
            <svg class="h-16 w-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
            </svg>
            <h3 class="text-xl font-semibold text-gray-900 mb-2">No Jobs Posted Yet</h3>
            <p class="text-gray-600 mb-6">Start posting jobs to attract talented candidates.</p>
            <BaseButton variant="primary" @click="navigateToPostJob">
              <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
              </svg>
              Post Your First Job
            </BaseButton>
          </BaseCard>
        </div>
      </div>
    </div>

    <!-- Delete Job Confirmation Modal -->
    <BaseModal
      v-model="showDeleteJobModal"
      title="Delete Job"
      size="sm"
    >
      <div class="p-6">
        <p class="text-gray-700 mb-6">
          Are you sure you want to delete <strong>{{ selectedJob?.title }}</strong>? 
          This action cannot be undone and all applications for this job will be lost.
        </p>
        <div class="flex items-center justify-end gap-3">
          <BaseButton
            variant="outline"
            @click="showDeleteJobModal = false"
            :disabled="deletingJob"
          >
            Cancel
          </BaseButton>
          <BaseButton
            variant="primary"
            @click="handleDeleteJob"
            :loading="deletingJob"
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
const loadingJobs = ref(false)
const company = ref<Company | null>(null)
const jobs = ref<Job[]>([])
const accessDenied = ref(false)
const showDeleteJobModal = ref(false)
const selectedJob = ref<Job | null>(null)
const deletingJob = ref(false)

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

const formatFoundedDate = (dateString: string): string => {
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

const navigateToPostJob = () => {
  router.push({
    name: 'post-job',
    query: { company_id: company.value?.id }
  })
}

const viewPublicProfile = () => {
  if (company.value?.slug) {
    router.push({
      name: 'company-detail-slug',
      params: { slug: company.value.slug }
    })
  }
}

const viewCompanyJob = (job: Job) => {
  router.push({
    name: 'view-company-job',
    params: { 
      companyId: company.value?.id,
      jobId: job.id 
    }
  })
}

const editCompanyJob = (job: Job) => {
  router.push({
    name: 'edit-company-job',
    params: { 
      companyId: company.value?.id,
      jobId: job.id 
    }
  })
}

const confirmDeleteJob = (job: Job) => {
  selectedJob.value = job
  showDeleteJobModal.value = true
}

const handleDeleteJob = async () => {
  if (!selectedJob.value) return
  
  deletingJob.value = true
  try {
    const response = await jobService.deleteJob(selectedJob.value.id)
    if (response.success) {
      showDeleteJobModal.value = false
      // Remove job from the list
      jobs.value = jobs.value.filter(j => j.id !== selectedJob.value?.id)
      toast.success('Job deleted successfully!')
      selectedJob.value = null
      
      // Reload company details to update job count
      await fetchCompanyDetail()
    }
  } catch (error) {
    console.error('Failed to delete job:', error)
    const err = error as { response?: { data?: { message?: string } } }
    toast.error(err.response?.data?.message || 'Failed to delete job')
  } finally {
    deletingJob.value = false
  }
}

const fetchCompanyDetail = async () => {
  loading.value = true
  accessDenied.value = false
  
  try {
    const companyId = route.params.id as string
    
    // Fetch all user's companies to verify ownership
    const response = await companyService.getMyCompanies()
    
    if (response.success && response.data) {
      // Find the company with matching ID
      const foundCompany = response.data.find((c: Company) => c.id.toString() === companyId)
      
      if (foundCompany) {
        company.value = foundCompany
        
        // Load jobs if available
        if (foundCompany.jobs && foundCompany.jobs.length > 0) {
          jobs.value = foundCompany.jobs
        }
      } else {
        // Company not found in user's companies - access denied
        accessDenied.value = true
        toast.error('You do not have permission to view this company')
      }
    }
  } catch (error) {
    console.error('Failed to fetch company:', error)
    const err = error as { response?: { data?: { message?: string } } }
    toast.error(err.response?.data?.message || 'Failed to load company details')
    company.value = null
  } finally {
    loading.value = false
  }
}

onMounted(async () => {
  // Ensure body can scroll
  document.body.style.overflow = ''
  await fetchCompanyDetail()
})
</script>

<style scoped>
.prose p {
  margin-bottom: 1rem;
}
</style>
