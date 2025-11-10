<template>
  <AdminLayout>
    <div class="space-y-6">
      <!-- Header -->
      <div class="flex items-center justify-between">
      </div>

      <!-- Filters -->
      <BaseCard>
        <div class="p-6">
          <div class="grid grid-cols-1 md:grid-cols-5 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Search</label>
              <input
                v-model="filters.search"
                type="text"
                placeholder="Job title..."
                class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                @input="handleFilterChange"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
              <select
                v-model="filters.status"
                class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                @change="handleFilterChange"
              >
                <option value="">All Statuses</option>
                <option value="active">Active</option>
                <option value="closed">Closed</option>
                <option value="draft">Draft</option>
              </select>
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Job Type</label>
              <select
                v-model="filters.job_type"
                class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                @change="handleFilterChange"
              >
                <option value="">All Types</option>
                <option value="full-time">Full-time</option>
                <option value="part-time">Part-time</option>
                <option value="contract">Contract</option>
                <option value="freelance">Freelance</option>
              </select>
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Featured</label>
              <select
                v-model="filters.is_featured"
                class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
                @change="handleFilterChange"
              >
                <option value="">All Jobs</option>
                <option value="1">Featured Only</option>
                <option value="0">Non-Featured</option>
              </select>
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
          :data="jobs"
          :loading="loading"
          :pagination="pagination"
          :sort-by="filters.sort_by"
          :sort-order="filters.sort_order"
          @sort="handleSort"
          @page-change="handlePageChange"
        >
          <template #cell-title="{ item }">
            <div>
              <div class="text-sm font-medium text-gray-900">{{ item.title }}</div>
              <div class="text-sm text-gray-500">{{ item.company?.name || 'Unknown Company' }}</div>
            </div>
          </template>

          <template #cell-status="{ value }">
            <span
              :class="[
                value === 'active' ? 'bg-green-100 text-green-800' :
                value === 'closed' ? 'bg-red-100 text-red-800' :
                'bg-gray-100 text-gray-800',
                'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium'
              ]"
            >
              {{ value.charAt(0).toUpperCase() + value.slice(1) }}
            </span>
          </template>

          <template #cell-job_type="{ value }">
            <span class="text-sm text-gray-900">
              {{ value.split('-').map((w: string) => w.charAt(0).toUpperCase() + w.slice(1)).join(' ') }}
            </span>
          </template>

          <template #cell-is_featured="{ item }">
            <button
              @click="toggleFeatured(item)"
              :class="[
                item.is_featured ? 'bg-yellow-100 text-yellow-800' : 'bg-gray-100 text-gray-600',
                'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium cursor-pointer hover:opacity-80'
              ]"
            >
              <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
              </svg>
              {{ item.is_featured ? 'Featured' : 'Not Featured' }}
            </button>
          </template>

          <template #cell-applications_count="{ value }">
            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
              {{ value }} Applications
            </span>
          </template>

          <template #actions="{ item }">
            <div class="flex items-center space-x-3">
              <button
                @click="viewJob(item)"
                class="text-indigo-600 hover:text-indigo-900"
                title="View"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                </svg>
              </button>
              <button
                @click="viewApplications(item)"
                class="text-green-600 hover:text-green-900"
                title="View Applications"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
              </button>
              <button
                @click="changeStatus(item)"
                class="text-yellow-600 hover:text-yellow-900"
                title="Change Status"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4" />
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

    <!-- Change Status Modal -->
    <BaseModal v-model="showStatusModal" title="Change Job Status">
      <form @submit.prevent="updateStatus" class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Job Title</label>
          <p class="text-sm text-gray-900">{{ editingJob?.title }}</p>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
          <select
            v-model="newStatus"
            required
            class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
          >
            <option value="active">Active</option>
            <option value="closed">Closed</option>
            <option value="draft">Draft</option>
          </select>
        </div>
        <div class="flex justify-end space-x-3 pt-4">
          <button
            type="button"
            @click="showStatusModal = false"
            class="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
          >
            Cancel
          </button>
          <button
            type="submit"
            :disabled="updating"
            class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 disabled:opacity-50"
          >
            {{ updating ? 'Updating...' : 'Update Status' }}
          </button>
        </div>
      </form>
    </BaseModal>

    <!-- Delete Confirmation Modal -->
    <BaseModal v-model="showDeleteModal" title="Delete Job">
      <div class="space-y-4">
        <p class="text-sm text-gray-500">
          Are you sure you want to delete <strong>{{ deletingJob?.title }}</strong>? 
          This will also delete all associated applications. This action cannot be undone.
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
            @click="deleteJob"
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

