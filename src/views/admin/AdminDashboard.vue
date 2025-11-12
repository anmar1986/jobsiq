<template>
  <AdminLayout>
    <!-- Main Stats Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 lg:gap-6 mb-6 lg:mb-8">
      <StatsCard
        title="Total Users"
        :value="stats?.users?.total || 0"
        :change="getUsersGrowth"
        icon="users"
        color="blue"
        :loading="loading"
      />
      <StatsCard
        title="Companies"
        :value="stats?.companies?.total || 0"
        :change="getCompaniesGrowth"
        icon="building"
        color="purple"
        :loading="loading"
      />
      <StatsCard
        title="Active Jobs"
        :value="stats?.jobs?.active || 0"
        :change="getJobsGrowth"
        icon="briefcase"
        color="green"
        :loading="loading"
      />
      <StatsCard
        title="Applications"
        :value="stats?.applications?.total || 0"
        :change="getApplicationsGrowth"
        icon="document"
        color="orange"
        :loading="loading"
      />
    </div>

    <!-- Detailed User Breakdown -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 lg:gap-6 mb-6 lg:mb-8">
      <BaseCard>
        <div class="p-4 sm:p-6">
          <h3 class="text-base sm:text-lg font-semibold text-gray-900 mb-4">User Breakdown</h3>
          <div class="space-y-4">
            <div>
              <div class="flex items-center justify-between mb-2">
                <span class="text-xs sm:text-sm font-medium text-gray-700">Job Seekers</span>
                <span class="text-xs sm:text-sm font-semibold text-gray-900">
                  {{ stats?.users?.job_seekers || 0 }} ({{ getUserPercentage('job_seekers') }}%)
                </span>
              </div>
              <div class="w-full bg-gray-200 rounded-full h-2">
                <div
                  class="bg-green-500 h-2 rounded-full transition-all duration-300"
                  :style="{ width: getUserPercentage('job_seekers') + '%' }"
                ></div>
              </div>
            </div>
            <div>
              <div class="flex items-center justify-between mb-2">
                <span class="text-xs sm:text-sm font-medium text-gray-700">Company Owners</span>
                <span class="text-xs sm:text-sm font-semibold text-gray-900">
                  {{ stats?.users?.company_owners || 0 }} ({{ getUserPercentage('company_owners') }}%)
                </span>
              </div>
              <div class="w-full bg-gray-200 rounded-full h-2">
                <div
                  class="bg-blue-500 h-2 rounded-full transition-all duration-300"
                  :style="{ width: getUserPercentage('company_owners') + '%' }"
                ></div>
              </div>
            </div>
            <div>
              <div class="flex items-center justify-between mb-2">
                <span class="text-xs sm:text-sm font-medium text-gray-700">Administrators</span>
                <span class="text-xs sm:text-sm font-semibold text-gray-900">
                  {{ stats?.users?.admins || 0 }} ({{ getUserPercentage('admins') }}%)
                </span>
              </div>
              <div class="w-full bg-gray-200 rounded-full h-2">
                <div
                  class="bg-purple-500 h-2 rounded-full transition-all duration-300"
                  :style="{ width: getUserPercentage('admins') + '%' }"
                ></div>
              </div>
            </div>
            <div class="pt-2 border-t border-gray-200">
              <div class="flex items-center justify-between text-xs text-gray-500">
                <span>New This Month</span>
                <span class="font-medium">{{ stats?.users?.new_this_month || 0 }}</span>
              </div>
            </div>
          </div>
        </div>
      </BaseCard>

      <BaseCard>
        <div class="p-4 sm:p-6">
          <h3 class="text-base sm:text-lg font-semibold text-gray-900 mb-4">Job Statistics</h3>
          <div class="space-y-4">
            <div class="flex items-center justify-between">
              <div class="flex items-center space-x-2">
                <div class="w-3 h-3 bg-green-500 rounded-full"></div>
                <span class="text-xs sm:text-sm text-gray-700">Active</span>
              </div>
              <span class="text-xs sm:text-sm font-semibold text-gray-900">
                {{ stats?.jobs?.active || 0 }} ({{ getJobPercentage('active') }}%)
              </span>
            </div>
            <div class="flex items-center justify-between">
              <div class="flex items-center space-x-2">
                <div class="w-3 h-3 bg-red-500 rounded-full"></div>
                <span class="text-xs sm:text-sm text-gray-700">Closed</span>
              </div>
              <span class="text-xs sm:text-sm font-semibold text-gray-900">
                {{ stats?.jobs?.closed || 0 }} ({{ getJobPercentage('closed') }}%)
              </span>
            </div>
            <div class="flex items-center justify-between">
              <div class="flex items-center space-x-2">
                <div class="w-3 h-3 bg-gray-500 rounded-full"></div>
                <span class="text-xs sm:text-sm text-gray-700">Draft</span>
              </div>
              <span class="text-xs sm:text-sm font-semibold text-gray-900">
                {{ stats?.jobs?.draft || 0 }} ({{ getJobPercentage('draft') }}%)
              </span>
            </div>
            <div class="flex items-center justify-between">
              <div class="flex items-center space-x-2">
                <div class="w-3 h-3 bg-yellow-500 rounded-full"></div>
                <span class="text-xs sm:text-sm text-gray-700">Featured</span>
              </div>
              <span class="text-xs sm:text-sm font-semibold text-gray-900">
                {{ stats?.jobs?.featured || 0 }} ({{ getJobPercentage('featured') }}%)
              </span>
            </div>
            <div class="pt-2 border-t border-gray-200">
              <div class="flex items-center justify-between text-xs text-gray-500">
                <span>New This Month</span>
                <span class="font-medium">{{ stats?.jobs?.new_this_month || 0 }}</span>
              </div>
            </div>
          </div>
        </div>
      </BaseCard>

      <BaseCard>
        <div class="p-4 sm:p-6">
          <h3 class="text-base sm:text-lg font-semibold text-gray-900 mb-4">Company Insights</h3>
          <div class="space-y-4">
            <div class="flex items-center justify-between">
              <span class="text-xs sm:text-sm text-gray-700">Total Companies</span>
              <span class="text-xl sm:text-2xl font-bold text-gray-900">{{ stats?.companies?.total || 0 }}</span>
            </div>
            <div class="flex items-center justify-between">
              <span class="text-xs sm:text-sm text-gray-700">With Active Jobs</span>
              <span class="text-base sm:text-lg font-semibold text-green-600">
                {{ stats?.companies?.with_active_jobs || 0 }}
              </span>
            </div>
            <div class="flex items-center justify-between">
              <span class="text-xs sm:text-sm text-gray-700">Activity Rate</span>
              <span class="text-base sm:text-lg font-semibold text-blue-600">
                {{ getCompanyActivityRate }}%
              </span>
            </div>
            <div class="pt-2 border-t border-gray-200">
              <div class="flex items-center justify-between text-xs text-gray-500">
                <span>New This Month</span>
                <span class="font-medium">{{ stats?.companies?.new_this_month || 0 }}</span>
              </div>
            </div>
          </div>
        </div>
      </BaseCard>

      <BaseCard>
        <div class="p-4 sm:p-6">
          <h3 class="text-base sm:text-lg font-semibold text-gray-900 mb-4">CV Statistics</h3>
          <div class="space-y-4">
            <div class="flex items-center justify-between">
              <span class="text-xs sm:text-sm text-gray-700">Total CVs</span>
              <span class="text-xl sm:text-2xl font-bold text-gray-900">{{ stats?.cvs?.total || 0 }}</span>
            </div>
            <div class="flex items-center justify-between">
              <span class="text-xs sm:text-sm text-gray-700">Public CVs</span>
              <span class="text-base sm:text-lg font-semibold text-blue-600">
                {{ stats?.cvs?.public || 0 }}
              </span>
            </div>
            <div class="flex items-center justify-between">
              <span class="text-xs sm:text-sm text-gray-700">Visibility Rate</span>
              <span class="text-base sm:text-lg font-semibold text-green-600">
                {{ getCvPublicRate }}%
              </span>
            </div>
            <div class="pt-2 border-t border-gray-200">
              <div class="flex items-center justify-between text-xs text-gray-500">
                <span>New This Month</span>
                <span class="font-medium">{{ stats?.cvs?.new_this_month || 0 }}</span>
              </div>
            </div>
          </div>
        </div>
      </BaseCard>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-4 lg:gap-6 mb-6 lg:mb-8">
      <!-- Recent Activity Chart -->
      <BaseCard class="lg:col-span-2">
        <div class="p-4 sm:p-6">
          <h3 class="text-base sm:text-lg font-semibold text-gray-900 mb-4">Activity Overview (Last 7 Days)</h3>
          <ActivityChart :data="activityData" :loading="loading" />
        </div>
      </BaseCard>

      <!-- Application Status Distribution -->
      <BaseCard>
        <div class="p-4 sm:p-6">
          <h3 class="text-base sm:text-lg font-semibold text-gray-900 mb-4">Application Pipeline</h3>
          <div class="space-y-3">
            <div v-for="status in applicationStatuses" :key="status.label" class="flex items-center">
              <div class="flex-1">
                <div class="flex items-center justify-between mb-1">
                  <span class="text-xs sm:text-sm font-medium text-gray-700">{{ status.label }}</span>
                  <span class="text-xs sm:text-sm text-gray-600">{{ status.count }}</span>
                </div>
                <div class="w-full bg-gray-200 rounded-full h-2">
                  <div
                    :class="status.color"
                    class="h-2 rounded-full transition-all duration-300"
                    :style="{ width: status.percentage + '%' }"
                  ></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </BaseCard>
    </div>

    <!-- Additional Statistics -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 lg:gap-6">
      <!-- Top Industries -->
      <BaseCard>
        <div class="p-4 sm:p-6">
          <h3 class="text-base sm:text-lg font-semibold text-gray-900 mb-4">Top Industries</h3>
          <div class="space-y-3">
            <div
              v-for="(industry, index) in topIndustries"
              :key="index"
              class="flex items-center justify-between py-2 border-b border-gray-100 last:border-0"
            >
              <div class="flex items-center space-x-2">
                <span class="text-xs font-medium text-gray-500">#{index + 1}</span>
                <span class="text-xs sm:text-sm text-gray-700">{{ industry.industry || 'Other' }}</span>
              </div>
              <span class="text-xs sm:text-sm font-semibold text-gray-900">{{ industry.count }}</span>
            </div>
            <div v-if="topIndustries.length === 0 && !loading" class="text-center text-xs sm:text-sm text-gray-500 py-8">
              No data available
            </div>
          </div>
        </div>
      </BaseCard>

      <!-- Top Job Types -->
      <BaseCard>
        <div class="p-4 sm:p-6">
          <h3 class="text-base sm:text-lg font-semibold text-gray-900 mb-4">Popular Job Types</h3>
          <div class="space-y-3">
            <div
              v-for="(jobType, index) in topJobTypes"
              :key="index"
              class="flex items-center justify-between py-2 border-b border-gray-100 last:border-0"
            >
              <div class="flex items-center space-x-2">
                <span class="text-xs font-medium text-gray-500">#{index + 1}</span>
                <span class="text-xs sm:text-sm text-gray-700 capitalize">{{ formatJobType(jobType.job_type) }}</span>
              </div>
              <span class="text-xs sm:text-sm font-semibold text-gray-900">{{ jobType.count }}</span>
            </div>
            <div v-if="topJobTypes.length === 0 && !loading" class="text-center text-xs sm:text-sm text-gray-500 py-8">
              No data available
            </div>
          </div>
        </div>
      </BaseCard>

      <!-- Top Companies by Jobs -->
      <BaseCard>
        <div class="p-4 sm:p-6">
          <h3 class="text-base sm:text-lg font-semibold text-gray-900 mb-4">Most Active Companies</h3>
          <div class="space-y-3">
            <div
              v-for="company in topCompaniesByJobs"
              :key="company.id"
              class="flex items-center justify-between py-2 border-b border-gray-100 last:border-0"
            >
              <div class="flex items-center space-x-2 flex-1 min-w-0">
                <span class="text-xs font-medium text-gray-500">#{index + 1}</span>
                <span class="text-xs sm:text-sm text-gray-700 truncate">{{ company.name }}</span>
              </div>
              <span class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800 whitespace-nowrap ml-2">
                {{ company.jobs_count }} jobs
              </span>
            </div>
            <div v-if="topCompaniesByJobs.length === 0 && !loading" class="text-center text-xs sm:text-sm text-gray-500 py-8">
              No data available
            </div>
          </div>
        </div>
      </BaseCard>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useAuthStore } from '@/stores/auth'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import BaseCard from '@/components/base/BaseCard.vue'
