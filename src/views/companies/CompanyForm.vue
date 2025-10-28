<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <!-- Basic Information Section -->
    <div class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">Basic Information</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div class="md:col-span-2">
          <BaseInput
            v-model="formData.name"
            label="Company Name *"
            placeholder="Enter company name"
            :error="errors.name"
            required
          />
        </div>

        <div class="md:col-span-2">
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Company Logo
          </label>
          
          <div class="flex items-center gap-6">
            <!-- Logo Preview -->
            <div class="relative">
              <div class="w-32 h-32 rounded-lg overflow-hidden bg-gray-100 border-2 border-gray-200 flex items-center justify-center">
                <img
                  v-if="logoPreview"
                  :src="logoPreview"
                  alt="Logo preview"
                  class="w-full h-full object-contain"
                />
                <svg v-else class="w-12 h-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
              </div>
              
              <!-- Remove Button -->
              <button
                v-if="logoPreview"
                type="button"
                @click="removeLogo"
                class="absolute -top-2 -right-2 p-2 bg-red-500 text-white rounded-full shadow-lg hover:bg-red-600 transition-colors"
              >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>
            
            <!-- Upload Controls -->
            <div class="flex-1">
              <input
                ref="logoInput"
                type="file"
                accept="image/*"
                class="hidden"
                @change="handleLogoChange"
              />
              
              <BaseButton
                type="button"
                variant="outline"
                @click="triggerLogoInput"
              >
                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
                Choose Logo
              </BaseButton>
              
              <p class="text-xs text-gray-500 mt-2">
                PNG, JPG, GIF up to 2MB
              </p>
              <p v-if="errors.logo" class="text-red-600 text-sm mt-1">{{ errors.logo }}</p>
            </div>
          </div>
        </div>

        <div class="md:col-span-2">
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Company Pictures
            <span class="text-gray-500 text-xs font-normal ml-2">(Maximum 10 images)</span>
          </label>
          
          <!-- Image Upload Area -->
          <div class="mb-4">
            <input
              ref="imagesInput"
              type="file"
              accept="image/*"
              multiple
              class="hidden"
              @change="handleImagesChange"
            />
            
            <button
              type="button"
              @click="triggerImagesInput"
              :disabled="companyImages.length >= 10"
              class="w-full border-2 border-dashed border-gray-300 rounded-lg p-8 text-center hover:border-primary-500 hover:bg-primary-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <svg class="w-12 h-12 mx-auto text-gray-400 mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
              <p class="text-sm text-gray-600">
                <span class="font-medium text-primary-600">Click to upload</span> or drag and drop
              </p>
              <p class="text-xs text-gray-500 mt-1">PNG, JPG, GIF up to 2MB each</p>
              <p class="text-xs text-gray-500 mt-1">{{ companyImages.length }} / 10 images uploaded</p>
            </button>
            <p v-if="errors.images" class="text-red-600 text-sm mt-1">{{ errors.images }}</p>
          </div>
          
          <!-- Images Preview Grid -->
          <div v-if="companyImages.length > 0" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
            <div
              v-for="(image, index) in companyImages"
              :key="index"
              class="relative group"
            >
              <div class="aspect-square rounded-lg overflow-hidden bg-gray-100 border-2 border-gray-200">
                <img
                  :src="image.preview"
                  :alt="`Company image ${index + 1}`"
                  class="w-full h-full object-cover"
                />
              </div>
              
              <!-- Remove Button -->
              <button
                type="button"
                @click="removeImage(index)"
                class="absolute -top-2 -right-2 p-2 bg-red-500 text-white rounded-full shadow-lg hover:bg-red-600 transition-colors opacity-0 group-hover:opacity-100"
              >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
              
              <!-- Image Number Badge -->
              <div class="absolute bottom-2 left-2 bg-black/60 text-white text-xs px-2 py-1 rounded">
                {{ index + 1 }}
              </div>
            </div>
          </div>
        </div>

        <div class="md:col-span-2">
          <label class="block text-sm font-medium text-gray-700 mb-1">
            Description
          </label>
          <textarea
            v-model="formData.description"
            rows="4"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            placeholder="Tell us about your company..."
          />
          <p v-if="errors.description" class="text-red-600 text-sm mt-1">{{ errors.description }}</p>
        </div>

        <BaseInput
          v-model="formData.tagline"
          label="Tagline"
          placeholder="Short company tagline"
          :error="errors.tagline"
        />

        <BaseInput
          v-model="formData.website"
          label="Website"
          type="url"
          placeholder="https://example.com"
          :error="errors.website"
        />
      </div>
    </div>

    <!-- Contact Information Section -->
    <div class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">Contact Information</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <BaseInput
          v-model="formData.email"
          label="Email"
          type="email"
          placeholder="contact@company.com"
          :error="errors.email"
        />

        <BaseInput
          v-model="formData.phone"
          label="Phone"
          placeholder="+1 (555) 000-0000"
          :error="errors.phone"
        />
      </div>
    </div>

    <!-- Address Section -->
    <div class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">Address</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div class="md:col-span-2">
          <BaseInput
            v-model="formData.street"
            label="Street Address"
            placeholder="123 Main Street"
            :error="errors.street"
          />
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            City *
          </label>
          <select
            v-model="formData.city"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            required
          >
            <option value="">Select city</option>
            <option v-for="city in iraqCities" :key="city" :value="city">
              {{ city }}
            </option>
          </select>
          <p v-if="errors.city" class="text-red-600 text-sm mt-1">{{ errors.city }}</p>
        </div>

        <BaseInput
          v-model="formData.state"
          label="State / Province"
          placeholder="Baghdad Governorate"
          :error="errors.state"
        />

        <BaseInput
          v-model="formData.country"
          label="Country"
          value="Iraq"
          readonly
          :error="errors.country"
        />
      </div>
    </div>

    <!-- Business Information Section -->
    <div class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">Business Information</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            Category *
          </label>
          <select
            v-model="formData.category"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            required
          >
            <option value="">Select category</option>
            <option v-for="category in companyCategories" :key="category" :value="category">
              {{ category }}
            </option>
          </select>
          <p v-if="errors.category" class="text-red-600 text-sm mt-1">{{ errors.category }}</p>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            Company Size
          </label>
          <select
            v-model="formData.company_size"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          >
            <option value="">Select size</option>
            <option value="1-10">1-10 employees</option>
            <option value="11-50">11-50 employees</option>
            <option value="51-200">51-200 employees</option>
            <option value="201-500">201-500 employees</option>
            <option value="501-1000">501-1000 employees</option>
            <option value="1000+">1000+ employees</option>
          </select>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            Company Type
          </label>
          <select
            v-model="formData.company_type"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          >
            <option value="">Select type</option>
            <option value="startup">Startup</option>
            <option value="small_business">Small Business</option>
            <option value="mid_market">Mid Market</option>
            <option value="enterprise">Enterprise</option>
            <option value="nonprofit">Nonprofit</option>
            <option value="government">Government</option>
            <option value="agency">Agency</option>
          </select>
        </div>

        <BaseInput
          v-model="formData.total_employees"
          label="Total Employees"
          type="number"
          min="0"
          placeholder="100"
          :error="errors.total_employees"
        />

        <div class="md:col-span-2">
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Required Skills
          </label>
          
          <div class="flex gap-2 mb-4">
            <input
              v-model="newSkill"
              type="text"
              placeholder="e.g., JavaScript, React, Node.js"
              class="flex-1 px-4 py-2.5 text-sm border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
              @keyup.enter="addSkill"
            />
            <BaseButton
              type="button"
              variant="primary"
              @click="addSkill"
              :disabled="!newSkill.trim()"
            >
              <svg class="w-5 h-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
              </svg>
              Add
            </BaseButton>
          </div>
          
          <!-- Skills List -->
          <div v-if="requiredSkills.length > 0" class="flex flex-wrap gap-2 p-4 bg-gray-50 rounded-lg border border-gray-200">
            <span
              v-for="(skill, index) in requiredSkills"
              :key="index"
              class="inline-flex items-center gap-2 px-3 py-1.5 bg-primary-100 text-primary-700 rounded-full text-sm font-medium"
            >
              {{ skill }}
              <button
                type="button"
                @click="removeSkill(index)"
                class="hover:text-primary-900 focus:outline-none"
              >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </span>
          </div>
          
          <p v-else class="text-sm text-gray-500 italic p-4 bg-gray-50 rounded-lg border border-gray-200">
            No skills added yet. Add required skills for this position.
          </p>
          
          <p v-if="errors.required_skills" class="text-red-600 text-sm mt-1">{{ errors.required_skills }}</p>
        </div>
      </div>
    </div>

    <!-- Social Media Section -->
    <div class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">Social Media</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <BaseInput
          v-model="formData.linkedin"
          label="LinkedIn"
          type="url"
          placeholder="https://linkedin.com/company/..."
          :error="errors.linkedin"
        >
          <template #icon-left>
            <svg class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 24 24">
              <path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z" />
            </svg>
          </template>
        </BaseInput>

        <BaseInput
          v-model="formData.twitter"
          label="Twitter / X"
          type="url"
          placeholder="https://twitter.com/..."
          :error="errors.twitter"
        >
          <template #icon-left>
            <svg class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 24 24">
              <path d="M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z" />
            </svg>
          </template>
        </BaseInput>

        <BaseInput
          v-model="formData.facebook"
          label="Facebook"
          type="url"
          placeholder="https://facebook.com/..."
          :error="errors.facebook"
        />

        <BaseInput
          v-model="formData.github"
          label="GitHub"
          type="url"
          placeholder="https://github.com/..."
          :error="errors.github"
        />
      </div>
    </div>

    <!-- Form Actions -->
    <div class="flex items-center justify-end gap-3 pt-4 border-t border-gray-200">
      <BaseButton
        type="button"
        variant="outline"
        @click="$emit('cancel')"
        :disabled="loading"
      >
        Cancel
      </BaseButton>
      <BaseButton
        type="submit"
        variant="primary"
        :loading="loading"
      >
        {{ isEdit ? 'Update Company' : 'Create Company' }}
      </BaseButton>
    </div>
  </form>
