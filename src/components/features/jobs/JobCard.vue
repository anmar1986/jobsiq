<template>
  <div v-for="job in jobs" :key="job.id" class="group">
    <BaseCard hoverable clickable @click="$emit('job-click', job)">
      <div class="p-6">
        <!-- Company Logo & Job Title -->
        <div class="flex items-start gap-4 mb-4">
          <div class="w-14 h-14 flex-shrink-0 rounded-lg overflow-hidden bg-white border border-gray-200">
            <img 
              v-if="job.company.logo?.url" 
              :src="job.company.logo.url" 
              :alt="job.company.name"
              class="w-full h-full object-contain p-1"
            />
            <div v-else class="w-full h-full bg-gradient-to-br from-primary-100 to-secondary-100 flex items-center justify-center">
              <span class="text-2xl font-bold text-primary-600">{{ job.company.name[0] }}</span>
            </div>
          </div>
          
          <div class="flex-1 min-w-0">
            <h3 class="text-lg font-semibold text-gray-900 mb-1 group-hover:text-primary-600 transition-colors">
              {{ job.title }}
            </h3>
            <p class="text-gray-600 font-medium">{{ job.company.name }}</p>
          </div>
          
          <BaseBadge
            :variant="job.is_remote ? 'info' : 'secondary'"
            size="sm"
          >
            {{ job.is_remote ? 'Remote' : 'On-site' }}
          </BaseBadge>
        </div>

        <!-- Job Details -->
        <div class="flex flex-wrap gap-4 text-sm text-gray-600 mb-4">
          <span class="flex items-center gap-1.5">
            <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
            </svg>
            {{ job.location }}
          </span>
          
          <span class="flex items-center gap-1.5">
            <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
            </svg>
            {{ formatEmploymentType(job.employment_type) }}
          </span>
          
          <span class="flex items-center gap-1.5">
            <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
            </svg>
            {{ formatExperienceLevel(job.experience_level) }}
          </span>
          
          <span class="flex items-center gap-1.5">
            <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            {{ formatDate(job.created_at) }}
          </span>
        </div>

        <!-- Job Description Preview -->
        <p class="text-gray-600 text-sm mb-4 line-clamp-2">
          {{ stripHtml(job.description) }}
        </p>

        <!-- Footer: Salary & Apply Button -->
        <div class="flex items-center justify-between pt-4 border-t border-gray-100">
          <div>
            <span v-if="job.salary_min && job.salary_max" class="text-lg font-bold text-gray-900">
              ${{ formatNumber(job.salary_min) }} - ${{ formatNumber(job.salary_max) }}
            </span>
            <span v-else class="text-sm text-gray-500">Salary not disclosed</span>
          </div>
          
          <div class="flex items-center gap-2">
            <BaseBadge :variant="getBadgeVariant(job.experience_level)">
              {{ formatExperienceLevel(job.experience_level) }}
            </BaseBadge>
            <button
              @click.stop="$emit('save-job', job)"
              class="p-2 text-gray-400 hover:text-primary-600 transition-colors"
            >
              <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 5a2 2 0 012-2h10a2 2 0 012 2v16l-7-3.5L5 21V5z" />
              </svg>
            </button>
          </div>
        </div>
      </div>
    </BaseCard>
  </div>
</template>

<script setup lang="ts">
import BaseCard from '@/components/base/BaseCard.vue'
import BaseBadge from '@/components/base/BaseBadge.vue'
import type { Job } from '@/types'

interface Props {
  jobs: Job[]
}

defineProps<Props>()

defineEmits<{
  'job-click': [job: Job]
  'save-job': [job: Job]
}>()

const formatEmploymentType = (type: string) => {
  const types: Record<string, string> = {
    'full-time': 'Full-time',
    'part-time': 'Part-time',
    'contract': 'Contract',
    'freelance': 'Freelance',
    'internship': 'Internship',
  }
  return types[type] || type
}

const formatExperienceLevel = (level: string) => {
  const levels: Record<string, string> = {
    'entry': 'Entry Level',
    'mid': 'Mid Level',
    'senior': 'Senior',
    'lead': 'Lead',
    'executive': 'Executive',
  }
  return levels[level] || level
}

const formatDate = (date: string) => {
  const now = new Date()
  const posted = new Date(date)
  const diffTime = Math.abs(now.getTime() - posted.getTime())
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
  
  if (diffDays === 0) return 'Today'
  if (diffDays === 1) return 'Yesterday'
  if (diffDays < 7) return `${diffDays} days ago`
  if (diffDays < 30) return `${Math.floor(diffDays / 7)} weeks ago`
  return `${Math.floor(diffDays / 30)} months ago`
}

const formatNumber = (num: number) => {
  return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')
}

const stripHtml = (html: string) => {
  const tmp = document.createElement('DIV')
  tmp.innerHTML = html
  return tmp.textContent || tmp.innerText || ''
}

const getBadgeVariant = (level: string): 'primary' | 'success' | 'warning' => {
  if (level === 'entry') return 'success'
  if (level === 'senior' || level === 'lead' || level === 'executive') return 'warning'
  return 'primary'
}
</script>
