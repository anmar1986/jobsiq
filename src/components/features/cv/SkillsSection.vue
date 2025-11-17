<template>
  <div class="mb-5">
    <h3 class="text-base font-semibold text-gray-900 mb-3 flex items-center gap-2">
      <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" />
      </svg>
      {{ $t('cv.skills') }}
    </h3>

    <div>
      <label for="skill-input" class="block text-sm font-medium text-gray-700 mb-2">
        {{ $t('cv.addSkills') }}
      </label>

      <div class="flex gap-2 mb-4">
        <input
          id="skill-input"
          v-model="newSkill"
          type="text"
          :placeholder="$t('cv.skillsPlaceholder')"
          class="flex-1 px-4 py-2.5 text-sm border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
          @keyup.enter="addSkill"
        />
        <BaseButton
          type="button"
          variant="primary"
          @click="addSkill"
          :disabled="!newSkill.trim()"
        >
          <template #icon-left>
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
          </template>
          {{ $t('common.add') }}
        </BaseButton>
      </div>

      <!-- Skills List -->
      <div v-if="localSkills.length > 0" class="flex flex-wrap gap-2 p-4 bg-gray-50 rounded-lg border border-gray-200">
        <span
          v-for="(skill, index) in localSkills"
          :key="index"
          class="inline-flex items-center gap-2 px-3 py-1.5 bg-primary-100 text-primary-700 rounded-full text-sm font-medium"
        >
          {{ skill }}
          <button
            type="button"
            @click="removeSkill(index)"
            class="hover:text-primary-900 focus:outline-none"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </span>
      </div>

      <p v-else class="text-sm text-gray-500 italic p-4 bg-gray-50 rounded-lg border border-gray-200">
        {{ $t('cv.noSkillsAdded') }}
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import BaseButton from '@/components/base/BaseButton.vue'

const { t: $t } = useI18n()

interface Props {
  skills: string[]
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'update:skills': [value: string[]]
}>()

const newSkill = ref('')
const localSkills = ref<string[]>([...props.skills])

watch(() => props.skills, (newSkills) => {
  localSkills.value = [...newSkills]
}, { deep: true })

const addSkill = () => {
  const skill = newSkill.value.trim()
  if (skill && !localSkills.value.includes(skill)) {
    localSkills.value.push(skill)
    emit('update:skills', [...localSkills.value])
    newSkill.value = ''
  }
}

const removeSkill = (index: number) => {
  localSkills.value.splice(index, 1)
  emit('update:skills', [...localSkills.value])
}
</script>
