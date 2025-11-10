<template>
  <div class="bg-gray-50 min-h-screen py-8">
    <div class="mx-auto px-4 sm:px-6 lg:px-8" style="max-width: 1200px;">
      <!-- Header -->
      <div class="mb-8 flex items-center justify-between">
        <div>
          <h1 class="text-3xl font-bold text-gray-900 mb-2">My Profile</h1>
          <p class="text-gray-600">{{ isEditMode ? 'Update your personal information' : 'View your profile information' }}</p>
        </div>
        <div v-if="!isEditMode">
          <BaseButton
            variant="primary"
            @click="enterEditMode"
          >
            <template #icon-left>
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
              </svg>
            </template>
            Edit Profile
          </BaseButton>
        </div>
      </div>

      <!-- View Mode -->
      <div v-if="!isEditMode">
        <div class="bg-white rounded-lg shadow-md p-6 space-y-6">
          <!-- Profile Photo & Basic Info -->
          <div class="border-b border-gray-200 pb-6">
            <div class="flex items-start gap-6">
              <div class="relative">
                <div v-if="authStore.user?.profile_photo" class="w-32 h-32 rounded-full overflow-hidden border-4 border-gray-200">
                  <img 
                    :src="getProfilePhotoUrl(authStore.user?.profile_photo || '')" 
                    alt="Profile" 
                    class="w-full h-full object-cover"
                  />
                </div>
                <BaseAvatar 
                  v-else
                  :name="authStore.user?.name || 'User'" 
                  size="xl" 
                  class="w-32 h-32"
                />
              </div>
              <div class="flex-1">
                <h2 class="text-2xl font-bold text-gray-900 mb-1">{{ authStore.user?.name }}</h2>
                <p v-if="authStore.user?.headline" class="text-lg text-gray-600 mb-2">{{ authStore.user.headline }}</p>
                <p class="text-gray-500">{{ authStore.user?.email }}</p>
              </div>
            </div>
          </div>

          <!-- Personal Information -->
          <div class="border-b border-gray-200 pb-6">
            <h3 class="text-xl font-semibold text-gray-900 mb-4">Personal Information</h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div v-if="authStore.user?.gender">
                <p class="text-sm font-semibold text-gray-500">Gender</p>
                <p class="text-gray-900 capitalize">{{ authStore.user.gender }}</p>
              </div>
              <div v-if="authStore.user?.date_of_birth">
                <p class="text-sm font-semibold text-gray-500">Date of Birth</p>
                <p class="text-gray-900">{{ formatDate(authStore.user.date_of_birth) }}</p>
              </div>
              <div v-if="authStore.user?.nationality">
                <p class="text-sm font-semibold text-gray-500">Nationality</p>
                <p class="text-gray-900">{{ authStore.user.nationality }}</p>
              </div>
              <div v-if="authStore.user?.phone_number">
                <p class="text-sm font-semibold text-gray-500">Phone Number</p>
                <p class="text-gray-900">{{ authStore.user.phone_number }}</p>
              </div>
              <div v-if="authStore.user?.city">
                <p class="text-sm font-semibold text-gray-500">City</p>
                <p class="text-gray-900">{{ authStore.user.city }}</p>
              </div>
              <div v-if="authStore.user?.country">
                <p class="text-sm font-semibold text-gray-500">Country</p>
                <p class="text-gray-900">{{ authStore.user.country }}</p>
              </div>
              <div v-if="authStore.user?.address" class="md:col-span-2">
                <p class="text-sm font-semibold text-gray-500">Address</p>
                <p class="text-gray-900">{{ authStore.user.address }}</p>
              </div>
            </div>
            <div v-if="!authStore.user?.gender && !authStore.user?.date_of_birth && !authStore.user?.nationality && !authStore.user?.phone_number && !authStore.user?.city && !authStore.user?.country && !authStore.user?.address" class="text-gray-500 italic">
              No personal information added yet.
            </div>
          </div>

          <!-- Social Links -->
          <div v-if="authStore.user?.linkedin_url">
            <h3 class="text-xl font-semibold text-gray-900 mb-4">Social Links</h3>
            <div>
              <a 
                :href="authStore.user.linkedin_url" 
                target="_blank" 
                class="flex items-center gap-2 text-primary-600 hover:text-primary-700"
              >
                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z" />
                </svg>
                LinkedIn Profile
              </a>
            </div>
          </div>
        </div>
      </div>

      <!-- Edit Mode -->
      <div v-else>
        <form @submit.prevent="handleSubmit" class="bg-white rounded-lg shadow-md p-6 space-y-6">
          <!-- Profile Photo Section -->
          <div class="border-b border-gray-200 pb-6">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Profile Photo</h2>
            <div class="flex items-center gap-6">
              <div class="relative">
                <div v-if="profilePhotoPreview || authStore.user?.profile_photo" class="w-32 h-32 rounded-full overflow-hidden border-4 border-gray-200">
                  <img 
                    :src="profilePhotoPreview || getProfilePhotoUrl(authStore.user?.profile_photo || '')" 
                    alt="Profile" 
                    class="w-full h-full object-cover"
                  />
                </div>
                <BaseAvatar 
                  v-else
                  :name="formData.name || 'User'" 
                  size="xl" 
                  class="w-32 h-32"
                />
              </div>
              <div class="flex-1">
                <input
                  type="file"
                  ref="photoInput"
                  accept="image/*"
                  @change="handlePhotoChange"
                  class="hidden"
                />
                <BaseButton
                  type="button"
                  variant="outline"
                  @click="photoInput?.click()"
                  class="mb-2"
                >
                  Choose Photo
                </BaseButton>
                <p class="text-sm text-gray-500">JPG, PNG or GIF. Max size 2MB.</p>
                <button
                  v-if="profilePhotoPreview || authStore.user?.profile_photo"
                  type="button"
                  @click="removePhoto"
                  class="text-sm text-red-600 hover:text-red-700 mt-2"
                >
                  Remove Photo
                </button>
              </div>
            </div>
          </div>

          <!-- Basic Information -->
          <div class="border-b border-gray-200 pb-6">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Basic Information</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <BaseInput
                v-model="formData.name"
                label="Full Name"
                placeholder="Enter your full name"
                required
              />
              <BaseInput
                v-model="formData.email"
                type="email"
                label="Email"
                placeholder="Enter your email"
                required
              />
              <BaseInput
                v-model="formData.headline"
                label="Headline/Title"
                placeholder="e.g., Software Engineer"
                class="md:col-span-2"
              />
            </div>
          </div>

          <!-- Personal Information -->
          <div class="border-b border-gray-200 pb-6">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Personal Information</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-semibold text-gray-700 mb-2">Gender</label>
                <select
                  v-model="formData.gender"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                >
                  <option value="">Select gender</option>
                  <option value="male">Male</option>
                  <option value="female">Female</option>
                  <option value="other">Other</option>
                </select>
              </div>
              <BaseInput
                v-model="formData.date_of_birth"
                type="date"
                label="Date of Birth"
                :max="maxDate"
              />
              <BaseInput
                v-model="formData.nationality"
                label="Nationality"
                placeholder="e.g., Iraqi"
              />
              <BaseInput
                v-model="formData.phone_number"
                type="tel"
                label="Phone Number"
                placeholder="+964 XXX XXX XXXX"
              />
              <BaseInput
                v-model="formData.city"
                label="City"
                placeholder="e.g., Baghdad"
              />
              <BaseInput
                v-model="formData.country"
                label="Country"
                placeholder="Iraq"
                readonly
              />
              <BaseInput
                v-model="formData.address"
                label="Street Address"
                placeholder="Enter your street address"
                class="md:col-span-2"
              />
            </div>
          </div>

          <!-- Social Links -->
          <div class="pb-6">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Social Links</h2>
            <BaseInput
              v-model="formData.linkedin_url"
              type="url"
              label="LinkedIn URL"
              placeholder="https://www.linkedin.com/in/your-profile"
            />
          </div>

          <!-- Action Buttons -->
          <div class="flex gap-4 pt-6 border-t border-gray-200">
            <BaseButton
              type="submit"
              variant="primary"
              :loading="loading"
              class="flex-1 md:flex-none"
            >
              Save Changes
            </BaseButton>
            <BaseButton
              type="button"
              variant="outline"
              @click="cancelEdit"
              :disabled="loading"
            >
              Cancel
            </BaseButton>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { useToast } from '@/composables/useToast'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseAvatar from '@/components/base/BaseAvatar.vue'
