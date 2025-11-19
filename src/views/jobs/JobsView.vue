<template>
  <div class="bg-gray-50 min-h-screen">
    <!-- Search & Filters Bar -->
    <div class="bg-white border-b-2 border-gray-300 z-30">
      <div class="mx-auto px-4 py-4 w-full max-w-[900px]">
        <!-- Search Row -->
        <div class="flex flex-col sm:flex-row gap-3 mb-3">
          <div class="flex-1">
            <BaseInput
              v-model="filters.search"
              type="text"
              :placeholder="$t('jobs.searchByKeywords')"
              size="md"
              show-clear-button
              @keyup.enter="searchJobs"
            >
              <template #icon-left>
                <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
              </template>
            </BaseInput>
          </div>
          <div class="w-full sm:w-72 relative">
            <label for="job-location" class="sr-only">{{ $t('common.location') }}</label>
            <input
              id="job-location"
              v-model="filters.location"
              type="text"
              name="job-location"
              :placeholder="$t('jobs.cityPlaceholder')"
              class="w-full px-4 py-2 pl-10 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500 bg-white"
              @input="handleLocationInput"
              @focus="showCitySuggestions = true"
              @blur="handleCityBlur"
              @keydown="handleCityKeyDown"
              @keyup.enter="searchJobs"
            />
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
              </svg>
            </div>
            
            <!-- City Suggestions Dropdown -->
            <div
              v-if="showCitySuggestions && filteredCities.length > 0"
              ref="citySuggestionsRef"
              class="absolute z-50 w-full mt-1 bg-white border border-gray-300 rounded-lg shadow-lg max-h-60 overflow-y-auto"
            >
              <button
                v-for="(city, index) in filteredCities"
                :key="city"
                :ref="el => { if (el) cityRefs[index] = el as HTMLElement }"
                type="button"
                :class="[
                  'w-full px-3 py-2 text-left text-gray-900 hover:bg-gray-100 focus:bg-gray-100 focus:outline-none transition-colors text-sm',
                  { 'bg-primary-100 font-medium': index === selectedCityIndex }
                ]"
                @mousedown.prevent="selectCity(city)"
                @mouseenter="selectedCityIndex = index"
              >
                {{ city }}
              </button>
            </div>
          </div>
          <BaseButton variant="primary" size="md" class="w-full sm:w-auto" @click="searchJobs" :loading="loading">
            Search
          </BaseButton>
        </div>

        <!-- Filters Row -->
        <div class="flex flex-col sm:flex-row gap-3 items-stretch sm:items-center">
          <!-- Results count -->
          <span class="text-sm font-medium text-gray-900 sm:flex-shrink-0">
            {{ $t('jobs.jobCount', { count: totalJobs }) }}
          </span>

          <!-- Scrollable filters container on mobile -->
          <div class="flex gap-3 overflow-x-auto pb-2 sm:pb-0 flex-1">
            <!-- Employment Type -->
            <label for="employment-type" class="sr-only">{{ $t('jobs.employmentType') }}</label>
            <select
              id="employment-type"
              v-model="filters.employment_type"
              name="employment-type"
              @change="searchJobs"
              class="px-4 py-2 border border-gray-300 rounded-lg text-sm focus:ring-primary-500 focus:border-primary-500 bg-white flex-shrink-0 cursor-pointer hover:border-gray-400 hover:bg-gray-50 transition-colors"
            >
              <option value="">{{ $t('jobs.employmentType') }}</option>
              <option value="full-time">{{ $t('jobs.fullTime') }}</option>
              <option value="part-time">{{ $t('jobs.partTime') }}</option>
              <option value="contract">{{ $t('jobs.contract') }}</option>
              <option value="freelance">{{ $t('jobs.freelance') }}</option>
              <option value="internship">{{ $t('jobs.internship') }}</option>
            </select>

            <!-- Experience Level -->
            <label for="experience-level" class="sr-only">{{ $t('jobs.experienceLevel') }}</label>
            <select
              id="experience-level"
              v-model="filters.experience_level"
              name="experience-level"
              @change="searchJobs"
              class="px-4 py-2 border border-gray-300 rounded-lg text-sm focus:ring-primary-500 focus:border-primary-500 bg-white flex-shrink-0 cursor-pointer hover:border-gray-400 hover:bg-gray-50 transition-colors"
            >
              <option value="">{{ $t('jobs.experienceLevel') }}</option>
              <option value="entry">{{ $t('jobs.entryLevel') }}</option>
              <option value="mid">{{ $t('jobs.midLevel') }}</option>
              <option value="senior">{{ $t('jobs.senior') }}</option>
              <option value="lead">{{ $t('jobs.lead') }}</option>
              <option value="executive">{{ $t('jobs.executive') }}</option>
            </select>

            <!-- Salary -->
            <label for="salary-min" class="sr-only">{{ $t('jobs.salaryMin') }}</label>
            <select
              id="salary-min"
              v-model="filters.salary_min"
              name="salary-min"
              @change="searchJobs"
              class="px-4 py-2 border border-gray-300 rounded-lg text-sm focus:ring-primary-500 focus:border-primary-500 bg-white flex-shrink-0 cursor-pointer hover:border-gray-400 hover:bg-gray-50 transition-colors"
            >
              <option value="">{{ $t('jobs.salaryMin') }}</option>
              <option value="250">{{ $t('jobs.from', { amount: '250' }) }}</option>
              <option value="500">{{ $t('jobs.from', { amount: '500' }) }}</option>
              <option value="1000">{{ $t('jobs.from', { amount: '1000' }) }}</option>
              <option value="2000">{{ $t('jobs.from', { amount: '2000' }) }}</option>
            </select>

            <!-- Remote Only Checkbox -->
            <label class="flex items-center gap-2 px-4 py-2 border border-gray-300 rounded-lg text-sm bg-white cursor-pointer hover:bg-gray-50 hover:border-gray-400 flex-shrink-0 whitespace-nowrap transition-colors">
              <input
                id="is-remote"
                v-model="filters.is_remote"
                type="checkbox"
                name="is-remote"
                class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded cursor-pointer"
                @change="searchJobs"
              />
              <span class="font-medium text-gray-700">{{ $t('jobs.remoteOnly') }}</span>
            </label>
          </div>

          <!-- Clear Filters -->
          <button
            @click="clearFilters"
            class="px-4 py-2 text-sm text-gray-600 hover:text-gray-900 font-medium flex-shrink-0 cursor-pointer transition-colors"
          >
            {{ $t('common.clearAll') }}
          </button>
        </div>
      </div>
    </div>

    <!-- Main Content: Split View -->
    <div class="container-custom py-6">
      <div class="flex flex-col lg:flex-row gap-6 min-h-[calc(100vh-280px)]">
        <!-- Left: Jobs List -->
        <div class="w-full lg:w-96 flex-shrink-0 bg-white rounded-lg border border-gray-200">
          <!-- Loading State -->
          <div v-if="loading" class="divide-y divide-gray-200">
            <div v-for="i in 8" :key="i" class="p-4">
              <div class="animate-pulse">
                <div class="flex gap-3 mb-3">
                  <div class="w-12 h-12 bg-gray-200 rounded"></div>
                  <div class="flex-1">
                    <div class="h-4 bg-gray-200 rounded w-3/4 mb-2"></div>
                    <div class="h-3 bg-gray-200 rounded w-1/2"></div>
                  </div>
                </div>
                <div class="h-3 bg-gray-200 rounded w-full mb-2"></div>
                <div class="h-3 bg-gray-200 rounded w-2/3"></div>
              </div>
            </div>
          </div>

          <!-- Jobs List -->
          <div v-else-if="jobs.length > 0">
            <div
              v-for="job in jobs"
              :key="job.id"
              @click="selectJob(job)"
              :class="[
                'p-4 cursor-pointer transition-all duration-200 border-b-2 border-gray-300 border-l-4',
                selectedJob?.id === job.id 
                  ? 'bg-primary-50 border-l-primary-600' 
                  : 'border-l-transparent hover:bg-gray-50 hover:border-l-primary-400'
              ]"
            >
              <div class="flex gap-3">
                <!-- Company Logo -->
                <div class="w-16 h-16 bg-gray-100 rounded flex items-center justify-center flex-shrink-0 self-start">
                  <img
                    v-if="job.company?.logo?.url"
                    :src="job.company.logo.url"
                    :alt="job.company.name"
                    class="w-full h-full object-contain rounded"
                  />
                  <svg v-else class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
                  </svg>
                </div>

                <div class="flex-1 min-w-0">
                  <h3 class="font-semibold text-gray-900 text-sm mb-1 truncate">{{ job.title }}</h3>
                  <p class="text-sm text-gray-600 mb-2 truncate">{{ job.company?.name }}</p>
                  
                  <div class="flex items-center gap-2 text-xs text-gray-500 mb-2">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                    </svg>
                    <span class="truncate">{{ job.location }}</span>
                  </div>

                  <div class="flex flex-wrap gap-2 mb-2">
                    <span v-if="job.employment_type" class="inline-flex items-center px-2 py-1 rounded text-xs font-medium bg-blue-100 text-blue-800">
                      {{ formatEmploymentType(job.employment_type) }}
                    </span>
                    <span v-if="job.is_remote" class="inline-flex items-center px-2 py-1 rounded text-xs font-medium bg-green-100 text-green-800">
                      {{ $t('jobs.remote') }}
                    </span>
                    <span v-if="job.category" class="inline-flex items-center px-2 py-1 rounded text-xs font-medium bg-purple-100 text-purple-800">
                      {{ formatCategory(job.category) }}
                    </span>
                  </div>
                  
                  <div v-if="job.salary_min && job.salary_max" class="mb-2">
                    <span class="inline-flex items-center px-2 py-1 rounded text-xs font-medium bg-gray-100 text-gray-800">
                      {{ formatSalaryRange(job.salary_min, job.salary_max, job.salary_currency, job.salary_period ? formatSalaryPeriod(job.salary_period) : undefined) }}
                    </span>
                  </div>

                  <!-- Posted and Expires dates -->
                  <div class="flex items-center gap-3 text-xs text-gray-500 mt-2">
                    <span class="flex items-center gap-1">
                      <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                      </svg>
                      {{ formatJobDate(job.published_at || job.created_at) }}
                    </span>
                    <span v-if="job.expires_at" class="flex items-center gap-1 text-red-600 font-medium">
                      <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                      </svg>
                      {{ $t('jobs.expires') }}: {{ formatJobDate(job.expires_at) }}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Empty State -->
          <div v-else class="p-12 text-center">
            <svg class="h-12 w-12 mx-auto text-gray-400 mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
            <h3 class="text-sm font-semibold text-gray-900 mb-1">{{ $t('jobs.noJobsFound') }}</h3>
            <p class="text-xs text-gray-600 mb-4">{{ $t('jobs.tryAdjustingFilters') }}</p>
            <BaseButton variant="primary" size="sm" @click="clearFilters">{{ $t('common.clearAll') }}</BaseButton>
          </div>

          <!-- Load More Button -->
          <div v-if="!loading && hasMoreJobs" class="p-6 border-t border-gray-200 bg-gray-50">
            <BaseButton
              variant="primary"
              size="lg"
              class="w-full"
              :loading="loadingMore"
              @click="loadMoreJobs"
            >
              <template #icon-left>
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                </svg>
              </template>
              {{ $t('jobs.loadMoreJobs') }}
            </BaseButton>
            <p class="text-center text-sm text-gray-500 mt-3">
              {{ $t('jobs.showingJobs', { current: jobs.length, total: totalJobs }) }}
            </p>
          </div>
        </div>

        <!-- Right: Job Details - Desktop Only -->
        <div class="flex-1 bg-white rounded-lg border border-gray-200 lg:sticky lg:top-20 self-start max-h-[calc(100vh-120px)] overflow-y-auto hidden lg:block">
          <!-- Job Selected -->
          <div v-if="selectedJob" class="p-8">
            <!-- Header -->
            <div class="flex gap-6 mb-6">
              <div class="w-20 h-20 bg-gray-100 rounded-lg flex items-center justify-center flex-shrink-0">
                <img
                  v-if="selectedJob.company?.logo?.url"
                  :src="selectedJob.company.logo.url"
                  :alt="selectedJob.company.name"
                  class="w-full h-full object-contain p-2 rounded-lg"
                />
                <svg v-else class="w-10 h-10 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
                </svg>
              </div>

              <div class="flex-1">
                <h1 class="text-3xl font-bold text-gray-900 mb-2">{{ selectedJob.title }}</h1>
                <p class="text-lg text-gray-600 mb-4">{{ selectedJob.company?.name }}</p>
                
                <div class="flex flex-wrap gap-3 mb-4 p-4 bg-gray-50 rounded-lg border border-gray-200">
                  <div class="flex items-center gap-2 px-3 py-1.5 bg-white rounded-md border border-gray-200">
                    <svg class="w-4 h-4 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                    </svg>
                    <span class="text-sm font-medium text-gray-900">{{ selectedJob.location }}</span>
                  </div>
                  <span class="flex items-center gap-2 px-3 py-1.5 bg-primary-100 rounded-full border border-primary-200">
                    <svg class="w-4 h-4 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    <span class="text-sm font-semibold text-primary-800">{{ formatEmploymentType(selectedJob.employment_type) }}</span>
                  </span>
                  <div v-if="selectedJob.is_remote" class="flex items-center gap-2 px-3 py-1.5 bg-green-50 rounded-md border border-green-200">
                    <svg class="w-4 h-4 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                    <span class="text-sm font-medium text-green-700">{{ $t('jobs.remote') }}</span>
                  </div>
                  <div v-if="selectedJob.category" class="flex items-center gap-2 px-3 py-1.5 bg-purple-50 rounded-md border border-purple-200">
                    <svg class="w-4 h-4 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" />
                    </svg>
                    <span class="text-sm font-medium text-purple-700">{{ formatCategory(selectedJob.category) }}</span>
                  </div>
                </div>

                <div class="flex flex-wrap gap-3">
                  <BaseButton 
                    v-if="authStore.user?.user_type !== 'company_owner'" 
                    variant="primary" 
                    size="lg" 
                    class="flex-1 sm:flex-initial" 
                    :disabled="hasApplied(selectedJob.id)"
                    @click="applyForJob(selectedJob)"
                  >
                    <template #icon-left>
                      <svg v-if="!hasApplied(selectedJob.id)" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                      </svg>
                    </template>
                    {{ hasApplied(selectedJob.id) ? $t('jobs.alreadyApplied') : $t('jobs.applyNow') }}
                  </BaseButton>
                  <BaseButton variant="outline" size="lg" class="flex-1 sm:flex-initial" @click="goToJobDetail(selectedJob)">
                    {{ $t('jobs.viewDetails') }}
                  </BaseButton>
                  
                  <!-- Share Job Button with Dropdown -->
                  <div class="relative" ref="shareMenuRef">
                    <BaseButton variant="outline" size="lg" @click.stop="toggleShareMenu">
                      <template #icon-left>
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z" />
                        </svg>
                      </template>
                      {{ $t('common.share') }}
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
                        class="absolute top-full left-0 mt-2 min-w-[200px] bg-white rounded-lg shadow-lg border border-gray-200 py-2 z-50 max-h-96 overflow-y-auto"
                      >
                        <!-- Copy Link -->
                        <button
                          @click="copyJobLink"
                          class="w-full px-3 py-2 bg-gray-800 hover:bg-gray-900 text-white rounded-lg transition-colors text-sm flex items-center gap-2 cursor-pointer"
                        >
                          <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 5H6a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2v-1M8 5a2 2 0 002 2h2a2 2 0 002-2M8 5a2 2 0 012-2h2a2 2 0 012 2m0 0h2a2 2 0 012 2v3m2 4H10m0 0l3-3m-3 3l3 3" />
                          </svg>
                          <span>{{ $t('jobs.copyLink') }}</span>
                        </button>

                        <div class="border-t border-gray-200 my-1"></div>

                        <!-- Share on Facebook -->
                        <button
                          @click="shareOn('facebook')"
                          class="w-full px-3 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors text-sm flex items-center gap-2 cursor-pointer"
                        >
                          <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z" />
                          </svg>
                          <span>{{ $t('jobs.shareOnFacebook') }}</span>
                        </button>

                        <!-- Share on Instagram -->
                        <button
                          @click="shareOn('instagram')"
                          class="instagram-gradient w-full px-3 py-2 text-white rounded-lg transition-colors text-sm flex items-center gap-2 cursor-pointer"
                        >
                          <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z" />
                          </svg>
                          <span>{{ $t('jobs.shareOnInstagram') }}</span>
                        </button>

                        <!-- Share on LinkedIn -->
                        <button
                          @click="shareOn('linkedin')"
                          class="w-full px-3 py-2 bg-blue-700 hover:bg-blue-800 text-white rounded-lg transition-colors text-sm flex items-center gap-2 cursor-pointer"
                        >
                          <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z" />
                          </svg>
                          <span>{{ $t('jobs.shareOnLinkedIn') }}</span>
                        </button>

                        <!-- Share on X (Twitter) -->
                        <button
                          @click="shareOn('twitter')"
                          class="w-full px-3 py-2 bg-black hover:bg-gray-900 text-white rounded-lg transition-colors text-sm flex items-center gap-2 cursor-pointer"
                        >
                          <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
                          </svg>
                          <span>{{ $t('jobs.shareOnTwitter') }}</span>
                        </button>

                        <!-- Share on Snapchat -->
                        <button
                          @click="shareOn('snapchat')"
                          class="w-full px-3 py-2 bg-yellow-400 hover:bg-yellow-500 text-gray-900 rounded-lg transition-colors text-sm flex items-center gap-2 cursor-pointer"
                        >
                          <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M12.206.793c.99 0 4.347.276 5.93 3.821.529 1.193.403 3.219.299 4.847l-.003.06c-.012.18-.022.345-.03.51.075.045.203.09.401.09.3 0 .73-.057 1.126-.12.57-.084 1.185-.179 1.757-.179.3 0 .582.04.84.12.42.15.81.42 1.023.84.195.39.225.84.09 1.289-.12.45-.36.87-.645 1.17-.27.285-.645.54-1.065.705l-.084.045c-.3.165-.704.42-.78.885-.03.135-.015.27.045.404.09.21.21.405.345.585.195.27.42.54.645.81.51.585 1.065 1.185 1.47 1.83.225.36.42.72.57 1.095.09.24.15.495.18.75.015.195 0 .375-.045.555-.075.27-.24.54-.495.705-.3.195-.659.285-1.065.285l-.075-.015c-.705-.075-1.38-.24-2.04-.42-.585-.165-1.17-.3-1.77-.42-.15-.03-.296-.045-.444-.045-.555 0-1.05.195-1.53.42-.45.195-.945.405-1.485.57-.9.3-1.725.345-2.385.345-.405 0-.78-.045-1.095-.09-.75-.15-1.485-.42-2.22-.705-.585-.225-1.17-.48-1.77-.705-.42-.15-.885-.225-1.335-.225-.3 0-.585.03-.87.09-.555.12-1.095.27-1.65.42-.705.195-1.38.42-2.085.57-.705.15-1.38.225-2.01.195-.45-.015-.885-.135-1.26-.375-.3-.195-.495-.495-.585-.84-.075-.3-.075-.615 0-.915.09-.375.27-.735.495-1.065.42-.645.96-1.23 1.485-1.815.24-.27.465-.54.675-.81.12-.165.225-.345.3-.54.09-.195.12-.405.075-.615-.045-.435-.375-.705-.69-.87l-.096-.06c-.42-.165-.795-.42-1.065-.705-.285-.3-.525-.72-.645-1.17-.135-.45-.105-.9.09-1.29.21-.42.6-.69 1.02-.84.259-.08.541-.12.84-.12.573 0 1.185.09 1.757.18.39.06.825.12 1.124.12.195 0 .315-.045.375-.075-.015-.165-.03-.345-.045-.54l-.015-.09c-.105-1.59-.21-3.615.285-4.806C7.86 1.068 11.19.792 12.206.792zm0 0" />
                          </svg>
                          <span>{{ $t('jobs.shareOnSnapchat') }}</span>
                        </button>
                      </div>
                    </Transition>
                  </div>

                  <BaseButton 
                    v-if="!isOwnJob(selectedJob) && authStore.user?.user_type !== 'company_owner'"
                    variant="outline" 
                    size="lg" 
                    @click="saveJob(selectedJob)"
                  >
                    <template #icon-left>
                      <svg 
                        class="w-5 h-5" 
                        :class="savedJobStore.savedJobIds.has(selectedJob.id) ? 'fill-yellow-500 text-yellow-500' : ''"
                        :fill="savedJobStore.savedJobIds.has(selectedJob.id) ? 'currentColor' : 'none'" 
                        stroke="currentColor" 
                        viewBox="0 0 24 24"
                      >
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 5a2 2 0 012-2h10a2 2 0 012 2v16l-7-3.5L5 21V5z" />
                      </svg>
                    </template>
                    <span class="hidden sm:inline">{{ savedJobStore.savedJobIds.has(selectedJob.id) ? $t('jobs.saved') : $t('jobs.saveJob') }}</span>
                  </BaseButton>
                </div>
              </div>
            </div>

            <!-- Salary & Details -->
            <div v-if="selectedJob.salary_min && selectedJob.salary_max" class="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-8 p-6 bg-gray-50 rounded-lg border border-gray-200">
              <div>
                <div class="flex items-center gap-2 mb-2">
                  <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  <p class="text-sm font-medium text-gray-700">{{ $t('jobs.salaryRange') }}</p>
                </div>
                <p class="text-2xl font-bold text-green-600">
                  {{ formatSalaryRange(selectedJob.salary_min, selectedJob.salary_max, selectedJob.salary_currency, selectedJob.salary_period ? formatSalaryPeriod(selectedJob.salary_period) : undefined) }}
                </p>
              </div>
              <div>
                <div class="flex items-center gap-2 mb-2">
                  <svg class="w-5 h-5 text-secondary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z" />
                  </svg>
                  <p class="text-sm font-medium text-gray-700">{{ $t('jobs.experienceLevel') }}</p>
                </div>
                <span class="inline-flex px-3 py-1 bg-secondary-100 text-secondary-800 rounded-full text-sm font-semibold">{{ formatExperienceLevel(selectedJob.experience_level) }}</span>
              </div>
            </div>

            <!-- Job Description -->
            <div class="prose prose-sm max-w-none mb-8">
              <div class="flex items-center gap-3 mb-4">
                <svg class="w-6 h-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h7" />
                </svg>
                <h2 class="text-xl font-bold text-gray-900">{{ $t('jobs.jobDescription') }}</h2>
              </div>
              <!-- eslint-disable-next-line vue/no-v-html -->
              <div v-html="selectedJob.description" class="text-gray-600"></div>
            </div>

            <!-- Requirements -->
            <div v-if="selectedJob.requirements" class="prose prose-sm max-w-none mb-8">
              <div class="flex items-center gap-3 mb-4">
                <svg class="w-6 h-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" />
                </svg>
                <h2 class="text-xl font-bold text-gray-900">{{ $t('jobs.requirements') }}</h2>
              </div>
              <!-- eslint-disable-next-line vue/no-v-html -->
              <div v-html="selectedJob.requirements" class="text-gray-600"></div>
            </div>

            <!-- Benefits -->
            <div v-if="selectedJob.benefits" class="prose prose-sm max-w-none mb-8">
              <div class="flex items-center gap-3 mb-4">
                <svg class="w-6 h-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
                </svg>
                <h2 class="text-xl font-bold text-gray-900">{{ $t('jobs.benefits') }}</h2>
              </div>
              <!-- eslint-disable-next-line vue/no-v-html -->
              <div v-html="selectedJob.benefits" class="text-gray-600"></div>
            </div>

            <!-- Skills -->
            <div v-if="selectedJob.skills && selectedJob.skills.length > 0" class="mt-8">
              <div class="flex items-center gap-2 mb-4">
                <svg class="w-6 h-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
                </svg>
                <h3 class="text-lg font-bold text-gray-900">{{ $t('jobs.requiredSkills') }}</h3>
              </div>
              <div class="flex flex-wrap gap-2">
                <span
                  v-for="skill in selectedJob.skills"
                  :key="skill"
                  class="px-3 py-1.5 bg-teal-100 text-teal-800 rounded-full text-sm font-medium"
                >
                  {{ skill }}
                </span>
              </div>
            </div>
          </div>

          <!-- No Job Selected -->
          <div v-else class="flex items-center justify-center h-full p-12 text-center">
            <div>
              <svg class="h-24 w-24 mx-auto text-gray-300 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
              </svg>
              <h3 class="text-xl font-semibold text-gray-900 mb-2">{{ $t('jobs.selectJobToViewDetails') }}</h3>
              <p class="text-gray-600">{{ $t('jobs.clickAnyJob') }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted, onBeforeUnmount, nextTick } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useMediaQuery } from '@vueuse/core'