</template>

<script setup lang="ts">
import { ref, reactive, watch } from 'vue'
import type { Company } from '@/types'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import { companyCategories } from '@/config/companyCategories'
import { iraqCities } from '@/config/iraqCities'

interface Props {
  company?: Company
  loading?: boolean
}

const props = defineProps<Props>()
const emit = defineEmits<{
  submit: [data: FormData]
  cancel: []
}>()

const isEdit = ref(!!props.company)

const formData = reactive({
  name: '',
  description: '',
  tagline: '',
  website: '',
  email: '',
  phone: '',
  street: '',
  city: '',
  state: '',
  country: 'Iraq',
  postal_code: '',
  category: '',
  company_size: '',
  company_type: '',
  total_employees: '',
  linkedin: '',
  twitter: '',
  facebook: '',
  github: '',
})

const errors = reactive<Record<string, string>>({})
const logoFile = ref<File | null>(null)
const logoPreview = ref<string | null>(null)
const logoInput = ref<HTMLInputElement | null>(null)
const imagesInput = ref<HTMLInputElement | null>(null)
const companyImages = ref<Array<{ file: File; preview: string }>>([])
const requiredSkills = ref<string[]>([])
const newSkill = ref('')

// Initialize form with existing company data if editing
watch(() => props.company, (company) => {
  if (company) {
    Object.assign(formData, {
      name: company.name || '',
      description: company.description || '',
      tagline: company.tagline || '',
      website: company.website || '',
      email: company.email || '',
      phone: company.phone || '',
      street: company.street || '',
      city: company.city || '',
      state: company.state || '',
      country: company.country || 'Iraq',
      postal_code: company.postal_code || '',
      category: company.industry || '',
      company_size: company.company_size || '',
      company_type: company.company_type || '',
      total_employees: company.total_employees?.toString() || '',
      linkedin: company.linkedin || '',
      twitter: company.twitter || '',
      facebook: company.facebook || '',
      github: company.github || '',
    })
    // Initialize required skills if exists
    if (company.required_skills) {
      try {
        requiredSkills.value = typeof company.required_skills === 'string' 
          ? JSON.parse(company.required_skills) 
          : company.required_skills
      } catch {
        requiredSkills.value = []
      }
    }
    // Initialize logo preview if exists
    if (company.logo) {
      const path = company.logo.path
      // Handle different path formats
      if (path.startsWith('data:') || path.startsWith('blob:') || path.startsWith('http')) {
        logoPreview.value = path
      } else if (path.startsWith('/storage/')) {
        logoPreview.value = path
      } else {
        // Remove leading slashes and construct clean path
        const cleanPath = path.replace(/^\/+/, '')
        logoPreview.value = `/storage/${cleanPath}`
      }
    }
    
    // Initialize company images if exists
    if (company.images && company.images.length > 0) {
      // Filter out the logo image and only show gallery images
      const galleryImages = company.images.filter(img => img.type !== 'logo')
      companyImages.value = galleryImages.map(img => {
        const path = img.path
        let preview = ''
        
        // Handle different path formats
        if (path.startsWith('data:') || path.startsWith('blob:') || path.startsWith('http')) {
          preview = path
        } else if (path.startsWith('/storage/')) {
          preview = path
        } else {
          const cleanPath = path.replace(/^\/+/, '')
          preview = `/storage/${cleanPath}`
        }
        
        return {
          file: new File([], img.path), // Placeholder file object for existing images
          preview: preview
        }
      })
    }
  }
}, { immediate: true })

