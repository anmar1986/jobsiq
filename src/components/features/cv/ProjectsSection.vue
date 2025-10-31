<template>
  <div class="mb-5">
    <div class="flex items-center justify-between mb-3">
      <h3 class="text-base font-semibold text-gray-900 flex items-center gap-2">
        <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
        </svg>
        Projects
      </h3>
      <BaseButton
        type="button"
        variant="outline"
        size="sm"
        @click="addProject"
      >
        <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
        </svg>
        Add Project
      </BaseButton>
    </div>
    
    <!-- Projects List -->
    <div v-if="localProjects.length > 0" class="space-y-4">
      <BaseCard
        v-for="(project, index) in localProjects"
        :key="index"
        class="p-6 border-l-4 border-primary-500"
      >
        <div class="flex justify-between items-start mb-4">
          <h4 class="font-semibold text-gray-900">Project #{{ index + 1 }}</h4>
          <button
            type="button"
            @click="removeProject(index)"
            class="text-red-600 hover:text-red-700 p-1"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
          </button>
        </div>
        
        <div class="grid md:grid-cols-2 gap-4">
          <BaseInput
            v-model="project.title"
            label="Project Title"
            placeholder="e.g., E-commerce Platform"
            required
            @update:model-value="updateProject(index)"
          />
          
          <BaseInput
            :model-value="project.url || ''"
            label="Project URL"
            placeholder="https://example.com"
            @update:model-value="project.url = $event as string; updateProject(index)"
          />
          
          <BaseInput
            :model-value="project.start_date || ''"
            type="date"
            label="Start Date"
            @update:model-value="project.start_date = $event as string; updateProject(index)"
          />
          
          <BaseInput
            :model-value="project.end_date || ''"
            type="date"
            label="End Date"
            @update:model-value="project.end_date = $event as string; updateProject(index)"
          />
          
          <div class="md:col-span-2">
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Description
            </label>
            <textarea
              v-model="project.description"
              rows="3"
              placeholder="Describe the project, your role, and key achievements..."
              class="block w-full px-4 py-2.5 text-sm border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
              @input="updateProject(index)"
            />
          </div>
          
          <div class="md:col-span-2">
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Technologies
              <span class="text-gray-500 text-xs ml-2">(comma-separated)</span>
            </label>
            <input
              :value="getTechnologiesString(project.technologies)"
              type="text"
              placeholder="e.g., Vue.js, Laravel, MySQL"
              class="block w-full px-4 py-2.5 text-sm border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
              @input="updateTechnologies(index, ($event.target as HTMLInputElement).value)"
            />
          </div>
        </div>
      </BaseCard>
    </div>
    
    <p v-else class="text-sm text-gray-500 italic p-4 bg-gray-50 rounded-lg border border-gray-200">
      No projects added yet. Click "Add Project" to showcase your work.
    </p>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseInput from '@/components/base/BaseInput.vue'
import type { Project } from '@/types'

interface Props {
  projects: Project[]
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'update:projects': [value: Project[]]
}>()

const localProjects = ref<Project[]>([...props.projects])

watch(() => props.projects, (newProjects) => {
  localProjects.value = [...newProjects]
}, { deep: true })

const addProject = () => {
  const newProject: Project = {
    title: '',
    description: '',
    technologies: [],
    url: '',
    start_date: '',
    end_date: ''
  }
  localProjects.value.push(newProject)
  emit('update:projects', [...localProjects.value])
}

const removeProject = (index: number) => {
  localProjects.value.splice(index, 1)
  emit('update:projects', [...localProjects.value])
}

const updateProject = (_index: number) => {
  emit('update:projects', [...localProjects.value])
}

const getTechnologiesString = (technologies?: string[]): string => {
  return technologies?.join(', ') || ''
}

const updateTechnologies = (index: number, value: string) => {
  localProjects.value[index].technologies = value
    .split(',')
    .map(t => t.trim())
    .filter(t => t.length > 0)
  updateProject(index)
}
</script>
