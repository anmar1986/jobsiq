<template>
  <div class="mb-8">
    <div class="flex items-center justify-between mb-4">
      <h3 class="text-lg font-semibold text-gray-900 flex items-center gap-2">
        <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5h12M9 3v2m1.048 9.5A18.022 18.022 0 016.412 9m6.088 9h7M11 21l5-10 5 10M12.751 5C11.783 10.77 8.07 15.61 3 18.129" />
        </svg>
        Languages
      </h3>
      <BaseButton
        type="button"
        variant="outline"
        size="sm"
        @click="addLanguage"
      >
        <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
        </svg>
        Add Language
      </BaseButton>
    </div>
    
    <!-- Languages List -->
    <div v-if="localLanguages.length > 0" class="space-y-4">
      <BaseCard
        v-for="(lang, index) in localLanguages"
        :key="index"
        class="p-6 border-l-4 border-blue-500"
      >
        <div class="flex justify-between items-start mb-4">
          <h4 class="font-semibold text-gray-900">Language #{{ index + 1 }}</h4>
          <button
            type="button"
            @click="removeLanguage(index)"
            class="text-red-600 hover:text-red-700 p-1"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
          </button>
        </div>
        
        <div class="grid md:grid-cols-2 gap-4">
          <BaseInput
            v-model="lang.language"
            label="Language"
            placeholder="e.g., English, Spanish, Mandarin"
            required
            @update:model-value="updateLanguage(index)"
          />
          
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Proficiency
              <span class="text-red-500 ml-1">*</span>
            </label>
            <select
              v-model="lang.proficiency"
              required
              class="block w-full px-4 py-2.5 text-sm border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors bg-white"
              @change="updateLanguage(index)"
            >
              <option value="">Select proficiency</option>
              <option value="basic">Basic</option>
              <option value="conversational">Conversational</option>
              <option value="fluent">Fluent</option>
              <option value="native">Native</option>
            </select>
          </div>
        </div>
      </BaseCard>
    </div>
    
    <p v-else class="text-sm text-gray-500 italic p-4 bg-gray-50 rounded-lg border border-gray-200">
      No languages added yet. Click "Add Language" to get started.
    </p>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseInput from '@/components/base/BaseInput.vue'
import type { Language } from '@/types'

interface Props {
  languages: Language[]
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'update:languages': [value: Language[]]
}>()

const localLanguages = ref<Language[]>([...props.languages])

watch(() => props.languages, (newLangs) => {
  localLanguages.value = [...newLangs]
}, { deep: true })

const addLanguage = () => {
  const newLang: Language = {
    language: '',
    proficiency: 'basic'
  }
  localLanguages.value.push(newLang)
  emit('update:languages', [...localLanguages.value])
}

const removeLanguage = (index: number) => {
  localLanguages.value.splice(index, 1)
  emit('update:languages', [...localLanguages.value])
}

const updateLanguage = (_index: number) => {
  emit('update:languages', [...localLanguages.value])
}
</script>
