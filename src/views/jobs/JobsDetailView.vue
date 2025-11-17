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

    <!-- Job Not Found -->
    <div v-else-if="!job" class="container mx-auto py-16 px-4 sm:px-6 lg:px-8 max-w-7xl">
      <div class="bg-white rounded-xl p-12 text-center shadow-custom">
        <svg class="h-16 w-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <h2 class="text-2xl font-bold text-gray-900 mb-2">{{ $t('jobs.jobNotFound') }}</h2>
        <p class="text-gray-600 mb-6">{{ $t('jobs.tryAdjustingFilters') }}</p>
        <button 
          @click="router.push('/jobs')"
          class="px-6 py-3 bg-primary-600 text-white rounded-full font-semibold hover:bg-primary-700 transition-colors shadow-lg"
        >
          {{ $t('jobs.browseAllJobs') }}
        </button>
      </div>
    </div>

    <!-- Job Detail Content -->
    <div v-else class="container mx-auto py-6 px-4 sm:px-6 lg:px-8 max-w-7xl">
      <!-- Back Button -->
      <button 
        @click="router.back()" 
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
              <!-- Apply Button -->
              <button
                v-if="authStore.isJobSeeker"
                @click="handleApply"
                :disabled="hasApplied"
                class="flex-1 lg:flex-none px-6 py-3 bg-primary-600 text-white rounded-full font-semibold hover:bg-primary-700 hover:scale-[1.02] transition-all shadow-lg disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:scale-100 cursor-pointer"
              >
                {{ hasApplied ? $t('jobs.alreadyApplied') : $t('jobs.applyNow') }}
              </button>
              
              <button
                v-else-if="!authStore.isAuthenticated"
                @click="handleApply"
                class="flex-1 lg:flex-none px-6 py-3 bg-primary-600 text-white rounded-full font-semibold hover:bg-primary-700 hover:scale-[1.02] transition-all shadow-lg cursor-pointer"
              >
                {{ $t('jobs.applyNow') }}
              </button>

              <!-- Save Button -->
              <button
                v-if="!isOwnJob && authStore.isJobSeeker"
                @click="toggleSave"
                class="flex-1 lg:flex-none px-6 py-3 border-2 border-gray-300 text-gray-700 rounded-full font-semibold hover:bg-gray-50 transition-all flex items-center justify-center gap-2 cursor-pointer"
              >
                <svg 
                  class="w-5 h-5" 
                  :class="isSaved ? 'fill-yellow-500 text-yellow-500' : ''"
                  :fill="isSaved ? 'currentColor' : 'none'"
                  stroke="currentColor" 
                  viewBox="0 0 24 24"
                >
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 5a2 2 0 012-2h10a2 2 0 012 2v16l-7-3.5L5 21V5z" />
                </svg>
                <span>{{ isSaved ? $t('jobs.saved') : $t('jobs.saveJob') }}</span>
              </button>

              <!-- Share Button with Dropdown -->
              <div class="relative flex-1 lg:flex-none" ref="shareMenuRef">
                <button
                  @click.stop="toggleShareMenu"
                  class="w-full px-6 py-3 border-2 border-gray-300 text-gray-700 rounded-full font-semibold hover:bg-gray-50 transition-all flex items-center justify-center gap-2 cursor-pointer"
                >
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z" />
                  </svg>
                  <span>{{ $t('jobs.shareJob') }}</span>
                </button>

                <!-- Share Menu Dropdown -->
                <Teleport to="body">
                  <div
                    v-if="showShareMenu"
                    :style="shareMenuStyle"
                    class="fixed bg-white rounded-lg shadow-xl border border-gray-200 py-2 min-w-[200px]"
                    style="z-index: 9999;"
                  >
                    <button @click="copyJobLink" class="w-full px-3 py-2 bg-gray-800 hover:bg-gray-900 text-white rounded-lg transition-colors text-sm flex items-center gap-2 cursor-pointer">
                      <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 5H6a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2v-1M8 5a2 2 0 002 2h2a2 2 0 002-2M8 5a2 2 0 012-2h2a2 2 0 012 2m0 0h2a2 2 0 012 2v3m2 4H10m0 0l3-3m-3 3l3 3" />
                      </svg>
                      <span>{{ $t('jobs.copyLink') }}</span>
                    </button>
                    <div class="border-t border-gray-200 my-1"></div>
                    <button @click="shareOn('facebook')" class="w-full px-3 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors text-sm flex items-center gap-2 cursor-pointer">
                      <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z" />
                      </svg>
                      <span>{{ $t('jobs.shareOnFacebook') }}</span>
                    </button>
                    <button @click="shareOn('instagram')" class="instagram-gradient w-full px-3 py-2 text-white rounded-lg transition-colors text-sm flex items-center gap-2 cursor-pointer">
                      <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z" />
                      </svg>
                      <span>{{ $t('jobs.shareOnInstagram') }}</span>
                    </button>
                    <button @click="shareOn('linkedin')" class="w-full px-3 py-2 bg-blue-700 hover:bg-blue-800 text-white rounded-lg transition-colors text-sm flex items-center gap-2 cursor-pointer">
                      <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z" />
                      </svg>
                      <span>{{ $t('jobs.shareOnLinkedIn') }}</span>
                    </button>
                    <button @click="shareOn('twitter')" class="w-full px-3 py-2 bg-black hover:bg-gray-900 text-white rounded-lg transition-colors text-sm flex items-center gap-2 cursor-pointer">
                      <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
                      </svg>
                      <span>{{ $t('jobs.shareOnTwitter') }}</span>
                    </button>
                    <button @click="shareOn('snapchat')" class="w-full px-3 py-2 bg-yellow-400 hover:bg-yellow-500 text-gray-900 rounded-lg transition-colors text-sm flex items-center gap-2 cursor-pointer">
                      <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M12.206.793c.99 0 4.347.276 5.93 3.821.529 1.193.403 3.219.299 4.847l-.003.06c-.012.18-.022.345-.03.51.075.045.203.09.401.09.3 0 .73-.057 1.126-.12.57-.084 1.185-.179 1.757-.179.3 0 .582.04.84.12.42.15.81.42 1.023.84.195.39.225.84.09 1.289-.12.45-.36.87-.645 1.17-.27.285-.645.54-1.065.705l-.084.045c-.3.165-.704.42-.78.885-.03.135-.015.27.045.404.09.21.21.405.345.585.195.27.42.54.645.81.51.585 1.065 1.185 1.47 1.83.225.36.42.72.57 1.095.09.24.15.495.18.75.015.195 0 .375-.045.555-.075.27-.24.54-.495.705-.3.195-.659.285-1.065.285l-.075-.015c-.705-.075-1.38-.24-2.04-.42-.585-.165-1.17-.3-1.77-.42-.15-.03-.296-.045-.444-.045-.555 0-1.05.195-1.53.42-.45.195-.945.405-1.485.57-.9.3-1.725.345-2.385.345-.405 0-.78-.045-1.095-.09-.75-.15-1.485-.42-2.22-.705-.585-.225-1.17-.48-1.77-.705-.42-.15-.885-.225-1.335-.225-.3 0-.585.03-.87.09-.555.12-1.095.27-1.65.42-.705.195-1.38.42-2.085.57-.705.15-1.38.225-2.01.195-.45-.015-.885-.135-1.26-.375-.3-.195-.495-.495-.585-.84-.075-.3-.075-.615 0-.915.09-.375.27-.735.495-1.065.42-.645.96-1.23 1.485-1.815.24-.27.465-.54.675-.81.12-.165.225-.345.3-.54.09-.195.12-.405.075-.615-.045-.435-.375-.705-.69-.87l-.096-.06c-.42-.165-.795-.42-1.065-.705-.285-.3-.525-.72-.645-1.17-.135-.45-.105-.9.09-1.29.21-.42.6-.69 1.02-.84.259-.08.541-.12.84-.12.573 0 1.185.09 1.757.18.39.06.825.12 1.124.12.195 0 .315-.045.375-.075-.015-.165-.03-.345-.045-.54l-.015-.09c-.105-1.59-.21-3.615.285-4.806C7.86 1.068 11.19.792 12.206.792zm0 0" />
                      </svg>
                      <span>{{ $t('jobs.shareOnSnapchat') }}</span>
                    </button>
                  </div>
                </Teleport>
              </div>
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
                <p class="text-gray-700 mb-4 leading-relaxed">{{ job.company.description || 'No description available.' }}</p>
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
              <h3 class="text-lg font-bold text-gray-900">{{ $t('jobs.salaryRange') }}</h3>
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
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { useJobStore } from '@/stores/job'
import { useAuthStore } from '@/stores/auth'
import { useSavedJobStore } from '@/stores/savedJob'
import { useToast } from '@/composables/useToast'
import { copyToClipboard } from '@/utils/clipboard'
import { formatSalaryRange } from '@/utils/currency'
import type { Job } from '@/types'

