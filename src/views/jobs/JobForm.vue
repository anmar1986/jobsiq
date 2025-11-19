<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <!-- No Company Warning -->
    <div v-if="!userCompanies || userCompanies.length === 0" class="bg-white p-6 rounded-lg border border-gray-200">
      <div class="text-center py-8">
        <svg class="h-16 w-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
        </svg>
        <h4 class="text-lg font-semibold text-gray-900 mb-2">{{ $t('jobs.noCompanyProfileYet') }}</h4>
        <p class="text-gray-600 mb-4">{{ $t('jobs.needCompanyToPostJobs') }}</p>
        <router-link to="/companies/create" class="inline-block">
          <BaseButton
            type="button"
            variant="primary"
          >
            {{ $t('company.createYourCompany') }}
          </BaseButton>
        </router-link>
      </div>
    </div>

    <!-- Job Details Section -->
    <div v-if="userCompanies && userCompanies.length > 0" class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">{{ $t('jobs.jobDetails') }}</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div class="md:col-span-2">
          <BaseInput
            v-model="formData.title"
            :label="$t('jobs.jobTitle') + ' *'"
            :placeholder="$t('jobs.jobTitlePlaceholder')"
            :error="errors.title"
            required
          />
        </div>

        <div class="md:col-span-2">
          <label class="block text-sm font-medium text-gray-700 mb-1">
            {{ $t('jobs.description') }} *
          </label>
          <textarea
            v-model="formData.description"
            rows="6"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            :class="{ 'border-red-500': errors.description }"
            :placeholder="$t('jobs.descriptionPlaceholder')"
            required
            @invalid="handleInvalid"
            @input="handleInput"
          />
          <p v-if="errors.description" class="text-red-600 text-sm mt-1">{{ errors.description }}</p>
        </div>

        <div class="md:col-span-2">
          <label class="block text-sm font-medium text-gray-700 mb-1">
            {{ $t('jobs.requirements') }}
          </label>
          <textarea
            v-model="formData.requirements"
            rows="4"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            :placeholder="$t('jobs.requirementsPlaceholder')"
          />
          <p v-if="errors.requirements" class="text-red-600 text-sm mt-1">{{ errors.requirements }}</p>
        </div>

        <div class="md:col-span-2">
          <label class="block text-sm font-medium text-gray-700 mb-1">
            {{ $t('jobs.benefits') }}
          </label>
          <textarea
            v-model="formData.benefits"
            rows="4"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            :placeholder="$t('jobs.benefitsPlaceholder')"
          />
          <p v-if="errors.benefits" class="text-red-600 text-sm mt-1">{{ errors.benefits }}</p>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            {{ $t('jobs.category') }} *
          </label>
          <select
            v-model="formData.category"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            :class="{ 'border-red-500': errors.category }"
            required
            @invalid="handleInvalid"
            @change="handleInput"
          >
            <option value="">{{ $t('jobs.selectCategory') }}</option>
            <option v-for="category in jobCategories" :key="category" :value="category">
              {{ category }}
            </option>
          </select>
          <p v-if="errors.category" class="text-red-600 text-sm mt-1">{{ errors.category }}</p>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            {{ $t('jobs.employmentType') }} *
          </label>
          <select
            v-model="formData.employment_type"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            :class="{ 'border-red-500': errors.employment_type }"
            required
            @invalid="handleInvalid"
            @change="handleInput"
          >
            <option value="">{{ $t('jobs.selectType') }}</option>
            <option value="full-time">{{ $t('jobs.fullTime') }}</option>
            <option value="part-time">{{ $t('jobs.partTime') }}</option>
            <option value="contract">{{ $t('jobs.contract') }}</option>
            <option value="freelance">{{ $t('jobs.freelance') }}</option>
            <option value="internship">{{ $t('jobs.internship') }}</option>
          </select>
          <p v-if="errors.employment_type" class="text-red-600 text-sm mt-1">{{ errors.employment_type }}</p>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            {{ $t('jobs.experienceLevel') }}
          </label>
          <select
            v-model="formData.experience_level"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          >
            <option value="">{{ $t('jobs.selectLevel') }}</option>
            <option v-for="level in EXPERIENCE_LEVELS" :key="level.value" :value="level.value">
              {{ level.label }}
            </option>
          </select>
        </div>
      </div>
    </div>

    <!-- Address Section -->
    <div v-if="userCompanies && userCompanies.length > 0" class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">{{ $t('jobs.address') }}</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div class="md:col-span-2">
          <BaseInput
            v-model="formData.street"
            :label="$t('jobs.streetAddress')"
            :placeholder="$t('jobs.streetAddressPlaceholder')"
            :error="errors.street"
          />
        </div>

        <BaseAutocomplete
          v-model="formData.city"
          :options="iraqCities"
          :label="$t('common.city')"
          :placeholder="$t('jobs.typeToSearchCities')"
          required
          :error="errors.city"
        />

        <BaseInput
          v-model="formData.country"
          :label="$t('common.country')"
          value="Iraq"
          readonly
          :error="errors.country"
        />

        <div class="md:col-span-2">
          <label class="flex items-center gap-2">
            <input
              type="checkbox"
              v-model="formData.is_remote"
              class="w-4 h-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
            />
            <span class="text-sm font-medium text-gray-700">{{ $t('jobs.isRemotePosition') }}</span>
          </label>
        </div>
      </div>
    </div>

    <!-- Salary Section -->
    <div v-if="userCompanies && userCompanies.length > 0" class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">{{ $t('jobs.salary') }} ({{ $t('common.optional') }})</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <BaseInput
          v-model="formData.salary_min"
          :label="$t('jobs.minimumSalary')"
          type="number"
          min="0"
          :placeholder="$t('jobs.salaryPlaceholder')"
          :error="errors.salary_min"
        />

        <BaseInput
          v-model="formData.salary_max"
          :label="$t('jobs.maximumSalary')"
          type="number"
          min="0"
          :placeholder="$t('jobs.maxSalaryPlaceholder')"
          :error="errors.salary_max"
        />

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            {{ $t('common.currency') }}
          </label>
          <select
            v-model="formData.salary_currency"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          >
            <option value="IQD">IQD - Iraqi Dinar</option>
            <option value="USD">USD - US Dollar</option>
          </select>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            {{ $t('jobs.period') }}
          </label>
          <select
            v-model="formData.salary_period"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          >
            <option value="yearly">{{ $t('jobs.perYear') }}</option>
            <option value="monthly">{{ $t('jobs.perMonth') }}</option>
            <option value="hourly">{{ $t('jobs.perHour') }}</option>
          </select>
        </div>
      </div>
    </div>

    <!-- Skills Section -->
    <div v-if="userCompanies && userCompanies.length > 0" class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">{{ $t('jobs.requiredSkills') }}</h3>
      
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-2">
          {{ $t('jobs.addSkillsHint') }}
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
          :placeholder="$t('jobs.skillsPlaceholder')"
        />
      </div>
    </div>

    <!-- Additional Options -->
    <div v-if="userCompanies && userCompanies.length > 0" class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">{{ $t('jobs.additionalOptions') }}</h3>
      
      <div class="space-y-3">
        <label class="flex items-center gap-2">
          <input
            type="checkbox"
            v-model="formData.is_featured"
            class="w-4 h-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
          />
          <span class="text-sm font-medium text-gray-700">{{ $t('jobs.featureThisJob') }}</span>
        </label>
        
        <label class="flex items-center gap-2">
          <input
            type="checkbox"
            v-model="formData.is_active"
            class="w-4 h-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
          />
          <span class="text-sm font-medium text-gray-700">{{ $t('jobs.activeVisibleToJobSeekers') }}</span>
        </label>

        <div class="mt-4 p-3 bg-blue-50 border border-blue-200 rounded-lg">
          <p class="text-sm text-blue-800">
            <svg class="inline h-4 w-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            {{ $t('jobs.autoExpireIn30Days') }}
          </p>
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
        {{ $t('common.cancel') }}
      </BaseButton>
      <BaseButton
        type="submit"
        variant="primary"
        :loading="loading"
      >
        {{ isEdit ? $t('jobs.updateJob') : $t('jobs.postJobButton') }}
      </BaseButton>
    </div>
  </form>
