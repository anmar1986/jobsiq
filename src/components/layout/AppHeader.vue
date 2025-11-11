<template>
  <header class="sticky top-0 z-40 bg-white border-b-2 border-gray-300 shadow-sm">
    <nav class="container-custom">
      <div class="flex items-center justify-between h-16">
        <!-- Logo -->
        <router-link to="/" class="flex items-center gap-2 group">
          <div class="h-10 w-10 bg-gradient-to-br from-primary-600 to-secondary-600 rounded-lg flex items-center justify-center transform group-hover:scale-105 transition-transform">
            <span class="text-white font-bold text-xl">J</span>
          </div>
          <span class="text-2xl font-bold bg-gradient-to-r from-primary-600 to-secondary-600 bg-clip-text text-transparent">
            JobsIQ
          </span>
        </router-link>

        <!-- Right Side Actions -->
        <div class="flex items-center gap-6">
          <!-- Authenticated User -->
          <template v-if="authStore.isAuthenticated && authStore.user">
            <!-- Navigation Links -->
            <router-link
              v-for="link in navLinks"
              :key="link.path"
              :to="link.path"
              class="hidden md:inline-flex text-gray-700 hover:text-primary-600 font-medium transition-all relative pb-1 after:content-[''] after:absolute after:bottom-0 after:left-0 after:w-0 after:h-0.5 after:bg-primary-600 after:transition-all after:duration-300 hover:after:w-full"
              active-class="text-primary-600 after:!w-full"
            >
              {{ link.label }}
            </router-link>
            
            <router-link
              to="/dashboard"
              class="hidden md:inline-flex text-gray-700 hover:text-primary-600 font-medium transition-all relative pb-1 after:content-[''] after:absolute after:bottom-0 after:left-0 after:w-0 after:h-0.5 after:bg-primary-600 after:transition-all after:duration-300 hover:after:w-full"
              active-class="text-primary-600 after:!w-full"
            >
              Dashboard
            </router-link>
            
            <!-- User Menu -->
            <div class="relative" ref="userMenuRef">
              <button
                @click="toggleUserMenu"
                class="flex items-center gap-2 p-1 rounded-lg hover:bg-gray-100 transition-colors cursor-pointer"
              >
                <div v-if="authStore.user.profile_photo" class="relative">
                  <img 
                    :src="getProfilePhotoUrl(authStore.user.profile_photo)"
                    :alt="authStore.user.name"
                    class="w-10 h-10 rounded-full object-cover border-2 border-gray-200"
                  />
                  <div class="absolute bottom-0 right-0 w-3 h-3 bg-green-500 border-2 border-white rounded-full"></div>
                </div>
                <BaseAvatar
                  v-else
                  :name="authStore.user.name"
                  size="sm"
                  show-status
                  status="online"
                />
              </button>

              <!-- Dropdown Menu -->
              <Transition
                enter-active-class="transition-all duration-200"
                enter-from-class="opacity-0 scale-95"
                enter-to-class="opacity-100 scale-100"
                leave-active-class="transition-all duration-150"
                leave-from-class="opacity-100 scale-100"
                leave-to-class="opacity-0 scale-95"
              >
                <div
                  v-if="isUserMenuOpen"
                  class="absolute right-0 mt-2 w-56 bg-white rounded-lg shadow-lg border border-gray-200 py-1 z-50"
                >
                  <div class="px-4 py-3 border-b border-gray-200">
                    <p class="text-sm font-semibold text-gray-900">{{ authStore.user.name }}</p>
                    <p class="text-xs text-gray-600 truncate">{{ authStore.user.email }}</p>
                  </div>
                  
                  <router-link
                    v-for="item in userMenuItems"
                    :key="item.path"
                    :to="item.path"
                    class="flex items-center gap-3 px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
                    @click="closeUserMenu"
                  >
                    <component :is="item.icon" class="h-4 w-4" />
                    {{ item.label }}
                  </router-link>
                  
                  <div class="border-t border-gray-200 mt-1">
                    <button
                      @click="handleDeleteProfile"
                      class="flex items-center gap-3 px-4 py-2 text-sm text-red-600 hover:bg-red-50 transition-colors w-full"
                    >
                      <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                      </svg>
                      Delete Profile
                    </button>
                    <button
                      @click="handleLogout"
                      class="flex items-center gap-3 px-4 py-2 text-sm text-red-600 hover:bg-red-50 transition-colors w-full"
                    >
                      <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                      </svg>
                      Logout
                    </button>
                  </div>
                </div>
              </Transition>
            </div>
          </template>

          <!-- Guest User -->
          <template v-else>
            <!-- Navigation Links -->
            <router-link
              v-for="link in navLinks"
              :key="link.path"
              :to="link.path"
              class="hidden md:inline-flex text-gray-700 hover:text-primary-600 font-medium transition-all relative pb-1 after:content-[''] after:absolute after:bottom-0 after:left-0 after:w-0 after:h-0.5 after:bg-primary-600 after:transition-all after:duration-300 hover:after:w-full"
              active-class="text-primary-600 after:!w-full"
            >
              {{ link.label }}
            </router-link>
            
            <router-link to="/login" class="btn-primary text-sm">
              Login
            </router-link>
          </template>

          <!-- Mobile Menu Button -->
          <button
            @click="toggleMobileMenu"
            class="md:hidden p-2 rounded-lg hover:bg-gray-100 transition-colors"
          >
            <svg v-if="!isMobileMenuOpen" class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
            </svg>
            <svg v-else class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
      </div>

      <!-- Mobile Menu -->
      <Transition
        enter-active-class="transition-all duration-300"
        enter-from-class="opacity-0 -translate-y-2"
        enter-to-class="opacity-100 translate-y-0"
        leave-active-class="transition-all duration-200"
        leave-from-class="opacity-100 translate-y-0"
        leave-to-class="opacity-0 -translate-y-2"
      >
        <div v-if="isMobileMenuOpen" class="md:hidden py-4 border-t border-gray-200">
          <div class="flex flex-col gap-2">
            <router-link
              v-for="link in navLinks"
              :key="link.path"
              :to="link.path"
              class="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg font-medium transition-colors"
              active-class="bg-primary-50 text-primary-600"
              @click="closeMobileMenu"
            >
              {{ link.label }}
            </router-link>
            
            <template v-if="authStore.isAuthenticated">
              <div class="border-t border-gray-200 my-2"></div>
              <router-link
                to="/dashboard"
                class="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg font-medium transition-colors"
                @click="closeMobileMenu"
              >
                Dashboard
              </router-link>
              <router-link
                v-if="authStore.isCompanyOwner"
                to="/my-companies"
                class="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg font-medium transition-colors"
                @click="closeMobileMenu"
              >
                For Companies
              </router-link>
              <router-link
                to="/profile"
                class="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg font-medium transition-colors"
                @click="closeMobileMenu"
              >
                Profile
              </router-link>
              <router-link
                v-if="authStore.isJobSeeker"
                to="/my-cvs"
                class="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg font-medium transition-colors"
                @click="closeMobileMenu"
              >
                My CVs
              </router-link>
              <router-link
                v-if="authStore.isJobSeeker"
                to="/my-applications"
                class="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg font-medium transition-colors"
                @click="closeMobileMenu"
              >
                My Applications
              </router-link>
              <button
                @click="handleLogout"
                class="px-4 py-2 text-red-600 hover:bg-red-50 rounded-lg font-medium transition-colors text-left"
              >
                Logout
              </button>
            </template>
            <template v-else>
              <div class="border-t border-gray-200 my-2"></div>
              <router-link
                to="/login"
                class="px-4 py-2 bg-primary-600 text-white hover:bg-primary-700 rounded-lg font-medium transition-colors text-center"
                @click="closeMobileMenu"
              >
                Login
              </router-link>
            </template>
          </div>
        </div>
      </Transition>
    </nav>

    <!-- Delete Profile Confirmation Modal -->
    <BaseModal
      v-model="showDeleteProfileModal"
      title="Delete Profile"
      size="sm"
    >
      <div class="p-6">
        <p class="text-gray-700 mb-6">
          Are you sure you want to delete your profile <strong>{{ authStore.user?.name }}</strong>? 
          This action cannot be undone and will permanently delete your account, all your CVs, job applications, and personal data.
        </p>
        <div class="flex items-center justify-end gap-3">
          <BaseButton
            variant="outline"
            @click="showDeleteProfileModal = false"
            :disabled="deletingProfile"
          >
            Cancel
          </BaseButton>
          <BaseButton
            variant="primary"
            @click="confirmDeleteProfile"
            :loading="deletingProfile"
            class="bg-red-600 hover:bg-red-700"
          >
            Delete Profile
          </BaseButton>
        </div>
      </div>
    </BaseModal>
  </header>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, h, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useToast } from '@/composables/useToast'
