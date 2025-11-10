<template>
  <div class="bg-gray-50 min-h-screen">
    <!-- Loading State -->
    <div v-if="loading" class="container-custom py-4 sm:py-8 px-4 sm:px-6 lg:px-8" style="max-width: 1400px;">
      <div class="animate-pulse space-y-4 sm:space-y-8">
        <div class="h-6 sm:h-8 bg-gray-200 rounded w-3/4"></div>
        <div class="bg-white rounded-lg p-4 sm:p-8">
          <div class="h-5 sm:h-6 bg-gray-200 rounded w-1/2 mb-4"></div>
          <div class="space-y-2">
            <div class="h-4 bg-gray-200 rounded w-full"></div>
            <div class="h-4 bg-gray-200 rounded w-5/6"></div>
            <div class="h-4 bg-gray-200 rounded w-4/6"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Job Not Found -->
    <div v-else-if="!job" class="container-custom py-8 sm:py-16 px-4 sm:px-6 lg:px-8" style="max-width: 1400px;">
      <BaseCard class="p-6 sm:p-12 text-center">
        <svg class="h-12 w-12 sm:h-16 sm:w-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <h2 class="text-xl sm:text-2xl font-bold text-gray-900 mb-2">Job Not Found</h2>
        <p class="text-sm sm:text-base text-gray-600 mb-6">The job you're looking for doesn't exist or has been removed.</p>
        <BaseButton variant="primary" @click="router.push('/jobs')">Browse All Jobs</BaseButton>
      </BaseCard>
    </div>

    <!-- Job Detail Content -->
    <div v-else>
      <!-- Header Section -->
      <div class="bg-white border-b border-gray-200">
        <div class="container-custom py-4 sm:py-8 px-4 sm:px-6 lg:px-8" style="max-width: 1400px;">
          <!-- Back Button -->
          <button 
            @click="router.back()" 
            class="inline-flex items-center gap-2 px-4 py-2 text-sm sm:text-base font-medium text-gray-700 bg-white border-2 border-gray-300 rounded-lg hover:bg-gray-50 hover:border-gray-400 hover:text-gray-900 transition-all mb-4 sm:mb-6 shadow-sm cursor-pointer hover:shadow-md"
          >
            <svg class="h-4 w-4 sm:h-5 sm:w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
            Back to Jobs
          </button>

          <div class="flex flex-col lg:flex-row gap-6 sm:gap-8 lg:relative">
            <!-- Job Info -->
            <div class="flex-1">
              <div class="flex items-start gap-3 sm:gap-4 mb-4 sm:mb-6">
                <!-- Company Logo -->
                <div class="w-14 h-14 sm:w-16 sm:h-16 lg:w-20 lg:h-20 rounded-lg sm:rounded-xl overflow-hidden bg-white border-2 border-gray-200 flex items-center justify-center flex-shrink-0">
                  <img 
                    v-if="job.company?.logo?.url" 
                    :src="job.company.logo.url" 
                    :alt="job.company.name"
                    class="w-full h-full object-contain p-1 sm:p-2"
                  />
                  <div v-else class="w-full h-full bg-gradient-to-br from-primary-500 to-secondary-500 flex items-center justify-center text-white text-lg sm:text-xl lg:text-2xl font-bold">
                    {{ job.company?.name?.charAt(0) || 'C' }}
                  </div>
                </div>

                <div class="flex-1 min-w-0">
                  <h1 class="text-xl sm:text-2xl md:text-3xl lg:text-4xl font-bold text-gray-900 mb-1 sm:mb-2 line-clamp-2">{{ job.title }}</h1>
                  <router-link :to="`/companies/${job.company?.slug}`" class="text-base sm:text-lg lg:text-xl text-primary-600 hover:text-primary-700 font-medium mb-2 sm:mb-3 inline-block">
                    {{ job.company?.name }}
                  </router-link>
                  
                  <!-- Meta Info -->
                  <div class="flex flex-wrap gap-2 sm:gap-3 mb-3 sm:mb-4 p-3 sm:p-4 bg-gray-50 rounded-lg border border-gray-200">
                    <div class="flex items-center gap-1.5 sm:gap-2 px-2 sm:px-3 py-1 sm:py-1.5 bg-white rounded-md border border-gray-200">
                      <svg class="w-3.5 h-3.5 sm:w-4 sm:h-4 text-primary-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                      </svg>
                      <span class="text-xs sm:text-sm font-medium text-gray-900 truncate">{{ job.location }}</span>
                    </div>
                    <div class="flex items-center gap-1.5 sm:gap-2 px-2 sm:px-3 py-1 sm:py-1.5 bg-white rounded-md border border-gray-200">
                      <svg class="w-3.5 h-3.5 sm:w-4 sm:h-4 text-primary-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                      </svg>
                      <span class="text-xs sm:text-sm font-medium text-gray-900 whitespace-nowrap">{{ formatEmploymentType(job.employment_type) }}</span>
                    </div>
                    <div class="flex items-center gap-1.5 sm:gap-2 px-2 sm:px-3 py-1 sm:py-1.5 bg-white rounded-md border border-gray-200">
                      <svg class="w-3.5 h-3.5 sm:w-4 sm:h-4 text-primary-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                      </svg>
                      <span class="text-xs sm:text-sm font-medium text-gray-900 whitespace-nowrap">{{ formatExperienceLevel(job.experience_level) }}</span>
                    </div>
                    <div v-if="job.is_remote" class="flex items-center gap-1.5 sm:gap-2 px-2 sm:px-3 py-1 sm:py-1.5 bg-green-50 rounded-md border border-green-200">
                      <svg class="w-3.5 h-3.5 sm:w-4 sm:h-4 text-green-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                      </svg>
                      <span class="text-xs sm:text-sm font-medium text-green-700 whitespace-nowrap">Remote</span>
                    </div>
                    <div v-if="job.category" class="flex items-center gap-1.5 sm:gap-2 px-2 sm:px-3 py-1 sm:py-1.5 bg-purple-50 rounded-md border border-purple-200">
                      <svg class="w-3.5 h-3.5 sm:w-4 sm:h-4 text-purple-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" />
                      </svg>
                      <span class="text-xs sm:text-sm font-medium text-purple-700 truncate">{{ job.category }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Salary & Apply Card -->
            <div class="lg:hidden">
              <BaseCard class="p-4 sm:p-6">
                <div class="mb-4 sm:mb-6">
                  <p class="text-xs sm:text-sm text-gray-600 mb-2">
                    Salary Range{{ job.salary_period ? ' (' + formatSalaryPeriod(job.salary_period) + ')' : '' }}
                  </p>
                  <p class="text-xl sm:text-2xl font-bold text-gray-900">
                    {{ formatSalaryRange(job.salary_min || 0, job.salary_max || 0, job.salary_currency, job.salary_period) }}
                  </p>
                </div>

                <!-- Apply Button - Only for Job Seekers -->
                <BaseButton
                  v-if="authStore.isJobSeeker"
                  variant="primary"
                  size="lg"
                  class="w-full mb-3"
                  @click="handleApply"
                  :disabled="hasApplied"
                >
                  <template #icon-left>
                    <svg v-if="!hasApplied" class="h-4 w-4 sm:h-5 sm:w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                  </template>
                  {{ hasApplied ? 'Already Applied' : 'Apply Now' }}
                </BaseButton>

                <!-- Login prompt for non-authenticated users -->
                <BaseButton
                  v-else-if="!authStore.isAuthenticated"
                  variant="primary"
                  size="lg"
                  class="w-full mb-3"
                  @click="handleApply"
                >
                  <template #icon-left>
                    <svg class="h-4 w-4 sm:h-5 sm:w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                  </template>
                  Apply Now
                </BaseButton>

                <!-- Share Job Button with Dropdown -->
                <div class="relative w-full mb-3" ref="shareMenuRef">
                  <BaseButton
                    variant="outline"
                    size="lg"
                    class="w-full"
                    @click.stop="toggleShareMenu"
                  >
                    <template #icon-left>
                      <svg class="h-4 w-4 sm:h-5 sm:w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z" />
                      </svg>
                    </template>
                    Share Job
                  </BaseButton>

                  <!-- Share Menu Dropdown -->
                  <Transition
                    enter-active-class="transition ease-out duration-100"
                    enter-from-class="transform opacity-0 scale-95"
                    enter-to-class="transform opacity-100 scale-100"
                    leave-active-class="transition ease-in duration-75"
                    leave-from-class="transform opacity-100 scale-100"
                    leave-to-class="transform opacity-0 scale-95"
                  >
                    <div
                      v-if="showShareMenu"
                      class="absolute top-full left-0 right-0 mt-2 bg-white rounded-lg shadow-lg border border-gray-200 py-2 z-10 max-h-96 overflow-y-auto"
                    >
                      <!-- Share on X (Twitter) -->
                      <button
                        @click="shareOn('twitter')"
                        class="w-full px-4 py-2 text-left hover:bg-gray-50 flex items-center gap-3 text-gray-700"
                      >
                        <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                          <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
                        </svg>
                        <span>Share on X</span>
                      </button>

                      <!-- Share on Facebook -->
                      <button
                        @click="shareOn('facebook')"
                        class="w-full px-4 py-2 text-left hover:bg-gray-50 flex items-center gap-3 text-gray-700"
                      >
                        <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                          <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z" />
                        </svg>
                        <span>Share on Facebook</span>
                      </button>

                      <!-- Share on Instagram -->
                      <button
                        @click="shareOn('instagram')"
                        class="w-full px-4 py-2 text-left hover:bg-gray-50 flex items-center gap-3 text-gray-700"
                      >
                        <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                          <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z" />
                        </svg>
                        <span>Share on Instagram</span>
                      </button>

                      <!-- Share on Snapchat -->
                      <button
                        @click="shareOn('snapchat')"
                        class="w-full px-4 py-2 text-left hover:bg-gray-50 flex items-center gap-3 text-gray-700"
                      >
                        <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                          <path d="M12.206.793c.99 0 4.347.276 5.93 3.821.529 1.193.403 3.219.299 4.847l-.003.06c-.012.18-.022.345-.03.51.075.045.203.09.401.09.3 0 .73-.057 1.126-.12.57-.084 1.185-.179 1.757-.179.3 0 .582.04.84.12.42.15.81.42 1.023.84.195.39.225.84.09 1.289-.12.45-.36.87-.645 1.17-.27.285-.645.54-1.065.705l-.084.045c-.3.165-.704.42-.78.885-.03.135-.015.27.045.404.09.21.21.405.345.585.195.27.42.54.645.81.51.585 1.065 1.185 1.47 1.83.225.36.42.72.57 1.095.09.24.15.495.18.75.015.195 0 .375-.045.555-.075.27-.24.54-.495.705-.3.195-.659.285-1.065.285l-.075-.015c-.705-.075-1.38-.24-2.04-.42-.585-.165-1.17-.3-1.77-.42-.15-.03-.296-.045-.444-.045-.555 0-1.05.195-1.53.42-.45.195-.945.405-1.485.57-.9.3-1.725.345-2.385.345-.405 0-.78-.045-1.095-.09-.75-.15-1.485-.42-2.22-.705-.585-.225-1.17-.48-1.77-.705-.42-.15-.885-.225-1.335-.225-.3 0-.585.03-.87.09-.555.12-1.095.27-1.65.42-.705.195-1.38.42-2.085.57-.705.15-1.38.225-2.01.195-.45-.015-.885-.135-1.26-.375-.3-.195-.495-.495-.585-.84-.075-.3-.075-.615 0-.915.09-.375.27-.735.495-1.065.42-.645.96-1.23 1.485-1.815.24-.27.465-.54.675-.81.12-.165.225-.345.3-.54.09-.195.12-.405.075-.615-.045-.435-.375-.705-.69-.87l-.096-.06c-.42-.165-.795-.42-1.065-.705-.285-.3-.525-.72-.645-1.17-.135-.45-.105-.9.09-1.29.21-.42.6-.69 1.02-.84.259-.08.541-.12.84-.12.573 0 1.185.09 1.757.18.39.06.825.12 1.124.12.195 0 .315-.045.375-.075-.015-.165-.03-.345-.045-.54l-.015-.09c-.105-1.59-.21-3.615.285-4.806C7.86 1.068 11.19.792 12.206.792zm0 0" />
                        </svg>
                        <span>Share on Snapchat</span>
                      </button>

                      <!-- Copy Link -->
                      <button
                        @click="copyJobLink"
                        class="w-full px-4 py-2 text-left hover:bg-gray-50 flex items-center gap-3 text-gray-700 border-t border-gray-100"
                      >
                        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 5H6a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2v-1M8 5a2 2 0 002 2h2a2 2 0 002-2M8 5a2 2 0 012-2h2a2 2 0 012 2m0 0h2a2 2 0 012 2v3m2 4H10m0 0l3-3m-3 3l3 3" />
                        </svg>
                        <span>Copy Link</span>
                      </button>
                    </div>
                  </Transition>
                </div>

                <!-- Save Job Button - Only for Job Seekers -->
                <BaseButton
                  v-if="!isOwnJob && authStore.isJobSeeker"
                  variant="outline"
                  size="lg"
                  class="w-full"
                  @click="toggleSave"
                >
                  <template #icon-left>
                    <svg 
                      class="h-4 w-4 sm:h-5 sm:w-5" 
                      :class="isSaved ? 'fill-yellow-500 text-yellow-500' : ''"
                      :fill="isSaved ? 'currentColor' : 'none'" 
                      stroke="currentColor" 
                      viewBox="0 0 24 24"
                    >
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 5a2 2 0 012-2h10a2 2 0 012 2v16l-7-3.5L5 21V5z" />
                    </svg>
                  </template>
                  {{ isSaved ? 'Saved' : 'Save Job' }}
                </BaseButton>

                <!-- Job Stats -->
                <div class="mt-4 sm:mt-6 pt-4 sm:pt-6 border-t border-gray-200 space-y-3">
                  <div class="flex items-center justify-between text-xs sm:text-sm">
                    <span class="text-gray-600">Posted</span>
                    <span class="font-medium text-gray-900">{{ formatDate(job.created_at) }}</span>
                  </div>
                  <div v-if="job.expires_at" class="flex items-center justify-between text-xs sm:text-sm">
                    <span class="text-gray-600">Expires</span>
                    <span class="font-medium text-gray-900">{{ formatDate(job.expires_at) }}</span>
                  </div>
                </div>
              </BaseCard>
            </div>

            <!-- Salary & Apply Card - Desktop -->
            <div class="hidden lg:block lg:w-80 lg:absolute lg:right-0 lg:top-0">
              <BaseCard class="p-6 sticky top-24">
                <div class="mb-6">
                  <p class="text-sm text-gray-600 mb-2">
                    Salary Range{{ job.salary_period ? ' (' + formatSalaryPeriod(job.salary_period) + ')' : '' }}
                  </p>
                  <p class="text-2xl font-bold text-gray-900">
                    {{ formatSalaryRange(job.salary_min || 0, job.salary_max || 0, job.salary_currency, job.salary_period) }}
                  </p>
                </div>

                <!-- Apply Button - Only for Job Seekers -->
                <BaseButton
                  v-if="authStore.isJobSeeker"
                  variant="primary"
                  size="lg"
                  class="w-full mb-3"
                  @click="handleApply"
                  :disabled="hasApplied"
                >
                  <template #icon-left>
                    <svg v-if="!hasApplied" class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                  </template>
                  {{ hasApplied ? 'Already Applied' : 'Apply Now' }}
                </BaseButton>

                <!-- Login prompt for non-authenticated users -->
                <BaseButton
                  v-else-if="!authStore.isAuthenticated"
                  variant="primary"
                  size="lg"
                  class="w-full mb-3"
                  @click="handleApply"
                >
                  <template #icon-left>
                    <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                  </template>
                  Apply Now
                </BaseButton>

                <!-- Share Job Button with Dropdown -->
                <div class="relative w-full mb-3" ref="shareMenuRef">
                  <BaseButton
                    variant="outline"
                    size="lg"
                    class="w-full"
                    @click.stop="toggleShareMenu"
                  >
                    <template #icon-left>
                      <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z" />
                      </svg>
                    </template>
                    Share Job
                  </BaseButton>

                  <!-- Share Menu Dropdown -->
                  <Transition
                    enter-active-class="transition ease-out duration-100"
                    enter-from-class="transform opacity-0 scale-95"
                    enter-to-class="transform opacity-100 scale-100"
                    leave-active-class="transition ease-in duration-75"
                    leave-from-class="transform opacity-100 scale-100"
                    leave-to-class="transform opacity-0 scale-95"
                  >
                    <div
                      v-if="showShareMenu"
                      class="absolute top-full left-0 right-0 mt-2 bg-white rounded-lg shadow-lg border border-gray-200 py-2 z-10 max-h-96 overflow-y-auto"
                    >
                      <!-- Share on X (Twitter) -->
                      <button
                        @click="shareOn('twitter')"
                        class="w-full px-4 py-2 text-left hover:bg-gray-50 flex items-center gap-3 text-gray-700"
                      >
                        <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                          <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
                        </svg>
                        <span>Share on X</span>
                      </button>

                      <!-- Share on Facebook -->
                      <button
                        @click="shareOn('facebook')"
                        class="w-full px-4 py-2 text-left hover:bg-gray-50 flex items-center gap-3 text-gray-700"
                      >
                        <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                          <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z" />
                        </svg>
                        <span>Share on Facebook</span>
                      </button>

                      <!-- Share on Instagram -->
                      <button
                        @click="shareOn('instagram')"
                        class="w-full px-4 py-2 text-left hover:bg-gray-50 flex items-center gap-3 text-gray-700"
                      >
                        <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                          <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z" />
                        </svg>
                        <span>Share on Instagram</span>
                      </button>

                      <!-- Share on Snapchat -->
                      <button
                        @click="shareOn('snapchat')"
                        class="w-full px-4 py-2 text-left hover:bg-gray-50 flex items-center gap-3 text-gray-700"
                      >
                        <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                          <path d="M12.206.793c.99 0 4.347.276 5.93 3.821.529 1.193.403 3.219.299 4.847l-.003.06c-.012.18-.022.345-.03.51.075.045.203.09.401.09.3 0 .73-.057 1.126-.12.57-.084 1.185-.179 1.757-.179.3 0 .582.04.84.12.42.15.81.42 1.023.84.195.39.225.84.09 1.289-.12.45-.36.87-.645 1.17-.27.285-.645.54-1.065.705l-.084.045c-.3.165-.704.42-.78.885-.03.135-.015.27.045.404.09.21.21.405.345.585.195.27.42.54.645.81.51.585 1.065 1.185 1.47 1.83.225.36.42.72.57 1.095.09.24.15.495.18.75.015.195 0 .375-.045.555-.075.27-.24.54-.495.705-.3.195-.659.285-1.065.285l-.075-.015c-.705-.075-1.38-.24-2.04-.42-.585-.165-1.17-.3-1.77-.42-.15-.03-.296-.045-.444-.045-.555 0-1.05.195-1.53.42-.45.195-.945.405-1.485.57-.9.3-1.725.345-2.385.345-.405 0-.78-.045-1.095-.09-.75-.15-1.485-.42-2.22-.705-.585-.225-1.17-.48-1.77-.705-.42-.15-.885-.225-1.335-.225-.3 0-.585.03-.87.09-.555.12-1.095.27-1.65.42-.705.195-1.38.42-2.085.57-.705.15-1.38.225-2.01.195-.45-.015-.885-.135-1.26-.375-.3-.195-.495-.495-.585-.84-.075-.3-.075-.615 0-.915.09-.375.27-.735.495-1.065.42-.645.96-1.23 1.485-1.815.24-.27.465-.54.675-.81.12-.165.225-.345.3-.54.09-.195.12-.405.075-.615-.045-.435-.375-.705-.69-.87l-.096-.06c-.42-.165-.795-.42-1.065-.705-.285-.3-.525-.72-.645-1.17-.135-.45-.105-.9.09-1.29.21-.42.6-.69 1.02-.84.259-.08.541-.12.84-.12.573 0 1.185.09 1.757.18.39.06.825.12 1.124.12.195 0 .315-.045.375-.075-.015-.165-.03-.345-.045-.54l-.015-.09c-.105-1.59-.21-3.615.285-4.806C7.86 1.068 11.19.792 12.206.792zm0 0" />
                        </svg>
                        <span>Share on Snapchat</span>
                      </button>

                      <!-- Copy Link -->
                      <button
                        @click="copyJobLink"
                        class="w-full px-4 py-2 text-left hover:bg-gray-50 flex items-center gap-3 text-gray-700 border-t border-gray-100"
                      >
                        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 5H6a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2v-1M8 5a2 2 0 002 2h2a2 2 0 002-2M8 5a2 2 0 012-2h2a2 2 0 012 2m0 0h2a2 2 0 012 2v3m2 4H10m0 0l3-3m-3 3l3 3" />
                        </svg>
                        <span>Copy Link</span>
                      </button>
                    </div>
                  </Transition>
                </div>

                <!-- Save Job Button - Only for Job Seekers -->
                <BaseButton
                  v-if="!isOwnJob && authStore.isJobSeeker"
                  variant="outline"
                  size="lg"
                  class="w-full"
                  @click="toggleSave"
                >
                  <template #icon-left>
                    <svg 
                      class="h-5 w-5" 
                      :class="isSaved ? 'fill-yellow-500 text-yellow-500' : ''"
                      :fill="isSaved ? 'currentColor' : 'none'" 
                      stroke="currentColor" 
                      viewBox="0 0 24 24"
                    >
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 5a2 2 0 012-2h10a2 2 0 012 2v16l-7-3.5L5 21V5z" />
                    </svg>
                  </template>
                  {{ isSaved ? 'Saved' : 'Save Job' }}
                </BaseButton>

                <!-- Job Stats -->
                <div class="mt-6 pt-6 border-t border-gray-200 space-y-3">
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
      <div class="container-custom py-4 sm:py-8 px-4 sm:px-6 lg:px-8" style="max-width: 1400px;">
        <!-- Main Content -->
        <div class="max-w-4xl">
          <BaseCard class="p-4 sm:p-6 lg:p-8 mb-6 sm:mb-8">
            <!-- Job Description -->
            <section class="mb-6 sm:mb-8">
              <h2 class="text-xl sm:text-2xl font-bold text-gray-900 mb-3 sm:mb-4">Job Description</h2>
              <!-- eslint-disable-next-line vue/no-v-html -->
              <div class="prose prose-sm sm:prose prose-gray max-w-none" v-html="job.description"></div>
            </section>

            <!-- Requirements -->
            <section v-if="job.requirements" class="mb-6 sm:mb-8 pb-6 sm:pb-8 border-t border-gray-200 pt-6 sm:pt-8">
              <h2 class="text-xl sm:text-2xl font-bold text-gray-900 mb-3 sm:mb-4">Requirements</h2>
              <!-- eslint-disable-next-line vue/no-v-html -->
              <div class="prose prose-sm sm:prose prose-gray max-w-none" v-html="job.requirements"></div>
            </section>

            <!-- Responsibilities -->
            <section v-if="job.responsibilities" class="mb-6 sm:mb-8 pb-6 sm:pb-8 border-t border-gray-200 pt-6 sm:pt-8">
              <h2 class="text-xl sm:text-2xl font-bold text-gray-900 mb-3 sm:mb-4">Responsibilities</h2>
              <!-- eslint-disable-next-line vue/no-v-html -->
              <div class="prose prose-sm sm:prose prose-gray max-w-none" v-html="job.responsibilities"></div>
            </section>

            <!-- Benefits -->
            <section v-if="job.benefits" class="mb-6 sm:mb-8 pb-6 sm:pb-8 border-t border-gray-200 pt-6 sm:pt-8">
              <h2 class="text-xl sm:text-2xl font-bold text-gray-900 mb-3 sm:mb-4">Benefits</h2>
              <!-- eslint-disable-next-line vue/no-v-html -->
              <div class="prose prose-sm sm:prose prose-gray max-w-none" v-html="job.benefits"></div>
            </section>

            <!-- Required Skills -->
            <section v-if="job.skills && job.skills.length > 0" class="pb-6 sm:pb-8 border-t border-gray-200 pt-6 sm:pt-8">
              <h2 class="text-xl sm:text-2xl font-bold text-gray-900 mb-3 sm:mb-4">Required Skills</h2>
              <div class="flex flex-wrap gap-2">
                <span
                  v-for="skill in job.skills"
                  :key="skill"
                  class="px-3 py-1.5 bg-primary-100 text-primary-800 rounded-full text-sm font-medium"
                >
                  {{ skill }}
                </span>
              </div>
            </section>
          </BaseCard>

          <!-- About Company -->
          <BaseCard v-if="job.company" class="p-4 sm:p-6 lg:p-8">
            <h2 class="text-xl sm:text-2xl font-bold text-gray-900 mb-4 sm:mb-6">About {{ job.company.name }}</h2>
            <div class="flex items-start gap-4 sm:gap-6">
              <div class="w-14 h-14 sm:w-16 sm:h-16 lg:w-20 lg:h-20 rounded-lg sm:rounded-xl bg-gradient-to-br from-primary-500 to-secondary-500 flex items-center justify-center text-white text-lg sm:text-xl lg:text-2xl font-bold flex-shrink-0">
                {{ job.company.name.charAt(0) }}
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-sm sm:text-base text-gray-700 mb-3 sm:mb-4 leading-relaxed">{{ job.company.description || 'No description available.' }}</p>
                <div class="flex flex-wrap gap-3 sm:gap-4 text-xs sm:text-sm text-gray-600">
                  <span v-if="job.company.city" class="flex items-center gap-1.5">
                    <svg class="h-3.5 w-3.5 sm:h-4 sm:w-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                    </svg>
                    <span class="truncate">{{ job.company.city }}, {{ job.company.country }}</span>
                  </span>
                  <span v-if="job.company.website" class="flex items-center gap-1.5">
                    <svg class="h-3.5 w-3.5 sm:h-4 sm:w-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9" />
                    </svg>
                    <a :href="job.company.website" target="_blank" class="text-primary-600 hover:text-primary-700 truncate">
                      Website
                    </a>
                  </span>
                  <span v-if="job.company.jobs_count" class="flex items-center gap-1.5 whitespace-nowrap">
                    <svg class="h-3.5 w-3.5 sm:h-4 sm:w-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                    </svg>
                    {{ job.company.jobs_count }} open positions
                  </span>
                </div>
                <BaseButton variant="outline" size="sm" class="mt-3 sm:mt-4" @click="router.push(`/companies/${job.company?.slug}`)">
                  View Company Profile
                </BaseButton>
              </div>
            </div>
          </BaseCard>
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
import { ref, computed, onMounted, watch, onBeforeUnmount } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useJobStore } from '@/stores/job'
import { useAuthStore } from '@/stores/auth'
import { useSavedJobStore } from '@/stores/savedJob'
import { jobApplicationService } from '@/services/jobApplication.service'
import { useToast } from '@/composables/useToast'
import { copyToClipboard } from '@/utils/clipboard'
import { stripAndTruncate } from '@/utils/html'
import { formatSalaryRange } from '@/utils/currency'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseModal from '@/components/base/BaseModal.vue'
import type { Job } from '@/types'