</template>

<script setup lang="ts">
import { ref, reactive, watch, computed } from 'vue'
import { useI18n } from 'vue-i18n'
import type { Job, Company } from '@/types'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseAutocomplete from '@/components/base/BaseAutocomplete.vue'
import { JOB_CATEGORIES, EXPERIENCE_LEVELS } from '@/config/constants'
import { iraqCities } from '@/config/iraqCities'

const { t } = useI18n()

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

const isEdit = computed(() => !!props.job)
const skillInput = ref('')
const jobCategories = JOB_CATEGORIES

// Validation handler
const handleInvalid = (e: Event) => {
  const target = e.target as HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement
  if (target.validity.valueMissing) {
    target.setCustomValidity(t('validation.fieldRequired'))
  }
}

const handleInput = (e: Event) => {
  const target = e.target as HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement
  target.setCustomValidity('')
}

// Calculate expiration date (30 days from now)
const getExpirationDate = () => {
  const date = new Date()
  date.setDate(date.getDate() + 30)
  return date.toISOString().split('T')[0]
}

const formData = reactive({
  company_id: '',
  title: '',
  description: '',
  requirements: '',
  benefits: '',
  street: '',
  city: '',
  country: 'Iraq',
  employment_type: '',
  experience_level: '',
  category: '',
  salary_min: '',
  salary_max: '',
  salary_currency: 'IQD',
  salary_period: 'monthly',
  is_remote: false,
  is_featured: false,
  is_active: true,
  skills: [] as string[],
  expires_at: getExpirationDate(),
})