import BaseAvatar from '@/components/base/BaseAvatar.vue'
import BaseModal from '@/components/base/BaseModal.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import { API_BASE_URL } from '@/config/constants'

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()
const toast = useToast()

const isMobileMenuOpen = ref(false)
const isUserMenuOpen = ref(false)
const userMenuRef = ref<HTMLElement | null>(null)
const showDeleteProfileModal = ref(false)
const deletingProfile = ref(false)

const getProfilePhotoUrl = (path: string) => {
  if (!path) return ''
  if (path.startsWith('http')) return path
  return `${API_BASE_URL}/storage/${path}`
}

// Check if current route is within /my-companies section
const _isMyCompaniesActive = computed(() => {
  return route.path.startsWith('/my-companies')
})

const navLinks = computed(() => {
  const links = [
    { path: '/jobs', label: 'Jobs' },
    { path: '/companies', label: 'Companies' },
    { path: '/about', label: 'About Us' },
  ]
  
  return links
})

interface MenuItem {
  path: string
  label: string
  icon?: () => ReturnType<typeof h>
}

const userMenuItems = computed(() => {
  const baseItems: MenuItem[] = [
    {
      path: '/profile',
      label: 'Profile',
      icon: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24', class: 'h-4 w-4' }, [
        h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z' })
      ])
    },
    {
      path: '/change-password',
      label: 'Change Password',
      icon: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24', class: 'h-4 w-4' }, [
        h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z' })
      ])
    }
  ]

  // Add role-specific menu items
  if (authStore.user?.user_type === 'company_owner') {
    baseItems.push({
      path: '/my-companies',
      label: 'My Companies',
      icon: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24', class: 'h-4 w-4' }, [
        h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4' })
      ])
    })
  }

  return baseItems
})

