<template>
  <BaseCard class="w-full max-w-md">
    <form @submit.prevent="handleSubmit" class="space-y-6">
      <div class="text-center">
        <h2 class="text-2xl font-bold text-gray-900">Create Account</h2>
        <p class="mt-2 text-sm text-gray-600">
          {{ accountType === 'job_seeker' ? 'Join JobsIQ and start your career journey' : 'Register your company and find great talent' }}
        </p>
      </div>

      <BaseAlert
        v-if="error"
        v-model="showError"
        variant="error"
        dismissible
        class="animate-fade-in"
      >
        {{ error }}
      </BaseAlert>

      <div class="space-y-4">
        <!-- Job Seeker Fields -->
        <template v-if="accountType === 'job_seeker'">
          <BaseInput
            v-model="formData.name"
            type="text"
            label="Full Name"
            placeholder="John Doe"
            :error="errors.name"
            required
            autocomplete="name"
          >
            <template #icon-left>
              <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
              </svg>
            </template>
          </BaseInput>
        </template>

        <!-- Company Fields -->
        <template v-else>
          <BaseInput
            v-model="formData.company_name"
            type="text"
            label="Company Name"
            placeholder="Acme Corporation"
            :error="errors.company_name"
            required
          >
            <template #icon-left>
              <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
              </svg>
            </template>
          </BaseInput>

          <BaseInput
            v-model="formData.name"
            type="text"
            label="Your Full Name"
            placeholder="John Doe"
            :error="errors.name"
            required
            autocomplete="name"
          >
            <template #icon-left>
              <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
              </svg>
            </template>
          </BaseInput>

          <BaseInput
            v-model="formData.company_email"
            type="email"
            label="Company Email"
            placeholder="info@company.com"
            :error="errors.company_email"
            required
          >
            <template #icon-left>
              <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
              </svg>
            </template>
          </BaseInput>
        </template>

        <BaseInput
          v-model="formData.email"
          type="email"
          :label="accountType === 'company_owner' ? 'Your Email' : 'Email Address'"
          :placeholder="accountType === 'company_owner' ? 'john@company.com' : 'john@example.com'"
          :error="errors.email"
          required
          autocomplete="email"
        >
          <template #icon-left>
            <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207" />
            </svg>
          </template>
        </BaseInput>

        <BaseInput
          v-model="formData.password"
          :type="showPassword ? 'text' : 'password'"
          label="Password"
          placeholder="Create a strong password"
          :error="errors.password"
          :hint="passwordStrength.hint"
          required
          autocomplete="new-password"
        >
          <template #icon-left>
            <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
            </svg>
          </template>
          <template #icon-right>
            <button
              type="button"
              @click="showPassword = !showPassword"
              class="text-gray-400 hover:text-gray-600"
            >
              <svg v-if="!showPassword" class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
              </svg>
              <svg v-else class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
              </svg>
            </button>
          </template>
        </BaseInput>

        <!-- Password Strength Indicator -->
        <div v-if="formData.password" class="space-y-2">
          <div class="flex gap-1">
            <div
              v-for="i in 4"
              :key="i"
              class="h-1 flex-1 rounded-full transition-colors"
              :class="i <= passwordStrength.score ? passwordStrength.color : 'bg-gray-200'"
            />
          </div>
        </div>

        <BaseInput
          v-model="formData.password_confirmation"
          :type="showConfirmPassword ? 'text' : 'password'"
          label="Confirm Password"
          placeholder="Re-enter your password"
          :error="errors.password_confirmation"
          required
          autocomplete="new-password"
        >
          <template #icon-left>
            <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </template>
          <template #icon-right>
            <button
              type="button"
              @click="showConfirmPassword = !showConfirmPassword"
              class="text-gray-400 hover:text-gray-600"
            >
              <svg v-if="!showConfirmPassword" class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
              </svg>
              <svg v-else class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
              </svg>
            </button>
          </template>
        </BaseInput>

        <label class="flex items-start gap-2 cursor-pointer">
          <input
            v-model="formData.agreeToTerms"
            type="checkbox"
            class="mt-1 h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
          />
          <span class="text-sm text-gray-700">
            I agree to the
            <a href="#" class="text-primary-600 hover:text-primary-700 font-medium">Terms of Service</a>
            and
            <a href="#" class="text-primary-600 hover:text-primary-700 font-medium">Privacy Policy</a>
          </span>
        </label>
        <p v-if="errors.agreeToTerms" class="text-sm text-red-600">{{ errors.agreeToTerms }}</p>
      </div>

      <BaseButton
        type="submit"
        variant="primary"
        size="lg"
        :loading="loading"
        full-width
      >
        Create Account
      </BaseButton>

      <div class="text-center text-sm text-gray-600">
        Already have an account?
        <router-link to="/login" class="text-primary-600 hover:text-primary-700 font-medium">
          Sign in
        </router-link>
      </div>
    </form>
  </BaseCard>