import { useJobStore } from '@/stores/job'
import { useAuthStore } from '@/stores/auth'
import { useSavedJobStore } from '@/stores/savedJob'
import { useToast } from '@/composables/useToast'
import { copyToClipboard } from '@/utils/clipboard'
import { formatSalaryRange } from '@/utils/currency'
import { jobApplicationService } from '@/services/jobApplication.service'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import type { Job, JobFilters } from '@/types'
import { iraqCities } from '@/config/iraqCities'
import { useI18n } from 'vue-i18n'

const router = useRouter()
const route = useRoute()
const jobStore = useJobStore()
const authStore = useAuthStore()
const savedJobStore = useSavedJobStore()
const toast = useToast()
const { t } = useI18n()

// Responsive breakpoint for mobile detection
const isMobile = useMediaQuery('(max-width: 1023px)')

// City suggestions state
const showCitySuggestions = ref(false)
const selectedCityIndex = ref(-1)
const citySuggestionsRef = ref<HTMLElement | null>(null)
const cityRefs: Record<number, HTMLElement> = {}

const filteredCities = computed(() => {
  if (!filters.location) return []
  const searchTerm = filters.location.toLowerCase()
  return iraqCities.filter(city => 
    city.toLowerCase().includes(searchTerm)
  )
})

const handleLocationInput = () => {
  showCitySuggestions.value = true
  selectedCityIndex.value = -1
}

