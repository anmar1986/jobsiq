import type { Company, CompanyFilters, ApiResponse, PaginatedResponse } from '@/types'
import apiClient from './api'

export const companyService = {
  async getCompanies(filters?: CompanyFilters): Promise<ApiResponse<PaginatedResponse<Company>>> {
    const response = await apiClient.get<ApiResponse<PaginatedResponse<Company>>>('/companies', {
      params: filters,
    })
    return response.data
  },

  async getCompany(id: number | string): Promise<ApiResponse<Company>> {
    const response = await apiClient.get<ApiResponse<Company>>(`/my-companies/${id}`)
    return response.data
  },

  async getCompanyBySlug(slug: string): Promise<ApiResponse<Company>> {
    const response = await apiClient.get<ApiResponse<Company>>(`/my-companies/slug/${slug}`)
    return response.data
  },

  async getPublicCompany(slug: string): Promise<ApiResponse<Company>> {
    const response = await apiClient.get<ApiResponse<Company>>(`/companies/${slug}`)
    return response.data
  },

  async getMyCompanies(): Promise<ApiResponse<Company[]>> {
    const response = await apiClient.get<ApiResponse<Company[]>>('/my-companies')
    return response.data
  },

  async createCompany(data: FormData): Promise<ApiResponse<Company>> {
    const response = await apiClient.post<ApiResponse<Company>>('/companies', data, {
      headers: { 'Content-Type': 'multipart/form-data' },
    })
    return response.data
  },

  async updateCompany(id: number, data: FormData): Promise<ApiResponse<Company>> {
    const response = await apiClient.post<ApiResponse<Company>>(`/companies/${id}?_method=PUT`, data, {
      headers: { 'Content-Type': 'multipart/form-data' },
    })
    return response.data
  },

  async deleteCompany(id: number): Promise<ApiResponse> {
    const response = await apiClient.delete<ApiResponse>(`/companies/${id}`)
    return response.data
  },
}
