<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <!-- Basic Information Section -->
    <div class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">Basic Information</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div class="md:col-span-2">
          <BaseInput
            v-model="formData.name"
            label="Company Name *"
            placeholder="Enter company name"
            :error="errors.name"
            required
          />
        </div>

        <div class="md:col-span-2">
          <label class="block text-sm font-medium text-gray-700 mb-1">
            Company Logo
          </label>
          <input
            type="file"
            accept="image/*"
            @change="handleLogoChange"
            class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-primary-50 file:text-primary-700 hover:file:bg-primary-100"
          />
          <p class="text-xs text-gray-500 mt-1">PNG, JPG, GIF up to 2MB</p>
          <p v-if="errors.logo" class="text-red-600 text-sm mt-1">{{ errors.logo }}</p>
        </div>

        <div class="md:col-span-2">
          <label class="block text-sm font-medium text-gray-700 mb-1">
            Description
          </label>
          <textarea
            v-model="formData.description"
            rows="4"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            placeholder="Tell us about your company..."
          />
          <p v-if="errors.description" class="text-red-600 text-sm mt-1">{{ errors.description }}</p>
        </div>

        <BaseInput
          v-model="formData.tagline"
          label="Tagline"
          placeholder="Short company tagline"
          :error="errors.tagline"
        />

        <BaseInput
          v-model="formData.website"
          label="Website"
          type="url"
          placeholder="https://example.com"
          :error="errors.website"
        />
      </div>
    </div>

    <!-- Contact Information Section -->
    <div class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">Contact Information</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <BaseInput
          v-model="formData.email"
          label="Email"
          type="email"
          placeholder="contact@company.com"
          :error="errors.email"
        />

        <BaseInput
          v-model="formData.phone"
          label="Phone"
          placeholder="+1 (555) 000-0000"
          :error="errors.phone"
        />
      </div>
    </div>

    <!-- Address Section -->
    <div class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">Address</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div class="md:col-span-2">
          <BaseInput
            v-model="formData.street"
            label="Street Address"
            placeholder="123 Main Street"
            :error="errors.street"
          />
        </div>

        <BaseInput
          v-model="formData.city"
          label="City"
          placeholder="San Francisco"
          :error="errors.city"
        />

        <BaseInput
          v-model="formData.state"
          label="State / Province"
          placeholder="California"
          :error="errors.state"
        />

        <BaseInput
          v-model="formData.country"
          label="Country"
          placeholder="United States"
          :error="errors.country"
        />

        <BaseInput
          v-model="formData.postal_code"
          label="Postal Code"
          placeholder="94102"
          :error="errors.postal_code"
        />
      </div>
    </div>

    <!-- Business Information Section -->
    <div class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">Business Information</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <BaseInput
          v-model="formData.industry"
          label="Industry"
          placeholder="Technology"
          :error="errors.industry"
        />

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            Company Size
          </label>
          <select
            v-model="formData.company_size"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          >
            <option value="">Select size</option>
            <option value="1-10">1-10 employees</option>
            <option value="11-50">11-50 employees</option>
            <option value="51-200">51-200 employees</option>
            <option value="201-500">201-500 employees</option>
            <option value="501-1000">501-1000 employees</option>
            <option value="1000+">1000+ employees</option>
          </select>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            Company Type
          </label>
          <select
            v-model="formData.company_type"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          >
            <option value="">Select type</option>
            <option value="startup">Startup</option>
            <option value="small_business">Small Business</option>
            <option value="mid_market">Mid Market</option>
            <option value="enterprise">Enterprise</option>
            <option value="nonprofit">Nonprofit</option>
            <option value="government">Government</option>
            <option value="agency">Agency</option>
          </select>
        </div>

        <BaseInput
          v-model="formData.total_employees"
          label="Total Employees"
          type="number"
          min="0"
          placeholder="100"
          :error="errors.total_employees"
        />
      </div>
    </div>

    <!-- Social Media Section -->
    <div class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">Social Media</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <BaseInput
          v-model="formData.linkedin"
          label="LinkedIn"
          type="url"
          placeholder="https://linkedin.com/company/..."
          :error="errors.linkedin"
        >
          <template #icon-left>
            <svg class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 24 24">
              <path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z" />
            </svg>
          </template>
        </BaseInput>

        <BaseInput
          v-model="formData.twitter"
          label="Twitter / X"
          type="url"
          placeholder="https://twitter.com/..."
          :error="errors.twitter"
        >
          <template #icon-left>
            <svg class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 24 24">
              <path d="M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z" />
            </svg>
          </template>
        </BaseInput>

        <BaseInput
          v-model="formData.facebook"
          label="Facebook"
          type="url"
          placeholder="https://facebook.com/..."
          :error="errors.facebook"
        />

        <BaseInput
          v-model="formData.github"
          label="GitHub"
          type="url"
          placeholder="https://github.com/..."
          :error="errors.github"
        />
      </div>
    </div>

    <!-- Form Actions -->
    <div class="flex items-center justify-end gap-3 pt-4 border-t border-gray-200">
      <BaseButton
        type="button"
        variant="outline"
        @click="$emit('cancel')"
        :disabled="loading"
      >
        Cancel
      </BaseButton>
      <BaseButton
        type="submit"
        variant="primary"
        :loading="loading"
      >
        {{ isEdit ? 'Update Company' : 'Create Company' }}
      </BaseButton>
    </div>
  </form>
