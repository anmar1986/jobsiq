<template>
  <div class="bg-gray-50 min-h-screen">
    <!-- Loading State -->
    <div v-if="loading" class="container-custom py-8">
      <div class="animate-pulse space-y-8">
        <div class="h-48 bg-gray-200 rounded-lg"></div>
        <div class="bg-white rounded-lg p-8 space-y-4">
          <div class="h-6 bg-gray-200 rounded w-1/2"></div>
          <div class="h-4 bg-gray-200 rounded w-full"></div>
          <div class="h-4 bg-gray-200 rounded w-3/4"></div>
        </div>
      </div>
    </div>

    <!-- CV Not Found -->
    <div v-else-if="!cv" class="container-custom py-16">
      <BaseCard class="p-12 text-center">
        <svg class="h-16 w-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
        </svg>
        <h2 class="text-2xl font-bold text-gray-900 mb-2">CV Not Found</h2>
        <p class="text-gray-600 mb-6">The CV you're looking for doesn't exist or is not public.</p>
        <BaseButton variant="primary" @click="router.push('/cvs')">Browse All CVs</BaseButton>
      </BaseCard>
    </div>

    <!-- CV Detail Content -->
    <div v-else>
      <!-- Header Section -->
      <div class="bg-gradient-to-br from-primary-600 to-secondary-600 text-white">
        <div class="container-custom py-8">
          <button @click="router.back()" class="flex items-center gap-2 text-white/80 hover:text-white mb-6 transition-colors">
            <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
            Back to CVs
          </button>

          <div class="flex items-start gap-8">
            <!-- Avatar -->
            <BaseAvatar
              :name="cv.full_name"
              size="2xl"
              class="border-4 border-white/20 flex-shrink-0"
            />

            <div class="flex-1">
              <h1 class="text-4xl md:text-5xl font-bold mb-2">{{ cv.full_name }}</h1>
              <p v-if="cv.title" class="text-2xl text-white/90 mb-4">{{ cv.title }}</p>
              
              <div class="flex flex-wrap gap-4 text-white/90 mb-4">
                <span class="flex items-center gap-1.5">
                  <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                  </svg>
                  {{ cv.email }}
                </span>
                <span v-if="cv.phone" class="flex items-center gap-1.5">
                  <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                  </svg>
                  {{ cv.phone }}
                </span>
              </div>

              <!-- Social Links -->
              <div class="flex flex-wrap gap-3">
                <a v-if="cv.linkedin" :href="cv.linkedin" target="_blank" class="px-4 py-2 bg-white/10 hover:bg-white/20 rounded-lg transition-colors flex items-center gap-2">
                  <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z" />
                  </svg>
                  LinkedIn
                </a>
                <a v-if="cv.github" :href="cv.github" target="_blank" class="px-4 py-2 bg-white/10 hover:bg-white/20 rounded-lg transition-colors flex items-center gap-2">
                  <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.840 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z" />
                  </svg>
                  GitHub
                </a>
                <a v-if="cv.website" :href="cv.website" target="_blank" class="px-4 py-2 bg-white/10 hover:bg-white/20 rounded-lg transition-colors flex items-center gap-2">
                  <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9" />
                  </svg>
                  Website
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Main Content -->
      <div class="container-custom py-8">
        <div class="flex flex-col lg:flex-row gap-6">
          <!-- Left Content -->
          <div class="flex-1">
            <!-- Summary -->
            <BaseCard v-if="cv.summary" class="p-6 mb-6">
              <h2 class="text-2xl font-bold text-gray-900 mb-4">Professional Summary</h2>
              <p class="text-gray-700 leading-relaxed">{{ cv.summary }}</p>
            </BaseCard>

            <!-- Experience -->
            <BaseCard v-if="cv.work_experiences && cv.work_experiences.length > 0" class="p-6 mb-6">
              <h2 class="text-2xl font-bold text-gray-900 mb-6">Work Experience</h2>
              <div class="space-y-6">
                <div v-for="(exp, index) in cv.work_experiences" :key="index" class="relative pl-8 pb-6 border-l-2 border-gray-200 last:pb-0">
                  <div class="absolute -left-2 top-0 w-4 h-4 rounded-full bg-primary-600 border-2 border-white"></div>
                  <div class="mb-2">
                    <h3 class="text-lg font-semibold text-gray-900">{{ exp.position }}</h3>
                    <p class="text-primary-600 font-medium">{{ exp.company }}</p>
                    <div class="flex flex-wrap gap-3 mt-1 text-sm text-gray-600">
                      <span v-if="exp.location">{{ exp.location }}</span>
                      <span>{{ exp.formatted_start_date }} - {{ exp.current ? 'Present' : (exp.formatted_end_date || 'Present') }}</span>
                    </div>
                  </div>
                  <p v-if="exp.description" class="text-gray-700 leading-relaxed">{{ exp.description }}</p>
                  <ul v-if="exp.achievements && exp.achievements.length > 0" class="mt-2 list-disc list-inside space-y-1 text-gray-700">
                    <li v-for="(achievement, i) in exp.achievements" :key="i">{{ achievement }}</li>
                  </ul>
                </div>
              </div>
            </BaseCard>

            <!-- Education -->
            <BaseCard v-if="cv.education_entries && cv.education_entries.length > 0" class="p-6 mb-6">
              <h2 class="text-2xl font-bold text-gray-900 mb-6">Education</h2>
              <div class="space-y-6">
                <div v-for="(edu, index) in cv.education_entries" :key="index" class="relative pl-8 pb-6 border-l-2 border-gray-200 last:pb-0">
                  <div class="absolute -left-2 top-0 w-4 h-4 rounded-full bg-secondary-600 border-2 border-white"></div>
                  <div class="mb-2">
                    <h3 class="text-lg font-semibold text-gray-900">{{ edu.degree }} in {{ edu.field }}</h3>
                    <p class="text-secondary-600 font-medium">{{ edu.institution }}</p>
                    <div class="flex flex-wrap gap-3 mt-1 text-sm text-gray-600">
                      <span v-if="edu.location">{{ edu.location }}</span>
                      <span>{{ edu.formatted_start_date }} - {{ edu.formatted_end_date || 'Present' }}</span>
                      <span v-if="edu.gpa" class="font-medium">GPA: {{ edu.gpa }}</span>
                    </div>
                  </div>
                  <p v-if="edu.description" class="text-gray-700 leading-relaxed">{{ edu.description }}</p>
                </div>
              </div>
            </BaseCard>

            <!-- Certifications -->
            <BaseCard v-if="cv.certifications && cv.certifications.length > 0" class="p-6">
              <h2 class="text-2xl font-bold text-gray-900 mb-4">Certifications</h2>
              <ul class="space-y-3">
                <li v-for="(cert, index) in cv.certifications" :key="index" class="flex items-start gap-3">
                  <svg class="h-5 w-5 text-primary-600 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  <div class="flex-1">
                    <p class="font-medium text-gray-900">{{ cert.name }}</p>
                    <p class="text-sm text-gray-600">{{ cert.issuer }}</p>
                    <p v-if="cert.formatted_date" class="text-xs text-gray-500 mt-1">{{ cert.formatted_date }}</p>
                  </div>
                </li>
              </ul>
            </BaseCard>
          </div>

          <!-- Right Sidebar -->
          <aside class="lg:w-80 flex-shrink-0">
            <!-- Skills -->
            <BaseCard v-if="cv.skills && cv.skills.length > 0" class="p-6 mb-6">
              <h3 class="font-semibold text-gray-900 mb-4">Skills</h3>
              <div class="flex flex-wrap gap-2">
                <BaseBadge v-for="(skill, index) in cv.skills" :key="index" variant="primary">
                  {{ typeof skill === 'string' ? skill : skill.name }}
                </BaseBadge>
              </div>
            </BaseCard>

            <!-- Languages -->
            <BaseCard v-if="cv.languages && cv.languages.length > 0" class="p-6 mb-6">
              <h3 class="font-semibold text-gray-900 mb-4">Languages</h3>
              <div class="space-y-3">
                <div v-for="(lang, index) in cv.languages" :key="index">
                  <div class="flex items-center justify-between mb-1">
                    <span class="text-sm font-medium text-gray-900">{{ lang.language }}</span>
                    <span class="text-xs text-gray-600 capitalize">{{ lang.proficiency }}</span>
                  </div>
                  <div class="w-full bg-gray-200 rounded-full h-2">
                    <div 
                      :class="[
                        'h-2 rounded-full transition-all',
                        getProficiencyColor(lang.proficiency)
                      ]"
                      :style="{ width: getProficiencyWidth(lang.proficiency) }"
                    ></div>
                  </div>
                </div>
              </div>
            </BaseCard>

            <!-- Contact CTA -->
            <BaseCard class="p-6 bg-gradient-to-br from-primary-50 to-secondary-50 border-primary-200">
              <h3 class="font-semibold text-gray-900 mb-3">Interested in this candidate?</h3>
              <p class="text-sm text-gray-600 mb-4">
                Contact {{ cv.full_name.split(' ')[0] }} directly to discuss opportunities.
              </p>
              <BaseButton 
                variant="primary" 
                size="md" 
                class="w-full"
                @click="contactCandidate"
              >
                <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                </svg>
                Send Message
              </BaseButton>
            </BaseCard>
          </aside>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useCvStore } from '@/stores/cv'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseBadge from '@/components/base/BaseBadge.vue'