const scrollToSelected = () => {
  nextTick(() => {
    if (selectedCityIndex.value >= 0 && cityRefs[selectedCityIndex.value]) {
      cityRefs[selectedCityIndex.value].scrollIntoView({
        block: 'nearest',
        behavior: 'smooth'
      })
    }
  })
}

const handleCityKeyDown = (event: KeyboardEvent) => {
  // Handle Enter key always (even without suggestions)
  if (event.key === 'Enter') {
    event.preventDefault()
    if (showCitySuggestions.value && filteredCities.value.length > 0 && 
        selectedCityIndex.value >= 0 && selectedCityIndex.value < filteredCities.value.length) {
      selectCity(filteredCities.value[selectedCityIndex.value])
    } else {
      searchJobs()
    }
    return
  }

  // Handle Escape key
  if (event.key === 'Escape') {
    showCitySuggestions.value = false
    selectedCityIndex.value = -1
    return
  }

  // For arrow keys, only work if suggestions are showing
  if (!showCitySuggestions.value || filteredCities.value.length === 0) return

  switch (event.key) {
    case 'ArrowDown':
      event.preventDefault()
      selectedCityIndex.value = Math.min(selectedCityIndex.value + 1, filteredCities.value.length - 1)
      scrollToSelected()
      break
    case 'ArrowUp':
      event.preventDefault()
      selectedCityIndex.value = Math.max(selectedCityIndex.value - 1, 0)
      scrollToSelected()
      break
  }
}

