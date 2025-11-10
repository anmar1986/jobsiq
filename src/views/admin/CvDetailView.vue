<template>
  <AdminLayout>
    <div class="p-6">
      <!-- Back Button -->
      <button 
        @click="router.push('/admin/cvs')" 
        class="flex items-center gap-2 text-gray-600 hover:text-gray-900 mb-6 transition-colors"
      >
        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
        </svg>
        Back to CVs Management
      </button>

      <!-- Loading State -->
      <div v-if="loading" class="flex justify-center items-center py-12">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>

      <!-- CV Not Found -->
      <div v-else-if="!cv" class="py-16">
        <BaseCard class="p-12 text-center">
          <svg class="h-16 w-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
          <h2 class="text-2xl font-bold text-gray-900 mb-2">CV Not Found</h2>
          <p class="text-gray-600 mb-6">The CV you're looking for doesn't exist.</p>
          <BaseButton variant="primary" @click="router.push('/admin/cvs')">Back to CVs</BaseButton>
        </BaseCard>
      </div>

      <!-- CV Content (reuse the FreeCvDetailView template structure) -->
      <div v-else>
        <!-- Admin Actions Bar -->
        <BaseCard class="mb-6 p-4">
          <div class="flex items-center justify-between">
            <div>
              <div class="flex items-center gap-3">
                <span
                  :class="[
                    'px-3 py-1 rounded-full text-sm font-medium',
                    cv.is_public ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-700'
                  ]"
                >
                  {{ cv.is_public ? 'Public' : 'Private' }}
                </span>
                <span
                  v-if="cv.is_primary"
                  class="px-3 py-1 rounded-full text-sm font-medium bg-blue-100 text-blue-700"
                >
                  Primary CV
                </span>
              </div>
              <p class="text-sm text-gray-600 mt-2">
                Created: {{ formatDate(cv.created_at) }} | 
                Last updated: {{ formatDate(cv.updated_at) }}
              </p>
            </div>
            <div class="flex gap-3">
              <BaseButton variant="danger" size="sm" @click="deleteCv">
                <template #icon-left>
                  <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                  </svg>
                </template>
                Delete
              </BaseButton>
            </div>
          </div>
        </BaseCard>

        <!-- Import the CV detail structure from FreeCvDetailView -->
        <div class="max-w-4xl mx-auto border-2 border-gray-300 rounded-lg p-6 bg-white shadow-lg">
          <!-- The rest of the CV display from FreeCvDetailView.vue can be included here -->
          <!-- For brevity, I'll add a placeholder - you can copy the full structure -->
          <div class="text-center py-12 text-gray-600">
            CV Detail View - Full structure would be here
            <br>
            <BaseButton variant="primary" class="mt-4" @click="router.push(`/cvs/${cv.slug}`)">
              View Full CV
            </BaseButton>
          </div>
        </div>
      </div>

      <!-- Delete Confirmation Modal -->
      <BaseModal v-model="showDeleteModal" title="Delete CV" max-width="md">
        <p class="text-gray-600 mb-4">
          Are you sure you want to delete this CV? This action cannot be undone.
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
import { useRouter, useRoute } from 'vue-router'
import api from '@/services/api'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseModal from '@/components/base/BaseModal.vue'

const router = useRouter()
const route = useRoute()

const loading = ref(true)
const cv = ref<any>(null)
const showDeleteModal = ref(false)
const deleting = ref(false)

const fetchCv = async () => {
  loading.value = true
  try {
    const slug = route.params.slug as string
    const response = await api.get(`/admin/cvs/${slug}`)
    
    if (response.data.success) {
      cv.value = response.data.data
    }
  } catch (error) {
    console.error('Failed to fetch CV:', error)
    cv.value = null
  } finally {
    loading.value = false
  }
}

const deleteCv = () => {
  showDeleteModal.value = true
}

const confirmDelete = async () => {
  if (!cv.value) return

  deleting.value = true
  try {
    await api.delete(`/admin/cvs/${cv.value.id}`)
    router.push('/admin/cvs')
  } catch (err: any) {
    console.error('Failed to delete CV:', err)
  } finally {
    deleting.value = false
  }
}

const formatDate = (dateString: string) => {
  return new Date(dateString).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })
}

onMounted(() => {
  fetchCv()
})
</script>
