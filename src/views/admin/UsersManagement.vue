<template>
  <AdminLayout>
    <div class="space-y-4 sm:space-y-6">
      <!-- Header -->
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-end gap-4">
        <button
          @click="showCreateModal = true"
          class="w-full sm:w-auto inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 touch-manipulation"
        >
          <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
          </svg>
          Create User
        </button>
      </div>

      <!-- Filters -->
      <BaseCard>
        <div class="p-4 sm:p-6">
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <div>
              <label for="user-search" class="block text-xs sm:text-sm font-medium text-gray-700 mb-1">Search</label>
              <input
                id="user-search"
                v-model="filters.search"
                type="text"
                name="user-search"
                placeholder="Name or email..."
                class="w-full px-3 py-2 text-sm rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 touch-manipulation"
                @input="handleFilterChange"
              />
            </div>
            <div>
              <label for="user-type" class="block text-xs sm:text-sm font-medium text-gray-700 mb-1">User Type</label>
              <select
                id="user-type"
                v-model="filters.user_type"
                name="user-type"
                class="w-full px-3 py-2 text-sm rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 touch-manipulation"
                @change="handleFilterChange"
              >
                <option value="">All Types</option>
                <option value="job_seeker">Job Seeker</option>
                <option value="company_owner">Company Owner</option>
              </select>
            </div>
            <div>
              <label for="admin-status" class="block text-xs sm:text-sm font-medium text-gray-700 mb-1">Admin Status</label>
              <select
                id="admin-status"
                v-model="filters.is_admin"
                name="admin-status"
                class="w-full px-3 py-2 text-sm rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 touch-manipulation"
                @change="handleFilterChange"
              >
                <option value="">All Users</option>
                <option value="1">Admins Only</option>
                <option value="0">Non-Admins</option>
              </select>
            </div>
            <div>
              <label for="users-per-page" class="block text-xs sm:text-sm font-medium text-gray-700 mb-1">Per Page</label>
              <select
                id="users-per-page"
                v-model="filters.per_page"
                name="users-per-page"
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
          :data="users"
          :loading="loading"
          :pagination="pagination"
          :sort-by="filters.sort_by"
          :sort-order="filters.sort_order"
          @sort="handleSort"
          @page-change="handlePageChange"
        >
          <template #cell-name="{ item, index }">
            <div class="flex items-center">
              <div class="flex-shrink-0 h-10 w-10">
                <div class="h-10 w-10 rounded-full bg-indigo-100 flex items-center justify-center">
                  <span class="text-sm font-medium text-indigo-700">
                    {{ getUserNumber(index) }}
                  </span>
                </div>
              </div>
              <div class="ml-4">
                <div class="text-sm font-medium text-gray-900">{{ item.name }}</div>
                <div class="text-sm text-gray-500">{{ item.email }}</div>
              </div>
            </div>
          </template>

          <template #cell-user_type="{ value }">
            <span
              :class="[
                value === 'job_seeker' ? 'bg-green-100 text-green-800' : 'bg-blue-100 text-blue-800',
                'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium'
              ]"
            >
              {{ value === 'job_seeker' ? 'Job Seeker' : 'Company Owner' }}
            </span>
          </template>

          <template #cell-is_admin="{ value }">
            <span v-if="value" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-purple-100 text-purple-800">
              Admin
            </span>
            <span v-else class="text-sm text-gray-500">-</span>
          </template>

          <template #cell-created_at="{ value }">
            <span class="text-sm text-gray-900">{{ formatDate(value) }}</span>
          </template>

          <template #actions="{ item }">
            <div class="flex items-center space-x-3">
              <button
                @click="viewUser(item)"
                class="text-indigo-600 hover:text-indigo-900"
                title="View"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                </svg>
              </button>
              <button
                @click="editUser(item)"
                class="text-yellow-600 hover:text-yellow-900"
                title="Edit"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
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

    <!-- Create/Edit User Modal -->
    <BaseModal v-model="showCreateModal" :title="editingUser ? 'Edit User' : 'Create User'">
      <form @submit.prevent="saveUser" class="space-y-4">
        <div>
          <label for="modal-user-name" class="block text-sm font-medium text-gray-700 mb-1">Name</label>
          <input
            id="modal-user-name"
            v-model="userForm.name"
            type="text"
            name="modal-user-name"
            required
            class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
          />
        </div>
        <div>
          <label for="modal-user-email" class="block text-sm font-medium text-gray-700 mb-1">Email</label>
          <input
            id="modal-user-email"
            v-model="userForm.email"
            type="email"
            name="modal-user-email"
            required
            class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
          />
        </div>
        <div v-if="!editingUser">
          <label for="modal-user-password" class="block text-sm font-medium text-gray-700 mb-1">Password</label>
          <input
            id="modal-user-password"
            v-model="userForm.password"
            type="password"
            name="modal-user-password"
            :required="!editingUser"
            class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
          />
        </div>
        <div>
          <label for="modal-user-type" class="block text-sm font-medium text-gray-700 mb-1">User Type</label>
          <select
            id="modal-user-type"
            v-model="userForm.user_type"
            name="modal-user-type"
            required
            class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
          >
            <option value="job_seeker">Job Seeker</option>
            <option value="company_owner">Company Owner</option>
          </select>
        </div>
        <div class="flex items-center">
          <input
            id="modal-user-admin"
            v-model="userForm.is_admin"
            type="checkbox"
            name="modal-user-admin"
            class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
          />
          <label for="modal-user-admin" class="ml-2 block text-sm text-gray-900">Admin User</label>
        </div>
        <div class="flex justify-end space-x-3 pt-4">
          <button
            type="button"
            @click="showCreateModal = false"
            class="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
          >
            Cancel
          </button>
          <button
            type="submit"
            :disabled="saving"
            class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 disabled:opacity-50"
          >
            {{ saving ? 'Saving...' : 'Save User' }}
          </button>
        </div>
      </form>
    </BaseModal>

    <!-- Delete Confirmation Modal -->
    <BaseModal v-model="showDeleteModal" title="Delete User">
      <div class="space-y-4">
        <p class="text-sm text-gray-500">
          Are you sure you want to delete <strong>{{ deletingUser?.name }}</strong>? This action cannot be undone.
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
            @click="deleteUser"
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
import { useAuthStore } from '@/stores/auth'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseModal from '@/components/base/BaseModal.vue'
import DataTable from '@/components/admin/DataTable.vue'
import axios from 'axios'

