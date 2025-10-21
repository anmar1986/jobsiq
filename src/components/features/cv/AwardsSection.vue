<template>
  <div class="mb-8">
    <div class="flex items-center justify-between mb-4">
      <h3 class="text-lg font-semibold text-gray-900 flex items-center gap-2">
        <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z" />
        </svg>
        Awards & Honors
      </h3>
      <BaseButton
        type="button"
        variant="outline"
        size="sm"
        @click="addAward"
      >
        <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
        </svg>
        Add Award
      </BaseButton>
    </div>
    
    <!-- Awards List -->
    <div v-if="localAwards.length > 0" class="space-y-4">
      <BaseCard
        v-for="(award, index) in localAwards"
        :key="index"
        class="p-6 border-l-4 border-primary-500"
      >
        <div class="flex justify-between items-start mb-4">
          <h4 class="font-semibold text-gray-900">Award #{{ index + 1 }}</h4>
          <button
            type="button"
            @click="removeAward(index)"
            class="text-red-600 hover:text-red-700 p-1"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
          </button>
        </div>
        
        <div class="grid md:grid-cols-2 gap-4">
          <BaseInput
            v-model="award.title"
            label="Award Title"
            placeholder="e.g., Employee of the Year"
            required
            @update:model-value="updateAward(index)"
          />
          
          <BaseInput
            v-model="award.issuer"
            label="Issuer"
            placeholder="e.g., Tech Corp"
            required
            @update:model-value="updateAward(index)"
          />
          
          <BaseInput
            v-model="award.date"
            type="date"
            label="Date Received"
            required
            @update:model-value="updateAward(index)"
          />
          
          <div class="md:col-span-2">
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Description
            </label>
            <textarea
              :value="award.description || ''"
              rows="2"
              placeholder="Describe what this award recognizes..."
              class="block w-full px-4 py-2.5 text-sm border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
              @input="award.description = ($event.target as HTMLTextAreaElement).value; updateAward(index)"
            />
          </div>
        </div>
      </BaseCard>
    </div>
    
    <p v-else class="text-sm text-gray-500 italic p-4 bg-gray-50 rounded-lg border border-gray-200">
      No awards added yet. Click "Add Award" to showcase your achievements and recognitions.
    </p>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseInput from '@/components/base/BaseInput.vue'
import type { Award } from '@/types'

interface Props {
  awards: Award[]
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'update:awards': [value: Award[]]
}>()

const localAwards = ref<Award[]>([...props.awards])

watch(() => props.awards, (newAwards) => {
  localAwards.value = [...newAwards]
}, { deep: true })

const addAward = () => {
  const newAward: Award = {
    title: '',
    issuer: '',
    date: '',
    description: ''
  }
  localAwards.value.push(newAward)
  emit('update:awards', [...localAwards.value])
}

const removeAward = (index: number) => {
  localAwards.value.splice(index, 1)
  emit('update:awards', [...localAwards.value])
}

const updateAward = (index: number) => {
  emit('update:awards', [...localAwards.value])
}
</script>
