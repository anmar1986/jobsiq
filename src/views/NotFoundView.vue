<template>
  <div class="min-h-screen bg-gradient-to-br from-gray-50 via-white to-gray-100 flex items-center justify-center px-4 sm:px-6 lg:px-8">
    <div class="max-w-4xl w-full">
      <div class="text-center">
        <!-- Animated 404 Illustration -->
        <div class="relative mb-8">
          <!-- Large 404 with gradient -->
          <h1 class="text-[150px] sm:text-[200px] font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-primary-600 to-secondary-600 leading-none select-none">
            404
          </h1>
          
          <!-- Floating decoration elements -->
          <div class="absolute top-0 left-1/2 -translate-x-1/2 w-full">
            <div class="relative h-48 sm:h-64">
              <!-- Floating icons -->
              <div class="absolute top-0 left-1/4 animate-float">
                <svg class="h-12 w-12 text-primary-400 opacity-60" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                </svg>
              </div>
              <div class="absolute top-8 right-1/4 animate-float-delayed">
                <svg class="h-10 w-10 text-secondary-400 opacity-50" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
                </svg>
              </div>
              <div class="absolute top-12 left-1/2 animate-float-slow">
                <svg class="h-8 w-8 text-indigo-400 opacity-40" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
              </div>
            </div>
          </div>
        </div>

        <!-- Error Message -->
        <div class="mb-10">
          <h2 class="text-2xl sm:text-3xl md:text-4xl font-bold text-gray-900 mb-3">
            Oops! Page Not Found
          </h2>
          <p class="text-base sm:text-lg text-gray-600 max-w-2xl mx-auto">
            The page you're looking for doesn't exist or has been moved. Don't worry, it happens to the best of us!
          </p>
        </div>

        <!-- Quick Actions -->
        <div class="mb-10">
          <p class="text-sm font-semibold text-gray-700 mb-4 uppercase tracking-wide">Quick Links</p>
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 max-w-4xl mx-auto">
            <!-- Home -->
            <router-link
              to="/"
              class="group p-4 bg-white border-2 border-gray-200 rounded-lg hover:border-primary-500 hover:shadow-lg transition-all duration-200"
            >
              <div class="flex flex-col items-center text-center">
                <div class="w-12 h-12 bg-primary-100 rounded-lg flex items-center justify-center mb-3 group-hover:bg-primary-200 transition-colors">
                  <svg class="h-6 w-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
                  </svg>
                </div>
                <span class="font-semibold text-gray-900 group-hover:text-primary-600 transition-colors">Home</span>
                <span class="text-xs text-gray-500 mt-1">Back to homepage</span>
              </div>
            </router-link>

            <!-- Jobs -->
            <router-link
              to="/jobs"
              class="group p-4 bg-white border-2 border-gray-200 rounded-lg hover:border-primary-500 hover:shadow-lg transition-all duration-200"
            >
              <div class="flex flex-col items-center text-center">
                <div class="w-12 h-12 bg-secondary-100 rounded-lg flex items-center justify-center mb-3 group-hover:bg-secondary-200 transition-colors">
                  <svg class="h-6 w-6 text-secondary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                  </svg>
                </div>
                <span class="font-semibold text-gray-900 group-hover:text-primary-600 transition-colors">Browse Jobs</span>
                <span class="text-xs text-gray-500 mt-1">Find opportunities</span>
              </div>
            </router-link>

            <!-- Companies -->
            <router-link
              to="/companies"
              class="group p-4 bg-white border-2 border-gray-200 rounded-lg hover:border-primary-500 hover:shadow-lg transition-all duration-200"
            >
              <div class="flex flex-col items-center text-center">
                <div class="w-12 h-12 bg-indigo-100 rounded-lg flex items-center justify-center mb-3 group-hover:bg-indigo-200 transition-colors">
                  <svg class="h-6 w-6 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
                  </svg>
                </div>
                <span class="font-semibold text-gray-900 group-hover:text-primary-600 transition-colors">Companies</span>
                <span class="text-xs text-gray-500 mt-1">Explore employers</span>
              </div>
            </router-link>

            <!-- Dashboard -->
            <router-link
              v-if="authStore.isAuthenticated"
              to="/dashboard"
              class="group p-4 bg-white border-2 border-gray-200 rounded-lg hover:border-primary-500 hover:shadow-lg transition-all duration-200"
            >
              <div class="flex flex-col items-center text-center">
                <div class="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mb-3 group-hover:bg-purple-200 transition-colors">
                  <svg class="h-6 w-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 5a1 1 0 011-1h4a1 1 0 011 1v7a1 1 0 01-1 1H5a1 1 0 01-1-1V5zM14 5a1 1 0 011-1h4a1 1 0 011 1v7a1 1 0 01-1 1h-4a1 1 0 01-1-1V5zM4 16a1 1 0 011-1h4a1 1 0 011 1v3a1 1 0 01-1 1H5a1 1 0 01-1-1v-3zM14 16a1 1 0 011-1h4a1 1 0 011 1v3a1 1 0 01-1 1h-4a1 1 0 01-1-1v-3z" />
                  </svg>
                </div>
                <span class="font-semibold text-gray-900 group-hover:text-primary-600 transition-colors">Dashboard</span>
                <span class="text-xs text-gray-500 mt-1">Your account</span>
              </div>
            </router-link>

            <!-- Login/Register -->
            <router-link
              v-else
              to="/login"
              class="group p-4 bg-white border-2 border-gray-200 rounded-lg hover:border-primary-500 hover:shadow-lg transition-all duration-200"
            >
              <div class="flex flex-col items-center text-center">
                <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mb-3 group-hover:bg-green-200 transition-colors">
                  <svg class="h-6 w-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1" />
                  </svg>
                </div>
                <span class="font-semibold text-gray-900 group-hover:text-primary-600 transition-colors">Sign In</span>
                <span class="text-xs text-gray-500 mt-1">Access your account</span>
              </div>
            </router-link>
          </div>
        </div>

        <!-- Help Text -->
        <div class="max-w-2xl mx-auto">
          <div class="bg-blue-50 border border-blue-200 rounded-lg p-4">
            <div class="flex items-start gap-3">
              <svg class="h-5 w-5 text-blue-600 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <div class="text-left">
                <p class="text-sm font-medium text-blue-900 mb-1">Need Help?</p>
                <p class="text-sm text-blue-700">
                  If you believe this is an error, please contact our support team or use the search above to find what you're looking for.
                </p>
              </div>
            </div>
          </div>
        </div>

        <!-- Error Code for Support -->
        <div class="mt-8 text-xs text-gray-400">
          <p>Error Code: 404 | Page Not Found | {{ currentPath }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const route = useRoute()
const authStore = useAuthStore()

const currentPath = computed(() => route.fullPath)
</script>

<style scoped>
@keyframes float {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-20px);
  }
}

@keyframes float-delayed {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-15px);
  }
}

@keyframes float-slow {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-10px);
  }
}

.animate-float {
  animation: float 3s ease-in-out infinite;
}

.animate-float-delayed {
  animation: float-delayed 4s ease-in-out infinite;
  animation-delay: 0.5s;
}

.animate-float-slow {
  animation: float-slow 5s ease-in-out infinite;
  animation-delay: 1s;
}
</style>
