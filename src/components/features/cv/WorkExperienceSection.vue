<template>
  <div class="mb-8">
    <div class="flex items-center justify-between mb-4">
      <h3 class="text-lg font-semibold text-gray-900 flex items-center gap-2">
        <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
        </svg>
        Work Experience
      </h3>
      <BaseButton
        type="button"
        variant="outline"
        size="sm"
        @click="addExperience"
      >
        <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
        </svg>
        Add Experience
      </BaseButton>
    </div>
    
    <!-- Experience List -->
    <div v-if="localExperiences.length > 0" class="space-y-4">
      <BaseCard
        v-for="(exp, index) in localExperiences"
        :key="index"
        class="p-6 border-l-4 border-primary-500"
      >
        <div class="flex justify-between items-start mb-4">
          <h4 class="font-semibold text-gray-900">Experience #{{ index + 1 }}</h4>
          <button
            type="button"
            @click="removeExperience(index)"
            class="text-red-600 hover:text-red-700 p-1"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
          </button>
        </div>
        
        <div class="grid md:grid-cols-2 gap-4">
          <BaseInput
            v-model="exp.position"
            label="Position"
            placeholder="e.g., Senior Software Engineer"
            required
            @update:model-value="updateExperience(index)"
          />
          
          <BaseInput
            v-model="exp.company"
            label="Company"
            placeholder="e.g., Tech Corp"
            required
            @update:model-value="updateExperience(index)"
          />
          
          <BaseInput
            :model-value="exp.street_address || ''"
            label="Street Address"
            placeholder="e.g., 123 Main Street"
            @update:model-value="exp.street_address = $event as string; updateLocationField(exp); updateExperience(index)"
          />
          
          <BaseInput
            :model-value="exp.city || ''"
            label="City"
            placeholder="e.g., New York"
            @update:model-value="exp.city = $event as string; updateLocationField(exp); updateExperience(index)"
          />
          
          <BaseInput
            :model-value="exp.country || ''"
            label="Country"
            placeholder="e.g., United States"
            @update:model-value="exp.country = $event as string; updateLocationField(exp); updateExperience(index)"
          />
          
          <BaseInput
            v-model="exp.start_date"
            type="date"
            label="Start Date"
            required
            @update:model-value="updateExperience(index)"
          />
          
          <BaseInput
            :model-value="exp.end_date || ''"
            type="date"
            label="End Date"
            :disabled="exp.current"
            @update:model-value="exp.end_date = $event as string; updateExperience(index)"
          />
          
          <div class="flex items-center pt-6">
            <label class="flex items-center gap-2 cursor-pointer">
              <input
                v-model="exp.current"
                type="checkbox"
                class="w-4 h-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
                @change="handleCurrentChange(index)"
              />
              <span class="text-sm font-medium text-gray-700">Currently working here</span>
            </label>
          </div>
          
          <div class="md:col-span-2">
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Description
            </label>
            <textarea
              v-model="exp.description"
              rows="3"
              placeholder="Describe your responsibilities and achievements..."
              class="block w-full px-4 py-2.5 text-sm border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
              @input="updateExperience(index)"
            />
          </div>
        </div>
      </BaseCard>
    </div>
    
    <p v-else class="text-sm text-gray-500 italic p-4 bg-gray-50 rounded-lg border border-gray-200">
      No work experience added yet. Click "Add Experience" to get started.
    </p>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseInput from '@/components/base/BaseInput.vue'
import type { WorkExperience } from '@/types'

interface Props {
  workExperience: WorkExperience[]
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'update:work-experience': [value: WorkExperience[]]
}>()

const localExperiences = ref<WorkExperience[]>([...props.workExperience])

watch(() => props.workExperience, (newExp) => {
  localExperiences.value = [...newExp]
}, { deep: true })

const addExperience = () => {
  const newExp: WorkExperience = {
    position: '',
    company: '',
    location: '',
    street_address: '',
    city: '',
    country: '',
    start_date: '',
    end_date: '',
    current: false,
    description: '',
    achievements: []
  }
  localExperiences.value.push(newExp)
  emit('update:work-experience', [...localExperiences.value])
}

const removeExperience = (index: number) => {
  localExperiences.value.splice(index, 1)
  emit('update:work-experience', [...localExperiences.value])
}

const updateLocationField = (exp: WorkExperience) => {
  // Combine street_address, city, and country into location field
  const parts = [exp.street_address, exp.city, exp.country].filter(part => part && part.trim())
  exp.location = parts.join(', ')
}

const updateExperience = (_index: number) => {
  emit('update:work-experience', [...localExperiences.value])
}

const handleCurrentChange = (index: number) => {
  if (localExperiences.value[index].current) {
    localExperiences.value[index].end_date = ''
  }
  updateExperience(index)
}
</script>
