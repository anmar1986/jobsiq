<template>
  <section class="bg-gradient-to-br from-primary-600 via-primary-700 to-secondary-700 text-white">
    <div class="container-custom py-12 sm:py-16 md:py-24">
      <div class="max-w-4xl mx-auto text-center">
        <h1 class="text-3xl sm:text-4xl md:text-6xl font-bold mb-4 sm:mb-6 animate-fade-in">
          Your Career Journey Starts Here
        </h1>
        <p class="text-lg sm:text-xl md:text-2xl text-primary-100 mb-6 sm:mb-8 md:mb-10 animate-fade-in animation-delay-200">
          Discover thousands of job opportunities with all the information you need.
          Connect with top companies worldwide.
        </p>
        
        <!-- Search Bar -->
        <div class="bg-white rounded-lg shadow-2xl p-3 sm:p-4 md:p-6 animate-fade-in animation-delay-400">
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
            
            <div class="flex-1 md:max-w-xs relative">
              <input
                v-model="locationQuery"
                type="text"
                placeholder="City"
                class="w-full px-4 py-2.5 sm:py-3 pl-10 sm:pl-12 border border-gray-300 rounded-lg text-gray-900 focus:ring-2 focus:ring-primary-500 focus:border-primary-500 text-sm sm:text-base"
                @input="handleLocationInput"
                @focus="showCitySuggestions = true"
                @blur="handleCityBlur"
                @keydown="handleCityKeyDown"
              />
              <div class="absolute inset-y-0 left-0 pl-3 sm:pl-4 flex items-center pointer-events-none">
                <svg class="h-4 w-4 sm:h-5 sm:w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                </svg>
              </div>
              
              <!-- City Suggestions Dropdown -->
              <div
                v-if="showCitySuggestions && filteredCities.length > 0"
                class="absolute z-50 w-full mt-1 bg-white border border-gray-300 rounded-lg shadow-lg max-h-60 overflow-y-auto"
              >
                <button
                  v-for="(city, index) in filteredCities"
                  :key="city"
                  :ref="el => { if (el) cityRefs[index] = el as HTMLElement }"
                  type="button"
                  :class="[
                    'w-full px-3 py-2 text-left text-gray-900 hover:bg-gray-100 focus:bg-gray-100 focus:outline-none transition-colors',
                    { 'bg-primary-100 font-medium': index === selectedCityIndex }
                  ]"
                  @mousedown.prevent="selectCity(city)"
                  @mouseenter="selectedCityIndex = index"
                >
                  {{ city }}
                </button>
              </div>
            </div>
            
            <BaseButton type="submit" variant="primary" size="lg" class="w-full md:w-auto">
              <template #icon-left>
                <svg class="h-4 w-4 sm:h-5 sm:w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
              </template>
              Search Jobs
            </BaseButton>
          </form>
          
          <!-- Popular Searches -->
          <div class="mt-3 sm:mt-4 flex flex-wrap gap-2 text-xs sm:text-sm justify-center">
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
</template>

<script setup lang="ts">
import { ref, computed, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import { iraqCities } from '@/config/iraqCities'

const router = useRouter()

const searchQuery = ref('')
const locationQuery = ref('')

// City suggestions state
const showCitySuggestions = ref(false)
const selectedCityIndex = ref(-1)
const cityRefs: Record<number, HTMLElement> = {}

const filteredCities = computed(() => {
  if (!locationQuery.value) return []
  const searchTerm = locationQuery.value.toLowerCase()
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
      handleSearch()
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
  locationQuery.value = city
  showCitySuggestions.value = false
  selectedCityIndex.value = -1
}

const handleCityBlur = () => {
  setTimeout(() => {
    showCitySuggestions.value = false
  }, 200)
}

const popularSearches = ['Designer', 'Developer', 'Marketing', 'Sales', 'Manager']

const handleSearch = () => {
  const params = new URLSearchParams()
  if (searchQuery.value) params.append('search', searchQuery.value)
  if (locationQuery.value) params.append('location', locationQuery.value)
  
  router.push(`/jobs?${params.toString()}`)
}
</script>
