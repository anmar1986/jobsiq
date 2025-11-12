<template>
  <AdminLayout>
    <div class="space-y-4 sm:space-y-6">
      <!-- Header -->
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-end gap-4">
        <BaseButton
          variant="danger"
          @click="showClearModal = true"
          :disabled="loading"
          class="w-full sm:w-auto touch-manipulation"
        >
          <template #icon-left>
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
          </template>
          Clear Old History
        </BaseButton>
      </div>

      <!-- Statistics Cards -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 lg:gap-6">
        <BaseCard>
          <div class="p-4 sm:p-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-xs sm:text-sm font-medium text-gray-600">Total Searches</p>
                <p class="text-xl sm:text-2xl font-bold text-gray-900 mt-1">
                  {{ statistics?.total_searches?.toLocaleString() || 0 }}
                </p>
              </div>
              <div class="p-2 sm:p-3 bg-blue-100 rounded-lg">
                <svg class="w-5 h-5 sm:w-6 sm:h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
              </div>
            </div>
          </div>
        </BaseCard>

        <BaseCard>
          <div class="p-4 sm:p-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-xs sm:text-sm font-medium text-gray-600">Unique Users</p>
                <p class="text-xl sm:text-2xl font-bold text-gray-900 mt-1">
                  {{ statistics?.unique_users?.toLocaleString() || 0 }}
                </p>
              </div>
              <div class="p-2 sm:p-3 bg-green-100 rounded-lg">
                <svg class="w-5 h-5 sm:w-6 sm:h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                </svg>
              </div>
            </div>
          </div>
        </BaseCard>

        <BaseCard>
          <div class="p-4 sm:p-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-xs sm:text-sm font-medium text-gray-600">Today</p>
                <p class="text-xl sm:text-2xl font-bold text-gray-900 mt-1">
                  {{ statistics?.today_searches?.toLocaleString() || 0 }}
                </p>
              </div>
              <div class="p-2 sm:p-3 bg-purple-100 rounded-lg">
                <svg class="w-5 h-5 sm:w-6 sm:h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
              </div>
            </div>
          </div>
        </BaseCard>

        <BaseCard>
          <div class="p-4 sm:p-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-xs sm:text-sm font-medium text-gray-600">Guest Searches</p>
                <p class="text-xl sm:text-2xl font-bold text-gray-900 mt-1">
                  {{ statistics?.guest_searches?.toLocaleString() || 0 }}
                </p>
              </div>
              <div class="p-2 sm:p-3 bg-orange-100 rounded-lg">
                <svg class="w-5 h-5 sm:w-6 sm:h-6 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                </svg>
              </div>
            </div>
          </div>
        </BaseCard>
      </div>

      <!-- Top Searches & Locations -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-4 lg:gap-6">
        <BaseCard>
          <div class="p-4 sm:p-6">
            <h3 class="text-base sm:text-lg font-semibold text-gray-900 mb-4">Top Search Queries</h3>
            <div v-if="statistics?.top_searches?.length" class="space-y-3">
              <div
                v-for="(item, index) in statistics.top_searches"
                :key="index"
                class="flex items-center justify-between"
              >
                <span class="text-xs sm:text-sm text-gray-700 truncate flex-1 mr-2">{{ item.search_query || '(empty)' }}</span>
                <span class="px-2 py-1 bg-gray-100 text-gray-700 rounded text-xs font-medium whitespace-nowrap">
                  {{ item.count }} searches
                </span>
              </div>
            </div>
            <p v-else class="text-xs sm:text-sm text-gray-500 italic">No search data available</p>
          </div>
        </BaseCard>

        <BaseCard>
          <div class="p-4 sm:p-6">
            <h3 class="text-base sm:text-lg font-semibold text-gray-900 mb-4">Top Locations</h3>
            <div v-if="statistics?.top_locations?.length" class="space-y-3">
              <div
                v-for="(item, index) in statistics.top_locations"
                :key="index"
                class="flex items-center justify-between"
              >
                <span class="text-xs sm:text-sm text-gray-700 truncate flex-1 mr-2">{{ item.location }}</span>
                <span class="px-2 py-1 bg-gray-100 text-gray-700 rounded text-xs font-medium whitespace-nowrap">
                  {{ item.count }} searches
                </span>
              </div>
            </div>
            <p v-else class="text-xs sm:text-sm text-gray-500 italic">No location data available</p>
          </div>
        </BaseCard>
      </div>

      <!-- Filters -->
      <BaseCard>
        <div class="p-4 sm:p-6">
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <div>
              <label class="block text-xs sm:text-sm font-medium text-gray-700 mb-1">Search</label>
              <input
                v-model="filters.search"
                type="text"
                placeholder="Search query..."
                class="w-full px-3 py-2 text-sm border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 touch-manipulation"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Location</label>
              <input
                v-model="filters.location"
                type="text"
                placeholder="Filter by location..."
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">From Date</label>
              <input
                v-model="filters.from_date"
                type="date"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">To Date</label>
              <input
                v-model="filters.to_date"
                type="date"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              />
            </div>
          </div>
          <div class="mt-4 flex gap-3">
            <BaseButton variant="primary" @click="() => fetchSearchHistory()">Apply Filters</BaseButton>
            <BaseButton variant="outline" @click="clearFilters">Clear</BaseButton>
          </div>
        </div>
      </BaseCard>

      <!-- Search History Table -->
      <BaseCard>
        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  User
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Search Query
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Location
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Results
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Date
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <tr v-if="loading">
                <td colspan="6" class="px-6 py-4 text-center text-gray-500">
                  Loading...
                </td>
              </tr>
              <tr v-else-if="searchHistory.length === 0">
                <td colspan="6" class="px-6 py-4 text-center text-gray-500">
                  No search history found
                </td>
              </tr>
              <tr v-else v-for="entry in searchHistory" :key="entry.id" class="hover:bg-gray-50">
                <td class="px-6 py-4 whitespace-nowrap">
                  <div v-if="entry.user">
                    <div class="text-sm font-medium text-gray-900">{{ entry.user.name }}</div>
                    <div class="text-sm text-gray-500">{{ entry.user.email }}</div>
                  </div>
                  <span v-else class="text-sm text-gray-500 italic">Guest</span>
                </td>
                <td class="px-6 py-4">
                  <div class="text-sm text-gray-900">{{ entry.search_query || '-' }}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="text-sm text-gray-900">{{ entry.location || '-' }}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <span class="px-2 py-1 bg-blue-100 text-blue-800 rounded text-xs font-medium">
                    {{ entry.results_count }} results
                  </span>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {{ formatDate(entry.created_at) }}
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm">
                  <button
                    @click="deleteEntry(entry.id)"
                    class="text-red-600 hover:text-red-900"
                    :disabled="deleting === entry.id"
                  >
                    Delete
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Pagination -->
        <div v-if="pagination && pagination.last_page > 1" class="px-6 py-4 border-t border-gray-200">
          <div class="flex items-center justify-between">
            <div class="text-sm text-gray-700">
              Showing {{ pagination.from }} to {{ pagination.to }} of {{ pagination.total }} results
            </div>
            <div class="flex gap-2">
              <BaseButton
                variant="outline"
                size="sm"
                @click="changePage(pagination.current_page - 1)"
                :disabled="pagination.current_page === 1 || loading"
              >
                Previous
              </BaseButton>
              <BaseButton
                variant="outline"
                size="sm"
                @click="changePage(pagination.current_page + 1)"
                :disabled="pagination.current_page === pagination.last_page || loading"
              >
                Next
              </BaseButton>
            </div>
          </div>
        </div>
      </BaseCard>
    </div>

    <!-- Clear History Modal -->
    <BaseModal v-model="showClearModal" title="Clear Search History" size="sm">
      <div class="p-6">
        <p class="text-gray-700 mb-4">
          Clear search history older than:
        </p>
        <input
          v-model="clearBeforeDate"
          type="date"
          class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 mb-4"
        />
        <p class="text-sm text-gray-500 mb-6">
          Leave empty to clear all history. This action cannot be undone.
        </p>
        <div class="flex items-center justify-end gap-3">
          <BaseButton variant="outline" @click="showClearModal = false" :disabled="clearing">
            Cancel
          </BaseButton>
          <BaseButton variant="danger" @click="clearHistory" :loading="clearing">
            Clear History
          </BaseButton>
        </div>
      </div>
    </BaseModal>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useToast } from '@/composables/useToast'
