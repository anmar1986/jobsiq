<template>
  <div class="min-h-screen">
    <!-- Hero Section with Search -->
    <section class="bg-gradient-to-br from-primary-600 via-primary-700 to-secondary-700 text-white">
      <div class="container-custom py-16 md:py-24">
        <div class="max-w-4xl mx-auto text-center">
          <h1 class="text-4xl md:text-6xl font-bold mb-6 animate-fade-in">
            Your Career Journey Starts Here
          </h1>
          <p class="text-xl md:text-2xl text-primary-100 mb-10 animate-fade-in animation-delay-200">
            Discover thousands of job opportunities with all the information you need.
            Connect with top companies worldwide.
          </p>
          
          <!-- Search Bar -->
          <div class="bg-white rounded-lg shadow-2xl p-4 md:p-6 animate-fade-in animation-delay-400">
            <form @submit.prevent="handleSearch" class="flex flex-col md:flex-row gap-3">
              <div class="flex-1">
                <BaseInput
                  v-model="searchQuery"
                  type="text"
                  placeholder="Job title, keywords, or company"
                  size="lg"
                  show-clear-button
                >
                  <template #icon-left>
                    <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                    </svg>
                  </template>
                </BaseInput>
              </div>
              
              <div class="flex-1 md:max-w-xs">
                <BaseInput
                  v-model="locationQuery"
                  type="text"
                  placeholder="City or country"
                  size="lg"
                  show-clear-button
                >
                  <template #icon-left>
                    <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                    </svg>
                  </template>
                </BaseInput>
              </div>
              
              <BaseButton type="submit" variant="primary" size="lg" class="md:w-auto">
                <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
                Search Jobs
              </BaseButton>
            </form>
            
            <!-- Popular Searches -->
            <div class="mt-4 flex flex-wrap gap-2 text-sm">
              <span class="text-gray-600">Popular:</span>
              <button
                v-for="tag in popularSearches"
                :key="tag"
                @click="searchQuery = tag; handleSearch()"
                class="text-primary-600 hover:text-primary-700 font-medium hover:underline"
              >
                {{ tag }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Stats Section -->
    <section class="bg-white border-b border-gray-200">
      <div class="container-custom py-12 md:py-16">
        <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
          <div v-for="stat in stats" :key="stat.label" class="text-center">
            <div class="text-4xl md:text-5xl font-bold text-primary-600 mb-2">{{ stat.value }}</div>
            <div class="text-gray-600 font-medium">{{ stat.label }}</div>
          </div>
        </div>
      </div>
    </section>

    <!-- For Companies CTA (for authenticated users) -->
    <section v-if="authStore.isAuthenticated" class="bg-gradient-to-r from-primary-600 to-secondary-600 border-b border-primary-700">
      <div class="container-custom py-8">
        <div class="flex flex-col md:flex-row items-center justify-between gap-4">
          <div class="text-white text-center md:text-left">
            <h3 class="text-2xl font-bold mb-2">Looking to Hire?</h3>
            <p class="text-primary-100">Manage your companies and post jobs to reach thousands of qualified candidates</p>
          </div>
          <router-link to="/my-companies" class="btn bg-white text-primary-600 hover:bg-gray-100 px-8 py-3 text-lg whitespace-nowrap">
            <svg class="h-5 w-5 mr-2 inline" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
            </svg>
            For Companies
          </router-link>
        </div>
      </div>
    </section>

    <!-- How It Works -->
    <section class="bg-gray-50 py-16 md:py-24">
      <div class="container-custom">
        <div class="text-center mb-16">
          <h2 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">How It Works</h2>
          <p class="text-xl text-gray-600 max-w-2xl mx-auto">
            Get hired in 3 simple steps
          </p>
        </div>

        <div class="grid md:grid-cols-3 gap-8 md:gap-12">
          <div v-for="(step, index) in howItWorks" :key="step.title" class="text-center">
            <div class="relative mb-6">
              <div class="w-20 h-20 mx-auto bg-gradient-to-br from-primary-500 to-secondary-500 rounded-full flex items-center justify-center text-white text-2xl font-bold shadow-lg">
                {{ index + 1 }}
              </div>
              <div v-if="index < howItWorks.length - 1" class="hidden md:block absolute top-10 left-1/2 w-full h-0.5 bg-gray-300" style="transform: translateX(50%)"></div>
            </div>
            <h3 class="text-xl font-semibold text-gray-900 mb-3">{{ step.title }}</h3>
            <p class="text-gray-600">{{ step.description }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Why Choose Us -->
    <section class="py-16 md:py-24 bg-white">
      <div class="container-custom">
        <div class="text-center mb-16">
          <h2 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Why Choose JobsIQ?</h2>
          <p class="text-xl text-gray-600 max-w-2xl mx-auto">
            We provide the best platform for job seekers and employers
          </p>
        </div>

        <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          <div v-for="feature in features" :key="feature.title" class="text-center md:text-left">
            <div class="w-14 h-14 bg-primary-100 rounded-lg flex items-center justify-center mb-4 mx-auto md:mx-0">
              <component :is="feature.icon" class="h-7 w-7 text-primary-600" />
            </div>
            <h3 class="text-xl font-semibold text-gray-900 mb-3">{{ feature.title }}</h3>
            <p class="text-gray-600">{{ feature.description }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="py-16 md:py-24 bg-gradient-to-r from-primary-600 to-secondary-600 text-white">
      <div class="container-custom text-center">
        <h2 class="text-3xl md:text-5xl font-bold mb-6">Ready to Get Started?</h2>
        <p class="text-xl text-primary-100 mb-8 max-w-2xl mx-auto">
          Join thousands of job seekers and employers who trust JobsIQ for their career needs
        </p>
        <div class="flex flex-col sm:flex-row gap-4 justify-center">
          <router-link to="/register" class="btn bg-white text-primary-600 hover:bg-gray-100 px-8 py-3 text-lg">
            Create Free Account
          </router-link>
          <router-link to="/jobs" class="btn border-2 border-white text-white hover:bg-white/10 px-8 py-3 text-lg">
            Browse Jobs
          </router-link>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { ref, h } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseBadge from '@/components/base/BaseBadge.vue'

const router = useRouter()
const authStore = useAuthStore()

const searchQuery = ref('')
const locationQuery = ref('')

const popularSearches = ['Designer', 'Developer', 'Marketing', 'Sales', 'Manager']

const stats = [
  { value: '10K+', label: 'Active Jobs' },
  { value: '5K+', label: 'Companies' },
  { value: '50K+', label: 'Job Seekers' },
  { value: '2K+', label: 'Success Stories' },
]

const howItWorks = [
  {
    title: 'Create Account',
    description: 'Sign up for free and build your professional profile in minutes',
  },
  {
    title: 'Search & Apply',
    description: 'Browse thousands of jobs and apply to positions that match your skills',
  },
  {
    title: 'Get Hired',
    description: 'Connect with employers and land your dream job',
  },
]

const features = [
  {
    title: 'Easy Job Search',
    description: 'Find jobs that match your skills with our powerful search and filter system',
    icon: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z' })]),
  },
  {
    title: 'Verified Companies',
    description: 'All companies are verified to ensure you\'re applying to legitimate opportunities',
    icon: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z' })]),
  },
  {
    title: 'Quick Apply',
    description: 'Apply to multiple jobs with one click using your saved profile and CV',
    icon: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M13 10V3L4 14h7v7l9-11h-7z' })]),
  },
  {
    title: 'Career Resources',
    description: 'Access resume tips, interview guides, and career advice from experts',
    icon: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253' })]),
  },
  {
    title: 'Job Alerts',
    description: 'Get notified when new jobs matching your preferences are posted',
    icon: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9' })]),
  },
  {
    title: 'Secure & Private',
    description: 'Your data is protected with enterprise-level security and privacy',
    icon: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z' })]),
  },
]

const handleSearch = () => {
  const params = new URLSearchParams()
  if (searchQuery.value) params.append('search', searchQuery.value)
  if (locationQuery.value) params.append('location', locationQuery.value)
  
  router.push(`/jobs?${params.toString()}`)
}
</script>
