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
          <h2 class="text-2xl font-bold text-gray-900">{{ $t('auth.checkYourEmail') }}</h2>
          <p class="text-gray-600">
            {{ $t('auth.resetLinkSent', { email: formData.email }) }}
          </p>
          <div class="pt-4">
            <BaseButton
              variant="outline"
              full-width
              @click="router.push('/login')"
            >
              {{ $t('auth.backToLogin') }}
            </BaseButton>
          </div>
        </div>

        <!-- Form State -->
        <form v-else @submit.prevent="handleSubmit" class="space-y-6">
          <div class="text-center">
            <h2 class="text-2xl font-bold text-gray-900">{{ $t('auth.forgotPassword') }}</h2>
            <p class="mt-2 text-sm text-gray-600">
              {{ $t('auth.forgotPasswordMessage') }}
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
              :label="$t('auth.email')"
              :placeholder="$t('auth.emailPlaceholder')"
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
          </div>

          <BaseButton
            type="submit"
            variant="primary"
            size="lg"
            :loading="loading"
            full-width
          >
            {{ $t('auth.sendResetLink') }}
          </BaseButton>

          <div class="text-center">
            <router-link to="/login" class="text-sm text-primary-600 hover:text-primary-700 font-medium">
              {{ $t('auth.backToLoginArrow') }}
            </router-link>
          </div>
        </form>
      </BaseCard>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { authService } from '@/services/auth.service'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseAlert from '@/components/base/BaseAlert.vue'

const router = useRouter()
const { t: $t } = useI18n()

const formData = reactive({
  email: '',
})

const errors = reactive({
  email: '',
})

const error = ref('')
const showError = ref(false)
const loading = ref(false)
const isSuccess = ref(false)

const validateForm = (): boolean => {
  errors.email = ''

  if (!formData.email) {
    errors.email = $t('validation.emailRequired')
    return false
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
    errors.email = $t('validation.emailInvalid')
    return false
  }

  return true
}

const handleSubmit = async () => {
  if (!validateForm()) return
  
  loading.value = true
  error.value = ''
  
  try {
    await authService.forgotPassword(formData.email)
    isSuccess.value = true
  } catch (err: unknown) {
    const errorMessage = err && typeof err === 'object' && 'response' in err
      ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
      : undefined
    error.value = errorMessage || $t('auth.resetLinkFailed')
    showError.value = true
  } finally {
    loading.value = false
  }
}
</script>