const selectCity = (city: string) => {
  filters.location = city
  showCitySuggestions.value = false
  selectedCityIndex.value = -1
}

const handleCityBlur = () => {
  setTimeout(() => {
    showCitySuggestions.value = false
  }, 200)
}


const loading = ref(false)
const loadingMore = ref(false)
const selectedJob = ref<Job | null>(null)
const showShareMenu = ref(false)
const shareMenuRef = ref<HTMLElement | null>(null)
const appliedJobIds = ref<Set<number>>(new Set())
const randomSeed = ref<number | null>(null)

const filters = reactive({
  search: '',
  location: '',
  employment_type: '',
  experience_level: '',
  salary_min: '',
  is_remote: false,
  company: '',
  per_page: 20,
  page: 1,
})

const jobs = computed(() => jobStore.jobs)
const totalJobs = computed(() => jobStore.pagination?.total || 0)
const currentPage = computed(() => jobStore.pagination?.current_page || 1)
const totalPages = computed(() => jobStore.pagination?.last_page || 1)
const hasMoreJobs = computed(() => currentPage.value < totalPages.value)

const searchJobs = async () => {
  loading.value = true
  try {
    // Reset to page 1 and clear seed when searching (creates new random order)
    filters.page = 1
    randomSeed.value = null
    
    // Clean filters: remove empty strings and zero values
    const cleanFilters = Object.entries(filters).reduce((acc, [key, value]) => {
      if (value !== '' && value !== 0 && value !== false && value !== undefined && value !== null) {
        acc[key as keyof JobFilters] = value as never
      }
      // Always include page and per_page
      if (key === 'page' || key === 'per_page') {
        acc[key as keyof JobFilters] = value as never
      }
      return acc
    }, {} as JobFilters)
    
    await jobStore.fetchJobs(cleanFilters, false)
    
    // Store the seed from the response for pagination consistency
    if (jobStore.pagination && 'seed' in jobStore.pagination) {
      randomSeed.value = (jobStore.pagination as typeof jobStore.pagination & { seed: number }).seed
    }
  } catch (error) {
    console.error('Failed to fetch jobs:', error)
  } finally {
    loading.value = false
  }
}