import StatsCard from '@/components/admin/StatsCard.vue'
import ActivityChart from '@/components/admin/ActivityChart.vue'
import axios from 'axios'

const authStore = useAuthStore()
const stats = ref<any>(null)
const loading = ref(true)

const activityData = computed(() => {
  if (!stats.value?.activity) return null
  return stats.value.activity
})

const applicationStatuses = computed(() => {
  if (!stats.value?.applications) return []
  
  const total = stats.value.applications.total || 1
  return [
    {
      label: 'Pending',
      count: stats.value.applications.pending || 0,
      percentage: ((stats.value.applications.pending || 0) / total) * 100,
      color: 'bg-yellow-500'
    },
    {
      label: 'Reviewed',
      count: stats.value.applications.reviewed || 0,
      percentage: ((stats.value.applications.reviewed || 0) / total) * 100,
      color: 'bg-blue-500'
    },
    {
      label: 'Interview',
      count: stats.value.applications.interview || 0,
      percentage: ((stats.value.applications.interview || 0) / total) * 100,
      color: 'bg-purple-500'
    },
    {
      label: 'Accepted',
      count: stats.value.applications.accepted || 0,
      percentage: ((stats.value.applications.accepted || 0) / total) * 100,
      color: 'bg-green-500'
    },
    {
      label: 'Rejected',
      count: stats.value.applications.rejected || 0,
      percentage: ((stats.value.applications.rejected || 0) / total) * 100,
      color: 'bg-red-500'
    }
  ]
})

