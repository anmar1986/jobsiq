<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Loading State -->
    <div v-if="loading" class="container mx-auto py-8 px-4 sm:px-6 lg:px-8 max-w-7xl">
      <div class="animate-pulse space-y-6">
        <div class="h-8 bg-gray-200 rounded w-3/4"></div>
        <div class="grid lg:grid-cols-3 gap-6">
          <div class="lg:col-span-2 space-y-6">
            <div class="bg-white rounded-xl p-8 shadow-custom">
              <div class="h-6 bg-gray-200 rounded w-1/2 mb-4"></div>
              <div class="space-y-2">
                <div class="h-4 bg-gray-200 rounded w-full"></div>
                <div class="h-4 bg-gray-200 rounded w-5/6"></div>
              </div>
            </div>
          </div>
          <div class="space-y-6">
            <div class="bg-white rounded-xl p-6 shadow-custom">
              <div class="h-6 bg-gray-200 rounded w-3/4"></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Job Detail Content -->
    <div v-else-if="job" class="container mx-auto py-6 px-4 sm:px-6 lg:px-8 max-w-7xl">
      <!-- Back Button -->
      <button 
        @click="goBack" 
        class="inline-flex items-center gap-2 px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 hover:border-gray-400 transition-all mb-6 shadow-sm"
      >
        <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
        </svg>
        {{ $t('common.back') }}
      </button>

      <!-- Header Section -->
      <div class="bg-white rounded-xl shadow-custom mb-6 overflow-hidden border-b-4 border-primary-600">
        <div class="p-6 lg:p-8">
          <div class="flex flex-col lg:flex-row lg:items-start lg:justify-between gap-6">
            <!-- Left: Job Info -->
            <div class="flex-1">
              <div class="flex items-start gap-4 mb-4">
                <!-- Company Logo -->
                <div class="w-16 h-16 rounded-lg overflow-hidden bg-gradient-to-br from-primary-500 to-secondary-500 flex items-center justify-center text-white flex-shrink-0 shadow-md">
                  <img 
                    v-if="job.company?.logo?.url" 
                    :src="job.company.logo.url" 
                    :alt="job.company.name"
                    class="w-full h-full object-contain"
                  />
                  <span v-else class="text-2xl font-bold">{{ job.company?.name?.charAt(0) || 'C' }}</span>
                </div>

                <div class="flex-1 min-w-0">
                  <h1 class="text-3xl lg:text-4xl font-extrabold text-gray-900 mb-2">{{ job.title }}</h1>
                  <router-link 
                    :to="`/companies/${job.company?.slug}`" 
                    class="text-xl font-semibold text-primary-600 hover:text-primary-700 inline-block mb-3"
                  >
                    {{ job.company?.name }}
                  </router-link>
                  
                  <div class="flex flex-wrap items-center gap-3 text-sm text-gray-600">
                    <div class="flex items-center gap-1.5">
                      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                      </svg>
                      <span>{{ job.location }}</span>
                    </div>
                    <div v-if="job.is_remote" class="flex items-center gap-1.5 px-3 py-1 bg-green-50 text-green-700 rounded-full border border-green-200">
                      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                      </svg>
                      <span class="font-medium">{{ $t('jobs.remote') }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Right: Action Buttons -->
            <div class="flex flex-wrap lg:flex-col gap-3 lg:min-w-[200px]">
              <button
                @click="editJob"
                class="flex-1 lg:flex-none px-6 py-3 bg-primary-600 text-white rounded-full font-semibold hover:bg-primary-700 hover:scale-[1.02] transition-all shadow-lg cursor-pointer"
              >
                {{ $t('myJobs.editJob') }}
              </button>
              
              <button
                @click="viewPublicJob"
                class="flex-1 lg:flex-none px-6 py-3 border-2 border-gray-300 text-gray-700 rounded-full font-semibold hover:bg-gray-50 transition-all flex items-center justify-center gap-2 cursor-pointer"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                </svg>
                <span>{{ $t('companies.viewPublicProfile') }}</span>
              </button>

              <button
                @click="confirmDelete"
                class="flex-1 lg:flex-none px-6 py-3 border-2 border-red-300 text-red-700 rounded-full font-semibold hover:bg-red-50 hover:border-red-500 transition-all flex items-center justify-center gap-2 cursor-pointer"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                </svg>
                <span>{{ $t('myJobs.deleteJob') }}</span>
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Main Content Grid -->
      <div class="grid lg:grid-cols-3 gap-6">
        <!-- Left Column: Main Content (2/3 width) -->
        <div class="lg:col-span-2 space-y-6">
          <!-- Job Description -->
          <div class="bg-white rounded-xl shadow-custom p-6 lg:p-8">
            <div class="flex items-center gap-3 mb-6 pb-4 border-b-2 border-gray-200">
              <svg class="w-7 h-7 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h7" />
              </svg>
              <h2 class="text-2xl font-bold text-gray-900">{{ $t('jobs.jobDescription') }}</h2>
            </div>
            <!-- eslint-disable-next-line vue/no-v-html -->
            <div class="prose prose-gray max-w-none text-gray-700 leading-relaxed" v-html="job.description"></div>
          </div>

          <!-- Requirements -->
          <div v-if="job.requirements" class="bg-white rounded-xl shadow-custom p-6 lg:p-8">
            <div class="flex items-center gap-3 mb-6 pb-4 border-b-2 border-gray-200">
              <svg class="w-7 h-7 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" />
              </svg>
              <h2 class="text-2xl font-bold text-gray-900">{{ $t('jobs.requirements') }}</h2>
            </div>
            <!-- eslint-disable-next-line vue/no-v-html -->
            <div class="prose prose-gray max-w-none text-gray-700 leading-relaxed" v-html="job.requirements"></div>
          </div>

          <!-- Responsibilities -->
          <div v-if="job.responsibilities" class="bg-white rounded-xl shadow-custom p-6 lg:p-8">
            <div class="flex items-center gap-3 mb-6 pb-4 border-b-2 border-gray-200">
              <svg class="w-7 h-7 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <h2 class="text-2xl font-bold text-gray-900">{{ $t('jobs.responsibilities') }}</h2>
            </div>
            <!-- eslint-disable-next-line vue/no-v-html -->
            <div class="prose prose-gray max-w-none text-gray-700 leading-relaxed" v-html="job.responsibilities"></div>
          </div>

          <!-- Benefits -->
          <div v-if="job.benefits" class="bg-white rounded-xl shadow-custom p-6 lg:p-8">
            <div class="flex items-center gap-3 mb-6 pb-4 border-b-2 border-gray-200">
              <svg class="w-7 h-7 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
              </svg>
              <h2 class="text-2xl font-bold text-gray-900">{{ $t('jobs.benefits') }}</h2>
            </div>
            <!-- eslint-disable-next-line vue/no-v-html -->
            <div class="prose prose-gray max-w-none text-gray-700 leading-relaxed" v-html="job.benefits"></div>
          </div>

          <!-- About Company -->
          <div v-if="job.company" class="bg-white rounded-xl shadow-custom p-6 lg:p-8">
            <h2 class="text-2xl font-bold text-gray-900 mb-6">{{ $t('companies.about') }} {{ job.company.name }}</h2>
            <div class="flex items-start gap-6">
              <div class="w-20 h-20 rounded-xl bg-gradient-to-br from-primary-500 to-secondary-500 flex items-center justify-center text-white text-2xl font-bold flex-shrink-0 shadow-md">
                <img 
                  v-if="job.company?.logo?.url" 
                  :src="job.company.logo.url" 
                  :alt="job.company.name"
                  class="w-full h-full object-contain rounded-xl"
                />
                <span v-else>{{ job.company.name.charAt(0) }}</span>
              </div>
              <div class="flex-1">
                <p class="text-gray-700 mb-4 leading-relaxed">{{ job.company.description || $t('companies.noDescriptionAvailable') }}</p>
                <div class="flex flex-wrap gap-4 text-sm text-gray-600 mb-4">
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
                    <a :href="job.company.website" target="_blank" class="text-primary-600 hover:text-primary-700">{{ $t('companies.website') }}</a>
                  </span>
                </div>
                <button 
                  @click="router.push(`/companies/${job.company?.slug}`)"
                  class="px-4 py-2 border-2 border-primary-600 text-primary-600 rounded-lg font-semibold hover:bg-primary-50 transition-all cursor-pointer"
                >
                  {{ $t('companies.viewCompanyProfile') }}
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Right Column: Sidebar (1/3 width) -->
        <div class="space-y-6">
          <!-- Compensation Card -->
          <div class="bg-white rounded-xl shadow-custom p-6">
            <div class="flex items-center gap-2 mb-4">
              <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <h3 class="text-lg font-bold text-gray-900">{{ $t('jobs.compensation') }}</h3>
            </div>
            <p class="text-3xl font-bold text-green-600">
              {{ formatSalaryRange(job.salary_min || 0, job.salary_max || 0, job.salary_currency, job.salary_period) }}
            </p>
          </div>

          <!-- Job Overview Card -->
          <div class="bg-white rounded-xl shadow-custom p-6">
            <h3 class="text-lg font-bold text-gray-900 mb-4">{{ $t('jobs.jobOverview') }}</h3>
            <div class="space-y-4">
              <!-- Employment Type -->
              <div class="flex items-start justify-between">
                <div class="flex items-center gap-2 text-gray-600">
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  <span class="text-sm">{{ $t('jobs.employmentType') }}</span>
                </div>
                <span class="px-3 py-1 bg-primary-100 text-primary-800 rounded-full text-sm font-semibold">
                  {{ formatEmploymentType(job.employment_type) }}
                </span>
              </div>

              <!-- Experience Level -->
              <div class="flex items-start justify-between">
                <div class="flex items-center gap-2 text-gray-600">
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z" />
                  </svg>
                  <span class="text-sm">{{ $t('jobs.experienceLevel') }}</span>
                </div>
                <span class="px-3 py-1 bg-secondary-100 text-secondary-800 rounded-full text-sm font-semibold">
                  {{ formatExperienceLevel(job.experience_level) }}
                </span>
              </div>

              <!-- Department/Category -->
              <div v-if="job.category" class="flex items-start justify-between">
                <div class="flex items-center gap-2 text-gray-600">
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" />
                  </svg>
                  <span class="text-sm">{{ $t('jobs.department') }}</span>
                </div>
                <span class="text-sm font-medium text-gray-900">{{ job.category }}</span>
              </div>

              <!-- Posted -->
              <div class="flex items-start justify-between">
                <div class="flex items-center gap-2 text-gray-600">
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                  </svg>
                  <span class="text-sm">{{ $t('jobs.posted') }}</span>
                </div>
                <span class="text-sm font-medium text-gray-900">{{ formatDate(job.created_at) }}</span>
              </div>

              <!-- Expires -->
              <div v-if="job.expires_at" class="flex items-start justify-between">
                <div class="flex items-center gap-2 text-gray-600">
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                  </svg>
                  <span class="text-sm">{{ $t('jobs.expires') }}</span>
                </div>
                <span class="text-sm font-bold text-red-600">{{ formatDate(job.expires_at) }}</span>
              </div>

              <!-- Status -->
              <div class="flex items-start justify-between">
                <div class="flex items-center gap-2 text-gray-600">
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  <span class="text-sm">{{ $t('common.status') }}</span>
                </div>
                <span
                  :class="[
                    'px-3 py-1 rounded-full text-sm font-semibold',
                    job.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'
                  ]"
                >
                  {{ job.is_active ? $t('myJobs.active') : $t('myJobs.inactive') }}
                </span>
              </div>

              <!-- Featured -->
              <div v-if="job.is_featured" class="flex items-start justify-between">
                <div class="flex items-center gap-2 text-gray-600">
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z" />
                  </svg>
                  <span class="text-sm">{{ $t('myJobs.featured') }}</span>
                </div>
                <span class="px-3 py-1 bg-yellow-100 text-yellow-800 rounded-full text-sm font-semibold">
                  ⭐ {{ $t('myJobs.featured') }}
                </span>
              </div>
            </div>
          </div>

          <!-- Required Skills Card -->
          <div v-if="job.skills && job.skills.length > 0" class="bg-white rounded-xl shadow-custom p-6">
            <div class="flex items-center gap-2 mb-4">
              <svg class="w-6 h-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
              </svg>
              <h3 class="text-lg font-bold text-gray-900">{{ $t('jobs.requiredSkills') }}</h3>
            </div>
            <div class="flex flex-wrap gap-2">
              <span
                v-for="skill in job.skills"
                :key="skill"
                class="px-3 py-1.5 bg-teal-100 text-teal-800 rounded-full text-sm font-medium"
              >
                {{ skill }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <BaseModal
      v-model="showDeleteModal"
      :title="$t('myJobs.deleteJobTitle')"
      size="sm"
    >
      <div class="p-6">
        <p class="text-gray-700 mb-6">
          {{ $t('myJobs.deleteJobConfirm', { jobTitle: job?.title }) }}
        </p>
        <div class="flex items-center justify-end gap-3">
          <BaseButton
            variant="outline"
            @click="showDeleteModal = false"
            :disabled="deleting"
          >
            {{ $t('myJobs.cancel') }}
          </BaseButton>
          <BaseButton
            variant="primary"
            @click="handleDelete"
            :loading="deleting"
            class="bg-red-600 hover:bg-red-700"
          >
            {{ deleting ? $t('myJobs.deleting') : $t('myJobs.deleteJob') }}
          </BaseButton>
        </div>
      </div>
    </BaseModal>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { companyService } from '@/services/cv.service'
import { jobService } from '@/services/job.service'
import { useToast } from '@/composables/useToast'
import { formatSalaryRange } from '@/utils/currency'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseModal from '@/components/base/BaseModal.vue'
import type { Company, Job } from '@/types'

const router = useRouter()
const route = useRoute()
const toast = useToast()
const { t } = useI18n()

const loading = ref(true)
const job = ref<Job | null>(null)
const company = ref<Company | null>(null)
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
  const levelKeys: Record<string, string> = {
    'entry': 'jobs.entryLevel',
    'junior': 'jobs.junior',
    'mid': 'jobs.midLevel',
    'senior': 'jobs.senior',
    'lead': 'jobs.lead',
    'executive': 'jobs.executive',
  }
  return levelKeys[level] ? t(levelKeys[level]) : level
}

