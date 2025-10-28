<template>
  <div class="mb-8">
    <div class="flex items-center justify-between mb-4">
      <h3 class="text-lg font-semibold text-gray-900 flex items-center gap-2">
        <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
        </svg>
        Education
      </h3>
      <BaseButton
        type="button"
        variant="outline"
        size="sm"
        @click="addEducation"
      >
        <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
        </svg>
        Add Education
      </BaseButton>
    </div>
    
    <!-- Education List -->
    <div v-if="localEducation.length > 0" class="space-y-4">
      <BaseCard
        v-for="(edu, index) in localEducation"
        :key="index"
        class="p-6 border-l-4 border-green-500"
      >
        <div class="flex justify-between items-start mb-4">
          <h4 class="font-semibold text-gray-900">Education #{{ index + 1 }}</h4>
          <button
            type="button"
            @click="removeEducation(index)"
            class="text-red-600 hover:text-red-700 p-1"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
          </button>
        </div>
        
        <div class="grid md:grid-cols-2 gap-4">
          <BaseInput
            v-model="edu.degree"
            label="Degree"
            placeholder="e.g., Bachelor of Science"
            required
            @update:model-value="updateEducation(index)"
          />
          
          <BaseInput
            v-model="edu.field"
            label="Field of Study"
            placeholder="e.g., Computer Science"
            required
            @update:model-value="updateEducation(index)"
          />
          
          <BaseInput
            v-model="edu.institution"
            label="Institution"
            placeholder="e.g., MIT"
            required
            @update:model-value="updateEducation(index)"
          />
          
          <BaseInput
            :model-value="edu.location || ''"
            label="Location"
            placeholder="e.g., Cambridge, MA"
            @update:model-value="edu.location = $event as string; updateEducation(index)"
          />
          
          <BaseInput
            v-model="edu.start_date"
            type="date"
            label="Start Date"
            required
            @update:model-value="updateEducation(index)"
          />
          
          <BaseInput
            :model-value="edu.end_date || ''"
            type="date"
            label="End Date"
            @update:model-value="edu.end_date = $event as string; updateEducation(index)"
          />
          
          <div class="md:col-span-2">
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Description
            </label>
            <textarea
              v-model="edu.description"
              rows="2"
              placeholder="Honors, relevant coursework, achievements..."
              class="block w-full px-4 py-2.5 text-sm border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
              @input="updateEducation(index)"
            />
          </div>
        </div>
      </BaseCard>
    </div>
    
    <p v-else class="text-sm text-gray-500 italic p-4 bg-gray-50 rounded-lg border border-gray-200">
      No education added yet. Click "Add Education" to get started.
    </p>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseInput from '@/components/base/BaseInput.vue'
import type { Education } from '@/types'

interface Props {
  education: Education[]
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'update:education': [value: Education[]]
}>()

const localEducation = ref<Education[]>([...props.education])

watch(() => props.education, (newEdu) => {
  localEducation.value = [...newEdu]
}, { deep: true })

const addEducation = () => {
  const newEdu: Education = {
    degree: '',
    field: '',
    institution: '',
    location: '',
    start_date: '',
    end_date: '',
    description: '',
  }
  localEducation.value.push(newEdu)
  emit('update:education', [...localEducation.value])
}

const removeEducation = (index: number) => {
  localEducation.value.splice(index, 1)
  emit('update:education', [...localEducation.value])
}

const updateEducation = (_index: number) => {
  emit('update:education', [...localEducation.value])
}
</script>
