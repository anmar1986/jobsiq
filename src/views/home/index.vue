<template>
  <div class="min-h-screen">
    <!-- Loading State -->
    <div v-if="loading" class="flex items-center justify-center min-h-screen">
      <div class="animate-spin rounded-full h-16 w-16 border-b-2 border-primary-600"></div>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="container-custom py-16 text-center">
      <div class="text-red-600 mb-4">{{ error }}</div>
      <button @click="fetchHomeData" class="btn-primary">Retry</button>
    </div>

    <!-- Home Content -->
    <template v-else>
      <HeroSection />
      
      <StatsSection :stats="homeData?.stats || defaultStats" />
      
      <CompanyCTA />
      
      <HowItWorksSection />
      
      <FeaturesSection />
      
      <CTASection />
    </template>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useHome } from '@/composables/useHome'
import HeroSection from './HeroSection.vue'
import StatsSection from './StatsSection.vue'
import CompanyCTA from './CompanyCTA.vue'
import HowItWorksSection from './HowItWorksSection.vue'
import FeaturesSection from './FeaturesSection.vue'
import CTASection from './CTASection.vue'

const { homeData, loading, error, fetchHomeData } = useHome()

const defaultStats = [
  { value: '10K+', label: 'Active Jobs' },
  { value: '5K+', label: 'Companies' },
  { value: '50K+', label: 'Job Seekers' },
  { value: '2K+', label: 'Success Stories' },
]

onMounted(() => {
  fetchHomeData()
})
</script>
