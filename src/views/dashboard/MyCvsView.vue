<template>
  <div class="container-custom py-8">
    <!-- Header -->
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-3xl font-bold text-gray-900 mb-2">My CVs</h1>
        <p class="text-gray-600">Create and manage your professional CVs ({{ cvs.length }}/6)</p>
      </div>
      <div>
        <BaseButton 
          variant="primary" 
          size="lg" 
          @click="handleCreateCV"
          :disabled="cvs.length >= 6"
          :class="{ 'opacity-50 cursor-not-allowed': cvs.length >= 6 }"
        >
          <template #icon-left>
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
          </template>
          Create New CV
        </BaseButton>
        <p v-if="cvs.length >= 6" class="text-sm text-red-600 mt-2">Maximum CV limit reached (6/6)</p>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div v-for="i in 3" :key="i" class="bg-white rounded-lg border border-gray-200 p-6">
        <div class="animate-pulse">
          <div class="h-6 bg-gray-200 rounded w-3/4 mb-4"></div>
          <div class="h-4 bg-gray-200 rounded w-1/2 mb-6"></div>
          <div class="space-y-2 mb-4">
            <div class="h-3 bg-gray-200 rounded"></div>
            <div class="h-3 bg-gray-200 rounded"></div>
          </div>
          <div class="flex gap-2">
            <div class="h-8 bg-gray-200 rounded w-20"></div>
            <div class="h-8 bg-gray-200 rounded w-20"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Empty State -->
    <BaseCard v-else-if="cvs.length === 0" class="p-12 text-center">
      <svg class="h-16 w-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
      </svg>
      <h3 class="text-xl font-semibold text-gray-900 mb-2">No CVs yet</h3>
      <p class="text-gray-600 mb-6">Create your first CV to start applying for jobs</p>
      <BaseButton variant="primary" @click="router.push('/my-cvs/create')">
        Create Your First CV
      </BaseButton>
    </BaseCard>

    <!-- CVs Grid -->
    <div v-else class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
      <CvCard
        v-for="cv in cvs"
        :key="cv.id"
        :cv="cv"
        :is-selected="selectedCvIds.includes(cv.id)"
        @click="selectCv"
        @view="viewCv"
        @edit="editCv"
        @menu="showCvMenu"
      />
    </div>
    <!-- CV Menu Modal -->
    <BaseModal
      v-model="showMenuModal"
      title="CV Actions"
      size="sm"
    >
      <div class="space-y-2">
        <button
          v-if="!selectedCv?.is_primary"
          @click="setPrimary"
          class="w-full px-4 py-3 text-left hover:bg-gray-50 rounded-lg transition-colors flex items-center gap-3"
        >
          <svg class="w-5 h-5 text-gray-600" fill="currentColor" viewBox="0 0 20 20">
            <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
          </svg>
          <span class="font-medium text-gray-900">Set as Primary</span>
        </button>
        <button
          @click="togglePublic"
          class="w-full px-4 py-3 text-left hover:bg-gray-50 rounded-lg transition-colors flex items-center gap-3"
        >
          <svg v-if="selectedCv?.is_public" class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
          </svg>
          <svg v-else class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
          </svg>
          <span class="font-medium text-gray-900">{{ selectedCv?.is_public ? 'Make Private' : 'Make Public' }}</span>
        </button>
        <button
          @click="duplicateCv"
          class="w-full px-4 py-3 text-left hover:bg-gray-50 rounded-lg transition-colors flex items-center gap-3"
        >
          <svg class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
          </svg>
          <span class="font-medium text-gray-900">Duplicate</span>
        </button>
        <button
          @click="downloadCv"
          class="w-full px-4 py-3 text-left hover:bg-gray-50 rounded-lg transition-colors flex items-center gap-3"
        >
          <svg class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
          <span class="font-medium text-gray-900">Download PDF</span>
        </button>
        <button
          @click="confirmDelete"
          class="w-full px-4 py-3 text-left hover:bg-red-50 rounded-lg transition-colors flex items-center gap-3 text-red-600"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
          </svg>
          <span class="font-medium">Delete CV</span>
        </button>
      </div>
    </BaseModal>

    <!-- Delete Confirmation -->
    <BaseModal
      v-model="showDeleteModal"
      title="Delete CV"
      size="sm"
    >
      <div class="mb-6">
        <p class="text-gray-600">Are you sure you want to delete this CV? This action cannot be undone.</p>
      </div>
      <div class="flex gap-3">
        <BaseButton type="button" variant="outline" @click="showDeleteModal = false" class="flex-1">
          Cancel
        </BaseButton>
        <BaseButton type="button" variant="danger" @click="deleteCv" :loading="deleting" class="flex-1">
          Delete
        </BaseButton>
      </div>
    </BaseModal>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useCvStore } from '@/stores/cv'
