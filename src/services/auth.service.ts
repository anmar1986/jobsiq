import type { 
  LoginForm, 
  RegisterForm, 
  AuthResponse, 
  User, 
  ApiResponse,
  ProfileUpdateForm,
  PasswordChangeForm
} from '@/types'
import apiClient from './api'

export const authService = {
  async register(data: RegisterForm): Promise<ApiResponse<AuthResponse>> {
    const response = await apiClient.post<ApiResponse<AuthResponse>>('/register', data)
    return response.data
  },

  async login(data: LoginForm): Promise<ApiResponse<AuthResponse>> {
    const response = await apiClient.post<ApiResponse<AuthResponse>>('/login', data)
    return response.data
  },

  async logout(): Promise<ApiResponse> {
    const response = await apiClient.post<ApiResponse>('/logout')
    return response.data
  },

  async logoutAll(): Promise<ApiResponse> {
    const response = await apiClient.post<ApiResponse>('/logout-all')
    return response.data
  },

  async getUser(): Promise<ApiResponse<User>> {
    const response = await apiClient.get<ApiResponse<User>>('/user')
    return response.data
  },

  async updateProfile(data: ProfileUpdateForm | FormData): Promise<ApiResponse<User>> {
    const response = await apiClient.post<ApiResponse<User>>('/profile', data, {
      headers: data instanceof FormData ? { 'Content-Type': 'multipart/form-data' } : {}
    })
    return response.data
  },

  async deleteProfile(): Promise<ApiResponse> {
    const response = await apiClient.delete<ApiResponse>('/profile')
    return response.data
  },

  async changePassword(data: PasswordChangeForm): Promise<ApiResponse> {
    const response = await apiClient.put<ApiResponse>('/change-password', data)
    return response.data
  },
}