import BaseAvatar from '@/components/base/BaseAvatar.vue'
import type { UserCv } from '@/types'

const router = useRouter()
const route = useRoute()
const cvStore = useCvStore()

const loading = ref(true)
const cv = ref<UserCv | null>(null)

const formatDateRange = (startDate: string, endDate?: string | null, current?: boolean): string => {
  if (!startDate) return 'Present'
  
  try {
    // Handle YYYY-MM-DD format from database
    const start = new Date(startDate)
    const startStr = start.toLocaleDateString('en-GB', { day: '2-digit', month: '2-digit', year: 'numeric' })
    
    if (current) {
      return `${startStr} - Present`
    }
    
    if (endDate) {
      const end = new Date(endDate)
      const endStr = end.toLocaleDateString('en-GB', { day: '2-digit', month: '2-digit', year: 'numeric' })
      return `${startStr} - ${endStr}`
    }
    
    return startStr
  } catch (error) {
    console.error('Error formatting date:', error, startDate, endDate)
    return startDate
  }
}

const formatCertDate = (dateStr: string): string => {
  if (!dateStr) return ''
  
  try {
    // Handle YYYY-MM-DD format from database
    const date = new Date(dateStr)
    return date.toLocaleDateString('en-GB', { day: '2-digit', month: '2-digit', year: 'numeric' })
  } catch (error) {
    console.error('Error formatting cert date:', error, dateStr)
    return dateStr
  }
}

