<template>
  <AdminLayout>
    <div class="p-6">
      <BaseCard>
        <div class="mb-6">
          <h1 class="text-2xl font-bold text-gray-900 mb-2">Free CVs Management</h1>
          <p class="text-gray-600">View and manage all candidate CVs in the system</p>
        </div>

        <!-- Filters -->
        <div class="mb-6 grid grid-cols-1 md:grid-cols-3 gap-4">
          <BaseInput
            v-model="filters.search"
            type="text"
            placeholder="Search by name, title, or skills..."
            @input="handleSearch"
          >
            <template #icon-left>
              <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </template>
          </BaseInput>

          <select
            v-model="filters.visibility"
            class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
            @change="() => fetchCvs()"
          >
            <option value="">All CVs</option>
            <option value="public">Public Only</option>
            <option value="private">Private Only</option>
          </select>

          <BaseButton variant="secondary" @click="resetFilters" class="w-full">
            <template #icon-left>
              <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
              </svg>
            </template>
            Reset
          </BaseButton>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="text-center py-12">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600 mx-auto"></div>
          <p class="text-gray-600 mt-4">Loading CVs...</p>
        </div>

        <!-- Error State -->
        <div v-else-if="error" class="text-center py-12">
          <p class="text-red-600">{{ error }}</p>
          <BaseButton variant="primary" class="mt-4" @click="() => fetchCvs()">Try Again</BaseButton>
        </div>

        <!-- Data Table -->
        <DataTable
          v-else
          :columns="columns"
          :data="cvs"
          :loading="loading"
          empty-message="No CVs found"
        >
          <template #cell-full_name="{ item }">
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 rounded-full bg-primary-100 flex items-center justify-center flex-shrink-0">
                <img
                  v-if="item.profile_image_url"
                  :src="item.profile_image_url"
                  :alt="item.full_name"
                  class="w-full h-full rounded-full object-cover"
                />
                <BaseAvatar v-else :name="item.full_name" size="sm" />
              </div>
              <div>
                <div class="font-medium text-gray-900">{{ item.full_name }}</div>
                <div class="text-sm text-gray-500">{{ item.email }}</div>
              </div>
            </div>
          </template>

          <template #cell-title="{ item }">
            <span class="text-gray-900">{{ item.title || '—' }}</span>
          </template>

          <template #cell-location="{ item }">
            <span class="text-gray-600">{{ item.location || '—' }}</span>
          </template>

          <template #cell-is_public="{ item }">
            <span
              :class="[
                'px-2 py-1 rounded-full text-xs font-medium',
                item.is_public
                  ? 'bg-green-100 text-green-700'
                  : 'bg-gray-100 text-gray-700'
              ]"
            >
              {{ item.is_public ? 'Public' : 'Private' }}
            </span>
          </template>

          <template #cell-is_primary="{ item }">
            <span
              v-if="item.is_primary"
              class="px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-700"
            >
              Primary
            </span>
            <span v-else class="text-gray-400">—</span>
          </template>

          <template #cell-created_at="{ item }">
            <span class="text-gray-600">{{ formatDate(item.created_at) }}</span>
          </template>

          <template #cell-actions="{ item }">
            <div class="flex items-center gap-2">
              <button
                @click="viewCv(item)"
                class="text-primary-600 hover:text-primary-700 p-2 hover:bg-primary-50 rounded"
                title="View CV"
              >
                <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                </svg>
              </button>
              <button
                @click="deleteCv(item)"
                class="text-red-600 hover:text-red-700 p-2 hover:bg-red-50 rounded"
                title="Delete CV"
              >
                <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                </svg>
              </button>
            </div>
          </template>
        </DataTable>

        <!-- Pagination -->
        <div v-if="pagination.total > pagination.per_page" class="mt-6 flex justify-between items-center">
          <div class="text-sm text-gray-600">
            Showing {{ pagination.from }} to {{ pagination.to }} of {{ pagination.total }} CVs
          </div>
          <div class="flex gap-2">
            <BaseButton
              variant="secondary"
              size="sm"
              :disabled="pagination.current_page === 1"
              @click="goToPage(pagination.current_page - 1)"
            >
              Previous
            </BaseButton>
            <BaseButton
              variant="secondary"
              size="sm"
              :disabled="pagination.current_page === pagination.last_page"
              @click="goToPage(pagination.current_page + 1)"
            >
              Next
            </BaseButton>
          </div>
        </div>
      </BaseCard>

      <!-- Delete Confirmation Modal -->
      <BaseModal v-model="showDeleteModal" title="Delete CV" max-width="md">
        <p class="text-gray-600 mb-4">
          Are you sure you want to delete the CV for <strong>{{ selectedCv?.full_name }}</strong>?
          This action cannot be undone.
        </p>
        <div class="flex justify-end gap-3">
          <BaseButton variant="secondary" @click="showDeleteModal = false">Cancel</BaseButton>
          <BaseButton variant="danger" @click="confirmDelete" :loading="deleting">
            Delete CV
          </BaseButton>
        </div>
      </BaseModal>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import api from '@/services/api'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import DataTable from '@/components/admin/DataTable.vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseModal from '@/components/base/BaseModal.vue'
