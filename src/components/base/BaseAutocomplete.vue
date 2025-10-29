<template>
  <div class="relative">
    <label 
      v-if="label" 
      :for="inputId" 
      class="block text-sm font-medium text-gray-700 mb-1"
    >
      {{ label }}
      <span v-if="required" class="text-red-500">*</span>
    </label>
    
    <div class="relative">
      <input
        :id="inputId"
        ref="inputRef"
        v-model="searchQuery"
        type="text"
        :placeholder="placeholder"
        :required="required"
        :disabled="disabled"
        class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
        :class="{
          'border-gray-300': !error,
          'border-red-500 focus:ring-red-500 focus:border-red-500': error,
          'bg-gray-50 cursor-not-allowed': disabled,
          'pr-10': showClearButton
        }"
        @input="handleInput"
        @focus="showDropdown = true"
        @blur="handleBlur"
        @keydown.down.prevent="navigateDown"
        @keydown.up.prevent="navigateUp"
        @keydown.enter.prevent="selectHighlighted"
        @keydown.esc="closeDropdown"
      />
      
      <!-- Clear Button -->
      <button
        v-if="showClearButton"
        type="button"
        class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
        @mousedown.prevent="clearInput"
      >
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>
      
      <!-- Dropdown List -->
      <div
        v-if="showDropdown && filteredOptions.length > 0"
        class="absolute z-50 w-full mt-1 bg-white border border-gray-300 rounded-lg shadow-lg max-h-60 overflow-auto"
      >
        <button
          v-for="(option, index) in filteredOptions"
          :key="index"
          type="button"
          class="w-full px-4 py-2 text-left hover:bg-primary-50 transition-colors"
          :class="{
            'bg-primary-100 text-primary-900': index === highlightedIndex,
            'text-gray-900': index !== highlightedIndex
          }"
          @mousedown.prevent="selectOption(option)"
          @mouseenter="highlightedIndex = index"
        >
          {{ option }}
        </button>
      </div>
      
      <!-- No Results -->
      <div
        v-if="showDropdown && searchQuery && filteredOptions.length === 0"
        class="absolute z-50 w-full mt-1 bg-white border border-gray-300 rounded-lg shadow-lg px-4 py-3 text-sm text-gray-500"
      >
        No results found for "{{ searchQuery }}"
      </div>
    </div>
    
    <!-- Error Message -->
    <p v-if="error" class="text-red-600 text-sm mt-1">{{ error }}</p>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'

interface Props {
  modelValue: string
  options: string[]
  label?: string
  placeholder?: string
  required?: boolean
  disabled?: boolean
  error?: string
}

const props = withDefaults(defineProps<Props>(), {
  label: '',
  placeholder: 'Type to search...',
  required: false,
  disabled: false,
  error: ''
})

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

const inputId = `autocomplete-${crypto.randomUUID()}`
const inputRef = ref<HTMLInputElement | null>(null)
const searchQuery = ref(props.modelValue)
const showDropdown = ref(false)
const highlightedIndex = ref(0)

// Watch for external changes to modelValue
watch(() => props.modelValue, (newValue) => {
  searchQuery.value = newValue
})

// Filter options based on search query
const filteredOptions = computed(() => {
  if (!searchQuery.value) {
    return props.options
  }
  
  const query = searchQuery.value.toLowerCase().trim()
  return props.options.filter(option => 
    option.toLowerCase().includes(query)
  )
})

const showClearButton = computed(() => {
  return searchQuery.value && !props.disabled
})

const handleInput = () => {
  showDropdown.value = true
  highlightedIndex.value = 0
  emit('update:modelValue', searchQuery.value)
}

const selectOption = (option: string) => {
  searchQuery.value = option
  emit('update:modelValue', option)
  closeDropdown()
  inputRef.value?.blur()
}

const selectHighlighted = () => {
  if (filteredOptions.value.length > 0 && highlightedIndex.value >= 0) {
    selectOption(filteredOptions.value[highlightedIndex.value])
  }
}

const navigateDown = () => {
  if (highlightedIndex.value < filteredOptions.value.length - 1) {
    highlightedIndex.value++
  }
}

const navigateUp = () => {
  if (highlightedIndex.value > 0) {
    highlightedIndex.value--
  }
}

const clearInput = () => {
  searchQuery.value = ''
  emit('update:modelValue', '')
  showDropdown.value = false
  inputRef.value?.focus()
}

const closeDropdown = () => {
  showDropdown.value = false
  highlightedIndex.value = 0
}

const handleBlur = () => {
  // Delay to allow click events on dropdown items
  setTimeout(() => {
    closeDropdown()
  }, 200)
}
</script>
