<template>
  <div class="mb-5">
    <div class="flex items-center justify-between mb-3">
      <h3 class="text-base font-semibold text-gray-900 flex items-center gap-2">
        <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z" />
        </svg>
        {{ $t('cv.certifications') }}
      </h3>
      <BaseButton
        type="button"
        variant="outline"
        size="sm"
        @click="addCertification"
      >
        <template #icon-left>
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
          </svg>
        </template>
        {{ $t('cv.addItem') }}
      </BaseButton>
    </div>
    
    <!-- Certifications List -->
    <div v-if="localCertifications.length > 0" class="space-y-4">
      <BaseCard
        v-for="(cert, index) in localCertifications"
        :key="index"
        class="p-6 border-l-4 border-yellow-500"
      >
        <div class="flex justify-between items-start mb-4">
          <h4 class="font-semibold text-gray-900">{{ $t('cv.certifications') }} #{{ index + 1 }}</h4>
          <button
            type="button"
            @click="removeCertification(index)"
            class="text-red-600 hover:text-red-700 p-1"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
          </button>
        </div>
        
        <div class="grid md:grid-cols-2 gap-4">
          <BaseInput
            v-model="cert.name"
            :label="$t('cv.certificateName')"
            placeholder="AWS Certified Solutions Architect"
            required
            @update:model-value="updateCertification(index)"
          />
          
          <BaseInput
            v-model="cert.issuer"
            :label="$t('cv.issuingOrganization')"
            placeholder="Amazon Web Services"
            required
            @update:model-value="updateCertification(index)"
          />
          
          <BaseInput
            v-model="cert.date"
            type="date"
            :label="$t('cv.issueDate')"
            required
            @update:model-value="updateCertification(index)"
          />
          
          <BaseInput
            :model-value="cert.expiry_date || ''"
            type="date"
            :label="$t('cv.expiryDate')"
            @update:model-value="cert.expiry_date = $event as string; updateCertification(index)"
          />
          
          <BaseInput
            :model-value="cert.credential_id || ''"
            :label="$t('cv.credentialId')"
            placeholder="ABC123XYZ"
            @update:model-value="cert.credential_id = $event as string; updateCertification(index)"
          />
          
          <BaseInput
            :model-value="cert.url || ''"
            type="url"
            label="URL"
            placeholder="https://..."
            @update:model-value="cert.url = $event as string; updateCertification(index)"
          />
        </div>
      </BaseCard>
    </div>
    
    <p v-else class="text-sm text-gray-500 italic p-4 bg-gray-50 rounded-lg border border-gray-200">
      {{ $t('cv.noCertificationsAdded') }}
    </p>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseInput from '@/components/base/BaseInput.vue'
import type { Certification } from '@/types'

interface Props {
  certifications: Certification[]
}

const props = defineProps<Props>()

const { t: $t } = useI18n()

const emit = defineEmits<{
  'update:certifications': [value: Certification[]]
}>()

const localCertifications = ref<Certification[]>([...props.certifications])

watch(() => props.certifications, (newCerts) => {
  localCertifications.value = [...newCerts]
}, { deep: true })

const addCertification = () => {
  const newCert: Certification = {
    name: '',
    issuer: '',
    date: '',
    expiry_date: '',
    credential_id: '',
    url: ''
  }
  localCertifications.value.push(newCert)
  emit('update:certifications', [...localCertifications.value])
}

const removeCertification = (index: number) => {
  localCertifications.value.splice(index, 1)
  emit('update:certifications', [...localCertifications.value])
}

const updateCertification = (_index: number) => {
  emit('update:certifications', [...localCertifications.value])
}
</script>
