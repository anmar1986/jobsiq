import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { Company, CompanyFilters, PaginatedResponse } from '@/types'
import { companyService } from '@/services/cv.service'

export const useCompanyStore = defineStore('company', () => {
  // State
  const companies = ref<Company[]>([])
  const myCompanies = ref<Company[]>([])
  const currentCompany = ref<Company | null>(null)
  const pagination = ref<Omit<PaginatedResponse<Company>, 'data'> | null>(null)
  const filters = ref<CompanyFilters>({
    search: '',
    city: '',
    country: '',
    per_page: 15,
    page: 1,
  })
  const loading = ref(false)
  const error = ref<string | null>(null)

  // Actions
  async function fetchCompanies(customFilters?: CompanyFilters) {
    try {
      loading.value = true
      error.value = null
      const mergedFilters = { ...filters.value, ...customFilters }
      const response = await companyService.getCompanies(mergedFilters)
      
      if (response.success && response.data) {
        const { data, ...paginationData } = response.data
        companies.value = data
        pagination.value = paginationData
      }
    } catch (err: any) {
      error.value = err.response?.data?.message || 'Failed to fetch companies'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function fetchCompany(id: number | string) {
    try {
      loading.value = true
      error.value = null
      const response = await companyService.getCompany(id)
      
      if (response.success && response.data) {
        currentCompany.value = response.data
      }
    } catch (err: any) {
      error.value = err.response?.data?.message || 'Failed to fetch company'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function fetchMyCompanies() {
    try {
      loading.value = true
      error.value = null
      const response = await companyService.getMyCompanies()
      
      if (response.success && response.data) {
        myCompanies.value = response.data
      }
    } catch (err: any) {
      error.value = err.response?.data?.message || 'Failed to fetch companies'
      throw err
    } finally {
      loading.value = false
    }
  }

  function updateFilters(newFilters: Partial<CompanyFilters>) {
    filters.value = { ...filters.value, ...newFilters }
  }

  function resetFilters() {
    filters.value = {
      search: '',
      city: '',
      country: '',
      per_page: 15,
      page: 1,
    }
  }

  return {
    companies,
    myCompanies,
    currentCompany,
    pagination,
    filters,
    loading,
    error,
    fetchCompanies,
    fetchCompany,
    fetchMyCompanies,
    updateFilters,
    resetFilters,
  }
})