const loadMoreJobs = async () => {
  if (!hasMoreJobs.value || loadingMore.value) return
  
  loadingMore.value = true
  try {
    // Increment page
    filters.page += 1
    
    // Clean filters and include seed for pagination consistency
    const cleanFilters = Object.entries(filters).reduce((acc, [key, value]) => {
      if (value !== '' && value !== 0 && value !== false && value !== undefined && value !== null) {
        acc[key as keyof JobFilters] = value as never
      }
      if (key === 'page' || key === 'per_page') {
        acc[key as keyof JobFilters] = value as never
      }
      return acc
    }, {} as JobFilters)
    
    // Add seed to maintain same random order during pagination
    if (randomSeed.value) {
      (cleanFilters as JobFilters & { seed: number }).seed = randomSeed.value
    }
    
    await jobStore.loadMoreJobs(cleanFilters)
  } catch (error) {
    console.error('Failed to load more jobs:', error)
    filters.page -= 1 // Revert page increment on error
  } finally {
    loadingMore.value = false
  }
}

const clearFilters = () => {
  filters.search = ''
  filters.location = ''
  filters.employment_type = ''
  filters.experience_level = ''
  filters.salary_min = ''
  filters.is_remote = false
  filters.page = 1
  selectedJob.value = null
  randomSeed.value = null // Reset seed to get new random order
  searchJobs()
}

