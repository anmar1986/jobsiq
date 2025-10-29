<template>
  <section class="bg-gray-50 py-12 sm:py-16 md:py-24">
    <div class="container-custom">
      <div class="text-center mb-12 sm:mb-16">
        <h2 class="text-2xl sm:text-3xl md:text-4xl font-bold text-gray-900 mb-3 sm:mb-4">How It Works</h2>
        <p class="text-base sm:text-lg md:text-xl text-gray-600 max-w-2xl mx-auto px-4">
          Get hired in 3 simple steps
        </p>
      </div>

      <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-8 md:gap-12">
        <div v-for="(step, index) in steps" :key="step.title" class="text-center">
          <div class="relative mb-4 sm:mb-6">
            <div class="w-16 h-16 sm:w-20 sm:h-20 mx-auto bg-gradient-to-br from-primary-500 to-secondary-500 rounded-full flex items-center justify-center text-white text-xl sm:text-2xl font-bold shadow-lg">
              {{ index + 1 }}
            </div>
            <div v-if="index < steps.length - 1" class="hidden md:block absolute top-8 sm:top-10 left-1/2 w-full h-0.5 bg-gray-300" style="transform: translateX(50%)"></div>
          </div>
          <h3 class="text-lg sm:text-xl font-semibold text-gray-900 mb-2 sm:mb-3">{{ step.title }}</h3>
          <p class="text-sm sm:text-base text-gray-600 px-4 sm:px-0">{{ step.description }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
const steps = [
  {
    title: 'Create Account',
    description: 'Sign up for free and build your professional profile in minutes',
  },
  {
    title: 'Search & Apply',
    description: 'Browse thousands of jobs and apply to positions that match your skills',
  },
  {
    title: 'Get Hired',
    description: 'Connect with employers and land your dream job',
  },
]
</script>
