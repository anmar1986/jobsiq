<template>
  <div class="min-h-screen flex items-center justify-center bg-gradient-to-br from-primary-50 via-white to-secondary-50 px-4 py-12">
    <div class="w-full max-w-md">
      <div class="text-center mb-8">
        <router-link to="/" class="inline-flex items-center gap-2 group mb-6">
          <div class="h-12 w-12 bg-gradient-to-br from-primary-600 to-secondary-600 rounded-lg flex items-center justify-center transform group-hover:scale-105 transition-transform">
            <span class="text-white font-bold text-2xl">J</span>
          </div>
          <span class="text-3xl font-bold bg-gradient-to-r from-primary-600 to-secondary-600 bg-clip-text text-transparent">
            JobsIQ
          </span>
        </router-link>
      </div>

      <BaseCard class="w-full">
        <!-- Success State -->
        <div v-if="isSuccess" class="text-center space-y-4">
          <div class="h-16 w-16 bg-green-100 rounded-full flex items-center justify-center mx-auto">
            <svg class="h-8 w-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
          </div>
          <h2 class="text-2xl font-bold text-gray-900">Password Reset Successfully</h2>
          <p class="text-gray-600">
            Your password has been reset successfully. You can now login with your new password.
          </p>
          <div class="pt-4">
            <BaseButton
              variant="primary"
              full-width
              @click="router.push('/login')"
            >
              Go to Login
            </BaseButton>
          </div>
        </div>

        <!-- Form State -->
        <form v-else @submit.prevent="handleSubmit" class="space-y-6">
          <div class="text-center">
            <h2 class="text-2xl font-bold text-gray-900">Reset Password</h2>
            <p class="mt-2 text-sm text-gray-600">
              Please enter your new password.
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
              :disabled="true"
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
              label="New Password"
              placeholder="Enter new password"
              :error="errors.password"
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

            <BaseInput
              v-model="formData.password_confirmation"
              :type="showConfirmPassword ? 'text' : 'password'"
              label="Confirm New Password"
              placeholder="Confirm new password"
              :error="errors.password_confirmation"
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
          </div>

          <BaseButton
            type="submit"
            variant="primary"
            size="lg"
            :loading="loading"
            full-width
          >
            Reset Password
          </BaseButton>

          <div class="text-center">
            <router-link to="/login" class="text-sm text-primary-600 hover:text-primary-700 font-medium">
              ← Back to Login
            </router-link>
          </div>
        </form>
      </BaseCard>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { authService } from '@/services/auth.service'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseAlert from '@/components/base/BaseAlert.vue'

const router = useRouter()
const route = useRoute()

const formData = reactive({
  token: '',
  email: '',
  password: '',
  password_confirmation: '',
})

const errors = reactive({
  password: '',
  password_confirmation: '',
})

const error = ref('')
const showError = ref(false)
const loading = ref(false)
const isSuccess = ref(false)
const showPassword = ref(false)
const showConfirmPassword = ref(false)

onMounted(() => {
  // Get token and email from URL query parameters
  formData.token = (route.query.token as string) || ''
  formData.email = (route.query.email as string) || ''

  if (!formData.token || !formData.email) {
    error.value = 'Invalid or missing reset token. Please request a new password reset link.'
    showError.value = true
  }
})

const validateForm = (): boolean => {
  errors.password = ''
  errors.password_confirmation = ''
  
  if (!formData.password) {
    errors.password = 'Password is required'
    return false
  } else if (formData.password.length < 8) {
    errors.password = 'Password must be at least 8 characters'
    return false
  }
  
  if (!formData.password_confirmation) {
    errors.password_confirmation = 'Please confirm your password'
    return false
  } else if (formData.password !== formData.password_confirmation) {
    errors.password_confirmation = 'Passwords do not match'
    return false
  }
  
  return true
}

const handleSubmit = async () => {
  if (!validateForm()) return
  
  loading.value = true
  error.value = ''
  
  try {
    await authService.resetPassword({
      token: formData.token,
      email: formData.email,
      password: formData.password,
      password_confirmation: formData.password_confirmation,
    })
    isSuccess.value = true
  } catch (err: unknown) {
    const errorMessage = err && typeof err === 'object' && 'response' in err
      ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
      : undefined
    error.value = errorMessage || 'Failed to reset password. The link may have expired. Please request a new one.'
    showError.value = true
  } finally {
    loading.value = false
  }
}
</script>