const selectJob = async (job: Job) => {
  // On mobile devices, navigate to job detail page
  if (isMobile.value) {
    // Save pagination state before navigating
    const stateToSave = {
      page: filters.page,
      filters: filters,
      seed: randomSeed.value,
      scrollPosition: window.scrollY
    }
    console.log('Saving state from selectJob (mobile):', stateToSave)
    sessionStorage.setItem('jobsListState', JSON.stringify(stateToSave))
    
    router.push(`/jobs/${job.slug}`)
    return
  }
  
  // On desktop, show in the side panel
  selectedJob.value = job
  // Optionally fetch full job details if needed:
  // try {
  //   const fullJob = await jobStore.fetchJob(job.id);
  //   selectedJob.value = fullJob;
  // } catch (error) {
  //   console.error('Failed to fetch job details:', error);
  // }
}

const goToJobDetail = (job: Job) => {
  // Save pagination state before navigating
  const stateToSave = {
    page: filters.page,
    filters: filters,
    seed: randomSeed.value,
    scrollPosition: window.scrollY
  }
  console.log('Saving state from goToJobDetail:', stateToSave)
  sessionStorage.setItem('jobsListState', JSON.stringify(stateToSave))
  
  router.push(`/jobs/${job.slug}`)
}

const applyForJob = (job: Job) => {
  if (!authStore.isAuthenticated) {
    router.push({
      path: '/login',
      query: { redirect: `/application/${job.slug}` }
    })
    return
  }
  
  // Check if already applied
  if (hasApplied(job.id)) {
    toast.info(t('jobs.alreadyAppliedToJob'))
    return
  }
  
  // Open application page in a new tab
  window.open(`/application/${job.slug}`, '_blank')
}