const errors = reactive<Record<string, string>>({})

// Auto-select company if only one exists
watch(() => props.userCompanies, (companies) => {
  if (companies && companies.length === 1 && !formData.company_id) {
    formData.company_id = companies[0].id.toString()
  }
}, { immediate: true })

// Initialize form with existing job data if editing
watch(() => props.job, (job) => {
  if (job) {
    const expiresAt = job.expires_at 
      ? new Date(job.expires_at).toISOString().split('T')[0] 
      : getExpirationDate()
    
    const formDataToAssign = {
      company_id: job.company_id?.toString() || '',
      title: job.title || '',
      description: job.description || '',
      requirements: job.requirements || '',
      benefits: job.benefits || '',
      street: job.location || '', // Use location as street for backward compatibility
      city: job.city || '',
      country: job.country || 'Iraq',
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
      skills: Array.isArray(job.skills) ? job.skills : [],
      expires_at: expiresAt,
    }
    Object.assign(formData, formDataToAssign)
  }
}, { immediate: true, deep: true })

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
    errors.company_id = t('jobs.pleaseSelectCompany')
    return
  }
  if (!formData.title.trim()) {
    errors.title = t('jobs.jobTitleRequired')
    return
  }
  if (!formData.description.trim()) {
    errors.description = t('jobs.jobDescriptionRequired')
    return
  }
  if (!formData.city.trim()) {
    errors.city = t('jobs.cityRequired')
    return
  }
  if (!formData.employment_type) {
    errors.employment_type = t('jobs.employmentTypeRequired')
    return
  }
  if (!formData.category) {
    errors.category = t('jobs.categoryRequired')
    return
  }

  // Validate salary if both min and max are provided
  if (formData.salary_min && formData.salary_max) {
    const minSalary = parseFloat(formData.salary_min)
    const maxSalary = parseFloat(formData.salary_max)
    if (maxSalary < minSalary) {
      errors.salary_max = t('validation.maxSalaryMustBeGreaterThanMin')
      return
    }
  }

  // Prepare location string from street and city
  const locationParts = [formData.street, formData.city].filter(Boolean)
  const location = locationParts.join(', ')

  // Ensure expiration date is set (30 days from now if not already set)
  if (!formData.expires_at) {
    formData.expires_at = getExpirationDate()
  }

  // Prepare data
  const data = {
    company_id: parseInt(formData.company_id),
    title: formData.title,
    description: formData.description,
    requirements: formData.requirements || undefined,
    benefits: formData.benefits || undefined,
    location: location || formData.city, // Use combined street + city, or just city
    city: formData.city,
    country: formData.country,
    employment_type: formData.employment_type,
    experience_level: formData.experience_level || undefined,
    category: formData.category,
    salary_min: formData.salary_min ? parseFloat(formData.salary_min) : undefined,
    salary_max: formData.salary_max ? parseFloat(formData.salary_max) : undefined,
    salary_currency: formData.salary_currency,
    salary_period: formData.salary_period,
    is_remote: formData.is_remote,
    is_featured: formData.is_featured,
    is_active: formData.is_active,
    skills: formData.skills.length > 0 ? formData.skills : undefined,
    expires_at: formData.expires_at, // Always send expiration date
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