import { searchHistoryAdminService } from '@/services/searchHistoryAdmin.service'
import type { SearchHistoryEntry, SearchHistoryStatistics } from '@/services/searchHistoryAdmin.service'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseModal from '@/components/base/BaseModal.vue'

const toast = useToast()

const searchHistory = ref<SearchHistoryEntry[]>([])
const statistics = ref<SearchHistoryStatistics | null>(null)
const loading = ref(false)
const deleting = ref<number | null>(null)
const clearing = ref(false)
const showClearModal = ref(false)
const clearBeforeDate = ref('')

const filters = ref({
  search: '',
  location: '',
  from_date: '',
  to_date: '',
})

const pagination = ref<any>(null)

const fetchSearchHistory = async (page = 1) => {
  loading.value = true
  try {
    const params: any = { page, per_page: 20 }
    if (filters.value.search) params.search = filters.value.search
    if (filters.value.location) params.location = filters.value.location
    if (filters.value.from_date) params.from_date = filters.value.from_date
    if (filters.value.to_date) params.to_date = filters.value.to_date

    const response = await searchHistoryAdminService.getSearchHistory(params)
    console.log('Search history response:', response)
    searchHistory.value = response.data
    pagination.value = {
      current_page: response.current_page,
      last_page: response.last_page,
      from: response.from,
      to: response.to,
      total: response.total,
    }
  } catch (error: any) {
    console.error('Failed to fetch search history:', error)
    console.error('Error response:', error.response?.data)
    toast.error(error.response?.data?.message || 'Failed to load search history')
  } finally {
    loading.value = false
  }
}

