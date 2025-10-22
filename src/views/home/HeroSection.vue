<template>
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
              <template #icon-left>
                <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
              </template>
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
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'

const router = useRouter()

const searchQuery = ref('')
const locationQuery = ref('')

const popularSearches = ['Designer', 'Developer', 'Marketing', 'Sales', 'Manager']

const handleSearch = () => {
  const params = new URLSearchParams()
  if (searchQuery.value) params.append('search', searchQuery.value)
  if (locationQuery.value) params.append('location', locationQuery.value)
  
  router.push(`/jobs?${params.toString()}`)
}
</script>
