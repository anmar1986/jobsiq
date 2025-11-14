<template>
  <BaseCard class="w-full max-w-md">
    <form @submit.prevent="handleSubmit" class="space-y-6">
      <div class="text-center">
        <h2 class="text-2xl font-bold text-gray-900">Welcome Back</h2>
        <p class="mt-2 text-sm text-gray-600">
          {{ accountType === 'job_seeker' ? 'Sign in to find your dream job' : 'Sign in to manage your company' }}
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
        <BaseInput
          v-model="formData.email"
          type="email"
          label="Email Address"
          placeholder="john@example.com"
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
          placeholder="Enter your password"
          :error="errors.password"
          required
          autocomplete="current-password"
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

        <div class="flex items-center justify-between">
          <label class="flex items-center gap-2 cursor-pointer">
            <input
              v-model="formData.remember"
              type="checkbox"
              class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
            />
            <span class="text-sm text-gray-700">Remember me</span>
          </label>
          <router-link to="/forgot-password" class="text-sm text-primary-600 hover:text-primary-700 font-medium">
            Forgot password?
          </router-link>
        </div>
      </div>

      <BaseButton
        type="submit"
        variant="primary"
        size="lg"
        :loading="loading"
        full-width
      >
        Sign In
      </BaseButton>

      <div class="text-center text-sm text-gray-600">
        Don't have an account?
        <router-link to="/register" class="text-primary-600 hover:text-primary-700 font-medium">
          Sign up for free
        </router-link>
      </div>
    </form>
  </BaseCard>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseAlert from '@/components/base/BaseAlert.vue'
import type { LoginForm } from '@/types'

interface Props {
  accountType: 'job_seeker' | 'company_owner'
}

defineProps<Props>()

const router = useRouter()
const authStore = useAuthStore()

const formData = reactive<LoginForm>({
  email: '',
  password: '',
  remember: false,
})

const errors = reactive({
  email: '',
  password: '',
})

const error = ref('')
const showError = ref(false)
const loading = ref(false)
const showPassword = ref(false)

const validateForm = (): boolean => {
  let isValid = true
  
  // Reset errors
  errors.email = ''
  errors.password = ''
  
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
  } else if (formData.password.length < 6) {
    errors.password = 'Password must be at least 6 characters'
    isValid = false
  }
  
  return isValid
}

const handleSubmit = async () => {
  if (!validateForm()) return
  
  loading.value = true
  error.value = ''
  
  try {
    const response = await authStore.login(formData)
    
    // Check if there's a redirect query parameter
    const redirectPath = router.currentRoute.value.query.redirect as string
    
    // Use redirect_to from API response, or fall back to query param or default
    const destination = response?.data?.redirect_to || redirectPath || '/dashboard'
    
    router.push(destination)
  } catch (err: unknown) {
    const errorMessage = err && typeof err === 'object' && 'response' in err
      ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
      : undefined
    error.value = errorMessage || 'Invalid email or password. Please try again.'
    showError.value = true
  } finally {
    loading.value = false
  }
}
</script>
