<template>
  <div class="bg-gray-50 min-h-screen">
    <!-- Page Header -->
    <div class="bg-white border-b border-gray-200">
      <div class="container-custom py-6">
        <h1 class="text-3xl font-bold text-gray-900 mb-2">Find Your Dream Job</h1>
        <p class="text-gray-600">Browse {{ totalJobs }} open positions from top companies</p>
      </div>
    </div>

    <!-- Search & Filters Bar -->
    <div class="bg-white border-b border-gray-200 sticky top-0 z-30 shadow-sm">
      <div class="container-custom py-4">
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

          <!-- Salary Min -->
          <BaseInput
            v-model.number="filters.salary_min"
            type="number"
            placeholder="Min Salary"
            size="md"
            class="w-40"
            @blur="searchJobs"
          >
            <template #icon-left>
              <span class="text-gray-400 text-sm">$</span>
            </template>
          </BaseInput>

          <div class="flex-1"></div>

          <!-- Clear Filters -->
          <button
            @click="clearFilters"
            class="px-4 py-2 text-sm text-gray-600 hover:text-gray-900 font-medium"
          >
            Clear all
          </button>

          <!-- Results count -->
          <span class="text-sm text-gray-600">
            {{ totalJobs }} {{ totalJobs === 1 ? 'job' : 'jobs' }}
          </span>
        </div>
      </div>
    </div>

    <!-- Main Content: Split View -->
    <div class="container-custom py-6">
      <div class="flex gap-6 h-[calc(100vh-280px)]">
        <!-- Left: Jobs List -->
        <div class="w-96 flex-shrink-0 overflow-y-auto bg-white rounded-lg border border-gray-200">
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
          <div v-else-if="jobs.length > 0" class="divide-y divide-gray-200">
            <div
              v-for="job in jobs"
              :key="job.id"
              @click="selectJob(job)"
              :class="[
                'p-4 cursor-pointer transition-colors',
                selectedJob?.id === job.id ? 'bg-primary-50 border-l-4 border-l-primary-600' : 'hover:bg-gray-50'
              ]"
            >
              <div class="flex gap-3 mb-2">
                <!-- Company Logo -->
                <div class="w-12 h-12 bg-gray-100 rounded flex items-center justify-center flex-shrink-0">
                  <img
                    v-if="job.company?.logo?.url"
                    :src="job.company.logo.url"
                    :alt="job.company.name"
                    class="w-full h-full object-contain rounded p-1"
                  />
                  <span v-else class="text-lg font-bold text-gray-600">
                    {{ job.company?.name?.charAt(0) || 'C' }}
                  </span>
                </div>

                <div class="flex-1 min-w-0">
                  <h3 class="font-semibold text-gray-900 text-sm mb-1 truncate">{{ job.title }}</h3>
                  <p class="text-xs text-gray-600 truncate">{{ job.company?.name }}</p>
                </div>
              </div>

              <div class="flex items-center gap-2 text-xs text-gray-500 mb-2">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                </svg>
                <span class="truncate">{{ job.location }}</span>
              </div>

              <div class="flex flex-wrap gap-2">
                <span v-if="job.employment_type" class="inline-flex items-center px-2 py-1 rounded text-xs font-medium bg-blue-100 text-blue-800">
                  {{ formatEmploymentType(job.employment_type) }}
                </span>
                <span v-if="job.is_remote" class="inline-flex items-center px-2 py-1 rounded text-xs font-medium bg-green-100 text-green-800">
                  Remote
                </span>
                <span v-if="job.salary_min && job.salary_max" class="inline-flex items-center px-2 py-1 rounded text-xs font-medium bg-gray-100 text-gray-800">
                  ${{ formatSalary(job.salary_min) }} - ${{ formatSalary(job.salary_max) }}
                </span>
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

          <!-- Pagination -->
          <div v-if="!loading && totalPages > 1" class="p-4 border-t border-gray-200 bg-gray-50">
            <div class="flex items-center justify-between">
              <BaseButton
                variant="outline"
                size="sm"
                :disabled="currentPage === 1"
                @click="goToPage(currentPage - 1)"
              >
                Previous
              </BaseButton>
              
              <span class="text-xs text-gray-600">
                Page {{ currentPage }} of {{ totalPages }}
              </span>
              
              <BaseButton
                variant="outline"
                size="sm"
                :disabled="currentPage === totalPages"
                @click="goToPage(currentPage + 1)"
              >
                Next
              </BaseButton>
            </div>
          </div>
        </div>

        <!-- Right: Job Details -->
        <div class="flex-1 overflow-y-auto bg-white rounded-lg border border-gray-200">
          <!-- Job Selected -->
          <div v-if="selectedJob" class="p-8">
            <!-- Header -->
            <div class="flex gap-6 mb-6">
              <div class="w-20 h-20 bg-gray-100 rounded-lg flex items-center justify-center flex-shrink-0">
                <img
                  v-if="selectedJob.company?.logo?.path"
                  :src="selectedJob.company.logo.path"
                  :alt="selectedJob.company.name"
                  class="w-full h-full object-cover rounded-lg"
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

                <div class="flex gap-3">
                  <BaseButton variant="primary" size="lg" @click="applyForJob(selectedJob)">
                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    Apply Now
                  </BaseButton>
                  <BaseButton variant="outline" size="lg" @click="goToJobDetail(selectedJob)">
                    View Details
                  </BaseButton>
                  <BaseButton variant="outline" size="lg" @click="saveJob(selectedJob)">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 5a2 2 0 012-2h10a2 2 0 012 2v16l-7-3.5L5 21V5z" />
                    </svg>
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
import { ref, reactive, computed, onMounted, nextTick } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useJobStore } from '@/stores/job'
import { useAuthStore } from '@/stores/auth'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import type { Job, JobFilters } from '@/types'
import { iraqCities } from '@/config/iraqCities'