const formatDate = (date: string): string => {
  const now = new Date()
  const postDate = new Date(date)
  const diffTime = now.getTime() - postDate.getTime()
  const diffDays = Math.floor(Math.abs(diffTime) / (1000 * 60 * 60 * 24))
  
  if (diffTime < 0) {
    if (diffDays === 0) return t('myApplications.today')
    if (diffDays === 1) return 'Tomorrow'
    if (diffDays < 7) return `in ${diffDays} days`
    if (diffDays < 30) {
      const weeks = Math.floor(diffDays / 7)
      return `in ${weeks} ${weeks === 1 ? 'week' : 'weeks'}`
    }
    if (diffDays < 365) {
      const months = Math.floor(diffDays / 30)
      return `in ${months} ${months === 1 ? 'month' : 'months'}`
    }
  }
  
  if (diffDays === 0) return t('myApplications.today')
  if (diffDays === 1) return t('myApplications.yesterday')
  if (diffDays < 7) return t('myApplications.daysAgo', { count: diffDays })
  if (diffDays < 30) {
    const weeks = Math.floor(diffDays / 7)
    return t('myApplications.weeksAgo', { count: weeks })
  }
  if (diffDays < 365) {
    const months = Math.floor(diffDays / 30)
    return t('myApplications.monthsAgo', { count: months })
  }
  const years = Math.floor(diffDays / 365)
  return t('myApplications.yearsAgo', { count: years })
}

