import apiClient from './api'
import type { JobApplication, ApiResponse, PaginatedResponse } from '@/types'

export const jobApplicationService = {
  /**
   * Apply for a job
   */
  async applyForJob(jobSlug: string, data: { cv_id?: number; cover_letter?: string }): Promise<ApiResponse<JobApplication>> {
    const response = await apiClient.post<ApiResponse<JobApplication>>(`/jobs/${jobSlug}/apply`, data)
    return response.data
  },

  /**
   * Check if user has applied to a job
   */
  async checkApplication(jobSlug: string): Promise<ApiResponse<{ has_applied: boolean; application: JobApplication | null }>> {
    const response = await apiClient.get<ApiResponse<{ has_applied: boolean; application: JobApplication | null }>>(`/jobs/${jobSlug}/check-application`)
    return response.data
  },

  /**
   * Get user's applications
   */
  async getMyApplications(params?: {
    page?: number
    per_page?: number
    status?: string
    search?: string
  }): Promise<ApiResponse<PaginatedResponse<JobApplication>>> {
    const response = await apiClient.get<ApiResponse<PaginatedResponse<JobApplication>>>('/my-applications', { params })
    return response.data
  },

  /**
   * Get applications for company owner's jobs
   */
  async getCompanyApplications(params?: {
    page?: number
    per_page?: number
    status?: string
    company_id?: number
    job_id?: number
    search?: string
  }): Promise<ApiResponse<PaginatedResponse<JobApplication>>> {
    const response = await apiClient.get<ApiResponse<PaginatedResponse<JobApplication>>>('/company-applications', { params })
    return response.data
  },

  /**
   * Get a single application
   */
  async getApplication(id: number): Promise<ApiResponse<JobApplication>> {
    const response = await apiClient.get<ApiResponse<JobApplication>>(`/applications/${id}`)
    return response.data
  },

  /**
   * Withdraw an application
   */
  async withdrawApplication(id: number): Promise<ApiResponse<null>> {
    const response = await apiClient.delete<ApiResponse<null>>(`/applications/${id}`)
    return response.data
  },

  /**
   * Update application status (for employers)
   */
  async updateApplicationStatus(id: number, data: { status: string; notes?: string }): Promise<ApiResponse<JobApplication>> {
    const response = await apiClient.put<ApiResponse<JobApplication>>(`/applications/${id}/status`, data)
    return response.data
  },
}
