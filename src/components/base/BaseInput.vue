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
        :min="type === 'date' ? (min || MIN_DATE) : min"
        :max="type === 'date' ? (max || MAX_DATE) : max"
        :pattern="pattern"
        :maxlength="maxlength"
        :class="inputClasses"
        @input="handleInput"
        @blur="handleBlur"
        @focus="handleFocus"
        @invalid="handleInvalid"
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
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

// Date validation constants
const MIN_YEAR = 1900
const MAX_YEAR = 2100
const MIN_DATE = `${MIN_YEAR}-01-01`
const MAX_DATE = `${MAX_YEAR}-12-31`

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
  let value = target.value
  
  // Clear custom validity message when user starts typing
  target.setCustomValidity('')
  
  // Validate date inputs to prevent invalid years (more than 4 digits)
  if (props.type === 'date' && value) {
    // Date format is YYYY-MM-DD
    const parts = value.split('-')
    if (parts.length === 3) {
      const year = parts[0]
      // If year has more than 4 digits, truncate it to 4 digits
      if (year.length > 4) {
        parts[0] = year.substring(0, 4)
        value = parts.join('-')
        target.value = value
      }
      // Validate year is between MIN_YEAR and MAX_YEAR
      const yearNum = parseInt(parts[0])
      if (yearNum < MIN_YEAR || yearNum > MAX_YEAR) {
        // Don't emit invalid dates
        return
      }
    }
  }
  
  emit('update:modelValue', value)
}

const handleBlur = (event: FocusEvent) => {
  isFocused.value = false
  
  // Additional validation on blur for date inputs
  if (props.type === 'date') {
    const target = event.target as HTMLInputElement
    const value = target.value
    
    if (value) {
      const parts = value.split('-')
      if (parts.length === 3) {
        const year = parts[0]
        // Ensure year is exactly 4 digits
        if (year.length !== 4) {
          target.value = ''
          emit('update:modelValue', '')
          emit('blur', event)
          return
        }
        // Validate year range
        const yearNum = parseInt(year)
        if (yearNum < MIN_YEAR || yearNum > MAX_YEAR) {
          target.value = ''
          emit('update:modelValue', '')
          emit('blur', event)
          return
        }
      }
    }
  }
  
  emit('blur', event)
}

const handleFocus = (event: FocusEvent) => {
  isFocused.value = true
  emit('focus', event)
}

const handleClear = () => {
  emit('update:modelValue', '')
}

const handleInvalid = (event: Event) => {
  const target = event.target as HTMLInputElement
  if (target.validity.valueMissing) {
    target.setCustomValidity(t('validation.fieldRequired'))
  }
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