const fetchStatistics = async () => {
  try {
    const response = await searchHistoryAdminService.getStatistics()
    statistics.value = response.data!
  } catch (error) {
    console.error('Failed to fetch statistics:', error)
  }
}

const deleteEntry = async (id: number) => {
  if (!confirm('Are you sure you want to delete this search history entry?')) return

  deleting.value = id
  try {
    await searchHistoryAdminService.deleteEntry(id)
    toast.success('Search history entry deleted')
    fetchSearchHistory()
    fetchStatistics()
  } catch (error) {
    console.error('Failed to delete entry:', error)
    toast.error('Failed to delete entry')
  } finally {
    deleting.value = null
  }
}

const clearHistory = async () => {
  clearing.value = true
  try {
    const params: any = {}
    if (clearBeforeDate.value) params.before_date = clearBeforeDate.value

    const response = await searchHistoryAdminService.clearHistory(params)
    toast.success(response.message || 'Search history cleared')
    showClearModal.value = false
    clearBeforeDate.value = ''
    fetchSearchHistory()
    fetchStatistics()
  } catch (error) {
    console.error('Failed to clear history:', error)
    toast.error('Failed to clear history')
  } finally {
    clearing.value = false
  }
}

const clearFilters = () => {
  filters.value = {
    search: '',
    location: '',
    from_date: '',
    to_date: '',
  }
  fetchSearchHistory()
}

const changePage = (page: number) => {
  fetchSearchHistory(page)
}

const formatDate = (dateString: string) => {
  return new Date(dateString).toLocaleString()
}

onMounted(() => {
  fetchSearchHistory()
  fetchStatistics()
})
</script>
