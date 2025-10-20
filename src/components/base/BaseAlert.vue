<template>
  <Transition
    enter-active-class="transition-all duration-300"
    enter-from-class="opacity-0 -translate-y-2"
    enter-to-class="opacity-100 translate-y-0"
    leave-active-class="transition-all duration-200"
    leave-from-class="opacity-100 translate-y-0"
    leave-to-class="opacity-0 -translate-y-2"
  >
    <div v-if="modelValue" :class="alertClasses" role="alert">
      <div class="flex items-start gap-3">
        <!-- Icon -->
        <div class="flex-shrink-0 mt-0.5">
          <component :is="iconComponent" class="h-5 w-5" />
        </div>
        
        <!-- Content -->
        <div class="flex-1 min-w-0">
          <p v-if="title" class="font-semibold mb-1">{{ title }}</p>
          <div class="text-sm">
            <slot />
          </div>
        </div>
        
        <!-- Close Button -->
        <button
          v-if="dismissible"
          type="button"
          :class="closeButtonClasses"
          @click="handleClose"
        >
          <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>
    </div>
  </Transition>
</template>

<script setup lang="ts">
import { computed, h } from 'vue'

interface Props {
  modelValue?: boolean
  variant?: 'success' | 'error' | 'warning' | 'info'
  title?: string
  dismissible?: boolean
  outline?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: true,
  variant: 'info',
  dismissible: false,
  outline: false,
})

const emit = defineEmits<{
  'update:modelValue': [value: boolean]
  close: []
}>()

const handleClose = () => {
  emit('update:modelValue', false)
  emit('close')
}

const iconComponent = computed(() => {
  const icons = {
    success: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24', class: 'h-5 w-5' }, [
      h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z' })
    ]),
    error: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24', class: 'h-5 w-5' }, [
      h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z' })
    ]),
    warning: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24', class: 'h-5 w-5' }, [
      h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z' })
    ]),
    info: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24', class: 'h-5 w-5' }, [
      h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z' })
    ]),
  }
  return icons[props.variant]
})

const alertClasses = computed(() => {
  const base = 'rounded-lg p-4 border'
  
  const variantClasses = props.outline ? {
    success: 'bg-green-50 border-green-200 text-green-800',
    error: 'bg-red-50 border-red-200 text-red-800',
    warning: 'bg-yellow-50 border-yellow-200 text-yellow-800',
    info: 'bg-blue-50 border-blue-200 text-blue-800',
  } : {
    success: 'bg-green-100 border-green-300 text-green-900',
    error: 'bg-red-100 border-red-300 text-red-900',
    warning: 'bg-yellow-100 border-yellow-300 text-yellow-900',
    info: 'bg-blue-100 border-blue-300 text-blue-900',
  }
  
  return [base, variantClasses[props.variant]].join(' ')
})

const closeButtonClasses = computed(() => {
  const variantClasses = {
    success: 'text-green-600 hover:text-green-800',
    error: 'text-red-600 hover:text-red-800',
    warning: 'text-yellow-600 hover:text-yellow-800',
    info: 'text-blue-600 hover:text-blue-800',
  }
  
  return ['flex-shrink-0 transition-colors focus:outline-none', variantClasses[props.variant]].join(' ')
})
</script>
