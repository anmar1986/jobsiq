<template>
  <div class="bg-gray-50 min-h-screen">
    <!-- Search & Filters Bar -->
    <div class="bg-white border-b-2 border-gray-300 sticky top-0 z-30">
      <div class="mx-auto px-4 py-4 max-w-[1200px]">
        <!-- Search Row -->
        <div class="flex gap-3 mb-3">
          <div class="flex-1">
            <BaseInput
              v-model="filters.search"
              type="text"
              placeholder="Search by job title, keywords, or company..."
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
          <div class="w-72 relative">
            <input
              v-model="filters.location"
              type="text"
              placeholder="City"
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
          <BaseButton variant="primary" size="md" @click="searchJobs" :loading="loading">
            Search
          </BaseButton>
        </div>

        <!-- Filters Row -->
        <div class="flex gap-3 items-center">
          <!-- Results count -->
          <span class="text-sm font-medium text-gray-900">
            {{ totalJobs }} {{ totalJobs === 1 ? 'job' : 'jobs' }}
          </span>

          <!-- Employment Type -->
          <select
            v-model="filters.employment_type"
            @change="searchJobs"
            class="px-4 py-2 border border-gray-300 rounded-lg text-sm focus:ring-primary-500 focus:border-primary-500 bg-white"
          >
            <option value="">Employment Type</option>
            <option value="full-time">Full-time</option>
            <option value="part-time">Part-time</option>
            <option value="contract">Contract</option>
            <option value="freelance">Freelance</option>
            <option value="internship">Internship</option>
          </select>

          <!-- Experience Level -->
          <select
            v-model="filters.experience_level"
            @change="searchJobs"
            class="px-4 py-2 border border-gray-300 rounded-lg text-sm focus:ring-primary-500 focus:border-primary-500 bg-white"
          >
            <option value="">Experience Level</option>
            <option value="entry">Entry Level</option>
            <option value="mid">Mid Level</option>
            <option value="senior">Senior</option>
            <option value="lead">Lead</option>
            <option value="executive">Executive</option>
          </select>

          <!-- Salary -->
          <select
            v-model="filters.salary_min"
            @change="searchJobs"
            class="px-4 py-2 border border-gray-300 rounded-lg text-sm focus:ring-primary-500 focus:border-primary-500 bg-white"
          >
            <option value="">Salary</option>
            <option value="250">From $250</option>
            <option value="500">From $500</option>
            <option value="1000">From $1000</option>
            <option value="2000">From $2000</option>
          </select>

          <!-- Remote Only Checkbox -->
          <label class="flex items-center gap-2 px-4 py-2 border border-gray-300 rounded-lg text-sm bg-white cursor-pointer hover:bg-gray-50">
            <input
              v-model="filters.is_remote"
              type="checkbox"
              class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
              @change="searchJobs"
            />
            <span class="font-medium text-gray-700">Remote Only</span>
          </label>

          <div class="flex-1"></div>

          <!-- Clear Filters -->
          <button
            @click="clearFilters"
            class="px-4 py-2 text-sm text-gray-600 hover:text-gray-900 font-medium"
          >
            Clear all
          </button>
        </div>
      </div>
    </div>

    <!-- Main Content: Split View -->
    <div class="container-custom py-6">
      <div class="flex gap-6 min-h-[calc(100vh-280px)]">
        <!-- Left: Jobs List -->
        <div class="w-96 flex-shrink-0 bg-white rounded-lg border border-gray-200">
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
                'p-4 cursor-pointer transition-colors border-b-2 border-gray-300',
                selectedJob?.id === job.id ? 'bg-primary-50 border-l-4 border-l-primary-600' : 'hover:bg-gray-50'
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
                      Remote
                    </span>
                  </div>
                  
                  <div v-if="job.salary_min && job.salary_max">
                    <span class="inline-flex items-center px-2 py-1 rounded text-xs font-medium bg-gray-100 text-gray-800">
                      ${{ formatSalary(job.salary_min) }} - ${{ formatSalary(job.salary_max) }}{{ job.salary_period ? '/' + formatSalaryPeriod(job.salary_period) : '' }}
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
            <h3 class="text-sm font-semibold text-gray-900 mb-1">No jobs found</h3>
            <p class="text-xs text-gray-600 mb-4">Try adjusting your filters</p>
            <BaseButton variant="primary" size="sm" @click="clearFilters">Clear Filters</BaseButton>
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
              Load More Jobs
            </BaseButton>
            <p class="text-center text-sm text-gray-500 mt-3">
              Showing {{ jobs.length }} of {{ totalJobs }} jobs
            </p>
          </div>
        </div>

        <!-- Right: Job Details -->
        <div class="flex-1 bg-white rounded-lg border border-gray-200 sticky top-20 self-start max-h-[calc(100vh-120px)] overflow-y-auto">
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
                
                <div class="flex flex-wrap gap-4 text-sm text-gray-600 mb-4">
                  <div class="flex items-center gap-2">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                    </svg>
                    {{ selectedJob.location }}
                  </div>
                  <div class="flex items-center gap-2">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    {{ formatEmploymentType(selectedJob.employment_type) }}
                  </div>
                  <div v-if="selectedJob.is_remote" class="flex items-center gap-2">
                    <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                    Remote
                  </div>
                </div>

                <div class="flex gap-3 flex-wrap">
                  <BaseButton variant="primary" size="lg" @click="applyForJob(selectedJob)">
                    <template #icon-left>
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                      </svg>
                    </template>
                    Apply Now
                  </BaseButton>
                  <BaseButton variant="outline" size="lg" @click="goToJobDetail(selectedJob)">
                    View Details
                  </BaseButton>
                  
                  <!-- Share Job Button with Dropdown -->
                  <div class="relative" ref="shareMenuRef">
                    <BaseButton variant="outline" size="lg" @click.stop="toggleShareMenu">
                      <template #icon-left>
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z" />
                        </svg>
                      </template>
                      Share
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
                        class="absolute top-full left-0 mt-2 w-64 bg-white rounded-lg shadow-lg border border-gray-200 py-2 z-50 max-h-96 overflow-y-auto"
                      >
                        <!-- Share on X (Twitter) -->
                        <button
                          @click="shareOn('twitter')"
                          class="w-full px-4 py-2 text-left hover:bg-gray-50 flex items-center gap-3 text-gray-700"
                        >
                          <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/>
                          </svg>
                          <span>Share on X</span>
                        </button>

                        <!-- Share on Facebook -->
                        <button
                          @click="shareOn('facebook')"
                          class="w-full px-4 py-2 text-left hover:bg-gray-50 flex items-center gap-3 text-gray-700"
                        >
                          <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
                          </svg>
                          <span>Share on Facebook</span>
                        </button>

                        <!-- Share on Instagram -->
                        <button
                          @click="shareOn('instagram')"
                          class="w-full px-4 py-2 text-left hover:bg-gray-50 flex items-center gap-3 text-gray-700"
                        >
                          <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z"/>
                          </svg>
                          <span>Share on Instagram</span>
                        </button>

                        <!-- Share on Snapchat -->
                        <button
                          @click="shareOn('snapchat')"
                          class="w-full px-4 py-2 text-left hover:bg-gray-50 flex items-center gap-3 text-gray-700"
                        >
                          <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M12.206.793c.99 0 4.347.276 5.93 3.821.529 1.193.403 3.219.299 4.847l-.003.06c-.012.18-.022.345-.03.51.075.045.203.09.401.09.3 0 .73-.057 1.126-.12.57-.084 1.185-.179 1.757-.179.3 0 .582.04.84.12.42.15.81.42 1.023.84.195.39.225.84.09 1.289-.12.45-.36.87-.645 1.17-.27.285-.645.54-1.065.705l-.084.045c-.3.165-.704.42-.78.885-.03.135-.015.27.045.404.09.21.21.405.345.585.195.27.42.54.645.81.51.585 1.065 1.185 1.47 1.83.225.36.42.72.57 1.095.09.24.15.495.18.75.015.195 0 .375-.045.555-.075.27-.24.54-.495.705-.3.195-.659.285-1.065.285l-.075-.015c-.705-.075-1.38-.24-2.04-.42-.585-.165-1.17-.3-1.77-.42-.15-.03-.296-.045-.444-.045-.555 0-1.05.195-1.53.42-.45.195-.945.405-1.485.57-.9.3-1.725.345-2.385.345-.405 0-.78-.045-1.095-.09-.75-.15-1.485-.42-2.22-.705-.585-.225-1.17-.48-1.77-.705-.42-.15-.885-.225-1.335-.225-.3 0-.585.03-.87.09-.555.12-1.095.27-1.65.42-.705.195-1.38.42-2.085.57-.705.15-1.38.225-2.01.195-.45-.015-.885-.135-1.26-.375-.3-.195-.495-.495-.585-.84-.075-.3-.075-.615 0-.915.09-.375.27-.735.495-1.065.42-.645.96-1.23 1.485-1.815.24-.27.465-.54.675-.81.12-.165.225-.345.3-.54.09-.195.12-.405.075-.615-.045-.435-.375-.705-.69-.87l-.096-.06c-.42-.165-.795-.42-1.065-.705-.285-.3-.525-.72-.645-1.17-.135-.45-.105-.9.09-1.29.21-.42.6-.69 1.02-.84.259-.08.541-.12.84-.12.573 0 1.185.09 1.757.18.39.06.825.12 1.124.12.195 0 .315-.045.375-.075-.015-.165-.03-.345-.045-.54l-.015-.09c-.105-1.59-.21-3.615.285-4.806C7.86 1.068 11.19.792 12.206.792zm0 0"/>
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

                  <BaseButton variant="outline" size="lg" @click="saveJob(selectedJob)">
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
                    {{ savedJobStore.savedJobIds.has(selectedJob.id) ? 'Saved' : 'Save' }}
                  </BaseButton>
                </div>
              </div>
            </div>

            <!-- Salary & Details -->
            <div v-if="selectedJob.salary_min && selectedJob.salary_max" class="grid grid-cols-2 gap-4 mb-8 p-6 bg-gray-50 rounded-lg">
              <div>
                <p class="text-sm text-gray-600 mb-1">Salary Range</p>
                <p class="text-2xl font-bold text-gray-900">
                  ${{ formatSalary(selectedJob.salary_min) }} - ${{ formatSalary(selectedJob.salary_max) }}
                </p>
                <p class="text-sm text-gray-600">{{ selectedJob.salary_currency }}</p>
              </div>
              <div>
                <p class="text-sm text-gray-600 mb-1">Experience Level</p>
                <p class="text-xl font-semibold text-gray-900">{{ formatExperienceLevel(selectedJob.experience_level) }}</p>
              </div>
            </div>

            <!-- Job Description -->
            <div class="prose prose-sm max-w-none mb-8">
              <h2 class="text-xl font-bold text-gray-900 mb-4">Job Description</h2>
              <!-- eslint-disable-next-line vue/no-v-html -->
              <div v-html="selectedJob.description" class="text-gray-600"></div>
            </div>

            <!-- Requirements -->
            <div v-if="selectedJob.requirements" class="prose prose-sm max-w-none mb-8">
              <h2 class="text-xl font-bold text-gray-900 mb-4">Requirements</h2>
              <!-- eslint-disable-next-line vue/no-v-html -->
              <div v-html="selectedJob.requirements" class="text-gray-600"></div>
            </div>

            <!-- Skills -->
            <div v-if="selectedJob.skills && selectedJob.skills.length > 0" class="mt-8">
              <h3 class="text-lg font-bold text-gray-900 mb-4">Required Skills</h3>
              <div class="flex flex-wrap gap-2">
                <span
                  v-for="skill in selectedJob.skills"
                  :key="skill"
                  class="px-3 py-1 bg-primary-100 text-primary-800 rounded-full text-sm font-medium"
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
              <h3 class="text-xl font-semibold text-gray-900 mb-2">Select a job to view details</h3>
              <p class="text-gray-600">Click on any job from the list to see more information</p>
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
import { useJobStore } from '@/stores/job'
import { useAuthStore } from '@/stores/auth'
import { useSavedJobStore } from '@/stores/savedJob'
import { useToast } from '@/composables/useToast'
import { copyToClipboard } from '@/utils/clipboard'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import type { Job, JobFilters } from '@/types'
import { iraqCities } from '@/config/iraqCities'

