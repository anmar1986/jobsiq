import type { ApiResponse, Job } from '@/types'
import apiClient from './api'

export const savedJobService = {
  /**
   * Get all saved jobs
   */
  async getSavedJobs(): Promise<ApiResponse<Job[]>> {
    const response = await apiClient.get<ApiResponse<Job[]>>('/saved-jobs')
    return response.data
  },

  /**
   * Save a job
   */
  async saveJob(jobId: number): Promise<ApiResponse<void>> {
    const response = await apiClient.post<ApiResponse<void>>(`/jobs/${jobId}/save`)
    return response.data
  },

  /**
   * Unsave a job
   */
  async unsaveJob(jobId: number): Promise<ApiResponse<void>> {
    const response = await apiClient.delete<ApiResponse<void>>(`/jobs/${jobId}/save`)
    return response.data
  },

  /**
   * Check if a job is saved
   */
  async checkSaved(jobId: number): Promise<ApiResponse<{ is_saved: boolean }>> {
    const response = await apiClient.get<ApiResponse<{ is_saved: boolean }>>(`/jobs/${jobId}/saved`)
    return response.data
  },
}
