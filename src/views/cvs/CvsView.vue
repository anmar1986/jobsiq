<template>
  <div class="bg-gray-50 min-h-screen">
    <!-- Page Header -->
    <div class="bg-white border-b border-gray-200">
      <div class="container-custom py-8">
        <h1 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Browse Candidate CVs</h1>
        <p class="text-lg text-gray-600">Find qualified candidates for your company</p>
      </div>
    </div>

    <!-- Search Bar -->
    <div class="bg-white border-b border-gray-200">
      <div class="container-custom py-4">
        <div class="flex gap-4">
          <BaseInput
            v-model="searchQuery"
            type="text"
            placeholder="Search by skills, title, or location..."
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

    <!-- CVs Grid -->
    <div class="container-custom py-8">
      <div class="grid md:grid-cols-2 gap-6">
        <BaseCard
          v-for="cv in cvs"
          :key="cv.id"
          hoverable
          clickable
          @click="$router.push(`/cvs/${cv.slug}`)"
        >
          <div class="p-6">
            <div class="flex items-start gap-4 mb-4">
              <BaseAvatar :name="cv.full_name" size="lg" />
              
              <div class="flex-1 min-w-0">
                <h3 class="text-xl font-semibold text-gray-900 mb-1">{{ cv.full_name }}</h3>
                <p class="text-primary-600 font-medium mb-2">{{ cv.title }}</p>
                <p class="text-sm text-gray-600">{{ cv.location }}</p>
              </div>
            </div>
            
            <p class="text-gray-600 text-sm mb-4 line-clamp-3">{{ cv.summary }}</p>
            
            <div class="flex flex-wrap gap-2 mb-4">
              <BaseBadge
                v-for="skill in cv.top_skills.slice(0, 4)"
                :key="skill"
                variant="secondary"
                size="sm"
              >
                {{ skill }}
              </BaseBadge>
            </div>
            
            <div class="flex items-center justify-between pt-4 border-t border-gray-100">
              <span class="text-sm text-gray-600">{{ cv.experience }} experience</span>
              <BaseButton variant="primary" size="sm">
                View Profile
              </BaseButton>
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
import BaseAvatar from '@/components/base/BaseAvatar.vue'

const searchQuery = ref('')

// Mock data - will be replaced with API call
const cvs = ref([
  {
    id: 1,
    slug: 'john-doe-senior-developer',
    full_name: 'John Doe',
    title: 'Senior Frontend Developer',
    location: 'San Francisco, CA',
    summary: 'Experienced frontend developer with 8+ years building scalable web applications using React, Vue, and TypeScript.',
    top_skills: ['React', 'Vue.js', 'TypeScript', 'Node.js', 'GraphQL'],
    experience: '8+ years',
  },
  {
    id: 2,
    slug: 'jane-smith-product-designer',
    full_name: 'Jane Smith',
    title: 'Product Designer',
    location: 'Remote',
    summary: 'Creative product designer specializing in user-centered design and prototyping for SaaS products.',
    top_skills: ['Figma', 'UI/UX', 'Prototyping', 'Design Systems', 'User Research'],
    experience: '5+ years',
  },
])
</script>
