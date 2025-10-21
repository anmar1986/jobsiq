import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { User, LoginForm, RegisterForm } from '@/types'
import { authService } from '@/services/auth.service'
import { STORAGE_KEYS } from '@/config/constants'

export const useAuthStore = defineStore('auth', () => {
  // State
  const user = ref<User | null>(null)
  const token = ref<string | null>(localStorage.getItem(STORAGE_KEYS.AUTH_TOKEN))
  const loading = ref(false)
  const error = ref<string | null>(null)

  // Getters
  const isAuthenticated = computed(() => !!token.value && !!user.value)
  const userName = computed(() => user.value?.name || '')
  const userEmail = computed(() => user.value?.email || '')

  // Actions
  async function login(credentials: LoginForm) {
    try {
      loading.value = true
      error.value = null
      const response = await authService.login(credentials)
      
      if (response.success && response.data) {
        token.value = response.data.token
        user.value = response.data.user
        localStorage.setItem(STORAGE_KEYS.AUTH_TOKEN, response.data.token)
        localStorage.setItem(STORAGE_KEYS.USER, JSON.stringify(response.data.user))
      }
      
      return response
    } catch (err: unknown) {
      const errorMessage = err && typeof err === 'object' && 'response' in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined
      error.value = errorMessage || 'Login failed'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function register(data: RegisterForm) {
    try {
      loading.value = true
      error.value = null
      const response = await authService.register(data)
      
      if (response.success && response.data) {
        token.value = response.data.token
        user.value = response.data.user
        localStorage.setItem(STORAGE_KEYS.AUTH_TOKEN, response.data.token)
        localStorage.setItem(STORAGE_KEYS.USER, JSON.stringify(response.data.user))
      }
      
      return response
    } catch (err: unknown) {
      const errorMessage = err && typeof err === 'object' && 'response' in err
        ? (err as { response?: { data?: { message?: string } } }).response?.data?.message
        : undefined
      error.value = errorMessage || 'Registration failed'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function logout() {
    try {
      if (token.value) {
        await authService.logout()
      }
    } catch (err) {
      console.error('Logout error:', err)
    } finally {
      token.value = null
      user.value = null
      localStorage.removeItem(STORAGE_KEYS.AUTH_TOKEN)
      localStorage.removeItem(STORAGE_KEYS.USER)
    }
  }

  async function fetchUser() {
    try {
      if (!token.value) return
      
      const response = await authService.getUser()
      if (response.success && response.data) {
        user.value = response.data
        localStorage.setItem(STORAGE_KEYS.USER, JSON.stringify(response.data))
      }
    } catch (err) {
      console.error('Fetch user error:', err)
      await logout()
    }
  }

  function initializeAuth() {
    const storedUser = localStorage.getItem(STORAGE_KEYS.USER)
    if (storedUser && token.value) {
      try {
        user.value = JSON.parse(storedUser)
      } catch (err) {
        console.error('Parse user error:', err)
        logout()
      }
    }
  }

  return {
    user,
    token,
    loading,
    error,
    isAuthenticated,
    userName,
    userEmail,
    login,
    register,
    logout,
    fetchUser,
    initializeAuth,
  }
})
