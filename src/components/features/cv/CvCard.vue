<template>
  <BaseCard
    hoverable
    clickable
    class="group h-full flex flex-col border-2 border-gray-200 hover:border-primary-500 hover:shadow-lg transition-all duration-300 relative"
    :class="{ 'ring-2 ring-primary-500 border-primary-500': isSelected }"
    @click="$emit('click', cv)"
  >
    <!-- Primary Badge -->
    <div v-if="cv.is_primary" class="absolute top-4 right-4 z-10">
      <BaseBadge variant="primary" size="sm">
        <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
          <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
        </svg>
        Primary
      </BaseBadge>
    </div>

    <div class="p-6 flex flex-col h-full">
      <!-- Profile Image & Name Section -->
      <div class="mb-4 flex-shrink-0">
        <div class="flex items-start gap-4 mb-3">
          <!-- Profile Image -->
          <div class="w-20 h-24 bg-gray-100 rounded-lg overflow-hidden flex-shrink-0 flex items-center justify-center ring-2 ring-gray-200 group-hover:ring-primary-300 transition-all duration-300">
            <img
              v-if="profileImageUrl"
              :src="profileImageUrl"
              :alt="cv.full_name"
              class="w-full h-full object-cover"
            />
            <svg v-else class="w-10 h-10 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
            </svg>
          </div>
          
          <!-- Name and Title -->
          <div class="flex-1 min-w-0">
            <h3 class="text-xl font-bold text-gray-900 mb-1 truncate group-hover:text-primary-600 transition-colors">
              {{ cv.full_name }}
            </h3>
            <p class="text-primary-600 font-medium mb-2 truncate">
              {{ cv.title || 'No title' }}
            </p>
            <p class="text-sm text-gray-600 truncate">{{ cv.email }}</p>
          </div>
        </div>
        
        <div class="flex items-center gap-4 text-xs text-gray-500">
          <span class="flex items-center gap-1">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            {{ formatDate(cv.updated_at) }}
          </span>
          <span v-if="cv.is_public" class="flex items-center gap-1 text-green-600">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
            </svg>
            Public
          </span>
          <span v-else class="flex items-center gap-1 text-gray-500">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
            </svg>
            Private
          </span>
        </div>
      </div>

      <!-- Skills Preview -->
      <div class="flex-shrink-0 mb-4 h-14 overflow-hidden">
        <div v-if="displaySkills.length > 0" class="flex flex-wrap gap-2">
          <span
            v-for="(skill, index) in displaySkills.slice(0, 3)"
            :key="index"
            class="px-2 py-1 bg-gray-100 text-gray-700 rounded text-xs font-medium group-hover:bg-primary-50 group-hover:text-primary-700 transition-colors"
          >
            {{ skill }}
          </span>
          <span v-if="displaySkills.length > 3" class="px-2 py-1 text-gray-500 text-xs">
            +{{ displaySkills.length - 3 }} more
          </span>
        </div>
      </div>

      <!-- Actions -->
      <div class="flex gap-2 pt-4 border-t border-gray-200 flex-shrink-0">
        <BaseButton 
          variant="outline" 
          size="sm" 
          @click.stop="$emit('view', cv)" 
          class="flex-1"
        >
          <template #icon-left>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
            </svg>
          </template>
          View
        </BaseButton>
        <BaseButton 
          variant="primary" 
          size="sm" 
          @click.stop="$emit('edit', cv)" 
          class="flex-1"
        >
          <template #icon-left>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
            </svg>
          </template>
          Edit
        </BaseButton>
        <button
          @click.stop="$emit('menu', cv)"
          class="px-3 py-2 text-gray-600 hover:text-primary-600 hover:bg-primary-50 rounded-lg transition-all duration-200"
        >
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z" />
          </svg>
        </button>
      </div>
    </div>
  </BaseCard>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseBadge from '@/components/base/BaseBadge.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import type { UserCv } from '@/types'

interface Props {
  cv: UserCv
  isSelected?: boolean
}

const props = defineProps<Props>()

defineEmits<{
  'click': [cv: UserCv]
  'view': [cv: UserCv]
  'edit': [cv: UserCv]
  'menu': [cv: UserCv]
}>()

const profileImageUrl = computed(() => {
  const profileImage = props.cv.profileImage || props.cv.profile_image
  if (profileImage?.path) {
    return `/storage/${profileImage.path}`
  }
  return null
})

const displaySkills = computed(() => {
  if (!props.cv.skills || props.cv.skills.length === 0) return []
  return props.cv.skills.map(skill => 
    typeof skill === 'string' ? skill : skill.name
  )
})

const formatDate = (date: string): string => {
  const now = new Date()
  const past = new Date(date)
  const diffTime = Math.abs(now.getTime() - past.getTime())
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
  
  if (diffDays === 0) return 'today'
  if (diffDays === 1) return 'yesterday'
  if (diffDays < 7) return `${diffDays} days ago`
  if (diffDays < 30) return `${Math.floor(diffDays / 7)} weeks ago`
  if (diffDays < 365) return `${Math.floor(diffDays / 30)} months ago`
  return `${Math.floor(diffDays / 365)} years ago`
}
</script>