const topIndustries = computed(() => {
  return stats.value?.top?.industries || []
})

const topJobTypes = computed(() => {
  return stats.value?.top?.job_types || []
})

const topCompaniesByJobs = computed(() => {
  return stats.value?.top?.companies_by_jobs || []
})

const formatJobType = (type: string) => {
  if (!type) return 'Unknown'
  return type.split('-').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ')
}

// Computed properties for growth indicators
const getUsersGrowth = computed(() => {
  const today = stats.value?.users?.new_today || 0
  const thisMonth = stats.value?.users?.new_this_month || 0
  return `+${today} today, ${thisMonth} this month`
})

const getCompaniesGrowth = computed(() => {
  const today = stats.value?.companies?.new_today || 0
  const thisMonth = stats.value?.companies?.new_this_month || 0
  return `+${today} today, ${thisMonth} this month`
})

const getJobsGrowth = computed(() => {
  const today = stats.value?.jobs?.new_today || 0
  const thisMonth = stats.value?.jobs?.new_this_month || 0
  return `+${today} today, ${thisMonth} this month`
})

const getApplicationsGrowth = computed(() => {
  const today = stats.value?.applications?.new_today || 0
  const thisMonth = stats.value?.applications?.new_this_month || 0
  return `+${today} today, ${thisMonth} this month`
})

// Percentage calculations
const getUserPercentage = (type: string) => {
  const total = stats.value?.users?.total || 1
  const value = stats.value?.users?.[type] || 0
  return Math.round((value / total) * 100)
}

const getJobPercentage = (type: string) => {
  const total = stats.value?.jobs?.total || 1
  const value = stats.value?.jobs?.[type] || 0
  return Math.round((value / total) * 100)
}

const getCompanyActivityRate = computed(() => {
  const total = stats.value?.companies?.total || 1
  const active = stats.value?.companies?.with_active_jobs || 0
  return Math.round((active / total) * 100)
})

const getCvPublicRate = computed(() => {
  const total = stats.value?.cvs?.total || 1
  const publicCvs = stats.value?.cvs?.public || 0
  return Math.round((publicCvs / total) * 100)
})

onMounted(async () => {
  try {
    const response = await axios.get('/api/admin/dashboard', {
      headers: {
        Authorization: `Bearer ${authStore.token}`
      }
    })
    stats.value = response.data
  } finally {
    loading.value = false
  }
})
</script>