const addSkill = () => {
  const skill = newSkill.value.trim()
  if (skill && !requiredSkills.value.includes(skill)) {
    requiredSkills.value.push(skill)
    newSkill.value = ''
  }
}

const removeSkill = (index: number) => {
  requiredSkills.value.splice(index, 1)
}

const triggerLogoInput = () => {
  logoInput.value?.click()
}

const handleLogoChange = (event: Event) => {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  
  if (!file) return
  
  // Validate file type
  const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/svg+xml']
  if (!validTypes.includes(file.type)) {
    errors.logo = 'Invalid file type. Please upload a JPG, PNG, GIF, or SVG image.'
    return
  }
  
  // Validate file size (2MB)
  const maxSize = 2 * 1024 * 1024
  if (file.size > maxSize) {
    errors.logo = 'File size too large. Please upload an image smaller than 2MB.'
    return
  }
  
  // Clear any previous errors
  delete errors.logo
  
  // Set the file
  logoFile.value = file
  
  // Create preview
  const reader = new FileReader()
  reader.onload = (e) => {
    logoPreview.value = e.target?.result as string
  }
  reader.readAsDataURL(file)
}

const removeLogo = () => {
  logoFile.value = null
  logoPreview.value = null
  if (logoInput.value) {
    logoInput.value.value = ''
  }
}

