import type { Job, JobFilters, ApiResponse, PaginatedResponse, JobForm } from '@/types'
import apiClient from './api'

export const jobService = {
  async getJobs(filters?: JobFilters): Promise<ApiResponse<PaginatedResponse<Job>>> {
    // Remove null, undefined, empty string, and false values
    const cleanFilters = filters ? Object.entries(filters).reduce((acc, [key, value]) => {
      if (value !== null && value !== undefined && value !== '' && value !== false) {
        acc[key as keyof JobFilters] = value as never
      }
      // Always include page and per_page even if they're 0 or false
      if ((key === 'page' || key === 'per_page') && value !== null && value !== undefined) {
        acc[key as keyof JobFilters] = value as never
      }
      return acc
    }, {} as JobFilters) : {}
    
    const response = await apiClient.get<ApiResponse<PaginatedResponse<Job>>>('/jobs', {
      params: cleanFilters,
    })
    return response.data
  },

  async getMyJobs(): Promise<ApiResponse<Job[]>> {
    const response = await apiClient.get<ApiResponse<Job[]>>('/my-jobs')
    return response.data
  },

  async getFeaturedJobs(limit = 6): Promise<ApiResponse<Job[]>> {
    const response = await apiClient.get<ApiResponse<Job[]>>('/jobs/featured', {
      params: { limit },
    })
    return response.data
  },

  async getJob(id: number | string): Promise<ApiResponse<Job>> {
    // Use /my-jobs endpoint for ID-based fetching (authenticated)
    // Use /jobs endpoint for slug-based fetching (public)
    const endpoint = typeof id === 'number' || !isNaN(Number(id)) 
      ? `/my-jobs/${id}` 
      : `/jobs/${id}`
    const response = await apiClient.get<ApiResponse<Job>>(endpoint)
    return response.data
  },

  async createJob(data: JobForm): Promise<ApiResponse<Job>> {
    const response = await apiClient.post<ApiResponse<Job>>('/jobs', data)
    return response.data
  },

  async updateJob(id: number, data: Partial<JobForm>): Promise<ApiResponse<Job>> {
    const response = await apiClient.put<ApiResponse<Job>>(`/jobs/${id}`, data)
    return response.data
  },

  async deleteJob(id: number): Promise<ApiResponse> {
    const response = await apiClient.delete<ApiResponse>(`/jobs/${id}`)
    return response.data
  },
}
