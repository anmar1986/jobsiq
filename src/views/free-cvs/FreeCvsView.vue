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
            @keyup.enter="handleSearch"
          >
            <template #icon-left>
              <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </template>
          </BaseInput>
          <BaseButton variant="primary" size="md" @click="handleSearch" :disabled="loading">
            {{ loading ? 'Searching...' : 'Search' }}
          </BaseButton>
        </div>
      </div>
    </div>

    <!-- CVs Grid -->
    <div class="container-custom py-8">
      <!-- Loading State -->
      <div v-if="loading" class="text-center py-12">
        <p class="text-gray-600">Loading CVs...</p>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="text-center py-12">
        <p class="text-red-600">{{ error }}</p>
        <BaseButton variant="primary" size="md" class="mt-4" @click="fetchCvs">
          Try Again
        </BaseButton>
      </div>

      <!-- Empty State -->
      <div v-else-if="cvs.length === 0" class="text-center py-12">
        <p class="text-gray-600 text-lg mb-2">No public CVs found</p>
        <p class="text-gray-500 text-sm">Be the first to create a public CV!</p>
      </div>

      <!-- CVs Grid -->
      <div v-else class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
        <BaseCard
          v-for="cv in cvs"
          :key="cv.id"
          hoverable
          clickable
          @click="$router.push(`/cvs/${cv.slug}`)"
        >
          <div class="p-6">
            <div class="flex items-start gap-4 mb-4">
              <!-- Profile Image -->
              <div class="w-20 h-24 bg-gray-100 rounded-lg overflow-hidden flex-shrink-0 flex items-center justify-center ring-2 ring-gray-200">
                <img
                  v-if="cv.profile_image_url"
                  :src="cv.profile_image_url"
                  :alt="cv.full_name"
                  class="w-full h-full object-cover"
                />
                <BaseAvatar v-else :name="cv.full_name" size="lg" />
              </div>
              
              <div class="flex-1 min-w-0">
                <h3 class="text-xl font-semibold text-gray-900 mb-1">{{ cv.full_name }}</h3>
                <p class="text-primary-600 font-medium mb-2">{{ cv.title }}</p>
                <p class="text-sm text-gray-600">{{ cv.location }}</p>
              </div>
            </div>
            
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
import { ref, onMounted } from 'vue'
import api from '@/services/api'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseBadge from '@/components/base/BaseBadge.vue'
import BaseAvatar from '@/components/base/BaseAvatar.vue'

interface CvListItem {
  id: number
  slug: string
  full_name: string
  title: string
  location: string
  top_skills: string[]
  experience: string
  profile_image_url: string | null
}

const searchQuery = ref('')
const cvs = ref<CvListItem[]>([])
const loading = ref(false)
const error = ref('')

// Fetch public CVs from API
const fetchCvs = async () => {
  loading.value = true
  error.value = ''
  
  try {
    const params: Record<string, string> = {}
    
    if (searchQuery.value) {
      params.search = searchQuery.value
    }
    
    const response = await api.get('/cvs', { params })
    
    if (response.data.success) {
      cvs.value = response.data.data.data.map((cv: {
        id: number
        slug: string
        full_name: string
        title: string | null
        city: string | null
        country: string | null
        skills: unknown
        work_experiences: Array<{ start_date: string; end_date?: string; current?: boolean }>
        profile_image?: { path: string; url: string } | null
        profileImage?: { path: string; url: string } | null
      }) => ({
        id: cv.id,
        slug: cv.slug,
        full_name: cv.full_name,
        title: cv.title,
        location: [cv.city, cv.country].filter(Boolean).join(', ') || 'Not specified',
        top_skills: Array.isArray(cv.skills) ? cv.skills : [],
        experience: calculateExperience(cv.work_experiences || []),
        profile_image_url: (cv.profileImage?.path || cv.profile_image?.path) ? 
          `/storage/${cv.profileImage?.path || cv.profile_image?.path}` : null,
      }))
    }
  } catch (err: unknown) {
    const errorObj = err as { response?: { data?: { message?: string } } }
    error.value = errorObj.response?.data?.message || 'Failed to load CVs'
    console.error('Error fetching CVs:', err)
  } finally {
    loading.value = false
  }
}

// Calculate total years of experience
const calculateExperience = (workExperiences: Array<{ start_date: string; end_date?: string; current?: boolean }>) => {
  if (!workExperiences.length) return 'No experience listed'
  
  let totalMonths = 0
  workExperiences.forEach((exp) => {
    if (exp.start_date) {
      const start = new Date(exp.start_date)
      const end = exp.current ? new Date() : new Date(exp.end_date || new Date())
      const months = (end.getFullYear() - start.getFullYear()) * 12 + (end.getMonth() - start.getMonth())
      totalMonths += months
    }
  })
  
  const years = Math.floor(totalMonths / 12)
  return years > 0 ? `${years}+ year${years > 1 ? 's' : ''}` : 'Less than 1 year'
}

// Search handler
const handleSearch = () => {
  fetchCvs()
}

onMounted(() => {
  fetchCvs()
})
</script>