const router = useRouter()
const route = useRoute()
const jobStore = useJobStore()
const authStore = useAuthStore()
const savedJobStore = useSavedJobStore()
const toast = useToast()

const loading = ref(true)
const job = ref<Job | null>(null)
const isSaved = ref(false)
const hasApplied = ref(false)
const showApplyModal = ref(false)
const submitting = ref(false)
const showShareMenu = ref(false)
const shareMenuRef = ref<HTMLElement | null>(null)

const isOwnJob = computed(() => {
  if (!authStore.isAuthenticated || !authStore.user || !job.value) {
    return false
  }
  return job.value.user_id === authStore.user.id
})

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
  const diffTime = now.getTime() - postDate.getTime()
  const diffDays = Math.floor(Math.abs(diffTime) / (1000 * 60 * 60 * 24))
  
  // If date is in the future
  if (diffTime < 0) {
    if (diffDays === 0) return 'Today'
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
    const years = Math.floor(diffDays / 365)
    return `in ${years} ${years === 1 ? 'year' : 'years'}`
  }
  
  // If date is in the past
  if (diffDays === 0) return 'Today'
  if (diffDays === 1) return 'Yesterday'
  if (diffDays < 7) return `${diffDays} days ago`
  if (diffDays < 30) {
    const weeks = Math.floor(diffDays / 7)
    return `${weeks} ${weeks === 1 ? 'week' : 'weeks'} ago`
  }
  if (diffDays < 365) {
    const months = Math.floor(diffDays / 30)
    return `${months} ${months === 1 ? 'month' : 'months'} ago`
  }
  const years = Math.floor(diffDays / 365)
  return `${years} ${years === 1 ? 'year' : 'years'} ago`
}

