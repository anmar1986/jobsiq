import apiClient from './api'
import type { Blog, BlogFormData, BlogFilters, BlogPagination } from '@/types/blog'

const API_URL = '/blogs'

export const blogService = {
  /**
   * Get all blogs with optional filters
   */
  async getBlogs(filters?: BlogFilters): Promise<BlogPagination> {
    const params = new URLSearchParams()
    if (filters?.category) params.append('category', filters.category)
    if (filters?.search) params.append('search', filters.search)
    if (filters?.page) params.append('page', filters.page.toString())

    const response = await apiClient.get(`${API_URL}?${params.toString()}`)
    return response.data
  },

  /**
   * Get a single blog by slug
   */
  async getBlog(slug: string): Promise<Blog> {
    const response = await apiClient.get(`${API_URL}/${slug}`)
    return response.data
  },

  /**
   * Get featured/popular blogs
   */
  async getFeaturedBlogs(): Promise<Blog[]> {
    const response = await apiClient.get(`${API_URL}/featured`)
    return response.data
  },

  /**
   * Get all blog categories
   */
  async getCategories(): Promise<string[]> {
    const response = await apiClient.get(`${API_URL}/categories`)
    return response.data
  },

  /**
   * Create a new blog
   */
  async createBlog(data: BlogFormData): Promise<Blog> {
    const response = await apiClient.post(API_URL, data)
    return response.data
  },

  /**
   * Update a blog
   */
  async updateBlog(id: number, data: Partial<BlogFormData>): Promise<Blog> {
    const response = await apiClient.put(`${API_URL}/${id}`, data)
    return response.data
  },

  /**
   * Delete a blog
   */
  async deleteBlog(id: number): Promise<void> {
    await apiClient.delete(`${API_URL}/${id}`)
  },

  /**
   * Upload blog image
   */
  async uploadImage(formData: FormData): Promise<{ path: string }> {
    const response = await apiClient.post(`${API_URL}/upload-image`, formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    })
    return response.data
  },
}
