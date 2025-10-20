<template>
  <span :class="badgeClasses">
    <slot name="icon-left" />
    <slot />
    <slot name="icon-right" />
  </span>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  variant?: 'primary' | 'secondary' | 'success' | 'warning' | 'danger' | 'info'
  size?: 'sm' | 'md' | 'lg'
  rounded?: boolean
  outline?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'secondary',
  size: 'md',
  rounded: false,
  outline: false,
})

const badgeClasses = computed(() => {
  const base = 'inline-flex items-center gap-1 font-medium transition-colors'
  
  const sizeClasses = {
    sm: 'px-2 py-0.5 text-xs',
    md: 'px-2.5 py-1 text-xs',
    lg: 'px-3 py-1.5 text-sm',
  }
  
  const variantClasses = props.outline ? {
    primary: 'border border-primary-300 text-primary-700 bg-primary-50',
    secondary: 'border border-gray-300 text-gray-700 bg-gray-50',
    success: 'border border-green-300 text-green-700 bg-green-50',
    warning: 'border border-yellow-300 text-yellow-700 bg-yellow-50',
    danger: 'border border-red-300 text-red-700 bg-red-50',
    info: 'border border-blue-300 text-blue-700 bg-blue-50',
  } : {
    primary: 'bg-primary-100 text-primary-800',
    secondary: 'bg-gray-100 text-gray-800',
    success: 'bg-green-100 text-green-800',
    warning: 'bg-yellow-100 text-yellow-800',
    danger: 'bg-red-100 text-red-800',
    info: 'bg-blue-100 text-blue-800',
  }
  
  const roundedClass = props.rounded ? 'rounded-full' : 'rounded-md'
  
  return [base, sizeClasses[props.size], variantClasses[props.variant], roundedClass].join(' ')
})
</script>
