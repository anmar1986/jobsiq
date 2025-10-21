<template>
  <div class="mb-8">
    <div class="flex items-center justify-between mb-4">
      <h3 class="text-lg font-semibold text-gray-900 flex items-center gap-2">
        <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
        </svg>
        Volunteer Work
      </h3>
      <BaseButton
        type="button"
        variant="outline"
        size="sm"
        @click="addVolunteerWork"
      >
        <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
        </svg>
        Add Volunteer Work
      </BaseButton>
    </div>
    
    <!-- Volunteer Work List -->
    <div v-if="localVolunteerWork.length > 0" class="space-y-4">
      <BaseCard
        v-for="(vol, index) in localVolunteerWork"
        :key="index"
        class="p-6 border-l-4 border-primary-500"
      >
        <div class="flex justify-between items-start mb-4">
          <h4 class="font-semibold text-gray-900">Volunteer Work #{{ index + 1 }}</h4>
          <button
            type="button"
            @click="removeVolunteerWork(index)"
            class="text-red-600 hover:text-red-700 p-1"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
          </button>
        </div>
        
        <div class="grid md:grid-cols-2 gap-4">
          <BaseInput
            v-model="vol.organization"
            label="Organization"
            placeholder="e.g., Local Food Bank"
            required
            @update:model-value="updateVolunteerWork(index)"
          />
          
          <BaseInput
            v-model="vol.role"
            label="Role"
            placeholder="e.g., Volunteer Coordinator"
            required
            @update:model-value="updateVolunteerWork(index)"
          />
          
          <BaseInput
            v-model="vol.start_date"
            type="date"
            label="Start Date"
            required
            @update:model-value="updateVolunteerWork(index)"
          />
          
          <BaseInput
            :model-value="vol.end_date || ''"
            type="date"
            label="End Date"
            @update:model-value="vol.end_date = $event as string; updateVolunteerWork(index)"
          />
          
          <div class="md:col-span-2">
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Description
            </label>
            <textarea
              :value="vol.description || ''"
              rows="3"
              placeholder="Describe your volunteer work and contributions..."
              class="block w-full px-4 py-2.5 text-sm border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
              @input="vol.description = ($event.target as HTMLTextAreaElement).value; updateVolunteerWork(index)"
            />
          </div>
        </div>
      </BaseCard>
    </div>
    
    <p v-else class="text-sm text-gray-500 italic p-4 bg-gray-50 rounded-lg border border-gray-200">
      No volunteer work added yet. Click "Add Volunteer Work" to showcase your community involvement.
    </p>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseInput from '@/components/base/BaseInput.vue'
import type { VolunteerWork } from '@/types'

interface Props {
  volunteerWork: VolunteerWork[]
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'update:volunteer-work': [value: VolunteerWork[]]
}>()

const localVolunteerWork = ref<VolunteerWork[]>([...props.volunteerWork])

watch(() => props.volunteerWork, (newVolunteerWork) => {
  localVolunteerWork.value = [...newVolunteerWork]
}, { deep: true })

const addVolunteerWork = () => {
  const newVol: VolunteerWork = {
    organization: '',
    role: '',
    start_date: '',
    end_date: '',
    description: ''
  }
  localVolunteerWork.value.push(newVol)
  emit('update:volunteer-work', [...localVolunteerWork.value])
}

const removeVolunteerWork = (index: number) => {
  localVolunteerWork.value.splice(index, 1)
  emit('update:volunteer-work', [...localVolunteerWork.value])
}

const updateVolunteerWork = (index: number) => {
  emit('update:volunteer-work', [...localVolunteerWork.value])
}
</script>
