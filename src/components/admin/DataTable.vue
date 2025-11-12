<template>
  <div class="overflow-hidden">
    <!-- Desktop Table View -->
    <div class="hidden md:block overflow-x-auto">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
          <tr>
            <th
              v-for="column in columns"
              :key="column.key"
              scope="col"
              class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
              @click="column.sortable !== false && handleSort(column.key)"
            >
              <div class="flex items-center space-x-1">
                <span>{{ column.label }}</span>
                <svg
                  v-if="column.sortable !== false && sortBy === column.key"
                  class="w-4 h-4"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    v-if="sortOrder === 'asc'"
                    fill-rule="evenodd"
                    d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
                    clip-rule="evenodd"
                  />
                  <path
                    v-else
                    fill-rule="evenodd"
                    d="M14.707 12.707a1 1 0 01-1.414 0L10 9.414l-3.293 3.293a1 1 0 01-1.414-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 010 1.414z"
                    clip-rule="evenodd"
                  />
                </svg>
              </div>
            </th>
            <th v-if="actions" scope="col" class="relative px-6 py-3">
              <span class="sr-only">Actions</span>
            </th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          <tr v-if="loading">
            <td :colspan="columns.length + (actions ? 1 : 0)" class="px-6 py-12 text-center">
              <div class="flex justify-center">
                <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-indigo-600"></div>
              </div>
            </td>
          </tr>
          <tr v-else-if="data.length === 0">
            <td :colspan="columns.length + (actions ? 1 : 0)" class="px-6 py-12 text-center text-gray-500">
              {{ emptyMessage || 'No data available' }}
            </td>
          </tr>
          <tr v-else v-for="(item, index) in data" :key="index" class="hover:bg-gray-50">
            <td v-for="column in columns" :key="column.key" class="px-6 py-4 whitespace-nowrap">
              <slot :name="`cell-${column.key}`" :item="item" :value="getNestedValue(item, column.key)" :index="index">
                <span class="text-sm text-gray-900">{{ formatValue(item, column) }}</span>
              </slot>
            </td>
            <td v-if="actions" class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
              <slot name="actions" :item="item" :index="index"></slot>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Mobile Card View -->
    <div class="md:hidden space-y-4">
      <div v-if="loading" class="flex justify-center py-12">
        <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-indigo-600"></div>
      </div>
      <div v-else-if="data.length === 0" class="text-center text-gray-500 py-12">
        {{ emptyMessage || 'No data available' }}
      </div>
      <div v-else v-for="(item, index) in data" :key="index" class="bg-white rounded-lg shadow p-4 space-y-3">
        <div v-for="column in columns" :key="column.key">
          <slot :name="`cell-${column.key}`" :item="item" :value="getNestedValue(item, column.key)" :index="index">
            <div class="flex justify-between items-start">
              <span class="text-xs font-medium text-gray-500 uppercase">{{ column.label }}</span>
              <span class="text-sm text-gray-900 text-right ml-2">{{ formatValue(item, column) }}</span>
            </div>
          </slot>
        </div>
        <div v-if="actions" class="pt-3 border-t border-gray-200 flex justify-end space-x-2">
          <slot name="actions" :item="item" :index="index"></slot>
        </div>
      </div>
    </div>

    <!-- Pagination -->
    <div v-if="pagination && !loading" class="bg-white px-4 py-3 flex items-center justify-between border-t border-gray-200 sm:px-6">
      <!-- Mobile Pagination -->
      <div class="flex-1 flex justify-between md:hidden">
        <button
          @click="handlePageChange(pagination.current_page - 1)"
          :disabled="pagination.current_page === 1"
          class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed touch-manipulation"
        >
          Previous
        </button>
        <span class="text-sm text-gray-700 flex items-center px-2">
          {{ pagination.current_page }} / {{ pagination.last_page }}
        </span>
        <button
          @click="handlePageChange(pagination.current_page + 1)"
          :disabled="pagination.current_page === pagination.last_page"
          class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed touch-manipulation"
        >
          Next
        </button>
      </div>
      
      <!-- Desktop Pagination -->
      <div class="hidden md:flex md:flex-1 md:items-center md:justify-between">
        <div>
          <p class="text-sm text-gray-700">
            Showing
            <span class="font-medium">{{ pagination.from }}</span>
            to
            <span class="font-medium">{{ pagination.to }}</span>
            of
            <span class="font-medium">{{ pagination.total }}</span>
            results
          </p>
        </div>
        <div>
          <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
            <button
              @click="handlePageChange(pagination.current_page - 1)"
              :disabled="pagination.current_page === 1"
              class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <span class="sr-only">Previous</span>
              <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
              </svg>
            </button>
            <button
              v-for="page in visiblePages"
              :key="page"
              @click="typeof page === 'number' && handlePageChange(page)"
              :class="[
                page === pagination.current_page
                  ? 'z-10 bg-indigo-50 border-indigo-500 text-indigo-600'
                  : 'bg-white border-gray-300 text-gray-500 hover:bg-gray-50',
                'relative inline-flex items-center px-4 py-2 border text-sm font-medium'
              ]"
            >
              {{ page }}
            </button>
            <button
              @click="handlePageChange(pagination.current_page + 1)"
              :disabled="pagination.current_page === pagination.last_page"
              class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <span class="sr-only">Next</span>
              <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
              </svg>
            </button>
          </nav>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Column {
  key: string
  label: string
  sortable?: boolean
  format?: (value: any, item: any) => string
}

interface Pagination {
  current_page: number
  last_page: number
  per_page: number
  total: number
  from: number
  to: number
}

interface Props {
  columns: Column[]
  data: any[]
  loading?: boolean
  pagination?: Pagination
  sortBy?: string
  sortOrder?: 'asc' | 'desc'
  actions?: boolean
  emptyMessage?: string
}

const props = withDefaults(defineProps<Props>(), {
  loading: false,
  sortBy: '',
  sortOrder: 'asc',
  actions: true,
  emptyMessage: 'No data available'
})

const emit = defineEmits<{
  sort: [key: string, order: 'asc' | 'desc']
  pageChange: [page: number]
}>()

const visiblePages = computed(() => {
  if (!props.pagination) return []
  
  const current = props.pagination.current_page
  const last = props.pagination.last_page
  const delta = 2
  const range = []
  const rangeWithDots = []

  for (let i = Math.max(2, current - delta); i <= Math.min(last - 1, current + delta); i++) {
    range.push(i)
  }

  if (current - delta > 2) {
    rangeWithDots.push(1, '...')
  } else {
    rangeWithDots.push(1)
  }

  rangeWithDots.push(...range)

  if (current + delta < last - 1) {
    rangeWithDots.push('...', last)
  } else if (last > 1) {
    rangeWithDots.push(last)
  }

  return rangeWithDots.filter(p => p !== '...')
})

const handleSort = (key: string) => {
  const newOrder = props.sortBy === key && props.sortOrder === 'asc' ? 'desc' : 'asc'
  emit('sort', key, newOrder)
}

const handlePageChange = (page: number) => {
  emit('pageChange', page)
}

const getNestedValue = (obj: any, path: string) => {
  return path.split('.').reduce((acc, part) => acc?.[part], obj)
}

const formatValue = (item: any, column: Column) => {
  const value = getNestedValue(item, column.key)
  if (column.format) {
    return column.format(value, item)
  }
  return value ?? '-'
}
</script>
