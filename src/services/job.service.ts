import type { Job, JobFilters, ApiResponse, PaginatedResponse, JobForm } from '@/types'
import apiClient from './api'

export const jobService = {
  async getJobs(filters?: JobFilters): Promise<ApiResponse<PaginatedResponse<Job>>> {
    const response = await apiClient.get<ApiResponse<PaginatedResponse<Job>>>('/jobs', {
      params: filters,
    })
    return response.data
  },

  async getFeaturedJobs(limit = 6): Promise<ApiResponse<Job[]>> {
    const response = await apiClient.get<ApiResponse<Job[]>>('/jobs/featured', {
      params: { limit },
    })
    return response.data
  },

  async getJob(id: number | string): Promise<ApiResponse<Job>> {
    const response = await apiClient.get<ApiResponse<Job>>(`/jobs/${id}`)
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
