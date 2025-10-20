<template>
  <div :class="containerClasses">
    <label v-if="label" :for="inputId" class="label">
      {{ label }}
      <span v-if="required" class="text-red-500 ml-1">*</span>
    </label>
    
    <div class="relative">
      <div v-if="$slots['icon-left']" class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
        <slot name="icon-left" />
      </div>
      
      <input
        :id="inputId"
        :type="type"
        :value="modelValue"
        :placeholder="placeholder"
        :disabled="disabled"
        :readonly="readonly"
        :required="required"
        :autocomplete="autocomplete"
        :min="min"
        :max="max"
        :pattern="pattern"
        :maxlength="maxlength"
        :class="inputClasses"
        @input="handleInput"
        @blur="handleBlur"
        @focus="handleFocus"
      />
      
      <div v-if="$slots['icon-right'] || showClearButton" class="absolute inset-y-0 right-0 pr-3 flex items-center">
        <button
          v-if="showClearButton && modelValue"
          type="button"
          class="text-gray-400 hover:text-gray-600 focus:outline-none"
          @click="handleClear"
        >
          <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
        <slot v-else name="icon-right" />
      </div>
    </div>
    
    <p v-if="error" class="mt-1 text-sm text-red-600">{{ error }}</p>
    <p v-else-if="hint" class="mt-1 text-sm text-gray-500">{{ hint }}</p>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, useSlots } from 'vue'

interface Props {
  modelValue: string | number
  type?: string
  label?: string
  placeholder?: string
  error?: string
  hint?: string
  disabled?: boolean
  readonly?: boolean
  required?: boolean
  autocomplete?: string
  size?: 'sm' | 'md' | 'lg'
  showClearButton?: boolean
  min?: string | number
  max?: string | number
  pattern?: string
  maxlength?: number | string
}

const props = withDefaults(defineProps<Props>(), {
  type: 'text',
  size: 'md',
  autocomplete: 'off',
  showClearButton: false,
})

const emit = defineEmits<{
  'update:modelValue': [value: string | number]
  blur: [event: FocusEvent]
  focus: [event: FocusEvent]
}>()

const slots = useSlots()
const isFocused = ref(false)
const inputId = `input-${Math.random().toString(36).substring(2, 9)}`

const handleInput = (event: Event) => {
  const target = event.target as HTMLInputElement
  emit('update:modelValue', target.value)
}

const handleBlur = (event: FocusEvent) => {
  isFocused.value = false
  emit('blur', event)
}

const handleFocus = (event: FocusEvent) => {
  isFocused.value = true
  emit('focus', event)
}

const handleClear = () => {
  emit('update:modelValue', '')
}

const containerClasses = computed(() => {
  return 'w-full'
})

const inputClasses = computed(() => {
  const base = 'block w-full border rounded-lg shadow-sm placeholder-gray-400 transition-colors focus:outline-none focus:ring-2 focus:ring-offset-0'
  
  const sizeClasses = {
    sm: 'px-3 py-1.5 text-sm',
    md: 'px-4 py-2.5 text-sm',
    lg: 'px-4 py-3 text-base',
  }
  
  const stateClasses = props.error
    ? 'border-red-300 text-red-900 focus:ring-red-500 focus:border-red-500'
    : 'border-gray-300 text-gray-900 focus:ring-primary-500 focus:border-primary-500'
  
  const disabledClasses = props.disabled
    ? 'bg-gray-100 cursor-not-allowed'
    : 'bg-white'
  
  const iconPadding = []
  if (slots['icon-left']) iconPadding.push('pl-10')
  if (slots['icon-right'] || props.showClearButton) iconPadding.push('pr-10')
  
  return [base, sizeClasses[props.size], stateClasses, disabledClasses, ...iconPadding].join(' ')
})
</script>