const authStore = useAuthStore()

const users = ref<any[]>([])
const loading = ref(true)
const saving = ref(false)
const deleting = ref(false)
const pagination = ref<any>(null)
const showCreateModal = ref(false)
const showDeleteModal = ref(false)
const editingUser = ref<any>(null)
const deletingUser = ref<any>(null)

const filters = reactive({
  search: '',
  user_type: '',
  is_admin: '',
  sort_by: 'created_at',
  sort_order: 'desc' as 'asc' | 'desc',
  per_page: 25,
  page: 1
})

const userForm = reactive({
  name: '',
  email: '',
  password: '',
  user_type: 'job_seeker',
  is_admin: false
})

const columns = [
  { key: 'name', label: 'User', sortable: true },
  { key: 'user_type', label: 'Type', sortable: true },
  { key: 'is_admin', label: 'Admin', sortable: true },
  { key: 'created_at', label: 'Joined', sortable: true }
]

const fetchUsers = async () => {
  loading.value = true
  try {
    const params: any = {
      page: filters.page,
      per_page: filters.per_page,
      sort_by: filters.sort_by,
      sort_order: filters.sort_order
    }

    if (filters.search) params.search = filters.search
    if (filters.user_type) params.user_type = filters.user_type
    if (filters.is_admin !== '') params.is_admin = filters.is_admin

    const response = await axios.get('/api/admin/users', {
      headers: { Authorization: `Bearer ${authStore.token}` },
      params
    })

    users.value = response.data.data
    pagination.value = response.data.meta
  } catch (error) {
    console.error('Failed to fetch users:', error)
  } finally {
    loading.value = false
  }
}

const handleFilterChange = () => {
  filters.page = 1
  fetchUsers()
}

const handleSort = (key: string, order: 'asc' | 'desc') => {
  filters.sort_by = key
  filters.sort_order = order
  fetchUsers()
}

const handlePageChange = (page: number) => {
  filters.page = page
  fetchUsers()
}

const viewUser = (user: any) => {
  // TODO: Implement user detail view
  console.log('View user:', user)
}

const editUser = (user: any) => {
  editingUser.value = user
  userForm.name = user.name
  userForm.email = user.email
  userForm.user_type = user.user_type
  userForm.is_admin = user.is_admin || false
  userForm.password = ''
  showCreateModal.value = true
}

const resetForm = () => {
  userForm.name = ''
  userForm.email = ''
  userForm.password = ''
  userForm.user_type = 'job_seeker'
  userForm.is_admin = false
  editingUser.value = null
}

const saveUser = async () => {
  saving.value = true
  try {
    const data: any = {
      name: userForm.name,
      email: userForm.email,
      user_type: userForm.user_type,
      is_admin: userForm.is_admin
    }

    if (!editingUser.value && userForm.password) {
      data.password = userForm.password
    }

    if (editingUser.value) {
      await axios.put(`/api/admin/users/${editingUser.value.id}`, data, {
        headers: { Authorization: `Bearer ${authStore.token}` }
      })
    } else {
      await axios.post('/api/admin/users', data, {
        headers: { Authorization: `Bearer ${authStore.token}` }
      })
    }

    showCreateModal.value = false
    resetForm()
    fetchUsers()
  } catch (error: any) {
    console.error('Failed to save user:', error)
    alert(error.response?.data?.message || 'Failed to save user')
  } finally {
    saving.value = false
  }
}

const confirmDelete = (user: any) => {
  deletingUser.value = user
  showDeleteModal.value = true
}

const deleteUser = async () => {
  if (!deletingUser.value) return
  
  deleting.value = true
  try {
    await axios.delete(`/api/admin/users/${deletingUser.value.id}`, {
      headers: { Authorization: `Bearer ${authStore.token}` }
    })
    showDeleteModal.value = false
    deletingUser.value = null
    fetchUsers()
  } catch (error: any) {
    console.error('Failed to delete user:', error)
    alert(error.response?.data?.message || 'Failed to delete user')
  } finally {
    deleting.value = false
  }
}

const getUserNumber = (index: number) => {
  // Calculate the actual user number based on pagination
  const currentPage = pagination.value?.current_page || 1
  const perPage = filters.per_page
  return (currentPage - 1) * perPage + index + 1
}

const formatDate = (date: string) => {
  return new Date(date).toLocaleDateString('en-US', { 
    year: 'numeric', 
    month: 'short', 
    day: 'numeric' 
  })
}

onMounted(() => {
  fetchUsers()
})
</script>
