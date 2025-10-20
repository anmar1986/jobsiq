<template>
  <div :class="spinnerClasses" role="status" :aria-label="label">
    <svg class="animate-spin" :class="sizeClass" fill="none" viewBox="0 0 24 24">
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
      <path
        class="opacity-75"
        fill="currentColor"
        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
      ></path>
    </svg>
    <span v-if="showLabel" class="ml-2 text-sm">{{ label }}</span>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl'
  color?: 'primary' | 'white' | 'gray' | 'current'
  label?: string
  showLabel?: boolean
  center?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  size: 'md',
  color: 'current',
  label: 'Loading...',
  showLabel: false,
  center: false,
})

const sizeClass = computed(() => {
  const sizes = {
    xs: 'h-3 w-3',
    sm: 'h-4 w-4',
    md: 'h-6 w-6',
    lg: 'h-8 w-8',
    xl: 'h-12 w-12',
  }
  return sizes[props.size]
})

const colorClass = computed(() => {
  const colors = {
    primary: 'text-primary-600',
    white: 'text-white',
    gray: 'text-gray-600',
    current: 'text-current',
  }
  return colors[props.color]
})

const spinnerClasses = computed(() => {
  const classes = ['inline-flex items-center', colorClass.value]
  if (props.center) {
    classes.push('justify-center w-full')
  }
  return classes.join(' ')
})
</script>
