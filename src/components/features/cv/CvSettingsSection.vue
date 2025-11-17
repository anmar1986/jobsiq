<template>
  <div class="mb-5">
    <h3 class="text-base font-semibold text-gray-900 mb-3 flex items-center gap-2">
      <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
      </svg>
      {{ $t('cv.cvSettings') }}
    </h3>
    
    <div class="space-y-4">
      <div class="flex items-start gap-3 p-4 bg-gray-50 rounded-lg border border-gray-200">
        <input
          id="is-public"
          v-model="localSettings.is_public"
          type="checkbox"
          class="mt-1 w-4 h-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
          @change="updateSettings"
        />
        <div class="flex-1">
          <label for="is-public" class="block text-sm font-medium text-gray-900 cursor-pointer">
            {{ $t('cv.makePublic') }}
          </label>
          <p class="text-xs text-gray-600 mt-1">
            {{ $t('cv.makePublicDescription') }}
          </p>
        </div>
      </div>
      
      <div class="flex items-start gap-3 p-4 bg-gray-50 rounded-lg border border-gray-200">
        <input
          id="is-primary"
          v-model="localSettings.is_primary"
          type="checkbox"
          class="mt-1 w-4 h-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
          @change="updateSettings"
        />
        <div class="flex-1">
          <label for="is-primary" class="block text-sm font-medium text-gray-900 cursor-pointer">
            {{ $t('cv.setPrimary') }}
          </label>
          <p class="text-xs text-gray-600 mt-1">
            {{ $t('cv.setPrimaryDescription') }}
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'

const { t: $t } = useI18n()

interface CvSettings {
  is_public: boolean
  is_primary: boolean
}

interface Props {
  settings: CvSettings
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'update:settings': [value: CvSettings]
}>()

const localSettings = ref<CvSettings>({ ...props.settings })

watch(() => props.settings, (newSettings) => {
  localSettings.value = { ...newSettings }
}, { deep: true })

const updateSettings = () => {
  emit('update:settings', { ...localSettings.value })
}
</script>
