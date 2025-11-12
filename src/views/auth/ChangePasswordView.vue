<template>
  <div class="min-h-screen bg-gray-50 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8">
      <div>
        <div class="mx-auto h-12 w-12 flex items-center justify-center rounded-full bg-blue-100">
          <svg
            class="h-6 w-6 text-blue-600"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z"
            />
          </svg>
        </div>
        <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
          Change Your Password
        </h2>
        <p class="mt-2 text-center text-sm text-gray-600">
          Please enter your current password and choose a new one
        </p>
      </div>

      <form class="mt-8 space-y-6" @submit.prevent="handleSubmit">
        <div v-if="error" class="rounded-md bg-red-50 p-4">
          <div class="flex">
            <div class="flex-shrink-0">
              <svg
                class="h-5 w-5 text-red-400"
                fill="currentColor"
                viewBox="0 0 20 20"
              >
                <path
                  fill-rule="evenodd"
                  d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
                  clip-rule="evenodd"
                />
              </svg>
            </div>
            <div class="ml-3">
              <h3 class="text-sm font-medium text-red-800">{{ error }}</h3>
            </div>
          </div>
        </div>

        <div v-if="success" class="rounded-md bg-green-50 p-4">
          <div class="flex">
            <div class="flex-shrink-0">
              <svg
                class="h-5 w-5 text-green-400"
                fill="currentColor"
                viewBox="0 0 20 20"
              >
                <path
                  fill-rule="evenodd"
                  d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                  clip-rule="evenodd"
                />
              </svg>
            </div>
            <div class="ml-3">
              <h3 class="text-sm font-medium text-green-800">{{ success }}</h3>
            </div>
          </div>
        </div>

        <div class="rounded-md shadow-sm -space-y-px">
          <div>
            <label for="current-password" class="sr-only">Current Password</label>
            <input
              id="current-password"
              v-model="form.current_password"
              name="current-password"
              type="password"
              required
              class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm"
              placeholder="Current Password"
            />
          </div>
          <div>
            <label for="new-password" class="sr-only">New Password</label>
            <input
              id="new-password"
              v-model="form.password"
              name="new-password"
              type="password"
              required
              class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm"
              placeholder="New Password (min. 8 characters)"
            />
          </div>
          <div>
            <label for="confirm-password" class="sr-only">Confirm New Password</label>
            <input
              id="confirm-password"
              v-model="form.password_confirmation"
              name="confirm-password"
              type="password"
              required
              class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-b-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm"
              placeholder="Confirm New Password"
            />
          </div>
        </div>

        <div class="rounded-md bg-blue-50 p-4">
          <div class="flex">
            <div class="flex-shrink-0">
              <svg
                class="h-5 w-5 text-blue-400"
                fill="currentColor"
                viewBox="0 0 20 20"
              >
                <path
                  fill-rule="evenodd"
                  d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z"
                  clip-rule="evenodd"
                />
              </svg>
            </div>
            <div class="ml-3 flex-1 md:flex md:justify-between">
              <div class="text-sm text-blue-700">
                <p class="font-medium mb-1">Password Requirements:</p>
                <ul class="list-disc list-inside space-y-1">
                  <li>At least 8 characters long</li>
                  <li>Different from your current password</li>
                </ul>
              </div>
            </div>
          </div>
        </div>

        <div>
          <button
            type="submit"
            :disabled="loading"
            class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <span v-if="loading" class="absolute left-0 inset-y-0 flex items-center pl-3">
              <svg
                class="animate-spin h-5 w-5 text-white"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
              >
                <circle
                  class="opacity-25"
                  cx="12"
                  cy="12"
                  r="10"
                  stroke="currentColor"
                  stroke-width="4"
                ></circle>
                <path
                  class="opacity-75"
                  fill="currentColor"
                  d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                ></path>
              </svg>
            </span>
            {{ loading ? 'Changing Password...' : 'Change Password' }}
          </button>
        </div>

        <div class="text-center">
          <router-link
            :to="{ name: 'profile' }"
            class="font-medium text-blue-600 hover:text-blue-500"
          >
            Back to Profile
          </router-link>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onBeforeUnmount } from 'vue'
import { useRouter } from 'vue-router'
import { authService } from '@/services/auth.service'
import type { PasswordChangeForm } from '@/types'

const router = useRouter()

const form = reactive<PasswordChangeForm>({
  current_password: '',
  password: '',
  password_confirmation: '',
})

const loading = ref(false)
const error = ref('')
const success = ref('')
const redirectTimeoutId = ref<number | null>(null)

const handleSubmit = async () => {
  error.value = ''
  success.value = ''

  // Client-side validation
  if (form.password.length < 8) {
    error.value = 'Password must be at least 8 characters long'
    return
  }

  if (form.password !== form.password_confirmation) {
    error.value = 'Passwords do not match'
    return
  }

  if (form.password === form.current_password) {
    error.value = 'New password must be different from current password'
    return
  }

  loading.value = true

  try {
    const response = await authService.changePassword(form)
    success.value = response.message || 'Password changed successfully!'
    
    // Clear form
    form.current_password = ''
    form.password = ''
    form.password_confirmation = ''

    // Redirect to login after 2 seconds
    redirectTimeoutId.value = window.setTimeout(() => {
      router.push({ name: 'login', query: { message: 'Please login with your new password' } })
    }, 2000)
  } catch (err: any) {
    error.value = err.response?.data?.message || 'Failed to change password. Please try again.'
  } finally {
    loading.value = false
  }
}

// Clean up timeout when component is unmounted
onBeforeUnmount(() => {
  if (redirectTimeoutId.value !== null) {
    clearTimeout(redirectTimeoutId.value)
  }
})
</script>