const router = useRouter()
const route = useRoute()
const jobStore = useJobStore()
const authStore = useAuthStore()
const savedJobStore = useSavedJobStore()
const toast = useToast()

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
    // Reset to page 1 when searching
    filters.page = 1
    
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
    
    // Clean filters
    const cleanFilters = Object.entries(filters).reduce((acc, [key, value]) => {
      if (value !== '' && value !== 0 && value !== false && value !== undefined && value !== null) {
        acc[key as keyof JobFilters] = value as never
      }
      if (key === 'page' || key === 'per_page') {
        acc[key as keyof JobFilters] = value as never
      }
      return acc
    }, {} as JobFilters)
    
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
  searchJobs()
}

const selectJob = async (job: Job) => {
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
  router.push(`/application/${job.slug}`)
}

const saveJob = async (job: Job) => {
  if (!authStore.isAuthenticated) {
    toast.error('Please login to save jobs')
    router.push('/login')
    return
  }

  try {
    if (savedJobStore.savedJobIds.has(job.id)) {
      // Unsave the job
      await savedJobStore.unsaveJob(job.id)
      toast.success('Job removed from saved')
    } else {
      // Save the job
      await savedJobStore.saveJob(job.id)
      toast.success('Job saved successfully')
    }
  } catch (err: unknown) {
    const errorMessage = err && typeof err === 'object' && 'response' in err
      ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
      : undefined
    toast.error(errorMessage || 'Failed to save job')
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

const copyJobLink = async () => {
  if (!selectedJob.value) return
  
  const url = `${window.location.origin}/jobs/${selectedJob.value.slug}`
  try {
    await copyToClipboard(url)
    toast.success('Link copied to clipboard!')
    showShareMenu.value = false
  } catch (error) {
    console.error('Failed to copy link:', error)
    toast.error('Failed to copy link')
  }
}

// Formatting helpers
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

const formatSalary = (amount: number): string => {
  if (amount >= 1000) {
    return (amount / 1000).toFixed(0) + 'k'
  }
  return amount.toString()
}

const formatSalaryPeriod = (period: string): string => {
  const periods: Record<string, string> = {
    'hourly': 'hourly',
    'daily': 'daily',
    'monthly': 'monthly',
    'yearly': 'yearly',
  }
  return periods[period] || period
}

const fetchSavedJobs = async () => {
  if (authStore.isAuthenticated) {
    await savedJobStore.fetchSavedJobsCount()
  }
}

onMounted(() => {
  // Load filters from URL query params
  if (route.query.search) filters.search = route.query.search as string
  if (route.query.location) filters.location = route.query.location as string
  if (route.query.employment_type) filters.employment_type = route.query.employment_type as string
  if (route.query.experience_level) filters.experience_level = route.query.experience_level as string
  if (route.query.is_remote) filters.is_remote = route.query.is_remote === 'true'
  if (route.query.company) filters.company = route.query.company as string
  
  fetchSavedJobs()
  searchJobs()
  
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