import { useToast } from '@/composables/useToast'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseModal from '@/components/base/BaseModal.vue'
import CvCard from '@/components/features/cv/CvCard.vue'
import type { UserCv } from '@/types'

const router = useRouter()
const cvStore = useCvStore()
const toast = useToast()

const loading = ref(false)
const deleting = ref(false)
const showMenuModal = ref(false)
const showDeleteModal = ref(false)
const selectedCv = ref<UserCv | null>(null)
const selectedCvIds = ref<number[]>([])

const cvs = ref<UserCv[]>([])

const loadCvs = async () => {
  loading.value = true
  try {
    await cvStore.fetchMyCvs()
    cvs.value = cvStore.myCvs
  } catch (error) {
    console.error('Failed to load CVs:', error)
  } finally {
    loading.value = false
  }
}

const handleCreateCV = () => {
  if (cvs.value.length >= 6) {
    toast.error('You have reached the maximum number of CVs (6). Please delete an existing CV before creating a new one.')
    return
  }
  router.push('/my-cvs/create')
}

const selectCv = (cv: UserCv) => {
  const index = selectedCvIds.value.indexOf(cv.id)
  if (index > -1) {
    selectedCvIds.value.splice(index, 1)
  } else {
    selectedCvIds.value.push(cv.id)
  }
}

const viewCv = (cv: UserCv) => {
  if (!cv.id) {
    toast.error('This CV cannot be viewed. Please try refreshing the page.')
    return
  }
  router.push(`/my-cvs/view/${cv.id}`)
}

const editCv = (cv: UserCv) => {
  if (!cv.id) {
    toast.error('This CV cannot be edited. Please try refreshing the page.')
    return
  }
  router.push(`/my-cvs/edit/${cv.id}`)
}

const showCvMenu = (cv: UserCv) => {
  selectedCv.value = cv
  showMenuModal.value = true
}

const setPrimary = async () => {
  if (!selectedCv.value) return
  
  try {
    // Update the selected CV to be primary
    await cvStore.updateCv(selectedCv.value.id, {
      is_primary: true
    })
    
    // Update local state
    cvs.value.forEach(cv => {
      cv.is_primary = cv.id === selectedCv.value?.id
    })
    
    toast.success('Primary CV updated successfully!')
    showMenuModal.value = false
  } catch (error: unknown) {
    console.error('Failed to set primary CV:', error)
    const err = error as { response?: { data?: { message?: string } } }
    toast.error(err.response?.data?.message || 'Failed to set primary CV. Please try again.')
  }
}

const togglePublic = async () => {
  if (!selectedCv.value) return
  
  try {
    const cv = cvs.value.find(c => c.id === selectedCv.value?.id)
    if (cv) {
      const newPublicStatus = !cv.is_public
      
      // Update in database
      await cvStore.updateCv(cv.id, {
        is_public: newPublicStatus
      })
      
      // Update local state
      cv.is_public = newPublicStatus
      
      toast.success(`CV is now ${newPublicStatus ? 'public' : 'private'}`)
    }
    showMenuModal.value = false
  } catch (error: unknown) {
    console.error('Failed to toggle public status:', error)
    const err = error as { response?: { data?: { message?: string } } }
    toast.error(err.response?.data?.message || 'Failed to update CV visibility. Please try again.')
  }
}

const duplicateCv = async () => {
  try {
    if (selectedCv.value) {
      const newCv: UserCv = {
        ...selectedCv.value,
        id: cvs.value.length + 1,
        full_name: `${selectedCv.value.full_name} (Copy)`,
        is_primary: false,
        slug: `${selectedCv.value.slug}-copy-${Date.now()}`,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
      }
      cvs.value.unshift(newCv)
    }
    showMenuModal.value = false
  } catch (error) {
    console.error('Failed to duplicate CV:', error)
  }
}

const downloadCv = async () => {
  try {
    alert('PDF download feature coming soon!')
    showMenuModal.value = false
  } catch (error) {
    console.error('Failed to download CV:', error)
  }
}

const confirmDelete = () => {
  showMenuModal.value = false
  showDeleteModal.value = true
}

const deleteCv = async () => {
  deleting.value = true
  try {
    if (selectedCv.value) {
      await cvStore.deleteCv(selectedCv.value.id)
      cvs.value = cvStore.myCvs
      toast.success('CV deleted successfully!')
    }
    showDeleteModal.value = false
    selectedCv.value = null
  } catch (error: unknown) {
    console.error('Failed to delete CV:', error)
    const err = error as { response?: { data?: { message?: string } } }
    toast.error(err.response?.data?.message || 'Failed to delete CV. Please try again.')
  } finally {
    deleting.value = false
  }
}

onMounted(() => {
  loadCvs()
})
</script>
