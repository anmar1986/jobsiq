import type { ApiResponse, PaginatedResponse } from '@/types'
import apiClient from './api'

export interface SearchHistoryEntry {
  id: number
  user_id: number | null
  user?: {
    id: number
    name: string
    email: string
  }
  search_query: string | null
  location: string | null
  filters: Record<string, any> | null
  results_count: number
  ip_address: string | null
  user_agent: string | null
  session_id: string | null
  created_at: string
  updated_at: string
}

export interface SearchHistoryStatistics {
  total_searches: number
  unique_users: number
  guest_searches: number
  today_searches: number
  this_week_searches: number
  this_month_searches: number
  top_searches: Array<{ search_query: string; count: number }>
  top_locations: Array<{ location: string; count: number }>
}

export interface SearchHistoryResponse {
  success: boolean
  data: SearchHistoryEntry[]
  current_page: number
  last_page: number
  per_page: number
  total: number
  from: number | null
  to: number | null
}

export const searchHistoryAdminService = {
  async getSearchHistory(params?: {
    page?: number
    per_page?: number
    user_id?: number
    search?: string
    location?: string
    from_date?: string
    to_date?: string
  }): Promise<SearchHistoryResponse> {
    const response = await apiClient.get<SearchHistoryResponse>(
      '/admin/search-history',
      { params }
    )
    return response.data
  },

  async getStatistics(): Promise<ApiResponse<SearchHistoryStatistics>> {
    const response = await apiClient.get<ApiResponse<SearchHistoryStatistics>>(
      '/admin/search-history/statistics'
    )
    return response.data
  },

  async deleteEntry(id: number): Promise<ApiResponse> {
    const response = await apiClient.delete<ApiResponse>(`/admin/search-history/${id}`)
    return response.data
  },

  async clearHistory(params?: {
    user_id?: number
    before_date?: string
  }): Promise<ApiResponse<{ count: number }>> {
    const response = await apiClient.delete<ApiResponse<{ count: number }>>(
      '/admin/search-history/clear',
      { data: params }
    )
    return response.data
  },
}
