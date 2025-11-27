<template>
  <div class="bg-gray-50 min-h-screen py-3 sm:py-8">
    <div class="container-custom px-3 sm:px-6 lg:px-8">
      <div class="mb-4 sm:mb-8">
        <h1 class="text-xl sm:text-3xl font-bold text-gray-900 mb-1 sm:mb-2">
          {{ $t('companyApplications.title') }}
        </h1>
        <p class="text-xs sm:text-base text-gray-600">
          {{ $t('companyApplications.subtitle') }}
        </p>
      </div>

      <!-- Filters -->
      <BaseCard class="p-3 sm:p-6 mb-3 sm:mb-6">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-2 sm:gap-4">
          <!-- Search -->
          <div class="md:col-span-2">
            <BaseInput
              v-model="filters.search"
              type="text"
              :placeholder="$t('companyApplications.searchPlaceholder')"
              @input="handleFilterChange"
            >
              <template #prefix>
                <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
              </template>
            </BaseInput>
          </div>

          <!-- Status Filter -->
          <div>
            <label for="company-applications-status" class="sr-only">{{ $t('companyApplications.statusFilter') }}</label>
            <select
              id="company-applications-status"
              v-model="filters.status"
              name="company-applications-status"
              @change="handleFilterChange"
              class="w-full px-3 sm:px-4 py-2 sm:py-2.5 text-sm sm:text-base border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            >
              <option value="">{{ $t('companyApplications.allStatus') }}</option>
              <option value="pending">{{ $t('companyApplications.pending') }}</option>
              <option value="reviewed">{{ $t('companyApplications.reviewed') }}</option>
              <option value="accepted">{{ $t('companyApplications.accepted') }}</option>
              <option value="rejected">{{ $t('companyApplications.rejected') }}</option>
            </select>
          </div>

          <!-- Company Filter (if multiple companies) -->
          <div v-if="myCompanies.length > 1">
            <label for="company-filter" class="sr-only">{{ $t('companyApplications.companyFilter') }}</label>
            <select
              id="company-filter"
              v-model="filters.company_id"
              name="company-filter"
              @change="handleFilterChange"
              class="w-full px-3 sm:px-4 py-2 sm:py-2.5 text-sm sm:text-base border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            >
              <option :value="undefined">{{ $t('companyApplications.allCompanies') }}</option>
              <option v-for="company in myCompanies" :key="company.id" :value="company.id">
                {{ company.name }}
              </option>
            </select>
          </div>
        </div>
      </BaseCard>

      <!-- Loading State -->
      <div v-if="loading" class="space-y-2 sm:space-y-4">
        <BaseCard v-for="i in 3" :key="i" class="p-3 sm:p-6">
          <div class="animate-pulse flex gap-3 sm:gap-4">
            <div class="w-12 h-12 sm:w-16 sm:h-16 bg-gray-200 rounded-full flex-shrink-0"></div>
            <div class="flex-1">
              <div class="h-5 sm:h-6 bg-gray-200 rounded w-1/2 mb-2 sm:mb-3"></div>
              <div class="h-4 bg-gray-200 rounded w-1/3 mb-2"></div>
              <div class="h-4 bg-gray-200 rounded w-1/4"></div>
            </div>
          </div>
        </BaseCard>
      </div>

      <!-- No Applications -->
      <div v-else-if="applications.length === 0" class="text-center py-8 sm:py-16">
        <BaseCard class="p-6 sm:p-12">
          <svg class="h-10 w-10 sm:h-16 sm:w-16 mx-auto text-gray-400 mb-3 sm:mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" />
          </svg>
          <h2 class="text-lg sm:text-2xl font-bold text-gray-900 mb-1 sm:mb-2">
            {{ $t('companyApplications.noApplications') }}
          </h2>
          <p class="text-xs sm:text-base text-gray-600 mb-4 sm:mb-6">
            {{ filters.search || filters.status 
              ? $t('companyApplications.noMatchingApplications') 
              : $t('companyApplications.noApplicationsMessage') 
            }}
          </p>
          <BaseButton variant="primary" @click="router.push('/my-jobs')">
            {{ $t('companyApplications.viewMyJobs') }}
          </BaseButton>
        </BaseCard>
      </div>

      <!-- Applications List -->
      <div v-else class="space-y-2 sm:space-y-4">
        <BaseCard v-for="application in applications" :key="application.id" hoverable class="p-3 sm:p-6">
          <div class="flex items-start gap-2 sm:gap-4">
            <!-- Applicant Avatar -->
            <div class="w-10 h-10 sm:w-16 sm:h-16 flex-shrink-0 bg-gradient-to-br from-primary-100 to-secondary-100 rounded-full flex items-center justify-center">
              <img 
                v-if="application.user?.profile_photo" 
                :src="getPhotoUrl(application.user.profile_photo)" 
                :alt="application.user.name"
                class="w-full h-full object-cover rounded-full"
              />
              <span v-else class="text-base sm:text-2xl font-bold text-primary-600">
                {{ application.user?.name?.[0]?.toUpperCase() || '?' }}
              </span>
            </div>

            <!-- Application Details -->
            <div class="flex-1 min-w-0">
              <div class="flex items-start justify-between gap-2 mb-1 sm:mb-2">
                <div class="flex-1 min-w-0">
                  <h3 class="text-sm sm:text-xl font-bold text-gray-900 mb-0.5 sm:mb-1">
                    {{ application.user?.name }}
                  </h3>
                  <p class="text-xs sm:text-base text-gray-600 mb-1 sm:mb-2">
                    {{ application.user?.email }}
                  </p>
                  <p 
                    class="text-xs sm:text-sm text-primary-600 hover:text-primary-700 cursor-pointer font-medium"
                    @click="router.push(`/jobs/${application.job?.slug}`)"
                  >
                    Applied for: {{ application.job?.title }}
                  </p>
                  <p 
                    v-if="myCompanies.length > 1"
                    class="text-xs sm:text-sm text-gray-500"
                  >
                    Company: {{ application.job?.company?.name }}
                  </p>
                </div>

                <!-- Status Badge -->
                <div class="flex-shrink-0">
                  <BaseBadge :variant="applicationStore.getStatusColor(application.status)">
                    <span class="text-xs sm:text-sm">{{ applicationStore.getStatusLabel(application.status) }}</span>
                  </BaseBadge>
                </div>
              </div>

              <!-- Application Meta -->
              <div class="flex flex-wrap gap-1.5 sm:gap-3 text-xs sm:text-sm text-gray-600 mb-2 sm:mb-4">
                <span class="flex items-center gap-1 whitespace-nowrap">
                  <svg class="h-3.5 w-3.5 sm:h-4 sm:w-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                  </svg>
                  <span class="truncate">{{ $t('companyApplications.applied') }} {{ formatDate(application.applied_at) }}</span>
                </span>
                <span v-if="application.reviewed_at" class="flex items-center gap-1 whitespace-nowrap">
                  <svg class="h-3.5 w-3.5 sm:h-4 sm:w-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4" />
                  </svg>
                  <span class="truncate">{{ $t('companyApplications.reviewed') }} {{ formatDate(application.reviewed_at) }}</span>
                </span>
              </div>

              <!-- Cover Letter Preview -->
              <div v-if="application.cover_letter" class="bg-gray-50 rounded-lg p-2 sm:p-3 mb-2 sm:mb-4">
                <p class="text-xs font-semibold text-gray-700 mb-1">{{ $t('companyApplications.coverLetter') }}</p>
                <p class="text-xs sm:text-sm text-gray-700 line-clamp-3">
                  {{ application.cover_letter }}
                </p>
              </div>

              <!-- Employer Notes -->
              <div v-if="application.notes" class="bg-blue-50 rounded-lg p-2 sm:p-3 mb-2 sm:mb-4">
                <p class="text-xs font-semibold text-blue-700 mb-1">{{ $t('companyApplications.notes') }}</p>
                <p class="text-xs sm:text-sm text-blue-700">
                  {{ application.notes }}
                </p>
              </div>

              <!-- Actions -->
              <div class="flex flex-wrap gap-2 sm:gap-3">
                <BaseButton
                  v-if="application.cv"
                  variant="primary"
                  size="sm"
                  @click="viewCV(application.cv.id)"
                  class="text-xs sm:text-sm"
                >
                  <template #icon-left>
                    <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                    </svg>
                  </template>
                  {{ $t('companyApplications.viewCV') }}
                </BaseButton>

                <BaseButton
                  variant="outline"
                  size="sm"
                  @click="openStatusModal(application)"
                  class="text-xs sm:text-sm"
                >
                  <template #icon-left>
                    <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                    </svg>
                  </template>
                  {{ $t('companyApplications.updateStatus') }}
                </BaseButton>

                <BaseButton
                  variant="outline"
                  size="sm"
                  @click="router.push(`/jobs/${application.job?.slug}`)"
                  class="text-xs sm:text-sm"
                >
                  <template #icon-left>
                    <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                    </svg>
                  </template>
                  {{ $t('companyApplications.viewJob') }}
                </BaseButton>
              </div>
            </div>
          </div>
        </BaseCard>
      </div>

      <!-- Pagination -->
      <div v-if="pagination && pagination.last_page > 1" class="mt-4 sm:mt-8 flex justify-center">
        <nav class="flex items-center gap-1 sm:gap-2 flex-wrap justify-center">
          <BaseButton
            variant="outline"
            size="sm"
            :disabled="pagination.current_page === 1"
            @click="goToPage(pagination.current_page - 1)"
            class="text-xs sm:text-sm"
          >
            <span class="hidden sm:inline">{{ $t('companyApplications.previous') }}</span>
            <span class="sm:hidden">{{ $t('companyApplications.prev') }}</span>
          </BaseButton>

          <template v-for="page in getPageNumbers()" :key="page">
            <BaseButton
              v-if="page !== '...'"
              :variant="pagination.current_page === page ? 'primary' : 'outline'"
              size="sm"
              @click="goToPage(page as number)"
              class="text-xs sm:text-sm min-w-[2rem] sm:min-w-[2.5rem]"
            >
              {{ page }}
            </BaseButton>
            <span v-else class="px-1 sm:px-2 text-gray-500">...</span>
          </template>

          <BaseButton
            variant="outline"
            size="sm"
            :disabled="pagination.current_page === pagination.last_page"
            @click="goToPage(pagination.current_page + 1)"
            class="text-xs sm:text-sm"
          >
            {{ $t('companyApplications.next') }}
          </BaseButton>
        </nav>
      </div>
    </div>

    <!-- Status Update Modal -->
    <BaseModal
      v-model="showStatusModal"
      :title="$t('companyApplications.updateApplicationStatus')"
      @update:model-value="(val) => !val && closeStatusModal()"
    >
      <div v-if="selectedApplication" class="space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">
            {{ $t('companyApplications.applicant') }}
          </label>
          <p class="text-base font-semibold">{{ selectedApplication.user?.name }}</p>
          <p class="text-sm text-gray-600">{{ selectedApplication.job?.title }}</p>
        </div>

        <div>
          <label for="status-select" class="block text-sm font-medium text-gray-700 mb-2">
            {{ $t('companyApplications.status') }}
          </label>
          <select
            id="status-select"
            v-model="statusForm.status"
            class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          >
            <option value="pending">{{ $t('companyApplications.pending') }}</option>
            <option value="reviewed">{{ $t('companyApplications.reviewed') }}</option>
            <option value="accepted">{{ $t('companyApplications.accepted') }}</option>
            <option value="rejected">{{ $t('companyApplications.rejected') }}</option>
          </select>
        </div>

        <div>
          <label for="notes-textarea" class="block text-sm font-medium text-gray-700 mb-2">
            {{ $t('companyApplications.notesLabel') }}
          </label>
          <textarea
            id="notes-textarea"
            v-model="statusForm.notes"
            rows="4"
            :placeholder="$t('companyApplications.notesPlaceholder')"
            class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          ></textarea>
        </div>

        <div class="flex gap-3 justify-end pt-4">
          <BaseButton variant="outline" @click="closeStatusModal">
            {{ $t('companyApplications.cancel') }}
          </BaseButton>
          <BaseButton 
            variant="primary" 
            @click="updateStatus"
            :disabled="applicationStore.submitting"
          >
            <span v-if="applicationStore.submitting" class="flex items-center gap-2">
              <svg class="animate-spin h-4 w-4" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              {{ $t('companyApplications.updating') }}
            </span>
            <span v-else>{{ $t('companyApplications.updateStatus') }}</span>
          </BaseButton>
        </div>
      </div>
    </BaseModal>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { useApplicationStore } from '@/stores/application'
