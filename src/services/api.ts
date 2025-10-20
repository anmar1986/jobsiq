import axios, { type AxiosInstance, type AxiosError } from 'axios'
import { API_URL, STORAGE_KEYS } from '@/config/constants'
import { useAuthStore } from '@/stores/auth'

// Create axios instance
const apiClient: AxiosInstance = axios.create({
  baseURL: API_URL,
  // Do not force a default Content-Type here. Some requests will
  // send FormData and the browser must set the Content-Type with
  // the proper multipart boundary.
  headers: {
    Accept: 'application/json',
  },
  withCredentials: false,
})

// Request interceptor
apiClient.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem(STORAGE_KEYS.AUTH_TOKEN)
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    // If the request data is FormData, remove any Content-Type header so
    // the browser can set the correct multipart/form-data boundary.
    if (config.data instanceof FormData) {
      if (config.headers) {
        // Some axios typings use lowercase keys, so delete both forms
        delete (config.headers as any)['Content-Type']
        delete (config.headers as any)['content-type']
      }
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// Response interceptor
apiClient.interceptors.response.use(
  (response) => response,
  (error: AxiosError) => {
    if (error.response?.status === 401) {
      // Unauthorized - clear auth and redirect to login
      const authStore = useAuthStore()
      authStore.logout()
      window.location.href = '/login'
    }
    return Promise.reject(error)
  }
)

export default apiClient
