<template>
  <div class="mb-5">
    <h3 class="text-base font-semibold text-gray-900 mb-3 flex items-center gap-2">
      <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.828 14.828a4 4 0 01-5.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
      </svg>
      {{ $t('cv.hobbies') }}
    </h3>
    
    <div class="space-y-3">
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-2">
          {{ $t('cv.addHobbies') }}
          <span class="text-gray-500 text-xs ml-2">({{ $t('cv.pressEnterToAdd') }})</span>
        </label>
        <div class="flex gap-2">
          <input
            v-model="newHobby"
            type="text"
            :placeholder="$t('cv.hobbiesPlaceholder')"
            class="flex-1 px-4 py-2.5 text-sm border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
            @keyup.enter="addHobby"
          />
          <BaseButton
            type="button"
            variant="primary"
            size="sm"
            @click="addHobby"
          >
            {{ $t('common.add') }}
          </BaseButton>
        </div>
        <p class="text-xs text-gray-500 mt-2">
          {{ $t('cv.hobbiesTip') }}
        </p>
      </div>
      
      <!-- Hobbies Tags -->
      <div v-if="localHobbies.length > 0" class="flex flex-wrap gap-2">
        <div
          v-for="(hobby, index) in localHobbies"
          :key="index"
          class="inline-flex items-center gap-2 px-4 py-2 bg-primary-50 text-primary-700 rounded-full text-sm font-medium"
        >
          <span>{{ hobby }}</span>
          <button
            type="button"
            @click="removeHobby(index)"
            class="hover:text-primary-900 transition-colors"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
      </div>
      
      <p v-else class="text-sm text-gray-500 italic p-4 bg-gray-50 rounded-lg border border-gray-200">
        {{ $t('cv.noHobbiesAdded') }}
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import BaseButton from '@/components/base/BaseButton.vue'

interface Props {
  hobbies: string[]
}

const props = defineProps<Props>()

const { t: $t } = useI18n()

const emit = defineEmits<{
  'update:hobbies': [value: string[]]
}>()

const localHobbies = ref<string[]>([...props.hobbies])
const newHobby = ref('')

watch(() => props.hobbies, (newHobbies) => {
  localHobbies.value = [...newHobbies]
}, { deep: true })

const addHobby = () => {
  const hobby = newHobby.value.trim()
  if (hobby && !localHobbies.value.includes(hobby)) {
    localHobbies.value.push(hobby)
    emit('update:hobbies', [...localHobbies.value])
    newHobby.value = ''
  }
}

const removeHobby = (index: number) => {
  localHobbies.value.splice(index, 1)
  emit('update:hobbies', [...localHobbies.value])
}
</script>