const toggleMobileMenu = () => {
  isMobileMenuOpen.value = !isMobileMenuOpen.value
  if (isMobileMenuOpen.value) {
    isUserMenuOpen.value = false
  }
}

const closeMobileMenu = () => {
  isMobileMenuOpen.value = false
}

const toggleUserMenu = () => {
  isUserMenuOpen.value = !isUserMenuOpen.value
  if (isUserMenuOpen.value) {
    isMobileMenuOpen.value = false
  }
}

const closeUserMenu = () => {
  isUserMenuOpen.value = false
}

const handleLogout = async () => {
  await authStore.logout()
  closeUserMenu()
  closeMobileMenu()
  router.push('/login')
}

const handleDeleteProfile = () => {
  showDeleteProfileModal.value = true
  closeUserMenu()
}

const confirmDeleteProfile = async () => {
  deletingProfile.value = true
  try {
    await authStore.deleteProfile()
    showDeleteProfileModal.value = false
    closeMobileMenu()
    toast.success('Profile deleted successfully')
    router.push('/')
  } catch (error) {
    console.error('Failed to delete profile:', error)
    const err = error as { response?: { data?: { message?: string } } }
    toast.error(err.response?.data?.message || 'Failed to delete profile. Please try again.')
  } finally {
    deletingProfile.value = false
  }
}

// Close menus when clicking outside
const handleClickOutside = (event: MouseEvent) => {
  if (userMenuRef.value && !userMenuRef.value.contains(event.target as Node)) {
    isUserMenuOpen.value = false
  }
}

onMounted(() => {
  document.addEventListener('click', handleClickOutside)
})

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>
