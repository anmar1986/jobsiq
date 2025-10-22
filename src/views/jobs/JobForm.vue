<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <!-- Company Selection -->
    <div class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">Company *</h3>
      
      <div v-if="!userCompanies || userCompanies.length === 0" class="text-center py-8">
        <svg class="h-16 w-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
        </svg>
        <h4 class="text-lg font-semibold text-gray-900 mb-2">No Companies Yet</h4>
        <p class="text-gray-600 mb-4">You need to create a company before posting a job.</p>
        <router-link to="/companies/create" class="inline-block">
          <BaseButton
            type="button"
            variant="primary"
          >
            Create Your Company
          </BaseButton>
        </router-link>
      </div>

      <div v-else>
        <label class="block text-sm font-medium text-gray-700 mb-2">
          Select Company *
        </label>
        <select
          v-model="formData.company_id"
          class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          :class="{ 'border-red-500': errors.company_id }"
          required
        >
          <option value="">Choose a company</option>
          <option
            v-for="company in userCompanies"
            :key="company.id"
            :value="company.id"
          >
            {{ company.name }}
          </option>
        </select>
        <p v-if="errors.company_id" class="text-red-600 text-sm mt-1">{{ errors.company_id }}</p>
      </div>
    </div>

    <!-- Job Details Section -->
    <div v-if="userCompanies && userCompanies.length > 0" class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">Job Details</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div class="md:col-span-2">
          <BaseInput
            v-model="formData.title"
            label="Job Title *"
            placeholder="e.g. Senior Frontend Developer"
            :error="errors.title"
            required
          />
        </div>

        <div class="md:col-span-2">
          <label class="block text-sm font-medium text-gray-700 mb-1">
            Job Description *
          </label>
          <textarea
            v-model="formData.description"
            rows="6"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            :class="{ 'border-red-500': errors.description }"
            placeholder="Describe the role, responsibilities, and what makes this position unique..."
            required
          />
          <p v-if="errors.description" class="text-red-600 text-sm mt-1">{{ errors.description }}</p>
        </div>

        <div class="md:col-span-2">
          <label class="block text-sm font-medium text-gray-700 mb-1">
            Requirements
          </label>
          <textarea
            v-model="formData.requirements"
            rows="4"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            placeholder="List the required qualifications, experience, and skills..."
          />
          <p v-if="errors.requirements" class="text-red-600 text-sm mt-1">{{ errors.requirements }}</p>
        </div>

        <BaseInput
          v-model="formData.category"
          label="Category"
          placeholder="e.g. Technology, Marketing, Sales"
          :error="errors.category"
        />

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            Employment Type *
          </label>
          <select
            v-model="formData.employment_type"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            :class="{ 'border-red-500': errors.employment_type }"
            required
          >
            <option value="">Select type</option>
            <option value="full-time">Full-time</option>
            <option value="part-time">Part-time</option>
            <option value="contract">Contract</option>
            <option value="freelance">Freelance</option>
            <option value="internship">Internship</option>
          </select>
          <p v-if="errors.employment_type" class="text-red-600 text-sm mt-1">{{ errors.employment_type }}</p>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            Experience Level
          </label>
          <select
            v-model="formData.experience_level"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          >
            <option value="">Select level</option>
            <option value="entry">Entry Level</option>
            <option value="junior">Junior</option>
            <option value="mid">Mid-level</option>
            <option value="senior">Senior</option>
            <option value="lead">Lead</option>
          </select>
        </div>
      </div>
    </div>

    <!-- Location Section -->
    <div v-if="userCompanies && userCompanies.length > 0" class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">Location</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div class="md:col-span-2">
          <BaseInput
            v-model="formData.location"
            label="Location *"
            placeholder="e.g. San Francisco, CA or Remote"
            :error="errors.location"
            required
          />
        </div>

        <BaseInput
          v-model="formData.city"
          label="City"
          placeholder="San Francisco"
          :error="errors.city"
        />

        <BaseInput
          v-model="formData.country"
          label="Country"
          placeholder="United States"
          :error="errors.country"
        />

        <div class="md:col-span-2">
          <label class="flex items-center gap-2">
            <input
              type="checkbox"
              v-model="formData.is_remote"
              class="w-4 h-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
            />
            <span class="text-sm font-medium text-gray-700">This is a remote position</span>
          </label>
        </div>
      </div>
    </div>

    <!-- Salary Section -->
    <div v-if="userCompanies && userCompanies.length > 0" class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">Salary (Optional)</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <BaseInput
          v-model="formData.salary_min"
          label="Minimum Salary"
          type="number"
          min="0"
          placeholder="50000"
          :error="errors.salary_min"
        />

        <BaseInput
          v-model="formData.salary_max"
          label="Maximum Salary"
          type="number"
          min="0"
          placeholder="80000"
          :error="errors.salary_max"
        />

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            Currency
          </label>
          <select
            v-model="formData.salary_currency"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          >
            <option value="USD">USD - US Dollar</option>
            <option value="EUR">EUR - Euro</option>
            <option value="GBP">GBP - British Pound</option>
            <option value="CAD">CAD - Canadian Dollar</option>
            <option value="AUD">AUD - Australian Dollar</option>
            <option value="IQD">IQD - Iraqi Dinar</option>
          </select>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            Period
          </label>
          <select
            v-model="formData.salary_period"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          >
            <option value="yearly">Per Year</option>
            <option value="monthly">Per Month</option>
            <option value="hourly">Per Hour</option>
          </select>
        </div>
      </div>
    </div>

    <!-- Skills Section -->
    <div v-if="userCompanies && userCompanies.length > 0" class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">Required Skills</h3>
      
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-2">
          Add Skills (press Enter after each skill)
        </label>
        <div class="flex flex-wrap gap-2 mb-3">
          <span
            v-for="(skill, index) in formData.skills"
            :key="index"
            class="inline-flex items-center gap-1 px-3 py-1 bg-primary-100 text-primary-700 rounded-full text-sm"
          >
            {{ skill }}
            <button
              type="button"
              @click="removeSkill(index)"
              class="hover:text-primary-900"
            >
              <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </span>
        </div>
        <input
          v-model="skillInput"
          type="text"
          @keydown.enter.prevent="addSkill"
          class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          placeholder="e.g. JavaScript, React, Node.js (press Enter)"
        />
      </div>
    </div>

    <!-- Additional Options -->
    <div v-if="userCompanies && userCompanies.length > 0" class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">Additional Options</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <BaseInput
          v-model="formData.expires_at"
          label="Expiration Date"
          type="date"
          :error="errors.expires_at"
        />

        <div class="space-y-3">
          <label class="flex items-center gap-2">
            <input
              type="checkbox"
              v-model="formData.is_featured"
              class="w-4 h-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
            />
            <span class="text-sm font-medium text-gray-700">Feature this job</span>
          </label>
          
          <label class="flex items-center gap-2">
            <input
              type="checkbox"
              v-model="formData.is_active"
              class="w-4 h-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
            />
            <span class="text-sm font-medium text-gray-700">Active (visible to job seekers)</span>
          </label>
        </div>
      </div>
    </div>

    <!-- Form Actions -->
    <div v-if="userCompanies && userCompanies.length > 0" class="flex items-center justify-end gap-3 pt-4 border-t border-gray-200">
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
        {{ isEdit ? 'Update Job' : 'Post Job' }}
      </BaseButton>
    </div>
  </form>
