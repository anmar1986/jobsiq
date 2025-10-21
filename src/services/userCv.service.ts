import type { UserCv, ApiResponse, PaginatedResponse } from '@/types'
import apiClient from './api'

interface CvFilters {
  search?: string
  skills?: string
  location?: string
  per_page?: number
  page?: number
}

export const userCvService = {
  async getCvs(filters?: CvFilters): Promise<ApiResponse<PaginatedResponse<UserCv>>> {
    const response = await apiClient.get<ApiResponse<PaginatedResponse<UserCv>>>('/cvs', {
      params: filters,
    })
    return response.data
  },

  async getCv(id: number | string): Promise<ApiResponse<UserCv>> {
    // If id is a string (slug), use public endpoint, otherwise use authenticated endpoint
    const endpoint = typeof id === 'string' ? `/cvs/${id}` : `/my-cvs/${id}`
    const response = await apiClient.get<ApiResponse<UserCv>>(endpoint)
    return response.data
  },

  async getMyCvs(): Promise<ApiResponse<UserCv[]>> {
    const response = await apiClient.get<ApiResponse<UserCv[]>>('/my-cvs')
    return response.data
  },

  async createCv(data: Partial<UserCv>): Promise<ApiResponse<UserCv>> {
    const response = await apiClient.post<ApiResponse<UserCv>>('/my-cvs', data)
    return response.data
  },

  async createCvWithFormData(formData: FormData): Promise<ApiResponse<UserCv>> {
    // Do NOT set Content-Type here. Let the browser set the correct
    // multipart/form-data boundary. apiClient will clear the default
    // application/json header when it detects FormData.
    const response = await apiClient.post<ApiResponse<UserCv>>('/my-cvs', formData)
    return response.data
  },

  async updateCv(id: number, data: Partial<UserCv>): Promise<ApiResponse<UserCv>> {
    // Route is POST, so build a FormData payload and let the browser
    // set the Content-Type (including multipart boundary).
    const formData = new FormData()

    // Convert data object to FormData
    Object.keys(data).forEach((key) => {
      const value = data[key as keyof typeof data]
      if (value === null || value === undefined) return

      // If value is a File (e.g., profile_image), append directly
      if (value instanceof File) {
        formData.append(key, value, value.name)
      } else if (Array.isArray(value) || typeof value === 'object') {
        formData.append(key, JSON.stringify(value))
      } else {
        formData.append(key, String(value))
      }
    })

    const response = await apiClient.post<ApiResponse<UserCv>>(`/my-cvs/${id}`, formData)
    return response.data
  },

  async updateCvWithFormData(id: number, formData: FormData): Promise<ApiResponse<UserCv>> {
    // Route is POST, so just send FormData directly (no _method needed)
    // Let the browser set Content-Type for FormData requests.
    const response = await apiClient.post<ApiResponse<UserCv>>(`/my-cvs/${id}`, formData)
    return response.data
  },

  async deleteCv(id: number): Promise<ApiResponse> {
    const response = await apiClient.delete<ApiResponse>(`/my-cvs/${id}`)
    return response.data
  },
}
