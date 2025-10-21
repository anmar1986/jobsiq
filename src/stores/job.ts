import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { Job, JobFilters, PaginatedResponse } from '@/types'
import { jobService } from '@/services/job.service'

export const useJobStore = defineStore('job', () => {
  // State
  const jobs = ref<Job[]>([])
  const featuredJobs = ref<Job[]>([])
  const currentJob = ref<Job | null>(null)
  const pagination = ref<Omit<PaginatedResponse<Job>, 'data'> | null>(null)
  const filters = ref<JobFilters>({
    search: '',
    location: '',
    employment_type: '',
    experience_level: '',
    is_remote: undefined,
    category: '',
    per_page: 15,
    page: 1,
  })
  const loading = ref(false)
  const error = ref<string | null>(null)

  // Actions
  async function fetchJobs(customFilters?: JobFilters) {
    try {
      loading.value = true
      error.value = null
      const mergedFilters = { ...filters.value, ...customFilters }
      const response = await jobService.getJobs(mergedFilters)
      
      if (response.success && response.data) {
        const { data, ...paginationData } = response.data
        jobs.value = data
        pagination.value = paginationData
      }
    } catch (err: unknown) {
      const errorMessage = err && typeof err === 'object' && 'response' in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined
      error.value = errorMessage || 'Failed to fetch jobs'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function fetchFeaturedJobs(limit = 6) {
    try {
      const response = await jobService.getFeaturedJobs(limit)
      if (response.success && response.data) {
        featuredJobs.value = response.data
      }
    } catch (err: unknown) {
      console.error('Failed to fetch featured jobs:', err)
    }
  }

  async function fetchJob(id: number | string) {
    try {
      loading.value = true
      error.value = null
      const response = await jobService.getJob(id)
      
      if (response.success && response.data) {
        currentJob.value = response.data
      }
    } catch (err: unknown) {
      const errorMessage = err && typeof err === 'object' && 'response' in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined
      error.value = errorMessage || 'Failed to fetch job'
      throw err
    } finally {
      loading.value = false
    }
  }

  function updateFilters(newFilters: Partial<JobFilters>) {
    filters.value = { ...filters.value, ...newFilters }
  }

  function resetFilters() {
    filters.value = {
      search: '',
      location: '',
      employment_type: '',
      experience_level: '',
      is_remote: undefined,
      category: '',
      per_page: 15,
      page: 1,
    }
  }

  return {
    jobs,
    featuredJobs,
    currentJob,
    pagination,
    filters,
    loading,
    error,
    fetchJobs,
    fetchFeaturedJobs,
    fetchJob,
    updateFilters,
    resetFilters,
  }
})
