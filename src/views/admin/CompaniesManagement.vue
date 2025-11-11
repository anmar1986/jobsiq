<template>
  <AdminLayout>
    <div class="space-y-6">
      <!-- Header -->
      <div class="flex items-center justify-between">
      </div>

      <!-- Filters -->
      <BaseCard>
        <div class="p-6">
          <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Search</label>
              <input
                v-model="filters.search"
                type="text"
                placeholder="Company name..."
                class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                @input="handleFilterChange"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Industry</label>
              <input
                v-model="filters.industry"
                type="text"
                placeholder="Filter by industry..."
                class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                @input="handleFilterChange"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Country</label>
              <input
                v-model="filters.country"
                type="text"
                placeholder="Filter by country..."
                class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                @input="handleFilterChange"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Per Page</label>
              <select
                v-model="filters.per_page"
                class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                @change="handleFilterChange"
              >
                <option :value="10">10</option>
                <option :value="25">25</option>
                <option :value="50">50</option>
                <option :value="100">100</option>
              </select>
            </div>
          </div>
        </div>
      </BaseCard>

      <!-- Data Table -->
      <BaseCard>
        <DataTable
          :columns="columns"
          :data="companies"
          :loading="loading"
          :pagination="pagination"
          :sort-by="filters.sort_by"
          :sort-order="filters.sort_order"
          @sort="handleSort"
          @page-change="handlePageChange"
        >
          <template #cell-name="{ item, index }">
            <div class="flex items-center">
              <div v-if="item.logo_url" class="flex-shrink-0 h-10 w-10">
                <img :src="item.logo_url" :alt="item.name" class="h-10 w-10 rounded-full object-cover" />
              </div>
              <div v-else class="flex-shrink-0 h-10 w-10">
                <div class="h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center">
                  <span class="text-sm font-medium text-blue-700">
                    {{ getCompanyNumber(index) }}
                  </span>
                </div>
              </div>
              <div class="ml-4">
                <div class="text-sm font-medium text-gray-900">{{ item.name }}</div>
                <div class="text-sm text-gray-500">{{ item.website || 'No website' }}</div>
              </div>
            </div>
          </template>

          <template #cell-industry="{ value }">
            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
              {{ value || 'N/A' }}
            </span>
          </template>

          <template #cell-size="{ value }">
            <span class="text-sm text-gray-900">{{ value || '-' }}</span>
          </template>

          <template #cell-country="{ value }">
            <span class="text-sm text-gray-900">{{ value || '-' }}</span>
          </template>

          <template #cell-jobs_count="{ value }">
            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
              {{ value }} Jobs
            </span>
          </template>

          <template #actions="{ item }">
            <div class="flex items-center space-x-3">
              <button
                @click="viewCompany(item)"
                class="text-indigo-600 hover:text-indigo-900"
                title="View"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                </svg>
              </button>
              <button
                @click="viewJobs(item)"
                class="text-green-600 hover:text-green-900"
                title="View Jobs"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                </svg>
              </button>
              <button
                @click="confirmDelete(item)"
                class="text-red-600 hover:text-red-900"
                title="Delete"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                </svg>
              </button>
            </div>
          </template>
        </DataTable>
      </BaseCard>
    </div>

    <!-- Delete Confirmation Modal -->
    <BaseModal v-model="showDeleteModal" title="Delete Company">
      <div class="space-y-4">
        <p class="text-sm text-gray-500">
          Are you sure you want to delete <strong>{{ deletingCompany?.name }}</strong>? 
          This will also delete all associated jobs and applications. This action cannot be undone.
        </p>
        <div class="flex justify-end space-x-3">
          <button
            type="button"
            @click="showDeleteModal = false"
            class="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
          >
            Cancel
          </button>
          <button
            type="button"
            @click="deleteCompany"
            :disabled="deleting"
            class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-red-600 hover:bg-red-700 disabled:opacity-50"
          >
            {{ deleting ? 'Deleting...' : 'Delete' }}
          </button>
        </div>
      </div>
    </BaseModal>

    <!-- Company Detail Modal -->
    <BaseModal v-model="showDetailModal" title="Company Details" size="lg">
      <div v-if="selectedCompany" class="space-y-4">
        <div class="flex items-center space-x-4">
          <img
            v-if="selectedCompany.logo_url"
            :src="selectedCompany.logo_url"
            :alt="selectedCompany.name"
            class="h-16 w-16 rounded-full object-cover"
          />
          <div>
            <h3 class="text-lg font-semibold text-gray-900">{{ selectedCompany.name }}</h3>
            <p class="text-sm text-gray-500">{{ selectedCompany.industry }}</p>
          </div>
        </div>
        <div class="grid grid-cols-2 gap-4 pt-4">
          <div>
            <label class="block text-sm font-medium text-gray-500">Website</label>
            <p class="mt-1 text-sm text-gray-900">{{ selectedCompany.website || '-' }}</p>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-500">Company Size</label>
            <p class="mt-1 text-sm text-gray-900">{{ selectedCompany.size || '-' }}</p>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-500">Country</label>
            <p class="mt-1 text-sm text-gray-900">{{ selectedCompany.country || '-' }}</p>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-500">City</label>
            <p class="mt-1 text-sm text-gray-900">{{ selectedCompany.city || '-' }}</p>
          </div>
        </div>
        <div v-if="selectedCompany.description">
          <label class="block text-sm font-medium text-gray-500">Description</label>
          <p class="mt-1 text-sm text-gray-900">{{ selectedCompany.description }}</p>
        </div>
      </div>
    </BaseModal>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseModal from '@/components/base/BaseModal.vue'
