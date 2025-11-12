<template>
  <BaseCard class="hover:shadow-lg transition-shadow">
    <div class="p-4 sm:p-6">
      <div class="flex items-center justify-between mb-3 sm:mb-4">
        <h3 class="text-xs sm:text-sm font-medium text-gray-600">{{ title }}</h3>
        <div :class="[`bg-${color}-100 p-2 rounded-lg`]">
          <component :is="iconComponent" :class="[`h-5 w-5 sm:h-6 sm:w-6 text-${color}-600`]" />
        </div>
      </div>
      
      <div v-if="loading" class="animate-pulse">
        <div class="h-6 sm:h-8 bg-gray-200 rounded w-20 sm:w-24 mb-2"></div>
        <div class="h-3 sm:h-4 bg-gray-200 rounded w-24 sm:w-32"></div>
      </div>
      
      <div v-else class="flex flex-col gap-1 sm:gap-2">
        <p class="text-2xl sm:text-3xl font-bold text-gray-900">{{ formattedValue }}</p>
        <span class="text-xs sm:text-sm text-gray-600">{{ change }}</span>
      </div>
    </div>
  </BaseCard>
</template>

<script setup lang="ts">
import { computed, h } from 'vue'
import BaseCard from '@/components/base/BaseCard.vue'

interface Props {
  title: string
  value: number
  change?: string
  icon: 'users' | 'building' | 'briefcase' | 'document'
  color: 'blue' | 'purple' | 'green' | 'orange'
  loading?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  change: '',
  loading: false
})

const formattedValue = computed(() => {
  return new Intl.NumberFormat().format(props.value)
})

const iconComponent = computed(() => {
  const icons = {
    users: h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z' })
    ]),
    building: h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4' })
    ]),
    briefcase: h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z' })
    ]),
    document: h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z' })
    ])
  }
  return icons[props.icon]
})
</script>

<style scoped>
.bg-blue-100 {
  background-color: #dbeafe;
}
.text-blue-600 {
  color: #2563eb;
}
.bg-purple-100 {
  background-color: #f3e8ff;
}
.text-purple-600 {
  color: #9333ea;
}
.bg-green-100 {
  background-color: #dcfce7;
}
.text-green-600 {
  color: #16a34a;
}
.bg-orange-100 {
  background-color: #ffedd5;
}
.text-orange-600 {
  color: #ea580c;
}
</style>