const formatNumber = (num: number): string => {
  if (num >= 1000000) return (num / 1000000).toFixed(1) + 'M'
  if (num >= 1000) return (num / 1000).toFixed(1) + 'K'
  return num.toString()
}

const _formatSalary = (min: number, max: number, period?: string | null): string => {
  const periodText = period ? `/${formatSalaryPeriod(period)}` : ''
  
  if (!min && !max) return 'Competitive'
  if (min && max) {
    return `$${formatNumber(min)} - $${formatNumber(max)}${periodText}`
  }
  if (min) return `From $${formatNumber(min)}${periodText}`
  if (max) return `Up to $${formatNumber(max)}${periodText}`
  return 'Competitive'
}

const formatSalaryPeriod = (period: string): string => {
  const periods: Record<string, string> = {
    'hourly': 'hour',
    'daily': 'day',
    'weekly': 'week',
    'monthly': 'month',
    'yearly': 'year',
  }
  return periods[period] || period
}

const _formatSalaryOnly = (min: number, max: number): string => {
  if (!min && !max) return 'Competitive'
  if (min && max) {
    return `$${formatNumber(min)} - $${formatNumber(max)}`
  }
  if (min) return `From $${formatNumber(min)}`
  if (max) return `Up to $${formatNumber(max)}`
  return 'Competitive'
}

