<template>
  <div class="bg-gray-50 min-h-screen">
    <!-- Page Header -->
    <div class="bg-white border-b border-gray-200">
      <div class="container-custom py-8">
        <h1 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Discover Top Companies</h1>
        <p class="text-lg text-gray-600">Browse leading companies hiring on JobsIQ</p>
      </div>
    </div>

    <!-- Search Bar -->
    <div class="bg-white border-b border-gray-200">
      <div class="container-custom py-4">
        <div class="flex gap-4">
          <BaseInput
            v-model="searchQuery"
            type="text"
            placeholder="Search companies..."
            size="md"
            show-clear-button
            class="flex-1"
          >
            <template #icon-left>
              <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </template>
          </BaseInput>
          <BaseButton variant="primary" size="md">
            Search
          </BaseButton>
        </div>
      </div>
    </div>

    <!-- Companies Grid -->
    <div class="container-custom py-8">
      <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <BaseCard
          v-for="company in companies"
          :key="company.id"
          hoverable
          clickable
          @click="$router.push(`/companies/${company.slug}`)"
        >
          <div class="p-6">
            <div class="w-20 h-20 bg-gradient-to-br from-primary-100 to-secondary-100 rounded-xl flex items-center justify-center mb-4">
              <span class="text-3xl font-bold text-primary-600">{{ company.name[0] }}</span>
            </div>
            
            <h3 class="text-xl font-semibold text-gray-900 mb-2">{{ company.name }}</h3>
            <p class="text-gray-600 text-sm mb-4 line-clamp-2">{{ company.description }}</p>
            
            <div class="flex items-center gap-4 text-sm text-gray-600 mb-4">
              <span class="flex items-center gap-1">
                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                </svg>
                {{ company.city }}, {{ company.country }}
              </span>
            </div>
            
            <div class="flex items-center justify-between pt-4 border-t border-gray-100">
              <span class="text-sm font-medium text-gray-900">{{ company.jobs_count }} open jobs</span>
              <BaseBadge variant="primary" size="sm">{{ company.industry }}</BaseBadge>
            </div>
          </div>
        </BaseCard>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseBadge from '@/components/base/BaseBadge.vue'

const searchQuery = ref('')

// Mock data - will be replaced with API call
const companies = ref([
  {
    id: 1,
    name: 'TechCorp Inc',
    slug: 'techcorp-inc',
    description: 'Leading technology company specializing in AI and machine learning solutions',
    city: 'San Francisco',
    country: 'USA',
    industry: 'Technology',
    jobs_count: 45,
  },
  {
    id: 2,
    name: 'Design Studio',
    slug: 'design-studio',
    description: 'Award-winning design agency creating exceptional digital experiences',
    city: 'London',
    country: 'UK',
    industry: 'Design',
    jobs_count: 12,
  },
  {
    id: 3,
    name: 'Growth Labs',
    slug: 'growth-labs',
    description: 'Marketing and growth consultancy for startups and enterprises',
    city: 'New York',
    country: 'USA',
    industry: 'Marketing',
    jobs_count: 23,
  },
])
</script>