</template>

<script setup lang="ts">
import { ref, reactive, watch } from 'vue'
import type { Job, Company } from '@/types'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'

interface Props {
  job?: Job
  userCompanies?: Company[]
  loading?: boolean
}

const props = defineProps<Props>()
const emit = defineEmits<{
  submit: [data: Record<string, unknown>]
  cancel: []
}>()

const isEdit = ref(!!props.job)
const skillInput = ref('')

const formData = reactive({
  company_id: '',
  title: '',
  description: '',
  requirements: '',
  location: '',
  city: '',
  country: '',
  employment_type: '',
  experience_level: '',
  category: '',
  salary_min: '',
  salary_max: '',
  salary_currency: 'USD',
  salary_period: 'yearly',
  is_remote: false,
  is_featured: false,
  is_active: true,
  skills: [] as string[],
  expires_at: '',
})

const errors = reactive<Record<string, string>>({})

// Initialize form with existing job data if editing
watch(() => props.job, (job) => {
  if (job) {
    Object.assign(formData, {
      company_id: job.company_id?.toString() || '',
      title: job.title || '',
      description: job.description || '',
      requirements: job.requirements || '',
      location: job.location || '',
      city: job.city || '',
      country: job.country || '',
      employment_type: job.employment_type || '',
      experience_level: job.experience_level || '',
      category: job.category || '',
      salary_min: job.salary_min?.toString() || '',
      salary_max: job.salary_max?.toString() || '',
      salary_currency: job.salary_currency || 'USD',
      salary_period: job.salary_period || 'yearly',
      is_remote: job.is_remote || false,
      is_featured: job.is_featured || false,
      is_active: job.is_active !== false,
      skills: job.skills || [],
      expires_at: job.expires_at || '',
    })
  }
}, { immediate: true })

const addSkill = () => {
  const skill = skillInput.value.trim()
  if (skill && !formData.skills.includes(skill)) {
    formData.skills.push(skill)
    skillInput.value = ''
  }
}

const removeSkill = (index: number) => {
  formData.skills.splice(index, 1)
}

const handleSubmit = () => {
  // Clear previous errors
  Object.keys(errors).forEach(key => delete errors[key])

  // Client-side validation
  if (!formData.company_id) {
    errors.company_id = 'Please select a company'
    return
  }
  if (!formData.title.trim()) {
    errors.title = 'Job title is required'
    return
  }
  if (!formData.description.trim()) {
    errors.description = 'Job description is required'
    return
  }
  if (!formData.location.trim()) {
    errors.location = 'Location is required'
    return
  }
  if (!formData.employment_type) {
    errors.employment_type = 'Employment type is required'
    return
  }

  // Prepare data
  const data = {
    company_id: parseInt(formData.company_id),
    title: formData.title,
    description: formData.description,
    requirements: formData.requirements || undefined,
    location: formData.location,
    city: formData.city || undefined,
    country: formData.country || undefined,
    employment_type: formData.employment_type,
    experience_level: formData.experience_level || undefined,
    category: formData.category || undefined,
    salary_min: formData.salary_min ? parseFloat(formData.salary_min) : undefined,
    salary_max: formData.salary_max ? parseFloat(formData.salary_max) : undefined,
    salary_currency: formData.salary_currency,
    salary_period: formData.salary_period,
    is_remote: formData.is_remote,
    is_featured: formData.is_featured,
    is_active: formData.is_active,
    skills: formData.skills.length > 0 ? formData.skills : undefined,
    expires_at: formData.expires_at || undefined,
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