const router = useRouter()
const route = useRoute()
const { t } = useI18n()
const jobStore = useJobStore()
const authStore = useAuthStore()
const savedJobStore = useSavedJobStore()
const toast = useToast()

const loading = ref(true)
const job = ref<Job | null>(null)
const isSaved = ref(false)
const hasApplied = ref(false)
const showShareMenu = ref(false)
const shareMenuRef = ref<HTMLElement | null>(null)

const isOwnJob = computed(() => {
  if (!authStore.isAuthenticated || !authStore.user || !job.value) {
    return false
  }
  return job.value.user_id === authStore.user.id
})

const shareMenuStyle = computed(() => {
  if (!shareMenuRef.value) return {}
  
  const rect = shareMenuRef.value.getBoundingClientRect()
  const menuWidth = 200 // min-w-[200px]
  const isRTL = document.documentElement.dir === 'rtl'
  
  // Calculate position based on direction
  let left = isRTL ? rect.right - menuWidth : rect.left
  let top = rect.bottom + 8 // mt-2 (8px)
  
  // Check if menu would overflow on the right
  if (left + menuWidth > window.innerWidth) {
    left = window.innerWidth - menuWidth - 16
  }
  
  // Check if menu would overflow on the left
  if (left < 16) {
    left = 16
  }
  
  // Check if menu would overflow on the bottom
  const menuHeight = 250 // approximate height
  if (top + menuHeight > window.innerHeight) {
    top = rect.top - menuHeight - 8
  }
  
  return {
    left: `${left}px`,
    top: `${top}px`,
  }
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
    'junior': 'Junior',
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
  }
  
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

const handleApply = () => {
  if (!authStore.isAuthenticated) {
    router.push(`/login?redirect=/jobs/${route.params.slug}`)
    return
  }

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

  if (authStore.isCompanyOwner) {
    toast.error('Company owners cannot save jobs. Only job seekers can save jobs.')
    return
  }
  
  if (!job.value) return

  try {
    if (isSaved.value) {
      await savedJobStore.unsaveJob(job.value.id)
      isSaved.value = false
      toast.success('Job removed from saved jobs')
    } else {
      await savedJobStore.saveJob(job.value.id)
      isSaved.value = true
      toast.success('Job saved successfully!')
    }
  } catch (error) {
    console.error('Error toggling save:', error)
    toast.error('Failed to save job. Please try again.')
  }
}

const toggleShareMenu = () => {
  showShareMenu.value = !showShareMenu.value
}

const shareOn = (platform: string) => {
  if (!job.value) return
  
  const url = window.location.href
  const title = `${job.value.title} at ${job.value.company?.name}`
  const text = `Check out this job: ${title}`

  let shareUrl = ''
  
  switch (platform) {
    case 'facebook':
      shareUrl = `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(url)}`
      break
    case 'instagram':
      // Instagram doesn't support direct URL sharing, so we copy the link
      copyToClipboard(window.location.href).then(() => {
        toast.info(t('jobs.linkCopiedInstagram'))
        showShareMenu.value = false
      }).catch(() => {
        toast.error(t('jobs.failedToCopyLink'))
      })
      return
    case 'linkedin':
      shareUrl = `https://www.linkedin.com/sharing/share-offsite/?url=${encodeURIComponent(url)}`
      break
    case 'twitter':
      shareUrl = `https://twitter.com/intent/tweet?url=${encodeURIComponent(url)}&text=${encodeURIComponent(text)}`
      break
    case 'snapchat':
      shareUrl = `https://www.snapchat.com/share?url=${encodeURIComponent(url)}`
      break
  }
  
  if (shareUrl) {
    window.open(shareUrl, '_blank', 'width=600,height=400')
    showShareMenu.value = false
  }
}

const copyJobLink = async () => {
  if (!job.value) return
  
  const url = window.location.href
  try {
    await copyToClipboard(url)
    toast.success('Link copied to clipboard!')
    showShareMenu.value = false
  } catch (err) {
    console.error('Failed to copy link:', err)
    toast.error('Failed to copy link')
  }
}

const handleClickOutside = (event: MouseEvent) => {
  if (shareMenuRef.value && !shareMenuRef.value.contains(event.target as Node)) {
    showShareMenu.value = false
  }
}

const checkIfSaved = async () => {
  if (!authStore.isAuthenticated || !job.value) return
  
  try {
    // Check if savedJobIds is empty, fetch it
    if (savedJobStore.savedJobIds.size === 0) {
      await savedJobStore.fetchSavedJobsCount()
    }
    isSaved.value = savedJobStore.savedJobIds.has(job.value.id)
  } catch (error) {
    console.error('Error checking if job is saved:', error)
  }
}

const checkIfApplied = async () => {
  if (!authStore.isAuthenticated || !job.value) return
  
  try {
    // This would need to be implemented based on your application service
    // hasApplied.value = await jobApplicationService.checkIfApplied(job.value.id)
  } catch (error) {
    console.error('Error checking if applied:', error)
  }
}

onMounted(async () => {
  try {
    const slug = route.params.slug as string
    await jobStore.fetchJob(slug)
    job.value = jobStore.currentJob
    
    if (job.value) {
      await checkIfSaved()
      await checkIfApplied()
    }
  } catch (error) {
    console.error('Error fetching job:', error)
    toast.error('Failed to load job details. Please try again.')
  } finally {
    loading.value = false
  }

  document.addEventListener('click', handleClickOutside)
})

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>

<style scoped>
.shadow-custom {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.instagram-gradient {
  background: linear-gradient(135deg, #9333ea 0%, #db2777 100%) !important;
}

.instagram-gradient:hover {
  background: linear-gradient(135deg, #7e22ce 0%, #be185d 100%) !important;
}
</style>

<style>
[dir="rtl"] .instagram-gradient {
  background: linear-gradient(225deg, #9333ea 0%, #db2777 100%) !important;
}

[dir="rtl"] .instagram-gradient:hover {
  background: linear-gradient(225deg, #7e22ce 0%, #be185d 100%) !important;
}
</style>
