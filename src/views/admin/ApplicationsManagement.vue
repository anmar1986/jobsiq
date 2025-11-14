<template>
  <AdminLayout>
    <div class="space-y-4 sm:space-y-6">
      <!-- Filters -->
      <BaseCard>
        <div class="p-4 sm:p-6">
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <div>
              <label for="application-search" class="block text-xs sm:text-sm font-medium text-gray-700 mb-1">Search</label>
              <input
                id="application-search"
                v-model="filters.search"
                type="text"
                name="application-search"
                placeholder="Applicant name..."
                class="w-full px-3 py-2 text-sm rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 touch-manipulation"
                @input="handleFilterChange"
              />
            </div>
            <div>
              <label for="application-status" class="block text-xs sm:text-sm font-medium text-gray-700 mb-1">Status</label>
              <select
                id="application-status"
                v-model="filters.status"
                name="application-status"
                class="w-full px-3 py-2 text-sm rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 touch-manipulation"
                @change="handleFilterChange"
              >
                <option value="">All Statuses</option>
                <option value="pending">Pending</option>
                <option value="reviewed">Reviewed</option>
                <option value="interview">Interview</option>
                <option value="accepted">Accepted</option>
                <option value="rejected">Rejected</option>
              </select>
            </div>
            <div>
              <label for="application-date-range" class="block text-xs sm:text-sm font-medium text-gray-700 mb-1">Date Range</label>
              <select
                id="application-date-range"
                v-model="filters.date_range"
                name="application-date-range"
                class="w-full px-3 py-2 text-sm rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 touch-manipulation"
                @change="handleFilterChange"
              >
                <option value="">All Time</option>
                <option value="today">Today</option>
                <option value="week">This Week</option>
                <option value="month">This Month</option>
              </select>
            </div>
            <div>
              <label for="applications-per-page" class="block text-xs sm:text-sm font-medium text-gray-700 mb-1">Per Page</label>
              <select
                id="applications-per-page"
                v-model="filters.per_page"
                name="applications-per-page"
                class="w-full px-3 py-2 text-sm rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 touch-manipulation"
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
          :data="applications"
          :loading="loading"
          :pagination="pagination"
          :sort-by="filters.sort_by"
          :sort-order="filters.sort_order"
          @sort="handleSort"
          @page-change="handlePageChange"
        >
          <template #cell-applicant="{ item }">
            <div class="flex items-center">
              <div class="flex-shrink-0 h-10 w-10">
                <div class="h-10 w-10 rounded-full bg-indigo-100 flex items-center justify-center">
                  <span class="text-sm font-medium text-indigo-700">
                    {{ item.user?.name?.charAt(0).toUpperCase() }}
                  </span>
                </div>
              </div>
              <div class="ml-4">
                <div class="text-sm font-medium text-gray-900">{{ item.user?.name || 'Unknown' }}</div>
                <div class="text-sm text-gray-500">{{ item.user?.email || '-' }}</div>
              </div>
            </div>
          </template>

          <template #cell-job="{ item }">
            <div>
              <div class="text-sm font-medium text-gray-900">{{ item.job?.title || 'Unknown Job' }}</div>
              <div class="text-sm text-gray-500">{{ item.job?.company?.name || 'Unknown Company' }}</div>
            </div>
          </template>

          <template #cell-status="{ item }">
            <select
              :value="item.status"
              @change="updateStatus(item, ($event.target as HTMLSelectElement).value)"
              :class="[
                item.status === 'pending' ? 'bg-yellow-50 border-yellow-200 text-yellow-800' :
                item.status === 'reviewed' ? 'bg-blue-50 border-blue-200 text-blue-800' :
                item.status === 'interview' ? 'bg-purple-50 border-purple-200 text-purple-800' :
                item.status === 'accepted' ? 'bg-green-50 border-green-200 text-green-800' :
                'bg-red-50 border-red-200 text-red-800',
                'text-xs font-medium rounded-full px-2.5 py-1.5 border cursor-pointer focus:outline-none focus:ring-2 focus:ring-indigo-500'
              ]"
            >
              <option value="pending">Pending</option>
              <option value="reviewed">Reviewed</option>
              <option value="interview">Interview</option>
              <option value="accepted">Accepted</option>
              <option value="rejected">Rejected</option>
            </select>
          </template>

          <template #cell-applied_at="{ value }">
            <span class="text-sm text-gray-900">{{ formatDate(value) }}</span>
          </template>

          <template #actions="{ item }">
            <div class="flex items-center space-x-3">
              <button
                @click="viewCV(item)"
                class="text-indigo-600 hover:text-indigo-900"
                title="View CV"
                :disabled="!item.cv_id"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
              </button>
              <button
                @click="viewDetails(item)"
                class="text-green-600 hover:text-green-900"
                title="View Details"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
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

    <!-- Application Details Modal -->
    <BaseModal v-model="showDetailsModal" title="Application Details" size="lg">
      <div v-if="selectedApplication" class="space-y-4">
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-500">Applicant</label>
            <p class="mt-1 text-sm text-gray-900">{{ selectedApplication.user?.name }}</p>
            <p class="text-sm text-gray-500">{{ selectedApplication.user?.email }}</p>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-500">Job Title</label>
            <p class="mt-1 text-sm text-gray-900">{{ selectedApplication.job?.title }}</p>
            <p class="text-sm text-gray-500">{{ selectedApplication.job?.company?.name }}</p>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-500">Status</label>
            <p class="mt-1">
              <span
                :class="[
                  selectedApplication.status === 'pending' ? 'bg-yellow-100 text-yellow-800' :
                  selectedApplication.status === 'reviewed' ? 'bg-blue-100 text-blue-800' :
                  selectedApplication.status === 'interview' ? 'bg-purple-100 text-purple-800' :
                  selectedApplication.status === 'accepted' ? 'bg-green-100 text-green-800' :
                  'bg-red-100 text-red-800',
                  'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium'
                ]"
              >
                {{ selectedApplication.status.charAt(0).toUpperCase() + selectedApplication.status.slice(1) }}
              </span>
            </p>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-500">Applied Date</label>
            <p class="mt-1 text-sm text-gray-900">{{ formatDate(selectedApplication.applied_at) }}</p>
          </div>
        </div>
        <div v-if="selectedApplication.cover_letter">
          <label class="block text-sm font-medium text-gray-500">Cover Letter</label>
          <p class="mt-1 text-sm text-gray-900 whitespace-pre-wrap">{{ selectedApplication.cover_letter }}</p>
        </div>
      </div>
    </BaseModal>

    <!-- Delete Confirmation Modal -->
    <BaseModal v-model="showDeleteModal" title="Delete Application">
      <div class="space-y-4">
        <p class="text-sm text-gray-500">
          Are you sure you want to delete this application from <strong>{{ deletingApplication?.user?.name }}</strong>? 
          This action cannot be undone.
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
            @click="deleteApplication"
            :disabled="deleting"
            class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-red-600 hover:bg-red-700 disabled:opacity-50"
          >
            {{ deleting ? 'Deleting...' : 'Delete' }}
          </button>
        </div>
      </div>
    </BaseModal>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseModal from '@/components/base/BaseModal.vue'
