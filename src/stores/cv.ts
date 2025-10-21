import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { UserCv, PaginatedResponse } from '@/types'
import { userCvService } from '@/services/userCv.service'

interface CvFilters {
  search?: string
  skills?: string
  location?: string
  per_page?: number
  page?: number
}

export const useCvStore = defineStore('cv', () => {
  // State
  const cvs = ref<UserCv[]>([])
  const myCvs = ref<UserCv[]>([])
  const currentCv = ref<UserCv | null>(null)
  const pagination = ref<Omit<PaginatedResponse<UserCv>, 'data'> | null>(null)
  const filters = ref<CvFilters>({
    search: '',
    skills: '',
    location: '',
    per_page: 15,
    page: 1,
  })
  const loading = ref(false)
  const error = ref<string | null>(null)

  // Actions
  async function fetchCvs(customFilters?: CvFilters) {
    try {
      loading.value = true
      error.value = null
      const mergedFilters = { ...filters.value, ...customFilters }
      const response = await userCvService.getCvs(mergedFilters)
      
      if (response.success && response.data) {
        const { data, ...paginationData } = response.data
        cvs.value = data
        pagination.value = paginationData
      }
    } catch (err: unknown) {
      const errorMessage = err && typeof err === 'object' && 'response' in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined
      error.value = errorMessage || 'Failed to fetch CVs'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function fetchCv(id: number | string) {
    try {
      loading.value = true
      error.value = null
      const response = await userCvService.getCv(id)
      
      if (response.success && response.data) {
        currentCv.value = response.data
      }
    } catch (err: unknown) {
      const errorMessage = err && typeof err === 'object' && 'response' in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined
      error.value = errorMessage || 'Failed to fetch CV'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function fetchCvById(id: number) {
    try {
      loading.value = true
      error.value = null
      const response = await userCvService.getCv(id)
      
      if (response.success && response.data) {
        currentCv.value = response.data
      }
    } catch (err: unknown) {
      const errorMessage = err && typeof err === 'object' && 'response' in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined
      error.value = errorMessage || 'Failed to fetch CV'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function fetchMyCvs() {
    try {
      loading.value = true
      error.value = null
      const response = await userCvService.getMyCvs()
      
      console.log('Fetch My CVs Response:', response)
      
      if (response.success && response.data) {
        console.log('My CVs data:', response.data)
        response.data.forEach((cv, index: number) => {
          console.log(`CV ${index} - ID: ${cv.id}, Slug: ${cv.slug}, Title: ${cv.title}`)
        })
        myCvs.value = response.data
      }
    } catch (err: unknown) {
      const errorMessage = err && typeof err === 'object' && 'response' in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined
      error.value = errorMessage || 'Failed to fetch CVs'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function createCv(data: Partial<UserCv>) {
    try {
      loading.value = true
      error.value = null
      const response = await userCvService.createCv(data)
      
      console.log('Create CV Response:', response)
      
      if (response.success && response.data) {
        console.log('Created CV data:', response.data)
        console.log('Created CV slug:', response.data.slug)
        myCvs.value.unshift(response.data)
        return response.data
      }
    } catch (err: unknown) {
      const errorMessage = err && typeof err === 'object' && 'response' in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined
      error.value = errorMessage || 'Failed to create CV'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function createCvWithFormData(formData: FormData) {
    try {
      loading.value = true
      error.value = null
      const response = await userCvService.createCvWithFormData(formData)
      
      console.log('Create CV Response:', response)
      
      if (response.success && response.data) {
        console.log('Created CV data:', response.data)
        console.log('Created CV slug:', response.data.slug)
        myCvs.value.unshift(response.data)
        return response.data
      }
    } catch (err: unknown) {
      const errorMessage = err && typeof err === 'object' && 'response' in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined
      error.value = errorMessage || 'Failed to create CV'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function updateCv(id: number, data: Partial<UserCv>) {
    try {
      loading.value = true
      error.value = null
      const response = await userCvService.updateCv(id, data)
      
      if (response.success && response.data) {
        const index = myCvs.value.findIndex(cv => cv.id === id)
        if (index !== -1) {
          myCvs.value[index] = response.data
        }
        return response.data
      }
    } catch (err: unknown) {
      const errorMessage = err && typeof err === 'object' && 'response' in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined
      error.value = errorMessage || 'Failed to update CV'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function updateCvWithFormData(id: number, formData: FormData) {
    try {
      loading.value = true
      error.value = null
      const response = await userCvService.updateCvWithFormData(id, formData)
      
      if (response.success && response.data) {
        const index = myCvs.value.findIndex(cv => cv.id === id)
        if (index !== -1) {
          myCvs.value[index] = response.data
        }
        return response.data
      }
    } catch (err: unknown) {
      const errorMessage = err && typeof err === 'object' && 'response' in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined
      error.value = errorMessage || 'Failed to update CV'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function deleteCv(id: number) {
    try {
      loading.value = true
      error.value = null
      const response = await userCvService.deleteCv(id)
      
      if (response.success) {
        myCvs.value = myCvs.value.filter(cv => cv.id !== id)
      }
    } catch (err: unknown) {
      const errorMessage = err && typeof err === 'object' && 'response' in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined
      error.value = errorMessage || 'Failed to delete CV'
      throw err
    } finally {
      loading.value = false
    }
  }

  function updateFilters(newFilters: Partial<CvFilters>) {
    filters.value = { ...filters.value, ...newFilters }
  }

  function resetFilters() {
    filters.value = {
      search: '',
      skills: '',
      location: '',
      per_page: 15,
      page: 1,
    }
  }

  return {
    cvs,
    myCvs,
    currentCv,
    pagination,
    filters,
    loading,
    error,
    fetchCvs,
    fetchCv,
    fetchCvById,
    fetchMyCvs,
    createCv,
    createCvWithFormData,
    updateCv,
    updateCvWithFormData,
    deleteCv,
    updateFilters,
    resetFilters,
  }
})
