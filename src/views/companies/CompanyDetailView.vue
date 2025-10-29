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
      <!-- Cover Image Hero Section -->
      <div class="relative">
        <!-- Cover Image -->
        <div class="h-96 bg-gradient-to-br from-primary-600 to-secondary-600 relative overflow-hidden">
          <img 
            v-if="company.cover?.path" 
            :src="getLogoUrl(company.cover.path)" 
            :alt="company.name || 'Company cover'"
            class="w-full h-full object-contain"
          />
          <!-- Gradient Overlay -->
          <div class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent"></div>
          
          <!-- Back Button -->
          <button 
            @click="router.back()" 
            class="absolute top-6 left-6 flex items-center gap-2 text-white/90 hover:text-white bg-black/30 hover:bg-black/50 px-4 py-2 rounded-lg backdrop-blur-sm transition-all"
          >
            <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
            Back to Companies
          </button>
        </div>

        <!-- Company Logo - Centered and Overlapping -->
        <div class="container-custom relative">
          <div class="absolute left-1/2 -translate-x-1/2 -translate-y-1/2">
            <div class="w-40 h-40 rounded-2xl bg-white shadow-2xl flex items-center justify-center overflow-hidden border-4 border-white">
              <img 
                v-if="company.logo?.path" 
                :src="getLogoUrl(company.logo.path)" 
                :alt="company.name"
                class="w-full h-full object-contain p-2"
              />
              <span v-else class="text-5xl font-bold text-primary-600">{{ company.name.charAt(0) }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Company Info Section -->
      <div class="bg-white border-b border-gray-200">
        <div class="container-custom pt-24 pb-8">
          <div class="text-center mb-8">
            <h1 class="text-4xl md:text-5xl font-bold text-gray-900 mb-3">{{ company.name }}</h1>
            <p v-if="company.tagline" class="text-xl text-gray-600 mb-4">{{ company.tagline }}</p>
            
            <div class="flex flex-wrap items-center justify-center gap-4 text-gray-600 mb-6">
              <span v-if="company.city" class="flex items-center gap-1.5">
                <svg class="h-5 w-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                </svg>
                {{ company.city }}, {{ company.country }}
              </span>
              <span v-if="company.industry" class="text-gray-300">•</span>
              <span v-if="company.industry" class="flex items-center gap-1.5">
                <svg class="h-5 w-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
                </svg>
                {{ company.industry }}
              </span>
              <span v-if="company.company_size" class="text-gray-300">•</span>
              <span v-if="company.company_size" class="flex items-center gap-1.5">
                <svg class="h-5 w-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                </svg>
                {{ company.company_size }} employees
              </span>
              <span v-if="company.website" class="text-gray-300">•</span>
              <span v-if="company.website" class="flex items-center gap-1.5">
                <svg class="h-5 w-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9" />
                </svg>
                <a :href="company.website" target="_blank" class="text-primary-600 hover:text-primary-700 hover:underline">
                  {{ formatWebsite(company.website) }}
                </a>
              </span>
            </div>

            <p v-if="company.description" class="text-lg text-gray-700 leading-relaxed max-w-4xl mx-auto">
              {{ company.description }}
            </p>
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

                <div v-if="company.street || company.city" class="flex items-start gap-3">
                  <svg class="h-5 w-5 text-gray-400 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                  </svg>
                  <div class="flex-1 min-w-0">
                    <p class="text-sm text-gray-600 mb-1">Address</p>
                    <p class="text-sm text-gray-900">
                      <span v-if="company.street">{{ company.street }}<br /></span>
                      <span v-if="company.city">{{ company.city }}</span>
                      <span v-if="company.country">, {{ company.country }}</span>
                    </p>
                  </div>
                </div>
              </div>

              <!-- Social Media Links -->
              <div v-if="company.linkedin || company.twitter || company.facebook || company.instagram || company.youtube" class="mt-6 pt-6 border-t border-gray-200">
                <h3 class="text-sm font-semibold text-gray-900 mb-3">Follow Us</h3>
                <div class="flex flex-col gap-3 items-start">
                  <a v-if="company.linkedin" :href="company.linkedin" target="_blank" rel="noopener noreferrer" 
                     class="flex items-center gap-2 px-3 py-2 bg-blue-700 hover:bg-blue-800 text-white rounded-lg transition-colors text-sm">
                    <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z" />
                    </svg>
                    LinkedIn
                  </a>

                  <a v-if="company.facebook" :href="company.facebook" target="_blank" rel="noopener noreferrer"
                     class="flex items-center gap-2 px-3 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors text-sm">
                    <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z" />
                    </svg>
                    Facebook
                  </a>

                  <a v-if="company.instagram" :href="company.instagram" target="_blank" rel="noopener noreferrer"
                     class="flex items-center gap-2 px-3 py-2 bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-700 hover:to-pink-700 text-white rounded-lg transition-colors text-sm">
                    <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z" />
                    </svg>
                    Instagram
                  </a>

                  <a v-if="company.youtube" :href="company.youtube" target="_blank" rel="noopener noreferrer"
                     class="flex items-center gap-2 px-3 py-2 bg-red-600 hover:bg-red-700 text-white rounded-lg transition-colors text-sm">
                    <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z" />
                    </svg>
                    YouTube
                  </a>

                  <a v-if="company.twitter" :href="company.twitter" target="_blank" rel="noopener noreferrer"
                     class="flex items-center gap-2 px-3 py-2 bg-black hover:bg-gray-900 text-white rounded-lg transition-colors text-sm">
                    <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
                    </svg>
                    X
                  </a>
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

const getLogoUrl = (path: string): string => {
  if (!path) return ''
  
  // Handle different path formats
  if (path.startsWith('data:') || path.startsWith('blob:') || path.startsWith('http')) {
    return path
  }
  
  if (path.startsWith('/storage/')) {
    return path
  }
  
  // Remove leading slashes and construct clean path
  const cleanPath = path.replace(/^\/+/, '')
  return `/storage/${cleanPath}`
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
    // Handle both ID and slug
    const identifier = (route.params.id || route.params.slug) as string
    await companyStore.fetchCompany(identifier)
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