import BaseAvatar from '@/components/base/BaseAvatar.vue'

const router = useRouter()

interface Cv {
  id: number
  slug: string
  user_id: number
  full_name: string
  email: string
  title: string | null
  location: string
  is_public: boolean
  is_primary: boolean
  profile_image_url: string | null
  created_at: string
  updated_at: string
}

const columns = [
  { key: 'full_name', label: 'Candidate', sortable: true },
  { key: 'title', label: 'Title', sortable: true },
  { key: 'location', label: 'Location', sortable: false },
  { key: 'is_public', label: 'Visibility', sortable: true },
  { key: 'is_primary', label: 'Primary', sortable: true },
  { key: 'created_at', label: 'Created', sortable: true },
  { key: 'actions', label: 'Actions', sortable: false },
]

const cvs = ref<Cv[]>([])
const loading = ref(false)
const error = ref('')
const filters = ref({
  search: '',
  visibility: '',
})

const pagination = ref({
  current_page: 1,
  last_page: 1,
  per_page: 15,
  total: 0,
  from: 0,
  to: 0,
})

const showDeleteModal = ref(false)
const selectedCv = ref<Cv | null>(null)
const deleting = ref(false)

let searchTimeout: number | null = null

const fetchCvs = async (page = 1) => {
  loading.value = true
  error.value = ''

  try {
    const params: Record<string, string | number> = { page }

    if (filters.value.search) {
      params.search = filters.value.search
    }

    if (filters.value.visibility) {
      params.visibility = filters.value.visibility
    }

    const response = await api.get('/admin/cvs', { params })

    if (response.data.success) {
      const data = response.data.data
      
      cvs.value = data.data.map((cv: any) => ({
        id: cv.id,
        slug: cv.slug,
        user_id: cv.user_id,
        full_name: cv.full_name,
        email: cv.email,
        title: cv.title,
        location: [cv.city, cv.country].filter(Boolean).join(', ') || 'Not specified',
        is_public: cv.is_public,
        is_primary: cv.is_primary,
        profile_image_url: cv.profile_image_path ? `/storage/${cv.profile_image_path}` : null,
        created_at: cv.created_at,
        updated_at: cv.updated_at,
      }))

      pagination.value = {
        current_page: data.current_page,
        last_page: data.last_page,
        per_page: data.per_page,
        total: data.total,
        from: data.from,
        to: data.to,
      }
    }
  } catch (err: any) {
    error.value = err.response?.data?.message || 'Failed to load CVs'
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  if (searchTimeout) clearTimeout(searchTimeout)
  searchTimeout = window.setTimeout(() => {
    fetchCvs(1)
  }, 500)
}

const resetFilters = () => {
  filters.value = {
    search: '',
    visibility: '',
  }
  fetchCvs(1)
}

const goToPage = (page: number) => {
  fetchCvs(page)
}

const viewCv = (cv: Cv) => {
  router.push(`/admin/cvs/${cv.slug}`)
}

const deleteCv = (cv: Cv) => {
  selectedCv.value = cv
  showDeleteModal.value = true
}

const confirmDelete = async () => {
  if (!selectedCv.value) return

  deleting.value = true
  try {
    await api.delete(`/admin/cvs/${selectedCv.value.id}`)
    showDeleteModal.value = false
    selectedCv.value = null
    fetchCvs(pagination.value.current_page)
  } catch (err: any) {
    error.value = err.response?.data?.message || 'Failed to delete CV'
  } finally {
    deleting.value = false
  }
}

const formatDate = (dateString: string) => {
  return new Date(dateString).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  })
}

onMounted(() => {
  fetchCvs()
})
</script>
