<template>
  <div class="mb-5">
    <h3 class="text-base font-semibold text-gray-900 mb-3 flex items-center gap-2">
      <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
      </svg>
      Personal Information
    </h3>
    
    <div class="grid md:grid-cols-2 gap-4">
      <BaseInput
        v-model="localInfo.full_name"
        label="Full Name"
        placeholder="John Doe"
        required
        @update:model-value="updateField('full_name', $event)"
      />
      
      <BaseInput
        v-model="localInfo.title"
        label="Job Title"
        placeholder="e.g., Senior Software Engineer"
        required
        @update:model-value="updateField('title', $event)"
      />
      
      <BaseInput
        v-model="localInfo.email"
        type="email"
        label="Email"
        placeholder="john.doe@example.com"
        required
        @update:model-value="updateField('email', $event)"
      />
      
      <BaseInput
        v-model="localInfo.phone"
        type="tel"
        label="Phone"
        placeholder="+1 (555) 123-4567"
        @update:model-value="updateField('phone', $event)"
      />
      
      <div class="relative">
        <label class="block text-sm font-medium text-gray-700 mb-1">
          City
        </label>
        <input
          v-model="cityInput"
          type="text"
          placeholder="Baghdad"
          class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors appearance-none"
          @input="handleCityInput"
          @focus="showCitySuggestions = true"
          @blur="handleCityBlur"
          @keydown="handleKeyDown"
        />
        
        <!-- Suggestions Dropdown -->
        <div
          v-if="showCitySuggestions && filteredCities.length > 0"
          ref="dropdownRef"
          class="absolute z-10 w-full mt-1 bg-white border border-gray-300 rounded-lg shadow-lg max-h-60 overflow-y-auto"
        >
          <button
            v-for="(city, index) in filteredCities"
            :key="city"
            :ref="el => { if (el) cityRefs[index] = el as HTMLElement }"
            type="button"
            :class="[
              'w-full px-3 py-2 text-left text-gray-900 hover:bg-gray-100 focus:bg-gray-100 focus:outline-none transition-colors',
              { 'bg-primary-100 font-medium': index === selectedIndex }
            ]"
            @mousedown.prevent="selectCity(city)"
            @mouseenter="selectedIndex = index"
          >
            {{ city }}
          </button>
        </div>
      </div>
      
      <div class="relative">
        <label class="block text-sm font-medium text-gray-700 mb-1">
          Country
        </label>
        <div class="px-3 py-2 border border-gray-300 rounded-lg bg-gray-50 text-gray-700">
          Iraq
        </div>
        <input type="hidden" value="Iraq" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, computed, nextTick } from 'vue'
import BaseInput from '@/components/base/BaseInput.vue'
import { iraqCities } from '@/config/iraqCities'

interface PersonalInfo {
  full_name: string
  email: string
  phone: string
  title: string
  city: string
  country: string
  postal_code: string
}

interface Props {
  personalInfo: PersonalInfo
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'update:personal-info': [value: PersonalInfo]
}>()

const localInfo = ref<PersonalInfo>({ ...props.personalInfo, country: 'Iraq' })
const cityInput = ref(props.personalInfo.city || '')
const showCitySuggestions = ref(false)
const selectedIndex = ref(-1)
const dropdownRef = ref<HTMLElement | null>(null)
const cityRefs: Record<number, HTMLElement> = {}

const filteredCities = computed(() => {
  if (!cityInput.value) return iraqCities
  const searchTerm = cityInput.value.toLowerCase()
  return iraqCities.filter(city => 
    city.toLowerCase().includes(searchTerm)
  )
})

watch(() => props.personalInfo, (newInfo) => {
  localInfo.value = { ...newInfo, country: 'Iraq' }
  cityInput.value = newInfo.city || ''
}, { deep: true })

const handleCityInput = (event: Event) => {
  const value = (event.target as HTMLInputElement).value
  cityInput.value = value
  localInfo.value.city = value
  selectedIndex.value = -1
  showCitySuggestions.value = true
  updateField('city', value)
}

const scrollToSelected = () => {
  nextTick(() => {
    if (selectedIndex.value >= 0 && cityRefs[selectedIndex.value]) {
      cityRefs[selectedIndex.value].scrollIntoView({
        block: 'nearest',
        behavior: 'smooth'
      })
    }
  })
}

const handleKeyDown = (event: KeyboardEvent) => {
  if (!showCitySuggestions.value || filteredCities.value.length === 0) return

  switch (event.key) {
    case 'ArrowDown':
      event.preventDefault()
      selectedIndex.value = Math.min(selectedIndex.value + 1, filteredCities.value.length - 1)
      scrollToSelected()
      break
    case 'ArrowUp':
      event.preventDefault()
      selectedIndex.value = Math.max(selectedIndex.value - 1, 0)
      scrollToSelected()
      break
    case 'Enter':
      event.preventDefault()
      if (selectedIndex.value >= 0 && selectedIndex.value < filteredCities.value.length) {
        selectCity(filteredCities.value[selectedIndex.value])
      }
      break
    case 'Escape':
      showCitySuggestions.value = false
      selectedIndex.value = -1
      break
  }
}

const selectCity = (city: string) => {
  cityInput.value = city
  localInfo.value.city = city
  showCitySuggestions.value = false
  selectedIndex.value = -1
  updateField('city', city)
}

const handleCityBlur = () => {
  // Delay hiding to allow click on suggestion
  setTimeout(() => {
    showCitySuggestions.value = false
  }, 200)
}

const updateField = (field: keyof PersonalInfo, value: string | number) => {
  localInfo.value[field] = value as never
  // Always ensure country is Iraq
  localInfo.value.country = 'Iraq'
  emit('update:personal-info', { ...localInfo.value })
}
</script>