const handleApply = () => {
  if (!authStore.isAuthenticated) {
    router.push(`/login?redirect=/jobs/${route.params.slug}`)
    return
  }

  // Prevent company owners from applying to jobs
  if (authStore.isCompanyOwner) {
    toast.error('Company owners cannot apply to jobs. Only job seekers can apply.')
    return
  }

  // Open application page in a new tab
  window.open(`/application/${route.params.slug}`, '_blank')
}

const toggleSave = async () => {
  if (!authStore.isAuthenticated) {
    router.push(`/login?redirect=/jobs/${route.params.slug}`)
    return
  }

  // Prevent company owners from saving jobs
  if (authStore.isCompanyOwner) {
    toast.error('Company owners cannot save jobs. Only job seekers can save jobs.')
    return
  }
  
  if (!job.value) return

  try {
    if (isSaved.value) {
      await savedJobStore.unsaveJob(job.value.id)
      isSaved.value = false
      toast.success('Job removed from saved')
    } else {
      await savedJobStore.saveJob(job.value.id)
      isSaved.value = true
      toast.success('Job saved successfully')
    }
  } catch (err: unknown) {
    // Revert the state if the API call fails
    const errorMessage = err && typeof err === 'object' && 'response' in err
      ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
      : undefined
    toast.error(errorMessage || 'Failed to save job')
  }
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

const copyJobLink = async () => {
  try {
    await copyToClipboard(window.location.href)
    toast.success('Link copied to clipboard!')
    showShareMenu.value = false
  } catch (error) {
    console.error('Failed to copy link:', error)
    toast.error('Failed to copy link')
  }
}

const toggleShareMenu = () => {
  showShareMenu.value = !showShareMenu.value
}

const shareOn = (platform: string) => {
  if (!job.value) return

  const url = window.location.href
  const title = job.value.title
  const text = `Check out this job opportunity: ${title} at ${job.value.company?.name || 'a great company'}`
  
  let shareUrl = ''

  switch (platform) {
    case 'twitter':
      shareUrl = `https://twitter.com/intent/tweet?text=${encodeURIComponent(text)}&url=${encodeURIComponent(url)}`
      break
    case 'facebook':
      shareUrl = `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(url)}`
      break
    case 'instagram':
      // Instagram doesn't support direct web sharing, so we'll copy the link and notify the user
      copyToClipboard(url).then(() => {
        toast.info('Link copied! Open Instagram app to share')
        showShareMenu.value = false
      }).catch(() => {
        toast.error('Failed to copy link')
      })
      return
    case 'snapchat':
      // Snapchat web sharing
      shareUrl = `https://www.snapchat.com/scan?attachmentUrl=${encodeURIComponent(url)}`
      break
  }

  if (shareUrl) {
    window.open(shareUrl, '_blank', 'width=600,height=400')
    showShareMenu.value = false
  }
}

const fetchJobDetail = async () => {
  loading.value = true
  try {
    const slug = route.params.slug as string
    
    // Fetch job by slug - use fetchJob which accepts slug or id
    await jobStore.fetchJob(slug)
    job.value = jobStore.currentJob
    
    // Check if user has already applied (only if authenticated)
    if (authStore.isAuthenticated && job.value) {
      try {
        const checkResponse = await jobApplicationService.checkApplication(slug)
        if (checkResponse.success && checkResponse.data) {
          hasApplied.value = checkResponse.data.has_applied
        }
      } catch (error) {
        console.error('Failed to check application status:', error)
      }

      // Check if job is saved
      if (savedJobStore.savedJobIds.size === 0) {
        // If savedJobIds is empty, fetch it
        await savedJobStore.fetchSavedJobsCount()
      }
      isSaved.value = savedJobStore.savedJobIds.has(job.value.id)
    }
  } catch (error) {
    console.error('Failed to fetch job:', error)
    job.value = null
  } finally {
    loading.value = false
  }
}

const updateMetaTags = (jobData: Job) => {
  const url = window.location.href
  const title = `${jobData.title} at ${jobData.company?.name} | JobsIQ`
  const description = jobData.description 
    ? stripAndTruncate(jobData.description, 160, '...') 
    : `Apply for ${jobData.title} at ${jobData.company?.name}. ${jobData.location}`
  const image = jobData.company?.logo?.url || jobData.company?.cover?.url || `${window.location.origin}/logo.png`

  // Update document title
  document.title = title

  // Remove existing meta tags
  const existingMetaTags = document.querySelectorAll('meta[property^="og:"], meta[name^="twitter:"]')
  existingMetaTags.forEach(tag => tag.remove())

  // Add Open Graph meta tags
  const metaTags = [
    { property: 'og:title', content: title },
    { property: 'og:description', content: description },
    { property: 'og:image', content: image },
    { property: 'og:url', content: url },
    { property: 'og:type', content: 'website' },
    { name: 'twitter:card', content: 'summary_large_image' },
    { name: 'twitter:title', content: title },
    { name: 'twitter:description', content: description },
    { name: 'twitter:image', content: image },
    { name: 'twitter:site', content: '@JobsIQ' },
    { name: 'twitter:creator', content: '@JobsIQ' },
    { name: 'description', content: description },
  ]

  metaTags.forEach(({ property, name, content }) => {
    const meta = document.createElement('meta')
    if (property) meta.setAttribute('property', property)
    if (name) meta.setAttribute('name', name)
    meta.setAttribute('content', content)
    document.head.appendChild(meta)
  })
}

watch(job, (newJob) => {
  if (newJob) {
    updateMetaTags(newJob)
  }
})

onMounted(() => {
  fetchJobDetail()
  
  // Add click-outside listener for share menu
  document.addEventListener('click', handleClickOutside)
})

onBeforeUnmount(() => {
  // Clean up click-outside listener
  document.removeEventListener('click', handleClickOutside)
})

const handleClickOutside = (event: MouseEvent) => {
  if (shareMenuRef.value && !shareMenuRef.value.contains(event.target as Node)) {
    showShareMenu.value = false
  }
}
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