import { useCompanyStore } from '@/stores/company'
import { useToast } from '@/composables/useToast'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseBadge from '@/components/base/BaseBadge.vue'
import BaseModal from '@/components/base/BaseModal.vue'
import type { JobApplication } from '@/types'

const router = useRouter()
const toast = useToast()
const { t } = useI18n()
const applicationStore = useApplicationStore()
const companyStore = useCompanyStore()

const applications = computed(() => applicationStore.companyApplications)
const loading = computed(() => applicationStore.loading)
const pagination = computed(() => applicationStore.companyApplicationsPagination)
const myCompanies = computed(() => companyStore.myCompanies)

const filters = ref({
  search: '',
  status: '',
  company_id: undefined as number | undefined,
  page: 1,
  per_page: 15,
})

const showStatusModal = ref(false)
const selectedApplication = ref<JobApplication | null>(null)
const statusForm = ref({
  status: 'pending',
  notes: '',
})

const fetchApplications = async () => {
  try {
    await applicationStore.fetchCompanyApplications(filters.value)
  } catch (error) {
    console.error('Error fetching company applications:', error)
    toast.error(t('companyApplications.loadFailed'))
  }
}

const handleFilterChange = () => {
  filters.value.page = 1
  fetchApplications()
}

const goToPage = (page: number) => {
  filters.value.page = page
  fetchApplications()
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

const getPageNumbers = (): (number | string)[] => {
  if (!pagination.value) return []
  
  const current = pagination.value.current_page
  const last = pagination.value.last_page
  const pages: (number | string)[] = []
  
  if (last <= 7) {
    for (let i = 1; i <= last; i++) {
      pages.push(i)
    }
  } else {
    if (current <= 3) {
      for (let i = 1; i <= 4; i++) pages.push(i)
      pages.push('...')
      pages.push(last)
    } else if (current >= last - 2) {
      pages.push(1)
      pages.push('...')
      for (let i = last - 3; i <= last; i++) pages.push(i)
    } else {
      pages.push(1)
      pages.push('...')
      for (let i = current - 1; i <= current + 1; i++) pages.push(i)
      pages.push('...')
      pages.push(last)
    }
  }
  
  return pages
}

const openStatusModal = (application: JobApplication) => {
  selectedApplication.value = application
  statusForm.value.status = application.status
  statusForm.value.notes = application.notes || ''
  showStatusModal.value = true
}

const closeStatusModal = () => {
  showStatusModal.value = false
  selectedApplication.value = null
  statusForm.value = { status: 'pending', notes: '' }
}

const updateStatus = async () => {
  if (!selectedApplication.value) return
  
  try {
    await applicationStore.updateApplicationStatus(
      selectedApplication.value.id,
      statusForm.value.status,
      statusForm.value.notes
    )
    toast.success(t('companyApplications.updateSuccess'))
    closeStatusModal()
    fetchApplications()
  } catch (error) {
    console.error('Error updating application status:', error)
    const errorMessage = (error as { response?: { data?: { message?: string } } }).response?.data?.message
    toast.error(errorMessage || t('companyApplications.updateFailed'))
  }
}

const viewCV = (cvId: number) => {
  router.push(`/application-cv/${cvId}`)
}

const getPhotoUrl = (path: string): string => {
  if (!path) return ''
  if (path.startsWith('data:') || path.startsWith('blob:') || path.startsWith('http')) {
    return path
  }
  if (path.startsWith('/storage/')) {
    return path
  }
  const cleanPath = path.replace(/^\/+/, '')
  return `/storage/${cleanPath}`
}

const formatDate = (date: string): string => {
  const now = new Date()
  const targetDate = new Date(date)
  const diffTime = Math.abs(now.getTime() - targetDate.getTime())
  const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24))
  
  if (diffDays === 0) return t('companyApplications.today')
  if (diffDays === 1) return t('companyApplications.yesterday')
  if (diffDays < 7) return t('companyApplications.daysAgo', { count: diffDays })
  if (diffDays < 30) return t('companyApplications.weeksAgo', { count: Math.floor(diffDays / 7) })
  if (diffDays < 365) return t('companyApplications.monthsAgo', { count: Math.floor(diffDays / 30) })
  
  return targetDate.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}

onMounted(async () => {
  // Fetch companies first to get company filter options
  if (companyStore.myCompanies.length === 0) {
    await companyStore.fetchMyCompanies()
  }
  
  await fetchApplications()
})
</script>
