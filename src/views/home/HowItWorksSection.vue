<template>
  <section class="bg-gray-50 py-12 sm:py-16 md:py-24">
    <div class="container-custom">
      <div class="text-center mb-12 sm:mb-16">
        <h2 class="text-2xl sm:text-3xl md:text-4xl font-bold text-gray-900 mb-3 sm:mb-4">{{ $t('home.howItWorks') }}</h2>
        <p class="text-base sm:text-lg md:text-xl text-gray-600 max-w-2xl mx-auto px-4">
          {{ $t('home.howItWorksSubtitle') }}
        </p>
      </div>

      <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-8 md:gap-12">
        <div v-for="(step, index) in steps" :key="index" class="text-center">
          <div class="relative mb-4 sm:mb-6">
            <div class="w-16 h-16 sm:w-20 sm:h-20 mx-auto bg-gradient-to-br from-primary-500 to-secondary-500 rounded-full flex items-center justify-center text-white text-xl sm:text-2xl font-bold shadow-lg">
              {{ index + 1 }}
            </div>
          </div>
          <h3 class="text-lg sm:text-xl font-semibold text-gray-900 mb-2 sm:mb-3">{{ $t(step.title) }}</h3>
          <p class="text-sm sm:text-base text-gray-600 px-4 sm:px-0">{{ $t(step.description) }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
const steps = [
  {
    title: 'home.stepCreateTitle',
    description: 'home.stepCreateDesc',
  },
  {
    title: 'home.stepSearchTitle',
    description: 'home.stepSearchDesc',
  },
  {
    title: 'home.stepHiredTitle',
    description: 'home.stepHiredDesc',
  },
]
</script>
