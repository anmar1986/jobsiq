<template>
  <div class="container-custom py-6 sm:py-8">
    <!-- Header -->
    <div class="mb-6 sm:mb-8">
      <h1 class="text-2xl sm:text-3xl font-bold text-gray-900 mb-2">Dashboard</h1>
      <p class="text-sm sm:text-base text-gray-600">
        {{ authStore.isCompanyOwner 
          ? 'Welcome back! Manage your companies and jobs from here.' 
          : 'Welcome back! Manage your CVs and job applications from here.' 
        }}
      </p>
    </div>

    <!-- Quick Actions Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-6">
      <!-- My Companies Card - Company Owners Only -->
      <router-link
        v-if="authStore.isCompanyOwner"
        :to="myCompaniesLink"
        class="block p-4 sm:p-6 bg-white border border-gray-200 rounded-lg hover:shadow-lg hover:border-primary-500 transition-all group"
      >
        <div class="flex items-start justify-between mb-3 sm:mb-4">
          <div class="w-12 h-12 bg-primary-100 rounded-lg flex items-center justify-center group-hover:bg-primary-200 transition-colors">
            <svg class="h-6 w-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
            </svg>
          </div>
          <svg class="h-5 w-5 text-gray-400 group-hover:text-primary-600 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
          </svg>
        </div>
        <h3 class="text-lg sm:text-xl font-semibold text-gray-900 mb-2 group-hover:text-primary-600 transition-colors">
          {{ companyStore.myCompanies.length === 1 ? 'My Company' : 'My Companies' }}
        </h3>
        <p class="text-gray-600 text-xs sm:text-sm">
          {{ companyStore.myCompanies.length === 1 ? 'Manage your company and post jobs' : 'Create your company profile' }}
        </p>
      </router-link>

      <!-- My CVs Card - Job Seekers Only -->
      <router-link
        v-if="authStore.isJobSeeker"
        to="/my-cvs"
        class="block p-4 sm:p-6 bg-white border border-gray-200 rounded-lg hover:shadow-lg hover:border-primary-500 transition-all group"
      >
        <div class="flex items-start justify-between mb-3 sm:mb-4">
          <div class="w-12 h-12 bg-secondary-100 rounded-lg flex items-center justify-center group-hover:bg-secondary-200 transition-colors">
            <svg class="h-6 w-6 text-secondary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
          </div>
          <svg class="h-5 w-5 text-gray-400 group-hover:text-primary-600 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
          </svg>
        </div>
        <h3 class="text-lg sm:text-xl font-semibold text-gray-900 mb-2 group-hover:text-primary-600 transition-colors">My CVs</h3>
        <p class="text-gray-600 text-xs sm:text-sm">Create and manage your resumes</p>
      </router-link>

      <!-- My Applications Card - Job Seekers Only -->
      <router-link
        v-if="authStore.isJobSeeker"
        to="/my-applications"
        class="block p-4 sm:p-6 bg-white border border-gray-200 rounded-lg hover:shadow-lg hover:border-primary-500 transition-all group"
      >
        <div class="flex items-start justify-between mb-3 sm:mb-4">
          <div class="w-12 h-12 bg-indigo-100 rounded-lg flex items-center justify-center group-hover:bg-indigo-200 transition-colors">
            <svg class="h-6 w-6 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" />
            </svg>
          </div>
          <svg class="h-5 w-5 text-gray-400 group-hover:text-primary-600 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
          </svg>
        </div>
        <h3 class="text-lg sm:text-xl font-semibold text-gray-900 mb-2 group-hover:text-primary-600 transition-colors">My Applications</h3>
        <p class="text-gray-600 text-xs sm:text-sm">Track your job applications</p>
      </router-link>

      <!-- Saved Jobs Card - Job Seekers Only -->
      <router-link
        v-if="authStore.isJobSeeker"
        to="/saved-jobs"
        class="block p-4 sm:p-6 bg-white border border-gray-200 rounded-lg hover:shadow-lg hover:border-primary-500 transition-all group"
      >
        <div class="flex items-start justify-between mb-3 sm:mb-4">
          <div class="w-12 h-12 bg-yellow-100 rounded-lg flex items-center justify-center group-hover:bg-yellow-200 transition-colors">
            <svg class="h-6 w-6 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 5a2 2 0 012-2h10a2 2 0 012 2v16l-7-3.5L5 21V5z" />
            </svg>
          </div>
          <svg class="h-5 w-5 text-gray-400 group-hover:text-primary-600 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
          </svg>
        </div>
        <h3 class="text-lg sm:text-xl font-semibold text-gray-900 mb-2 group-hover:text-primary-600 transition-colors">
          Saved Jobs
          <span v-if="savedJobStore.savedJobsCount !== null" class="text-xs sm:text-sm text-gray-500 font-normal ml-2">({{ savedJobStore.savedJobsCount }})</span>
        </h3>
        <p class="text-gray-600 text-xs sm:text-sm">View jobs you've bookmarked</p>
      </router-link>

      <!-- Profile Card -->
      <router-link
        to="/profile"
        class="block p-4 sm:p-6 bg-white border border-gray-200 rounded-lg hover:shadow-lg hover:border-primary-500 transition-all group"
      >
        <div class="flex items-start justify-between mb-3 sm:mb-4">
          <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center group-hover:bg-green-200 transition-colors">
            <svg class="h-6 w-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
            </svg>
          </div>
          <svg class="h-5 w-5 text-gray-400 group-hover:text-primary-600 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
          </svg>
        </div>
        <h3 class="text-lg sm:text-xl font-semibold text-gray-900 mb-2 group-hover:text-primary-600 transition-colors">My Profile</h3>
        <p class="text-gray-600 text-xs sm:text-sm">Update your personal information</p>
      </router-link>

      <!-- Browse Jobs Card -->
      <router-link
        to="/jobs"
        class="block p-4 sm:p-6 bg-white border border-gray-200 rounded-lg hover:shadow-lg hover:border-primary-500 transition-all group"
      >
        <div class="flex items-start justify-between mb-3 sm:mb-4">
          <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center group-hover:bg-blue-200 transition-colors">
            <svg class="h-6 w-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
            </svg>
          </div>
          <svg class="h-5 w-5 text-gray-400 group-hover:text-primary-600 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
          </svg>
        </div>
        <h3 class="text-lg sm:text-xl font-semibold text-gray-900 mb-2 group-hover:text-primary-600 transition-colors">Browse Jobs</h3>
        <p class="text-gray-600 text-xs sm:text-sm">Find your next opportunity</p>
      </router-link>

      <!-- Browse Companies Card -->
      <router-link
        to="/companies"
        class="block p-4 sm:p-6 bg-white border border-gray-200 rounded-lg hover:shadow-lg hover:border-primary-500 transition-all group"
      >
        <div class="flex items-start justify-between mb-3 sm:mb-4">
          <div class="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center group-hover:bg-purple-200 transition-colors">
            <svg class="h-6 w-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
            </svg>
          </div>
          <svg class="h-5 w-5 text-gray-400 group-hover:text-primary-600 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
          </svg>
        </div>
        <h3 class="text-lg sm:text-xl font-semibold text-gray-900 mb-2 group-hover:text-primary-600 transition-colors">Browse Companies</h3>
        <p class="text-gray-600 text-xs sm:text-sm">Explore companies hiring now</p>
      </router-link>

      <!-- Free CVs Card - Company Owners Only -->
      <router-link
        v-if="FEATURES.FREE_CVS_ENABLED && authStore.isCompanyOwner"
        to="/cvs"
        class="block p-4 sm:p-6 bg-white border border-gray-200 rounded-lg hover:shadow-lg hover:border-primary-500 transition-all group"
      >
        <div class="flex items-start justify-between mb-3 sm:mb-4">
          <div class="w-12 h-12 bg-orange-100 rounded-lg flex items-center justify-center group-hover:bg-orange-200 transition-colors">
            <svg class="h-6 w-6 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
          </div>
          <svg class="h-5 w-5 text-gray-400 group-hover:text-primary-600 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
          </svg>
        </div>
        <h3 class="text-lg sm:text-xl font-semibold text-gray-900 mb-2 group-hover:text-primary-600 transition-colors">Browse Free CVs</h3>
        <p class="text-gray-600 text-xs sm:text-sm">View available candidates</p>
      </router-link>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, computed } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { useSavedJobStore } from '@/stores/savedJob'
import { useCompanyStore } from '@/stores/company'
import { FEATURES } from '@/config/features'

const authStore = useAuthStore()
const savedJobStore = useSavedJobStore()
const companyStore = useCompanyStore()

// Compute the my companies link - goes directly to company profile if exists
const myCompaniesLink = computed(() => {
  if (companyStore.myCompanies.length > 0) {
    return `/my-companies/${companyStore.myCompanies[0].slug}`
  }
  return '/my-companies'
})

onMounted(async () => {
  if (authStore.isJobSeeker) {
    savedJobStore.fetchSavedJobsCount()
  }
  
  // Fetch user's companies for company owners
  if (authStore.isCompanyOwner) {
    await companyStore.fetchMyCompanies()
  }
})
</script>