const jobs = ref<any[]>([])
const loading = ref(true)
const updating = ref(false)
const deleting = ref(false)
const pagination = ref<any>(null)
const showStatusModal = ref(false)
const showDeleteModal = ref(false)
const editingJob = ref<any>(null)
const deletingJob = ref<any>(null)
const newStatus = ref('active')

const filters = reactive({
  search: '',
  status: '',
  job_type: '',
  is_featured: '',
  company_id: (route.query.company_id as string) || '',
  sort_by: 'created_at',
  sort_order: 'desc' as 'asc' | 'desc',
  per_page: 25,
  page: 1
})

const columns = [
  { key: 'title', label: 'Job Title', sortable: true },
  { key: 'status', label: 'Status', sortable: true },
  { key: 'job_type', label: 'Type', sortable: true },
  { key: 'is_featured', label: 'Featured', sortable: true },
  { key: 'applications_count', label: 'Applications', sortable: true }
]

const fetchJobs = async () => {
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
    if (filters.job_type) params.job_type = filters.job_type
    if (filters.is_featured !== '') params.is_featured = filters.is_featured
    if (filters.company_id) params.company_id = filters.company_id

    const response = await axios.get('/api/admin/jobs', {
      headers: { Authorization: `Bearer ${authStore.token}` },
      params
    })

    jobs.value = response.data.data
    pagination.value = response.data.meta
  } catch (error) {
    console.error('Failed to fetch jobs:', error)
  } finally {
    loading.value = false
  }
}

const handleFilterChange = () => {
  filters.page = 1
  fetchJobs()
}

const handleSort = (key: string, order: 'asc' | 'desc') => {
  filters.sort_by = key
  filters.sort_order = order
  fetchJobs()
}

const handlePageChange = (page: number) => {
  filters.page = page
  fetchJobs()
}

const viewJob = (job: any) => {
  router.push({ name: 'job-detail', params: { slug: job.slug } })
}

const viewApplications = (job: any) => {
  router.push({ name: 'admin-applications', query: { job_id: job.id } })
}

const changeStatus = (job: any) => {
  editingJob.value = job
  newStatus.value = job.status
  showStatusModal.value = true
}

const updateStatus = async () => {
  if (!editingJob.value) return
  
  updating.value = true
  try {
    await axios.put(
      `/api/admin/jobs/${editingJob.value.id}`,
      { status: newStatus.value },
      { headers: { Authorization: `Bearer ${authStore.token}` } }
    )
    showStatusModal.value = false
    editingJob.value = null
    fetchJobs()
  } catch (error: any) {
    console.error('Failed to update job status:', error)
    alert(error.response?.data?.message || 'Failed to update job status')
  } finally {
    updating.value = false
  }
}

const toggleFeatured = async (job: any) => {
  try {
    await axios.post(
      `/api/admin/jobs/${job.id}/toggle-featured`,
      {},
      { headers: { Authorization: `Bearer ${authStore.token}` } }
    )
    fetchJobs()
  } catch (error: any) {
    console.error('Failed to toggle featured status:', error)
    alert(error.response?.data?.message || 'Failed to toggle featured status')
  }
}

const confirmDelete = (job: any) => {
  deletingJob.value = job
  showDeleteModal.value = true
}

const deleteJob = async () => {
  if (!deletingJob.value) return
  
  deleting.value = true
  try {
    await axios.delete(`/api/admin/jobs/${deletingJob.value.id}`, {
      headers: { Authorization: `Bearer ${authStore.token}` }
    })
    showDeleteModal.value = false
    deletingJob.value = null
    fetchJobs()
  } catch (error: any) {
    console.error('Failed to delete job:', error)
    alert(error.response?.data?.message || 'Failed to delete job')
  } finally {
    deleting.value = false
  }
}

onMounted(() => {
  fetchJobs()
})
</script>
