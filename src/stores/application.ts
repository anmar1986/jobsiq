import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { JobApplication, PaginatedResponse } from '@/types'
import { jobApplicationService } from '@/services/jobApplication.service'

export const useApplicationStore = defineStore('application', () => {
  // State
  const myApplications = ref<JobApplication[]>([])
  const companyApplications = ref<JobApplication[]>([])
  const currentApplication = ref<JobApplication | null>(null)
  const myApplicationsPagination = ref<Omit<PaginatedResponse<JobApplication>, 'data'> | null>(null)
  const companyApplicationsPagination = ref<Omit<PaginatedResponse<JobApplication>, 'data'> | null>(null)
  const loading = ref(false)
  const error = ref<string | null>(null)
  const submitting = ref(false)

  // Filters for job seeker applications
  const myFilters = ref({
    page: 1,
    per_page: 15,
    status: '',
    search: '',
  })

  // Filters for company owner applications
  const companyFilters = ref({
    page: 1,
    per_page: 15,
    status: '',
    company_id: undefined as number | undefined,
    job_id: undefined as number | undefined,
    search: '',
  })

  // Actions

  /**
   * Fetch job seeker's applications
   */
  async function fetchMyApplications(customFilters?: Partial<typeof myFilters.value>) {
    try {
      loading.value = true
      error.value = null
      const mergedFilters = { ...myFilters.value, ...customFilters }
      
      // Filter out empty strings and undefined values to ensure "All Status" works correctly
      const cleanFilters: Record<string, string | number> = {}
      Object.entries(mergedFilters).forEach(([key, value]) => {
        if (value !== '' && value !== undefined && value !== null) {
          cleanFilters[key] = value
        }
      })
      
      const response = await jobApplicationService.getMyApplications(cleanFilters)
      
      if (response.success && response.data) {
        const { data, ...paginationData } = response.data
        myApplications.value = data
        myApplicationsPagination.value = paginationData
      }
    } catch (err: unknown) {
      const errorMessage = err && typeof err === 'object' && 'response' in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined
      error.value = errorMessage || 'Failed to fetch applications'
      throw err
    } finally {
      loading.value = false
    }
  }

  /**
   * Fetch company owner's applications
   */
  async function fetchCompanyApplications(customFilters?: Partial<typeof companyFilters.value>) {
    try {
      loading.value = true
      error.value = null
      const mergedFilters = { ...companyFilters.value, ...customFilters }
      
      // Filter out empty strings and undefined values to ensure "All Status" works correctly
      const cleanFilters: Record<string, string | number> = {}
      Object.entries(mergedFilters).forEach(([key, value]) => {
        if (value !== '' && value !== undefined && value !== null) {
          cleanFilters[key] = value
        }
      })
      
      const response = await jobApplicationService.getCompanyApplications(cleanFilters)
      
      if (response.success && response.data) {
        const { data, ...paginationData } = response.data
        companyApplications.value = data
        companyApplicationsPagination.value = paginationData
      }
    } catch (err: unknown) {
      const errorMessage = err && typeof err === 'object' && 'response' in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined
      error.value = errorMessage || 'Failed to fetch company applications'
      throw err
    } finally {
      loading.value = false
    }
  }

  /**
   * Apply for a job
   */
  async function applyForJob(jobSlug: string, data: { cv_id?: number; cover_letter?: string }) {
    try {
      submitting.value = true
      error.value = null
      const response = await jobApplicationService.applyForJob(jobSlug, data)
      
      if (response.success) {
        // Optionally refresh applications list
        await fetchMyApplications()
        return response
      }
      
      throw new Error(response.message || 'Failed to submit application')
    } catch (err: unknown) {
      const errorMessage = err && typeof err === 'object' && 'response' in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined
      error.value = errorMessage || 'Failed to submit application'
      throw err
    } finally {
      submitting.value = false
    }
  }

  /**
   * Check if user has applied to a job
   */
  async function checkApplication(jobSlug: string) {
    try {
      const response = await jobApplicationService.checkApplication(jobSlug)
      return response.data
    } catch (err: unknown) {
      console.error('Failed to check application:', err)
      return { has_applied: false, application: null }
    }
  }

  /**
   * Fetch a single application
   */
  async function fetchApplication(id: number) {
    try {
      loading.value = true
      error.value = null
      const response = await jobApplicationService.getApplication(id)
      
      if (response.success && response.data) {
        currentApplication.value = response.data
      }
    } catch (err: unknown) {
      const errorMessage = err && typeof err === 'object' && 'response' in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined
      error.value = errorMessage || 'Failed to fetch application'
      throw err
    } finally {
      loading.value = false
    }
  }

  /**
   * Update application status (for company owners)
   */
  async function updateApplicationStatus(id: number, status: string, notes?: string) {
    try {
      submitting.value = true
      error.value = null
      const response = await jobApplicationService.updateApplicationStatus(id, { status, notes })
      
      if (response.success) {
        // Update the application in the list
        const index = companyApplications.value.findIndex(app => app.id === id)
        if (index !== -1 && response.data) {
          companyApplications.value[index] = response.data
        }
        
        // Update current application if it's the same
        if (currentApplication.value?.id === id && response.data) {
          currentApplication.value = response.data
        }
        
        return response
      }
      
      throw new Error(response.message || 'Failed to update application status')
    } catch (err: unknown) {
      const errorMessage = err && typeof err === 'object' && 'response' in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined
      error.value = errorMessage || 'Failed to update application status'
      throw err
    } finally {
      submitting.value = false
    }
  }

  /**
   * Withdraw an application (for job seekers)
   */
  async function withdrawApplication(id: number) {
    try {
      submitting.value = true
      error.value = null
      const response = await jobApplicationService.withdrawApplication(id)
      
      if (response.success) {
        // Remove from list
        myApplications.value = myApplications.value.filter(app => app.id !== id)
        
        // Clear current application if it's the same
        if (currentApplication.value?.id === id) {
          currentApplication.value = null
        }
        
        return response
      }
      
      throw new Error(response.message || 'Failed to withdraw application')
    } catch (err: unknown) {
      const errorMessage = err && typeof err === 'object' && 'response' in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined
      error.value = errorMessage || 'Failed to withdraw application'
      throw err
    } finally {
      submitting.value = false
    }
  }

  /**
   * Update my applications filters
   */
  function updateMyFilters(newFilters: Partial<typeof myFilters.value>) {
    myFilters.value = { ...myFilters.value, ...newFilters }
  }

  /**
   * Update company applications filters
   */
  function updateCompanyFilters(newFilters: Partial<typeof companyFilters.value>) {
    companyFilters.value = { ...companyFilters.value, ...newFilters }
  }

  /**
   * Reset my applications filters
   */
  function resetMyFilters() {
    myFilters.value = {
      page: 1,
      per_page: 15,
      status: '',
      search: '',
    }
  }

  /**
   * Reset company applications filters
   */
  function resetCompanyFilters() {
    companyFilters.value = {
      page: 1,
      per_page: 15,
      status: '',
      company_id: undefined,
      job_id: undefined,
      search: '',
    }
  }

  /**
   * Get status badge color
   */
  function getStatusColor(status: string): 'primary' | 'secondary' | 'success' | 'warning' | 'danger' | 'info' {
    const colors: Record<string, 'primary' | 'secondary' | 'success' | 'warning' | 'danger' | 'info'> = {
      pending: 'warning',
      reviewed: 'info',
      accepted: 'success',
      rejected: 'danger',
    }
    return colors[status] || 'secondary'
  }

  /**
   * Get status label
   */
  function getStatusLabel(status: string): string {
    const labels: Record<string, string> = {
      pending: 'Pending',
      reviewed: 'Reviewed',
      accepted: 'Accepted',
      rejected: 'Rejected',
    }
    return labels[status] || status
  }

  return {
    // State
    myApplications,
    companyApplications,
    currentApplication,
    myApplicationsPagination,
    companyApplicationsPagination,
    loading,
    error,
    submitting,
    myFilters,
    companyFilters,
    
    // Actions
    fetchMyApplications,
    fetchCompanyApplications,
    applyForJob,
    checkApplication,
    fetchApplication,
    updateApplicationStatus,
    withdrawApplication,
    updateMyFilters,
    updateCompanyFilters,
    resetMyFilters,
    resetCompanyFilters,
    getStatusColor,
    getStatusLabel,
  }
})