import { API_BASE_URL } from '@/config/constants'

const authStore = useAuthStore()
const toast = useToast()

const photoInput = ref<HTMLInputElement | null>(null)
const profilePhotoPreview = ref<string | null>(null)
const photoFile = ref<File | null>(null)
const loading = ref(false)
const isEditMode = ref(false)

const formData = ref({
  name: '',
  email: '',
  headline: '',
  gender: '',
  date_of_birth: '',
  nationality: '',
  city: '',
  country: 'Iraq',
  address: '',
  phone_number: '',
  linkedin_url: '',
})

const maxDate = computed(() => {
  const today = new Date()
  today.setFullYear(today.getFullYear() - 16) // Minimum age 16
  return today.toISOString().split('T')[0]
})

const getProfilePhotoUrl = (path: string | undefined) => {
  if (!path) return ''
  if (path.startsWith('http')) return path
  return `${API_BASE_URL}/storage/${path}`
}

const handlePhotoChange = (event: Event) => {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  
  if (file) {
    if (file.size > 2 * 1024 * 1024) {
      toast.error('Image size must be less than 2MB')
      return
    }
    
    photoFile.value = file
    const reader = new FileReader()
    reader.onload = (e) => {
      profilePhotoPreview.value = e.target?.result as string
    }
    reader.readAsDataURL(file)
  }
}

