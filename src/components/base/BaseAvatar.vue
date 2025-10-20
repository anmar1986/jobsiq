<template>
  <div :class="avatarClasses" :title="name">
    <img
      v-if="src"
      :src="src"
      :alt="name"
      class="h-full w-full object-cover"
      @error="handleImageError"
    />
    <span v-else class="font-semibold">{{ initials }}</span>
    <span v-if="showStatus" :class="statusClasses" />
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'

interface Props {
  src?: string
  name: string
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl' | '2xl'
  rounded?: boolean
  status?: 'online' | 'offline' | 'busy' | 'away'
  showStatus?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  size: 'md',
  rounded: true,
  showStatus: false,
})

const imageError = ref(false)

const handleImageError = () => {
  imageError.value = true
}

const initials = computed(() => {
  if (!props.name) return '?'
  
  const names = props.name.trim().split(' ')
  if (names.length === 1) {
    return names[0].charAt(0).toUpperCase()
  }
  return (names[0].charAt(0) + names[names.length - 1].charAt(0)).toUpperCase()
})

const avatarClasses = computed(() => {
  const base = 'relative inline-flex items-center justify-center overflow-hidden bg-gradient-to-br from-primary-400 to-secondary-500 text-white'
  
  const sizeClasses = {
    xs: 'h-6 w-6 text-xs',
    sm: 'h-8 w-8 text-sm',
    md: 'h-10 w-10 text-base',
    lg: 'h-12 w-12 text-lg',
    xl: 'h-16 w-16 text-xl',
    '2xl': 'h-20 w-20 text-2xl',
  }
  
  const roundedClass = props.rounded ? 'rounded-full' : 'rounded-lg'
  
  return [base, sizeClasses[props.size], roundedClass].join(' ')
})

const statusClasses = computed(() => {
  if (!props.showStatus) return ''
  
  const base = 'absolute bottom-0 right-0 block rounded-full ring-2 ring-white'
  
  const sizeClasses = {
    xs: 'h-1.5 w-1.5',
    sm: 'h-2 w-2',
    md: 'h-2.5 w-2.5',
    lg: 'h-3 w-3',
    xl: 'h-3.5 w-3.5',
    '2xl': 'h-4 w-4',
  }
  
  const statusColors = {
    online: 'bg-green-500',
    offline: 'bg-gray-400',
    busy: 'bg-red-500',
    away: 'bg-yellow-500',
  }
  
  return [base, sizeClasses[props.size], statusColors[props.status || 'offline']].join(' ')
})
</script>
