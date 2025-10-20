<template>
  <Teleport to="body">
    <Transition
      enter-active-class="transition-opacity duration-300"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-active-class="transition-opacity duration-200"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div
        v-if="modelValue"
        class="fixed inset-0 z-50 overflow-y-auto"
        @click.self="handleBackdropClick"
      >
        <!-- Backdrop -->
        <div class="fixed inset-0 bg-black bg-opacity-50 transition-opacity" />
        
        <!-- Modal Container -->
        <div class="flex min-h-full items-center justify-center p-4">
          <Transition
            enter-active-class="transition-all duration-300"
            enter-from-class="opacity-0 scale-95"
            enter-to-class="opacity-100 scale-100"
            leave-active-class="transition-all duration-200"
            leave-from-class="opacity-100 scale-100"
            leave-to-class="opacity-0 scale-95"
          >
            <div
              v-if="modelValue"
              :class="modalClasses"
              role="dialog"
              aria-modal="true"
              :aria-labelledby="titleId"
            >
              <!-- Header -->
              <div v-if="!hideHeader" class="flex items-center justify-between p-6 border-b border-gray-200">
                <h3 :id="titleId" class="text-xl font-semibold text-gray-900">
                  <slot name="title">{{ title }}</slot>
                </h3>
                <button
                  v-if="!hideCloseButton"
                  type="button"
                  class="text-gray-400 hover:text-gray-600 transition-colors"
                  @click="handleClose"
                >
                  <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              </div>
              
              <!-- Body -->
              <div :class="bodyClasses">
                <slot />
              </div>
              
              <!-- Footer -->
              <div v-if="$slots.footer" class="flex items-center justify-end gap-3 px-6 py-4 bg-gray-50 border-t border-gray-200">
                <slot name="footer" />
              </div>
            </div>
          </Transition>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
import { computed, watch } from 'vue'

interface Props {
  modelValue: boolean
  title?: string
  size?: 'sm' | 'md' | 'lg' | 'xl' | 'full'
  hideHeader?: boolean
  hideCloseButton?: boolean
  closeOnBackdrop?: boolean
  noPadding?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  size: 'md',
  hideHeader: false,
  hideCloseButton: false,
  closeOnBackdrop: true,
  noPadding: false,
})

const emit = defineEmits<{
  'update:modelValue': [value: boolean]
  close: []
}>()

const titleId = `modal-title-${Math.random().toString(36).substring(2, 9)}`

const handleClose = () => {
  emit('update:modelValue', false)
  emit('close')
}

const handleBackdropClick = () => {
  if (props.closeOnBackdrop) {
    handleClose()
  }
}

const modalClasses = computed(() => {
  const base = 'relative bg-white rounded-lg shadow-xl max-h-[90vh] overflow-hidden flex flex-col'
  
  const sizeClasses = {
    sm: 'max-w-md w-full',
    md: 'max-w-lg w-full',
    lg: 'max-w-2xl w-full',
    xl: 'max-w-4xl w-full',
    full: 'max-w-7xl w-full mx-4',
  }
  
  return [base, sizeClasses[props.size]].join(' ')
})

const bodyClasses = computed(() => {
  const base = 'overflow-y-auto flex-1'
  const padding = props.noPadding ? '' : 'p-6'
  return [base, padding].filter(Boolean).join(' ')
})

// Lock body scroll when modal is open
watch(() => props.modelValue, (isOpen) => {
  if (isOpen) {
    document.body.style.overflow = 'hidden'
  } else {
    document.body.style.overflow = ''
  }
})
</script>