const removePhoto = () => {
  profilePhotoPreview.value = null
  photoFile.value = null
  if (photoInput.value) {
    photoInput.value.value = ''
  }
}

const loadProfile = () => {
  if (authStore.user) {
    formData.value = {
      name: authStore.user.name || '',
      email: authStore.user.email || '',
      headline: authStore.user.headline || '',
      gender: authStore.user.gender || '',
      date_of_birth: authStore.user.date_of_birth || '',
      nationality: authStore.user.nationality || '',
      city: authStore.user.city || '',
      country: authStore.user.country || 'Iraq',
      address: authStore.user.address || '',
      phone_number: authStore.user.phone_number || '',
      linkedin_url: authStore.user.linkedin_url || '',
    }
  }
}

const _resetForm = () => {
  loadProfile()
  removePhoto()
}

const handleSubmit = async () => {
  loading.value = true
  
  try {
    const formDataToSend = new FormData()
    
    // Append all form fields - include empty strings for nullable fields
    Object.entries(formData.value).forEach(([key, value]) => {
      // Always send the value, even if empty (for nullable fields)
      formDataToSend.append(key, value || '')
    })
    
    // Append photo if selected
    if (photoFile.value) {
      console.log('Uploading photo:', {
        name: photoFile.value.name,
        size: photoFile.value.size,
        type: photoFile.value.type
      })
      formDataToSend.append('profile_photo', photoFile.value, photoFile.value.name)
    }
    
    // Debug: Log what we're sending
    console.log('Submitting profile data:', {
      name: formData.value.name,
      email: formData.value.email,
      date_of_birth: formData.value.date_of_birth,
      gender: formData.value.gender,
      city: formData.value.city,
    })
    
    await authStore.updateProfile(formDataToSend)
    
    toast.success('Profile updated successfully!')
    
    // Clear photo upload state
    photoFile.value = null
    profilePhotoPreview.value = null
    if (photoInput.value) {
      photoInput.value.value = ''
    }
    
    // Refresh user data to get the latest saved data
    await authStore.fetchUser()
    
    // Reload form with fresh data and exit edit mode
    loadProfile()
    isEditMode.value = false
  } catch (error: unknown) {
    console.error('Failed to update profile:', error)
    const errorObj = error as { response?: { data?: { errors?: Record<string, string[]>; message?: string } }; message?: string }
    const errorMsg = errorObj?.response?.data?.errors 
      ? Object.values(errorObj.response.data.errors).flat().join(', ')
      : errorObj?.response?.data?.message || 'Failed to update profile'
    toast.error(errorMsg)
  } finally {
    loading.value = false
  }
}

const enterEditMode = () => {
  loadProfile() // Load current data
  isEditMode.value = true
}

const cancelEdit = () => {
  loadProfile() // Reset form to saved data
  removePhoto() // Clear any photo preview
  isEditMode.value = false
}

const formatDate = (dateString: string) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })
}

onMounted(() => {
  loadProfile()
})
</script>

