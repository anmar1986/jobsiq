import axios, { type AxiosInstance, type AxiosError } from 'axios'
import { API_URL, STORAGE_KEYS } from '@/config/constants'

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
        delete (config.headers as Record<string, unknown>)['Content-Type']
        delete (config.headers as Record<string, unknown>)['content-type']
      }
    }
    
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// Flag to prevent multiple simultaneous 401 redirects
let isRedirecting = false

// Response interceptor
apiClient.interceptors.response.use(
  (response) => response,
  async (error: AxiosError) => {
    if (error.response?.status === 401 && !isRedirecting) {
      // Unauthorized - clear auth data
      isRedirecting = true
      localStorage.removeItem(STORAGE_KEYS.AUTH_TOKEN)
      localStorage.removeItem(STORAGE_KEYS.USER)
      
      // Instead of using window.location.href, let Vue Router handle navigation
      // This prevents full page reloads and maintains SPA behavior
      if (typeof window !== 'undefined' && window.location.pathname !== '/login') {
        // Use dynamic import to avoid circular dependency
        const router = (await import('@/router')).default
        await router.push({ name: 'login', query: { redirect: window.location.pathname } })
      }
      
      // Reset flag after a short delay to allow for legitimate re-authentication
      setTimeout(() => { isRedirecting = false }, 1000)
    }
    return Promise.reject(error)
  }
)

export default apiClient
