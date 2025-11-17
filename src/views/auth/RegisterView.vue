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
      
      <!-- Account Type Switcher -->
      <div class="mb-6">
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-1 flex gap-1">
          <button
            @click="accountType = 'job_seeker'"
            :class="[
              'flex-1 px-4 py-3 rounded-md text-sm font-medium transition-all duration-200 cursor-pointer',
              accountType === 'job_seeker'
                ? 'bg-primary-600 text-white shadow-sm'
                : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
            ]"
          >
            <div class="flex items-center justify-center gap-2">
              <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
              </svg>
              <span>{{ $t('auth.imJobSeeker') }}</span>
            </div>
          </button>
          <button
            @click="accountType = 'company_owner'"
            :class="[
              'flex-1 px-4 py-3 rounded-md text-sm font-medium transition-all duration-200 cursor-pointer',
              accountType === 'company_owner'
                ? 'bg-primary-600 text-white shadow-sm'
                : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50'
            ]"
          >
            <div class="flex items-center justify-center gap-2">
              <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
              </svg>
              <span>{{ $t('auth.imCompany') }}</span>
            </div>
          </button>
        </div>
      </div>

      <RegisterForm :account-type="accountType" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import RegisterForm from '@/components/features/auth/RegisterForm.vue'

const { t: $t } = useI18n()
const accountType = ref<'job_seeker' | 'company_owner'>('job_seeker')
</script>
