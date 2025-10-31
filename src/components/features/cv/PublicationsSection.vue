<template>
  <div class="mb-5">
    <div class="flex items-center justify-between mb-3">
      <h3 class="text-base font-semibold text-gray-900 flex items-center gap-2">
        <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
        </svg>
        Publications
      </h3>
      <BaseButton
        type="button"
        variant="outline"
        size="sm"
        @click="addPublication"
      >
        <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
        </svg>
        Add Publication
      </BaseButton>
    </div>
    
    <!-- Publications List -->
    <div v-if="localPublications.length > 0" class="space-y-4">
      <BaseCard
        v-for="(pub, index) in localPublications"
        :key="index"
        class="p-6 border-l-4 border-primary-500"
      >
        <div class="flex justify-between items-start mb-4">
          <h4 class="font-semibold text-gray-900">Publication #{{ index + 1 }}</h4>
          <button
            type="button"
            @click="removePublication(index)"
            class="text-red-600 hover:text-red-700 p-1"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
          </button>
        </div>
        
        <div class="grid md:grid-cols-2 gap-4">
          <BaseInput
            v-model="pub.title"
            label="Publication Title"
            placeholder="e.g., Research Paper on AI"
            required
            @update:model-value="updatePublication(index)"
          />
          
          <BaseInput
            v-model="pub.publisher"
            label="Publisher"
            placeholder="e.g., Journal of Computer Science"
            required
            @update:model-value="updatePublication(index)"
          />
          
          <BaseInput
            v-model="pub.date"
            type="date"
            label="Publication Date"
            required
            @update:model-value="updatePublication(index)"
          />
          
          <BaseInput
            :model-value="pub.url || ''"
            label="URL"
            placeholder="https://example.com/publication"
            @update:model-value="pub.url = $event as string; updatePublication(index)"
          />
          
          <div class="md:col-span-2">
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Description
            </label>
            <textarea
              :value="pub.description || ''"
              rows="2"
              placeholder="Brief description of the publication..."
              class="block w-full px-4 py-2.5 text-sm border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
              @input="pub.description = ($event.target as HTMLTextAreaElement).value; updatePublication(index)"
            />
          </div>
        </div>
      </BaseCard>
    </div>
    
    <p v-else class="text-sm text-gray-500 italic p-4 bg-gray-50 rounded-lg border border-gray-200">
      No publications added yet. Click "Add Publication" to showcase your research and writings.
    </p>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseInput from '@/components/base/BaseInput.vue'
import type { Publication } from '@/types'

interface Props {
  publications: Publication[]
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'update:publications': [value: Publication[]]
}>()

const localPublications = ref<Publication[]>([...props.publications])

watch(() => props.publications, (newPublications) => {
  localPublications.value = [...newPublications]
}, { deep: true })

const addPublication = () => {
  const newPub: Publication = {
    title: '',
    publisher: '',
    date: '',
    url: '',
    description: ''
  }
  localPublications.value.push(newPub)
  emit('update:publications', [...localPublications.value])
}

const removePublication = (index: number) => {
  localPublications.value.splice(index, 1)
  emit('update:publications', [...localPublications.value])
}

const updatePublication = (_index: number) => {
  emit('update:publications', [...localPublications.value])
}
</script>