const _formatJobDate = (date: string): string => {
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

const _formatNumber = (num: number): string => {
  if (num >= 1000000) return (num / 1000000).toFixed(1) + 'M'
  if (num >= 1000) return (num / 1000).toFixed(1) + 'K'
  return num.toString()
}

const _formatSalary = (min: number, max: number): string => {
  if (!min && !max) return 'Competitive'
  if (min && max) {
    return `$${_formatNumber(min)} - $${_formatNumber(max)}`
  }
  if (min) return `From $${_formatNumber(min)}`
  if (max) return `Up to $${_formatNumber(max)}`
  return 'Competitive'
}

const _formatSalaryPeriod = (period: string): string => {
  const periods: Record<string, string> = {
    'hourly': 'hour',
    'daily': 'day',
    'weekly': 'week',
    'monthly': 'month',
    'yearly': 'year',
  }
  return periods[period] || period
}

const _getBadgeVariant = (level: string): 'primary' | 'secondary' | 'success' | 'warning' | 'danger' | 'info' => {
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
  if (company.value?.slug) {
    router.push({
      name: 'view-my-company',
      params: { slug: company.value.slug }
    })
  } else {
    router.push({ name: 'my-jobs' })
  }
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
      showDeleteModal.value = false
      toast.success(t('myJobs.deleteSuccess'))
      // Redirect to My Jobs page instead of company page
      await router.push({ name: 'my-jobs' })
    } else {
      toast.error(response.message || 'Failed to delete job. Please try again.')
    }
  } catch (error) {
    console.error('Failed to delete job:', error)
    const err = error as { response?: { data?: { message?: string }, status?: number } }
    
    // Handle specific error cases
    if (err.response?.status === 404) {
      showDeleteModal.value = false
      toast.error(t('myJobs.jobNotFound'))
      await router.push({ name: 'my-jobs' })
    } else {
      toast.error(err.response?.data?.message || 'Failed to delete job. Please try again.')
    }
  } finally {
    deleting.value = false
  }
}

const fetchJobAndCompany = async () => {
  loading.value = true
  
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
            router.push({ name: 'not-found' })
            return
          }
        }
      } else {
        router.push({ name: 'not-found' })
        return
      }
    }
  } catch (error) {
    console.error('Failed to fetch job:', error)
    router.push({ name: 'not-found' })
    return
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchJobAndCompany()
})
</script>

<style scoped>
.shadow-custom {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}
</style>