const router = useRouter()
const route = useRoute()
const jobStore = useJobStore()
const authStore = useAuthStore()

// City suggestions state
const showCitySuggestions = ref(false)
const selectedCityIndex = ref(-1)
const citySuggestionsRef = ref<HTMLElement | null>(null)
const cityRefs: Record<number, HTMLElement> = {}

const filteredCities = computed(() => {
  if (!filters.location) return iraqCities
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
    case 'Enter':
      event.preventDefault()
      if (selectedCityIndex.value >= 0 && selectedCityIndex.value < filteredCities.value.length) {
        selectCity(filteredCities.value[selectedCityIndex.value])
      } else {
        searchJobs()
      }
      break
    case 'Escape':
      showCitySuggestions.value = false
      selectedCityIndex.value = -1
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
const selectedJob = ref<Job | null>(null)

const filters = reactive({
  search: '',
  location: '',
  employment_type: '',
  experience_level: '',
  is_remote: false,
  salary_min: 0,
  per_page: 12,
  page: 1,
} as Required<JobFilters>)

const jobs = computed(() => jobStore.jobs)
const totalJobs = computed(() => jobStore.pagination?.total || 0)
const currentPage = computed(() => jobStore.pagination?.current_page || 1)
const totalPages = computed(() => jobStore.pagination?.last_page || 1)

const searchJobs = async () => {
  loading.value = true
  try {
    await jobStore.fetchJobs(filters)
  } catch (error) {
    console.error('Failed to fetch jobs:', error)
  } finally {
    loading.value = false
  }
}

const clearFilters = () => {
  filters.search = ''
  filters.location = ''
  filters.employment_type = ''
  filters.experience_level = ''
  filters.is_remote = false
  filters.salary_min = 0
  filters.page = 1
  selectedJob.value = null
  searchJobs()
}

const goToPage = (page: number) => {
  filters.page = page
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

const saveJob = (job: Job) => {
  console.log('Save job:', job)
  // TODO: Implement save job functionality
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

onMounted(() => {
  // Load filters from URL query params
  if (route.query.search) filters.search = route.query.search as string
  if (route.query.location) filters.location = route.query.location as string
  if (route.query.employment_type) filters.employment_type = route.query.employment_type as string
  if (route.query.experience_level) filters.experience_level = route.query.experience_level as string
  if (route.query.is_remote) filters.is_remote = route.query.is_remote === 'true'
  if (route.query.salary_min) filters.salary_min = parseInt(route.query.salary_min as string)
  
  searchJobs()
})
</script>