</template>

<script setup lang="ts">
import { ref, reactive, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseAlert from '@/components/base/BaseAlert.vue'

interface Props {
  accountType: 'job_seeker' | 'company_owner'
}

const props = defineProps<Props>()

const router = useRouter()
const authStore = useAuthStore()

const formData = reactive<{
  name: string
  email: string
  password: string
  password_confirmation: string
  agreeToTerms: boolean
  company_name: string
  company_email: string
}>({
  name: '',
  email: '',
  password: '',
  password_confirmation: '',
  agreeToTerms: false,
  company_name: '',
  company_email: '',
})

const errors = reactive({
  name: '',
  email: '',
  password: '',
  password_confirmation: '',
  agreeToTerms: '',
  company_name: '',
  company_email: '',
})

const error = ref('')
const showError = ref(false)
const loading = ref(false)
const showPassword = ref(false)
const showConfirmPassword = ref(false)

const passwordStrength = computed(() => {
  const password = formData.password
  let score = 0
  
  if (password.length >= 8) score++
  if (/[a-z]/.test(password) && /[A-Z]/.test(password)) score++
  if (/\d/.test(password)) score++
  if (/[^A-Za-z0-9]/.test(password)) score++
  
  const strengths = [
    { hint: '', color: 'bg-gray-200' },
    { hint: 'Weak password', color: 'bg-red-500' },
    { hint: 'Fair password', color: 'bg-yellow-500' },
    { hint: 'Good password', color: 'bg-blue-500' },
    { hint: 'Strong password', color: 'bg-green-500' },
  ]
  
  return { score, ...strengths[score] }
})

const validateForm = (): boolean => {
  let isValid = true
  
  // Reset errors
  Object.keys(errors).forEach(key => {
    errors[key as keyof typeof errors] = ''
  })
  
  // Name validation
  if (!formData.name) {
    errors.name = 'Name is required'
    isValid = false
  } else if (formData.name.length < 2) {
    errors.name = 'Name must be at least 2 characters'
    isValid = false
  }

  // Company name validation (for company owners)
  if (props.accountType === 'company_owner') {
    if (!formData.company_name) {
      errors.company_name = 'Company name is required'
      isValid = false
    }
    
    if (!formData.company_email) {
      errors.company_email = 'Company email is required'
      isValid = false
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.company_email)) {
      errors.company_email = 'Please enter a valid company email'
      isValid = false
    }
  }
  
  // Email validation
  if (!formData.email) {
    errors.email = 'Email is required'
    isValid = false
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
    errors.email = 'Please enter a valid email'
    isValid = false
  }
  
  // Password validation
  if (!formData.password) {
    errors.password = 'Password is required'
    isValid = false
  } else if (formData.password.length < 8) {
    errors.password = 'Password must be at least 8 characters'
    isValid = false
  }
  
  // Password confirmation validation
  if (!formData.password_confirmation) {
    errors.password_confirmation = 'Please confirm your password'
    isValid = false
  } else if (formData.password !== formData.password_confirmation) {
    errors.password_confirmation = 'Passwords do not match'
    isValid = false
  }
  
  // Terms agreement validation
  if (!formData.agreeToTerms) {
    errors.agreeToTerms = 'You must agree to the terms and conditions'
    isValid = false
  }
  
  return isValid
}

const handleSubmit = async () => {
  if (!validateForm()) return
  
  loading.value = true
  error.value = ''
  
  try {
    const { agreeToTerms: _agreeToTerms, company_name, company_email, ...baseData } = formData
    
    // Only include company fields for company owners
    const payload = {
      ...baseData,
      user_type: props.accountType,
      ...(props.accountType === 'company_owner' && {
        company_name,
        company_email,
      }),
    }
    
    await authStore.register(payload)
    router.push('/dashboard')
  } catch (err: unknown) {
    const errorMessage = err && typeof err === 'object' && 'response' in err
      ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
      : undefined
    error.value = errorMessage || 'Registration failed. Please try again.'
    showError.value = true
  } finally {
    loading.value = false
  }
}
</script>