import DataTable from '@/components/admin/DataTable.vue'
import axios from 'axios'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()

const applications = ref<any[]>([])
const loading = ref(true)
const deleting = ref(false)
const pagination = ref<any>(null)
const showDetailsModal = ref(false)
const showDeleteModal = ref(false)
const selectedApplication = ref<any>(null)
const deletingApplication = ref<any>(null)

const filters = reactive({
  search: '',
  status: '',
  date_range: '',
  job_id: (route.query.job_id as string) || '',
  sort_by: 'applied_at',
  sort_order: 'desc' as 'asc' | 'desc',
  per_page: 25,
  page: 1
})

const columns = [
  { key: 'applicant', label: 'Applicant', sortable: false },
  { key: 'job', label: 'Job', sortable: false },
  { key: 'status', label: 'Status', sortable: true },
  { key: 'applied_at', label: 'Applied Date', sortable: true }
]

const fetchApplications = async () => {
  loading.value = true
  try {
    const params: any = {
      page: filters.page,
      per_page: filters.per_page,
      sort_by: filters.sort_by,
      sort_order: filters.sort_order
    }

    if (filters.search) params.search = filters.search
    if (filters.status) params.status = filters.status
    if (filters.date_range) params.date_range = filters.date_range
    if (filters.job_id) params.job_id = filters.job_id

    const response = await axios.get('/api/admin/applications', {
      headers: { Authorization: `Bearer ${authStore.token}` },
      params
    })

    applications.value = response.data.data
    pagination.value = response.data.meta
  } catch (error) {
    console.error('Failed to fetch applications:', error)
  } finally {
    loading.value = false
  }
}

const handleFilterChange = () => {
  filters.page = 1
  fetchApplications()
}

const handleSort = (key: string, order: 'asc' | 'desc') => {
  filters.sort_by = key
  filters.sort_order = order
  fetchApplications()
}

const handlePageChange = (page: number) => {
  filters.page = page
  fetchApplications()
}

const updateStatus = async (application: any, newStatus: string) => {
  try {
    await axios.put(
      `/api/admin/applications/${application.id}`,
      { status: newStatus },
      { headers: { Authorization: `Bearer ${authStore.token}` } }
    )
    fetchApplications()
  } catch (error: any) {
    console.error('Failed to update application status:', error)
    alert(error.response?.data?.message || 'Failed to update application status')
  }
}

const viewCV = (application: any) => {
  if (application.cv_id) {
    router.push({ name: 'view-cv', params: { id: application.cv_id } })
  }
}

const viewDetails = (application: any) => {
  selectedApplication.value = application
  showDetailsModal.value = true
}

const confirmDelete = (application: any) => {
  deletingApplication.value = application
  showDeleteModal.value = true
}

const deleteApplication = async () => {
  if (!deletingApplication.value) return
  
  deleting.value = true
  try {
    await axios.delete(`/api/admin/applications/${deletingApplication.value.id}`, {
      headers: { Authorization: `Bearer ${authStore.token}` }
    })
    showDeleteModal.value = false
    deletingApplication.value = null
    fetchApplications()
  } catch (error: any) {
    console.error('Failed to delete application:', error)
    alert(error.response?.data?.message || 'Failed to delete application')
  } finally {
    deleting.value = false
  }
}

const formatDate = (date: string) => {
  return new Date(date).toLocaleDateString('en-US', { 
    year: 'numeric', 
    month: 'short', 
    day: 'numeric' 
  })
}

onMounted(() => {
  fetchApplications()
})
</script>
