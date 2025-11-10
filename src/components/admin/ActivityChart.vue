<template>
  <div class="relative">
    <div v-if="loading" class="h-64 flex items-center justify-center">
      <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600"></div>
    </div>
    
    <div v-else-if="chartData.length === 0" class="h-64 flex items-center justify-center text-gray-500">
      No activity data available
    </div>
    
    <div v-else class="h-64">
      <svg class="w-full h-full" viewBox="0 0 600 200">
        <!-- Grid lines -->
        <line v-for="i in 5" :key="`grid-${i}`" :x1="0" :y1="i * 40" :x2="600" :y2="i * 40" stroke="#e5e7eb" stroke-width="1" />
        
        <!-- Chart lines -->
        <polyline
          :points="usersLine"
          fill="none"
          stroke="#3b82f6"
          stroke-width="2"
          class="transition-all duration-300"
        />
        <polyline
          :points="jobsLine"
          fill="none"
          stroke="#10b981"
          stroke-width="2"
          class="transition-all duration-300"
        />
        <polyline
          :points="applicationsLine"
          fill="none"
          stroke="#f59e0b"
          stroke-width="2"
          class="transition-all duration-300"
        />
        
        <!-- Data points -->
        <circle
          v-for="(point, i) in usersPoints"
          :key="`user-${i}`"
          :cx="point.x"
          :cy="point.y"
          r="4"
          fill="#3b82f6"
          class="hover:r-6 transition-all cursor-pointer"
        >
          <title>Users: {{ point.value }}</title>
        </circle>
      </svg>
      
      <!-- Legend -->
      <div class="flex items-center justify-center gap-6 mt-4">
        <div class="flex items-center gap-2">
          <div class="w-3 h-3 bg-blue-500 rounded-full"></div>
          <span class="text-sm text-gray-600">Users</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-3 h-3 bg-green-500 rounded-full"></div>
          <span class="text-sm text-gray-600">Jobs</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-3 h-3 bg-orange-500 rounded-full"></div>
          <span class="text-sm text-gray-600">Applications</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  data: any
  loading?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  loading: false
})

const chartData = computed(() => {
  if (!props.data) return []
  
  const users = props.data.users_last_7_days || {}
  const jobs = props.data.jobs_last_7_days || {}
  const applications = props.data.applications_last_7_days || {}
  
  const dates = Object.keys(users).sort()
  
  return dates.map(date => ({
    date,
    users: users[date] || 0,
    jobs: jobs[date] || 0,
    applications: applications[date] || 0
  }))
})

const maxValue = computed(() => {
  if (chartData.value.length === 0) return 10
  return Math.max(
    ...chartData.value.map(d => Math.max(d.users, d.jobs, d.applications))
  ) || 10
})

const createLine = (values: number[]) => {
  if (values.length === 0) return ''
  
  const width = 600
  const height = 200
  const padding = 20
  const step = (width - padding * 2) / Math.max(values.length - 1, 1)
  
  return values.map((value, i) => {
    const x = padding + i * step
    const y = height - padding - ((value / maxValue.value) * (height - padding * 2))
    return `${x},${y}`
  }).join(' ')
}

const usersLine = computed(() => createLine(chartData.value.map(d => d.users)))
const jobsLine = computed(() => createLine(chartData.value.map(d => d.jobs)))
const applicationsLine = computed(() => createLine(chartData.value.map(d => d.applications)))

const usersPoints = computed(() => {
  if (chartData.value.length === 0) return []
  
  const width = 600
  const height = 200
  const padding = 20
  const step = (width - padding * 2) / Math.max(chartData.value.length - 1, 1)
  
  return chartData.value.map((d, i) => ({
    x: padding + i * step,
    y: height - padding - ((d.users / maxValue.value) * (height - padding * 2)),
    value: d.users
  }))
})
</script>