import DataTable from '@/components/admin/DataTable.vue'
import axios from 'axios'

const router = useRouter()
const authStore = useAuthStore()

const companies = ref<any[]>([])
const loading = ref(true)
const deleting = ref(false)
const pagination = ref<any>(null)
const showDeleteModal = ref(false)
const showDetailModal = ref(false)
const deletingCompany = ref<any>(null)
const selectedCompany = ref<any>(null)

const filters = reactive({
  search: '',
  industry: '',
  country: '',
  sort_by: 'created_at',
  sort_order: 'desc' as 'asc' | 'desc',
  per_page: 25,
  page: 1
})

const columns = [
  { key: 'name', label: 'Company', sortable: true },
  { key: 'industry', label: 'Industry', sortable: true },
  { key: 'size', label: 'Size', sortable: true },
  { key: 'country', label: 'Country', sortable: true },
  { key: 'jobs_count', label: 'Jobs', sortable: true }
]

const fetchCompanies = async () => {
  loading.value = true
  try {
    const params: any = {
      page: filters.page,
      per_page: filters.per_page,
      sort_by: filters.sort_by,
      sort_order: filters.sort_order
    }

    if (filters.search) params.search = filters.search
    if (filters.industry) params.industry = filters.industry
    if (filters.country) params.country = filters.country

    const response = await axios.get('/api/admin/companies', {
      headers: { Authorization: `Bearer ${authStore.token}` },
      params
    })

    companies.value = response.data.data
    pagination.value = response.data.meta
  } catch (error) {
    console.error('Failed to fetch companies:', error)
  } finally {
    loading.value = false
  }
}

const handleFilterChange = () => {
  filters.page = 1
  fetchCompanies()
}

const handleSort = (key: string, order: 'asc' | 'desc') => {
  filters.sort_by = key
  filters.sort_order = order
  fetchCompanies()
}

const handlePageChange = (page: number) => {
  filters.page = page
  fetchCompanies()
}

const viewCompany = (company: any) => {
  selectedCompany.value = company
  showDetailModal.value = true
}

const viewJobs = (company: any) => {
  router.push({ name: 'admin-jobs', query: { company_id: company.id } })
}

const confirmDelete = (company: any) => {
  deletingCompany.value = company
  showDeleteModal.value = true
}

const deleteCompany = async () => {
  if (!deletingCompany.value) return
  
  deleting.value = true
  try {
    await axios.delete(`/api/admin/companies/${deletingCompany.value.id}`, {
      headers: { Authorization: `Bearer ${authStore.token}` }
    })
    showDeleteModal.value = false
    deletingCompany.value = null
    fetchCompanies()
  } catch (error: any) {
    console.error('Failed to delete company:', error)
    alert(error.response?.data?.message || 'Failed to delete company')
  } finally {
    deleting.value = false
  }
}

const getCompanyNumber = (index: number) => {
  // Calculate the actual company number based on pagination
  const currentPage = pagination.value?.current_page || 1
  const perPage = filters.per_page
  return (currentPage - 1) * perPage + index + 1
}

onMounted(() => {
  fetchCompanies()
})
</script>
