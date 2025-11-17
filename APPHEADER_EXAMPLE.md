# AppHeader.vue - Translation Integration Example

This file shows the key changes needed to integrate translations into AppHeader.vue.

## Import the LanguageSwitcher Component

Add this import at the top of your script section:

```typescript
import LanguageSwitcher from '@/components/base/LanguageSwitcher.vue'
import { useI18n } from 'vue-i18n'
```

## Add useI18n Composable

In the script setup section, add:

```typescript
const { t } = useI18n()
```

## Update navLinks Computed

Replace the existing navLinks computed with:

```typescript
const navLinks = computed(() => {
  const links = [
    { path: '/jobs', label: t('nav.jobs') },
    { path: '/companies', label: t('nav.companies') },
    { path: '/about', label: t('footer.aboutUs') },
  ]

  return links
})
```

## Update userMenuItems Computed

Replace the label strings in userMenuItems:

```typescript
const userMenuItems = computed(() => {
  const baseItems: MenuItem[] = [
    {
      path: '/profile',
      label: t('nav.profile'),
      icon: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24', class: 'h-4 w-4' }, [
        h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z' })
      ])
    },
    {
      path: '/change-password',
      label: t('auth.changePassword'),
      icon: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24', class: 'h-4 w-4' }, [
        h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z' })
      ])
    }
  ]

  // Add role-specific menu items
  if (authStore.user?.user_type === 'company_owner') {
    baseItems.push({
      path: '/my-companies',
      label: t('nav.myCompanies'),
      icon: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24', class: 'h-4 w-4' }, [
        h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4' })
      ])
    })
  }

  return baseItems
})
```

## Add Language Switcher to Template

Add the LanguageSwitcher component to your header. Here's where to place it:

```vue
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
            {{ $t('common.appName') }}
          </span>
        </router-link>

        <!-- Right Side Actions -->
        <div class="flex items-center gap-4">
          <!-- Language Switcher - ADD THIS -->
          <LanguageSwitcher variant="compact" />

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
              {{ $t('nav.dashboard') }}
            </router-link>

            <!-- User menu... -->
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
              {{ $t('auth.login') }}
            </router-link>
          </template>

          <!-- Mobile Menu Button -->
          <button
            @click="toggleMobileMenu"
            class="md:hidden p-2 rounded-lg hover:bg-gray-100 transition-colors"
          >
            <!-- SVG icons... -->
          </button>
        </div>
      </div>

      <!-- Mobile Menu -->
      <Transition>
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
                {{ $t('nav.dashboard') }}
              </router-link>
              <router-link
                v-if="authStore.isCompanyOwner"
                to="/my-companies"
                class="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg font-medium transition-colors"
                @click="closeMobileMenu"
              >
                {{ $t('nav.myCompanies') }}
              </router-link>
              <router-link
                to="/profile"
                class="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg font-medium transition-colors"
                @click="closeMobileMenu"
              >
                {{ $t('nav.profile') }}
              </router-link>
              <router-link
                v-if="authStore.isJobSeeker"
                to="/my-cvs"
                class="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg font-medium transition-colors"
                @click="closeMobileMenu"
              >
                {{ $t('nav.myCvs') }}
              </router-link>
              <router-link
                v-if="authStore.isJobSeeker"
                to="/my-applications"
                class="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg font-medium transition-colors"
                @click="closeMobileMenu"
              >
                {{ $t('nav.myApplications') }}
              </router-link>
              <button
                @click="handleLogout"
                class="px-4 py-2 text-red-600 hover:bg-red-50 rounded-lg font-medium transition-colors text-left"
              >
                {{ $t('auth.logout') }}
              </button>
            </template>
            <template v-else>
              <div class="border-t border-gray-200 my-2"></div>
              <router-link
                to="/login"
                class="px-4 py-2 bg-primary-600 text-white hover:bg-primary-700 rounded-lg font-medium transition-colors text-center"
                @click="closeMobileMenu"
              >
                {{ $t('auth.login') }}
              </router-link>
            </template>
          </div>
        </div>
      </Transition>
    </nav>

    <!-- Delete Profile Confirmation Modal -->
    <BaseModal
      v-model="showDeleteProfileModal"
      :title="$t('common.delete') + ' ' + $t('common.profile')"
      size="sm"
    >
      <div class="p-6">
        <p class="text-gray-700 mb-6">
          {{ $t('messages.confirmDelete') }}
        </p>
        <div class="flex items-center justify-end gap-3">
          <BaseButton
            variant="outline"
            @click="showDeleteProfileModal = false"
            :disabled="deletingProfile"
          >
            {{ $t('common.cancel') }}
          </BaseButton>
          <BaseButton
            variant="primary"
            @click="confirmDeleteProfile"
            :loading="deletingProfile"
            class="bg-red-600 hover:bg-red-700"
          >
            {{ $t('common.delete') }} {{ $t('common.profile') }}
          </BaseButton>
        </div>
      </div>
    </BaseModal>
  </header>
</template>
```

## Update Toast Messages

Replace toast messages in functions:

```typescript
const confirmDeleteProfile = async () => {
  deletingProfile.value = true
  try {
    await authStore.deleteProfile()
    showDeleteProfileModal.value = false
    closeMobileMenu()
    toast.success(t('messages.deleteSuccess'))
    router.push('/')
  } catch (error) {
    console.error('Failed to delete profile:', error)
    const err = error as { response?: { data?: { message?: string } } }
    toast.error(err.response?.data?.message || t('messages.errorOccurred'))
  } finally {
    deletingProfile.value = false
  }
}
```

## Summary of Changes

1. ✅ Import `LanguageSwitcher` component
2. ✅ Import and use `useI18n` composable
3. ✅ Replace hardcoded strings in `navLinks` with `t('...')`
4. ✅ Replace hardcoded strings in `userMenuItems` with `t('...')`
5. ✅ Replace all template strings with `{{ $t('...') }}`
6. ✅ Add `<LanguageSwitcher variant="compact" />` to header
7. ✅ Update toast messages to use translations

That's it! Your header is now fully internationalized and supports both English and Arabic with RTL support.