const triggerImagesInput = () => {
  imagesInput.value?.click()
}

const handleImagesChange = (event: Event) => {
  const target = event.target as HTMLInputElement
  const files = target.files
  
  if (!files || files.length === 0) return
  
  // Check if adding these files would exceed the limit
  const remainingSlots = 10 - companyImages.value.length
  if (files.length > remainingSlots) {
    errors.images = `You can only upload ${remainingSlots} more image(s). Maximum is 10 images.`
    return
  }
  
  // Clear any previous errors
  delete errors.images
  
  // Process each file
  Array.from(files).forEach(file => {
    // Validate file type
    const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/svg+xml']
    if (!validTypes.includes(file.type)) {
      errors.images = 'Invalid file type. Please upload JPG, PNG, GIF, or SVG images only.'
      return
    }
    
    // Validate file size (2MB)
    const maxSize = 2 * 1024 * 1024
    if (file.size > maxSize) {
      errors.images = `File "${file.name}" is too large. Please upload images smaller than 2MB.`
      return
    }
    
    // Create preview
    const reader = new FileReader()
    reader.onload = (e) => {
      companyImages.value.push({
        file: file,
        preview: e.target?.result as string
      })
    }
    reader.readAsDataURL(file)
  })
  
  // Clear the input so the same files can be selected again if needed
  if (imagesInput.value) {
    imagesInput.value.value = ''
  }
}

const removeImage = (index: number) => {
  companyImages.value.splice(index, 1)
  delete errors.images
}

const handleSubmit = () => {
  // Clear previous errors
  Object.keys(errors).forEach(key => delete errors[key])

  // Client-side validation
  if (!formData.name.trim()) {
    errors.name = 'Company name is required'
    return
  }

  if (!formData.category) {
    errors.category = 'Category is required'
    return
  }

  if (!formData.city) {
    errors.city = 'City is required'
    return
  }

  // Create FormData object
  const data = new FormData()
  
  // Append all form fields (only if they have actual values)
  Object.entries(formData).forEach(([key, value]) => {
    if (value && value.trim() !== '') {
      // Map category to industry for backend compatibility
      if (key === 'category') {
        data.append('industry', value.toString())
      } else {
        data.append(key, value.toString())
      }
    }
  })

  // Append required skills as JSON
  if (requiredSkills.value.length > 0) {
    data.append('required_skills', JSON.stringify(requiredSkills.value))
  }

  // Append logo if selected
  if (logoFile.value) {
    data.append('logo', logoFile.value)
  }

  // Append company images if selected (only new images with actual file content)
  if (companyImages.value.length > 0) {
    const newImages = companyImages.value.filter(image => image.file.size > 0)
    newImages.forEach((image, index) => {
      data.append(`images[${index}]`, image.file)
    })
  }

  emit('submit', data)
}

// Expose method to set server errors
const setErrors = (serverErrors: Record<string, string[]>) => {
  Object.keys(serverErrors).forEach(key => {
    errors[key] = serverErrors[key][0]
  })
}

defineExpose({ setErrors })
</script>