</template>

<script setup lang="ts">
import { ref, reactive, watch } from 'vue'
import type { Company } from '@/types'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'

interface Props {
  company?: Company
  loading?: boolean
}

const props = defineProps<Props>()
const emit = defineEmits<{
  submit: [data: FormData]
  cancel: []
}>()

const isEdit = ref(!!props.company)

const formData = reactive({
  name: '',
  description: '',
  tagline: '',
  website: '',
  email: '',
  phone: '',
  street: '',
  city: '',
  state: '',
  country: '',
  postal_code: '',
  industry: '',
  company_size: '',
  company_type: '',
  total_employees: '',
  linkedin: '',
  twitter: '',
  facebook: '',
  github: '',
})

const errors = reactive<Record<string, string>>({})
const logoFile = ref<File | null>(null)

// Initialize form with existing company data if editing
watch(() => props.company, (company) => {
  if (company) {
    Object.assign(formData, {
      name: company.name || '',
      description: company.description || '',
      tagline: company.tagline || '',
      website: company.website || '',
      email: company.email || '',
      phone: company.phone || '',
      street: company.street || '',
      city: company.city || '',
      state: company.state || '',
      country: company.country || '',
      postal_code: company.postal_code || '',
      industry: company.industry || '',
      company_size: company.company_size || '',
      company_type: company.company_type || '',
      total_employees: company.total_employees?.toString() || '',
      linkedin: company.linkedin || '',
      twitter: company.twitter || '',
      facebook: company.facebook || '',
      github: company.github || '',
    })
  }
}, { immediate: true })

const handleLogoChange = (event: Event) => {
  const target = event.target as HTMLInputElement
  if (target.files && target.files[0]) {
    logoFile.value = target.files[0]
  }
}

const handleSubmit = () => {
  // Clear previous errors
  Object.keys(errors).forEach(key => delete errors[key])

  // Client-side validation
  if (!formData.name.trim()) {
    errors.name = 'Company name is required'
    return
  }

  // Create FormData object
  const data = new FormData()
  
  // Append all form fields (only if they have actual values)
  Object.entries(formData).forEach(([key, value]) => {
    if (value && value.trim() !== '') {
      data.append(key, value.toString())
    }
  })

  // Append logo if selected
  if (logoFile.value) {
    data.append('logo', logoFile.value)
  }

  emit('submit', data)
}

// Expose method to set server errors
const setErrors = (serverErrors: Record<string, string[]>) => {
  Object.keys(serverErrors).forEach(key => {
    errors[key] = serverErrors[key][0]
  })
}

defineExpose({ setErrors })
</script>
