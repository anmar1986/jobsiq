<template>
  <div class="mb-8">
    <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
      <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
      </svg>
      Professional Summary & Objective
    </h3>
    
    <div class="space-y-4">
      <div>
        <label for="objective" class="block text-sm font-medium text-gray-700 mb-2">
          Career Objective
          <span class="text-gray-500 text-xs ml-2">({{ localObjective.length }}/500 characters)</span>
        </label>
        <textarea
          id="objective"
          v-model="localObjective"
          rows="3"
          maxlength="500"
          placeholder="Write a brief statement about your career goals and what you're looking for..."
          class="block w-full px-4 py-2.5 text-sm border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
          @input="handleObjectiveInput"
        />
        <p class="text-xs text-gray-500 mt-2">
          Tip: State your career goals and what type of role you're seeking.
        </p>
      </div>
      
      <div>
        <label for="summary" class="block text-sm font-medium text-gray-700 mb-2">
          Professional Summary
          <span class="text-gray-500 text-xs ml-2">({{ localSummary.length }}/1000 characters)</span>
        </label>
        <textarea
          id="summary"
          v-model="localSummary"
          rows="5"
          maxlength="1000"
          placeholder="Write a brief summary of your professional background, key skills, and achievements..."
          class="block w-full px-4 py-2.5 text-sm border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
          @input="handleSummaryInput"
        />
        <p class="text-xs text-gray-500 mt-2">
          Tip: Focus on your key achievements, skills, and what makes you unique as a professional.
        </p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'

interface Props {
  summary: string
  objective: string
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'update:summary': [value: string]
  'update:objective': [value: string]
}>()

const localSummary = ref(props.summary || '')
const localObjective = ref(props.objective || '')

watch(() => props.summary, (newSummary) => {
  localSummary.value = newSummary || ''
})

watch(() => props.objective, (newObjective) => {
  localObjective.value = newObjective || ''
})

const handleSummaryInput = () => {
  emit('update:summary', localSummary.value)
}

const handleObjectiveInput = () => {
  emit('update:objective', localObjective.value)
}
</script>