const isOwnJob = (job: Job): boolean => {
  if (!authStore.isAuthenticated || !authStore.user) {
    return false
  }
  return job.user_id === authStore.user.id
}

const saveJob = async (job: Job) => {
  if (!authStore.isAuthenticated) {
    toast.error(t('jobs.pleaseLoginToSave'))
    router.push('/login')
    return
  }

  try {
    if (savedJobStore.savedJobIds.has(job.id)) {
      // Unsave the job
      await savedJobStore.unsaveJob(job.id)
      toast.success(t('jobs.jobUnsaved'))
    } else {
      // Save the job
      await savedJobStore.saveJob(job.id)
      toast.success(t('jobs.jobSaved'))
    }
  } catch (err: unknown) {
    const errorMessage = err && typeof err === 'object' && 'response' in err
      ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
      : undefined
    toast.error(errorMessage || t('jobs.failedToSaveJob'))
  }
}

const toggleShareMenu = () => {
  showShareMenu.value = !showShareMenu.value
}

const shareOn = (platform: string) => {
  if (!selectedJob.value) return

  const url = `${window.location.origin}/jobs/${selectedJob.value.slug}`
  const title = selectedJob.value.title
  const text = `Check out this job opportunity: ${title} at ${selectedJob.value.company?.name || 'a great company'}`
  
  let shareUrl = ''

  switch (platform) {
    case 'twitter':
      shareUrl = `https://twitter.com/intent/tweet?text=${encodeURIComponent(text)}&url=${encodeURIComponent(url)}`
      break
    case 'facebook':
      shareUrl = `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(url)}`
      break
    case 'linkedin':
      shareUrl = `https://www.linkedin.com/sharing/share-offsite/?url=${encodeURIComponent(url)}`
      break
    case 'instagram':
      // Instagram doesn't support direct web sharing, so we'll copy the link and notify the user
      copyToClipboard(url).then(() => {
        toast.info(t('jobs.linkCopiedInstagram'))
        showShareMenu.value = false
      }).catch(() => {
        toast.error(t('jobs.failedToCopyLink'))
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

const copyJobLink = async () => {
  if (!selectedJob.value) return
  
  const url = `${window.location.origin}/jobs/${selectedJob.value.slug}`
  try {
    await copyToClipboard(url)
    toast.success(t('jobs.linkCopied'))
    showShareMenu.value = false
  } catch (err) {
    console.error('Failed to copy link:', err)
    toast.error(t('jobs.failedToCopyLink'))
  }
}

// Formatting helpers
const formatEmploymentType = (type: string): string => {
  const types: Record<string, string> = {
    'full-time': t('jobs.fullTime'),
    'part-time': t('jobs.partTime'),
    'contract': t('jobs.contract'),
    'freelance': t('jobs.freelance'),
    'internship': t('jobs.internship'),
  }
  return types[type] || type
}

const formatExperienceLevel = (level: string): string => {
  const levels: Record<string, string> = {
    'entry': t('jobs.entryLevel'),
    'mid': t('jobs.midLevel'),
    'senior': t('jobs.senior'),
    'lead': t('jobs.lead'),
    'executive': t('jobs.executive'),
  }
  return levels[level] || level
}

const formatCategory = (category: string): string => {
  // Categories are stored as readable names in the database
  // For now, return as-is. Can be extended with translations in the future.
  return category
}

const _formatSalary = (amount: number): string => {
  if (amount >= 1000) {
    return (amount / 1000).toFixed(0) + 'k'
  }
  return amount.toString()
}

const formatSalaryPeriod = (period: string): string => {
  const periods: Record<string, string> = {
    'hourly': t('jobs.perHour'),
    'daily': t('jobs.perHour'), // No daily translation, using hourly as fallback
    'monthly': t('jobs.perMonth'),
    'yearly': t('jobs.perYear'),
  }
  return periods[period] || period
}

const formatJobDate = (date: string): string => {
  const targetDate = new Date(date)
  const day = String(targetDate.getDate()).padStart(2, '0')
  const month = String(targetDate.getMonth() + 1).padStart(2, '0')
  const year = targetDate.getFullYear()
  return `${day}.${month}.${year}`
}

const fetchSavedJobs = async () => {
  if (authStore.isAuthenticated) {
    await savedJobStore.fetchSavedJobsCount()
  }
}

const fetchAppliedJobs = async () => {
  if (!authStore.isAuthenticated) return
  
  try {
    const response = await jobApplicationService.getMyApplications({
      per_page: 1000, // Get all applications to check against
    })
    
    if (response.data) {
      // Create a Set of job IDs that the user has applied to
      const jobIds = response.data.data.map(application => application.job_id)
      appliedJobIds.value = new Set(jobIds)
    }
  } catch (error) {
    console.error('Failed to fetch applied jobs:', error)
  }
}

const hasApplied = (jobId: number): boolean => {
  return appliedJobIds.value.has(jobId)
}

onMounted(async () => {
  // Load filters from URL query params
  if (route.query.search) filters.search = route.query.search as string
  if (route.query.location) filters.location = route.query.location as string
  if (route.query.employment_type) filters.employment_type = route.query.employment_type as string
  if (route.query.experience_level) filters.experience_level = route.query.experience_level as string
  if (route.query.is_remote) filters.is_remote = route.query.is_remote === 'true'
  if (route.query.company) filters.company = route.query.company as string
  
  fetchSavedJobs()
  fetchAppliedJobs()
  
  // Check if we need to restore pagination state
  const savedState = sessionStorage.getItem('jobsListState')
  if (savedState) {
    try {
      const state = JSON.parse(savedState)
      
      // Restore filters and seed
      Object.assign(filters, state.filters)
      randomSeed.value = state.seed
      const targetPage = state.page
      
      // Load first page
      filters.page = 1
      await searchJobs()
      
      // Progressively load remaining pages
      for (let page = 2; page <= targetPage; page++) {
        if (hasMoreJobs.value) {
          await loadMoreJobs()
        }
      }
      
      // Restore scroll position
      setTimeout(() => {
        window.scrollTo(0, state.scrollPosition)
      }, 300)
      
      // Clear saved state
      sessionStorage.removeItem('jobsListState')
    } catch {
      searchJobs()
    }
  } else {
    searchJobs()
  }
  
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
.instagram-gradient {
  background: linear-gradient(135deg, #9333ea 0%, #db2777 100%);
}

.instagram-gradient:hover {
  background: linear-gradient(135deg, #7e22ce 0%, #be185d 100%);
}
</style>

