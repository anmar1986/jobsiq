<template>
  <div class="mb-8">
    <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
      <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
      </svg>
      Personal Information
    </h3>
    
    <div class="grid md:grid-cols-2 gap-4">
      <BaseInput
        v-model="localInfo.full_name"
        label="Full Name"
        placeholder="John Doe"
        required
        @update:model-value="updateField('full_name', $event)"
      />
      
      <BaseInput
        v-model="localInfo.title"
        label="Professional Title"
        placeholder="e.g., Senior Software Engineer"
        required
        @update:model-value="updateField('title', $event)"
      />
      
      <BaseInput
        v-model="localInfo.email"
        type="email"
        label="Email"
        placeholder="john.doe@example.com"
        required
        @update:model-value="updateField('email', $event)"
      />
      
      <BaseInput
        v-model="localInfo.phone"
        type="tel"
        label="Phone"
        placeholder="+1 (555) 123-4567"
        @update:model-value="updateField('phone', $event)"
      />
      
      <div class="md:col-span-2">
        <BaseInput
          v-model="localInfo.address"
          label="Address"
          placeholder="123 Main Street"
          @update:model-value="updateField('address', $event)"
        />
      </div>
      
      <BaseInput
        v-model="localInfo.city"
        label="City"
        placeholder="New York"
        @update:model-value="updateField('city', $event)"
      />
      
      <BaseInput
        v-model="localInfo.country"
        label="Country"
        placeholder="United States"
        @update:model-value="updateField('country', $event)"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import BaseInput from '@/components/base/BaseInput.vue'

interface PersonalInfo {
  full_name: string
  email: string
  phone: string
  title: string
  address: string
  city: string
  country: string
}

interface Props {
  personalInfo: PersonalInfo
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'update:personal-info': [value: PersonalInfo]
}>()

const localInfo = ref<PersonalInfo>({ ...props.personalInfo })

watch(() => props.personalInfo, (newInfo) => {
  localInfo.value = { ...newInfo }
}, { deep: true })

const updateField = (field: keyof PersonalInfo, value: string | number) => {
  localInfo.value[field] = value as never
  emit('update:personal-info', { ...localInfo.value })
}
</script>
