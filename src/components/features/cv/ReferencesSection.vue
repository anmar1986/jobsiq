<template>
  <div class="mb-5">
    <div class="flex items-center justify-between mb-3">
      <h3 class="text-base font-semibold text-gray-900 flex items-center gap-2">
        <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
        </svg>
        {{ $t('cv.references') }}
      </h3>
      <BaseButton
        type="button"
        variant="outline"
        size="sm"
        @click="addReference"
      >
        <template #icon-left>
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
          </svg>
        </template>
        {{ $t('cv.addItem') }}
      </BaseButton>
    </div>
    
    <!-- References List -->
    <div v-if="localReferences.length > 0" class="space-y-4">
      <BaseCard
        v-for="(reference, index) in localReferences"
        :key="index"
        class="p-6 border-l-4 border-primary-500"
      >
        <div class="flex justify-between items-start mb-4">
          <h4 class="font-semibold text-gray-900">{{ $t('cv.references') }} #{{ index + 1 }}</h4>
          <button
            type="button"
            @click="removeReference(index)"
            class="text-red-600 hover:text-red-700 p-1"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
          </button>
        </div>
        
        <div class="grid md:grid-cols-2 gap-4">
          <BaseInput
            v-model="reference.name"
            :label="$t('cv.fullName')"
            :placeholder="$t('cv.fullNamePlaceholder')"
            required
            @update:model-value="updateReference(index)"
          />
          
          <BaseInput
            v-model="reference.position"
            :label="$t('cv.position')"
            :placeholder="$t('cv.positionPlaceholder')"
            required
            @update:model-value="updateReference(index)"
          />
          
          <BaseInput
            v-model="reference.company"
            :label="$t('cv.companyName')"
            :placeholder="$t('cv.companyPlaceholder')"
            required
            @update:model-value="updateReference(index)"
          />
          
          <BaseInput
            v-model="reference.relationship"
            label="Relationship"
            placeholder="Former Supervisor"
            required
            @update:model-value="updateReference(index)"
          />
          
          <BaseInput
            :model-value="reference.email || ''"
            type="email"
            :label="$t('cv.email')"
            :placeholder="$t('cv.emailPlaceholder')"
            @update:model-value="reference.email = $event as string; updateReference(index)"
          />
          
          <BaseInput
            :model-value="reference.phone || ''"
            type="tel"
            :label="$t('cv.phone')"
            :placeholder="$t('cv.phonePlaceholder')"
            @update:model-value="reference.phone = $event as string; updateReference(index)"
          />
        </div>
      </BaseCard>
    </div>
    
    <p v-else class="text-sm text-gray-500 italic p-4 bg-gray-50 rounded-lg border border-gray-200">
      {{ $t('cv.noReferencesAdded') }}
    </p>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseInput from '@/components/base/BaseInput.vue'
import type { Reference } from '@/types'

interface Props {
  references: Reference[]
}

const props = defineProps<Props>()

const { t: $t } = useI18n()

const emit = defineEmits<{
  'update:references': [value: Reference[]]
}>()

const localReferences = ref<Reference[]>([...props.references])

watch(() => props.references, (newReferences) => {
  localReferences.value = [...newReferences]
}, { deep: true })

const addReference = () => {
  const newRef: Reference = {
    name: '',
    position: '',
    company: '',
    email: '',
    phone: '',
    relationship: ''
  }
  localReferences.value.push(newRef)
  emit('update:references', [...localReferences.value])
}

const removeReference = (index: number) => {
  localReferences.value.splice(index, 1)
  emit('update:references', [...localReferences.value])
}

const updateReference = (_index: number) => {
  emit('update:references', [...localReferences.value])
}
</script>
