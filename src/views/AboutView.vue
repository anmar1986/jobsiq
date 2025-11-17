<template>
  <div>
    <!-- Hero Section -->
    <section class="bg-gradient-to-br from-primary-600 to-secondary-600 text-white py-20">
      <div class="container-custom text-center">
        <h1 class="text-4xl md:text-5xl font-bold mb-6">{{ $t('about.title') }}</h1>
        <p class="text-xl text-primary-100 max-w-3xl mx-auto">
          {{ $t('about.subtitle') }}
        </p>
      </div>
    </section>

    <!-- Mission & Vision -->
    <section class="py-16 md:py-24">
      <div class="container-custom">
        <div class="grid md:grid-cols-2 gap-12 items-center">
          <div>
            <h2 class="text-3xl md:text-4xl font-bold text-gray-900 mb-6">{{ $t('about.ourMission') }}</h2>
            <p class="text-lg text-gray-600 mb-4">
              {{ $t('about.ourMissionText1') }}
            </p>
            <p class="text-lg text-gray-600">
              {{ $t('about.ourMissionText2') }}
            </p>
          </div>
          
          <div class="relative">
            <div class="aspect-square bg-gradient-to-br from-primary-100 to-secondary-100 rounded-2xl flex items-center justify-center">
              <svg class="h-32 w-32 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
              </svg>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Values -->
    <section class="py-16 md:py-24 bg-gray-50">
      <div class="container-custom">
        <div class="text-center mb-16">
          <h2 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">{{ $t('about.ourValues') }}</h2>
          <p class="text-xl text-gray-600">{{ $t('about.ourValuesSubtitle') }}</p>
        </div>

        <div class="grid md:grid-cols-3 gap-8">
          <BaseCard v-for="value in values" :key="value.titleKey">
            <div class="p-8 text-center">
              <div class="w-16 h-16 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <component :is="value.icon" class="h-8 w-8 text-primary-600" />
              </div>
              <h3 class="text-xl font-semibold text-gray-900 mb-3">{{ $t(value.titleKey) }}</h3>
              <p class="text-gray-600">{{ $t(value.descKey) }}</p>
            </div>
          </BaseCard>
        </div>
      </div>
    </section>

    <!-- Stats -->
    <section class="py-16 md:py-24">
      <div class="container-custom">
        <div class="text-center mb-16">
          <h2 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">{{ $t('about.ourImpact') }}</h2>
          <p class="text-xl text-gray-600">{{ $t('about.ourImpactSubtitle') }}</p>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
          <div v-for="stat in stats" :key="stat.labelKey" class="text-center">
            <div class="text-5xl font-bold text-primary-600 mb-2">{{ stat.value }}</div>
            <div class="text-gray-600 font-medium">{{ $t(stat.labelKey) }}</div>
          </div>
        </div>
      </div>
    </section>

    <!-- Team -->
    <section class="py-16 md:py-24 bg-gray-50">
      <div class="container-custom">
        <div class="text-center mb-16">
          <h2 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">{{ $t('about.ourTeam') }}</h2>
          <p class="text-xl text-gray-600">{{ $t('about.ourTeamSubtitle') }}</p>
        </div>

        <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-8">
          <BaseCard v-for="member in team" :key="member.nameKey">
            <div class="p-6 text-center">
              <BaseAvatar :name="$t(member.nameKey)" size="2xl" class="mx-auto mb-4" />
              <h3 class="text-lg font-semibold text-gray-900 mb-1">{{ $t(member.nameKey) }}</h3>
              <p class="text-primary-600 text-sm font-medium mb-3">{{ $t(member.roleKey) }}</p>
              <p class="text-gray-600 text-sm">{{ $t(member.bioKey) }}</p>
            </div>
          </BaseCard>
        </div>
      </div>
    </section>

    <!-- CTA -->
    <section class="py-16 md:py-24 cta-gradient text-white">
      <div class="container-custom text-center">
        <h2 class="text-3xl md:text-4xl font-bold mb-6">{{ $t('about.joinCommunity') }}</h2>
        <p class="text-xl text-primary-100 mb-8 max-w-2xl mx-auto">
          {{ $t('about.joinCommunityText') }}
        </p>
        <div class="flex flex-col sm:flex-row gap-4 justify-center">
          <router-link 
            to="/register" 
            class="inline-block bg-white text-primary-600 hover:bg-gray-100 px-8 py-3 text-lg font-semibold rounded-lg transition-colors shadow-lg"
          >
            {{ $t('about.getStarted') }}
          </router-link>
          <router-link 
            to="/jobs" 
            class="inline-block border-2 border-white text-white hover:bg-white/10 px-8 py-3 text-lg font-semibold rounded-lg transition-colors"
          >
            {{ $t('about.browseJobs') }}
          </router-link>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { h } from 'vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseAvatar from '@/components/base/BaseAvatar.vue'

const values = [
  {
    titleKey: 'about.transparency',
    descKey: 'about.transparencyDesc',
    icon: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z' })
    ])
  },
  {
    titleKey: 'about.innovation',
    descKey: 'about.innovationDesc',
    icon: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M13 10V3L4 14h7v7l9-11h-7z' })
    ])
  },
  {
    titleKey: 'about.inclusivity',
    descKey: 'about.inclusivityDesc',
    icon: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z' })
    ])
  },
]

const stats = [
  { value: '10K+', labelKey: 'about.activeJobs' },
  { value: '5K+', labelKey: 'about.companies' },
  { value: '50K+', labelKey: 'about.jobSeekers' },
  { value: '98%', labelKey: 'about.satisfactionRate' },
]

const team = [
  {
    nameKey: 'about.teamMember1Name',
    roleKey: 'about.ceoFounder',
    bioKey: 'about.teamMember1Bio',
  },
  {
    nameKey: 'about.teamMember2Name',
    roleKey: 'about.cto',
    bioKey: 'about.teamMember2Bio',
  },
  {
    nameKey: 'about.teamMember3Name',
    roleKey: 'about.headOfDesign',
    bioKey: 'about.teamMember3Bio',
  },
  {
    nameKey: 'about.teamMember4Name',
    roleKey: 'about.headOfGrowth',
    bioKey: 'about.teamMember4Bio',
  },
]
</script>

<style scoped>
/* CTA gradient that works in both LTR and RTL */
.cta-gradient {
  background: linear-gradient(to right, #3b82f6, #a855f7);
}

[dir="rtl"] .cta-gradient {
  background: linear-gradient(to left, #3b82f6, #a855f7);
}
</style>