const getProficiencyWidth = (proficiency: string): string => {
  const widths: Record<string, string> = {
    'basic': '25%',
    'conversational': '50%',
    'fluent': '75%',
    'native': '100%',
  }
  return widths[proficiency] || '50%'
}

const getProficiencyColor = (proficiency: string): string => {
  const colors: Record<string, string> = {
    'basic': 'bg-yellow-400',
    'conversational': 'bg-blue-400',
    'fluent': 'bg-green-400',
    'native': 'bg-primary-600',
  }
  return colors[proficiency] || 'bg-blue-400'
}

const contactCandidate = () => {
  if (!cv.value) return
  
  const subject = encodeURIComponent(`Opportunity: ${cv.value.title || 'Your Profile'}`)
  const body = encodeURIComponent(`Hi ${cv.value.full_name},\n\nI came across your profile on JobsIQ and would like to discuss a potential opportunity.\n\n`)
  window.location.href = `mailto:${cv.value.email}?subject=${subject}&body=${body}`
}

const fetchCvDetail = async () => {
  loading.value = true
  try {
    // Check if we have a slug or id parameter
    const slug = route.params.slug as string
    const id = route.params.id as string
    
    if (id) {
      // Fetching by ID (from my-cvs view)
      console.log('Fetching CV with ID:', id)
      await cvStore.fetchCvById(Number(id))
    } else if (slug) {
      // Fetching by slug (from public cvs view)
      console.log('Fetching CV with slug:', slug)
      await cvStore.fetchCv(slug)
    }
    
    console.log('CV Store currentCv:', cvStore.currentCv)
    cv.value = cvStore.currentCv
    console.log('CV value set:', cv.value)
  } catch (error) {
    console.error('Failed to fetch CV:', error)
    cv.value = null
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchCvDetail()
})
</script>

<style scoped>
.prose p {
  margin-bottom: 1rem;
}
</style>
