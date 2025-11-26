<template>
  <div class="container-custom py-8">
    <!-- Header -->
    <div class="mb-8">
      <button @click="router.back()" class="flex items-center gap-2 text-gray-600 hover:text-gray-900 mb-4 transition-colors">
        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
        </svg>
        {{ $t('cv.backToMyCvs') }}
      </button>
      <h1 class="text-3xl font-bold text-gray-900">{{ isEditing ? $t('cv.editCv') : $t('cv.createNewCv') }}</h1>
      <p class="text-gray-600 mt-2">{{ isEditing ? $t('cv.updateCvInfo') : $t('cv.fillDetailsToCreate') }}</p>
    </div>

    <!-- CV Form -->
    <form @submit.prevent="saveCv" class="max-w-4xl">
      <BaseCard class="p-8 mb-6">
        <!-- Profile Image Upload -->
        <ProfileImageUpload 
          v-model="profileImageFile" 
          :preview="profileImagePreview"
          @update:preview="profileImagePreview = $event"
          @error="toast.error"
        />

        <!-- Personal Information -->
        <PersonalInfoSection 
          :personal-info="personalInfo"
          @update:personal-info="updatePersonalInfo"
        />

        <!-- Education -->
        <EducationSection 
          :education="cvForm.education"
          @update:education="cvForm.education = $event"
        />

        <!-- Work Experience -->
        <WorkExperienceSection 
          :work-experience="cvForm.work_experience"
          @update:work-experience="cvForm.work_experience = $event"
        />

        <!-- Certifications -->
        <CertificationsSection 
          :certifications="cvForm.certifications"
          @update:certifications="cvForm.certifications = $event"
        />

        <!-- Volunteer Work -->
        <VolunteerWorkSection 
          :volunteer-work="cvForm.volunteer_work"
          @update:volunteer-work="cvForm.volunteer_work = $event"
        />

        <!-- References -->
        <ReferencesSection 
          :references="cvForm.references"
          @update:references="cvForm.references = $event"
        />

        <!-- Skills -->
        <SkillsSection 
          :skills="cvForm.skills"
          @update:skills="cvForm.skills = $event"
        />

        <!-- Languages -->
        <LanguagesSection 
          :languages="cvForm.languages"
          @update:languages="cvForm.languages = $event"
        />

        <!-- Hobbies -->
        <HobbiesSection 
          :hobbies="cvForm.hobbies"
          @update:hobbies="cvForm.hobbies = $event"
        />

        <!-- Social Links -->
        <SocialLinksSection 
          :social-links="socialLinks"
          @update:social-links="updateSocialLinks"
        />

        <!-- Settings -->
        <CvSettingsSection 
          :settings="cvSettings"
          @update:settings="updateCvSettings"
        />

        <!-- Form Actions -->
        <div class="flex gap-3 pt-4 border-t border-gray-200">
          <BaseButton type="button" variant="outline" @click="router.back()" class="flex-1">
            {{ $t('common.cancel') }}
          </BaseButton>
          <BaseButton type="submit" variant="primary" :loading="saving" class="flex-1">
            {{ isEditing ? $t('common.update') + ' ' + $t('cv.title') : $t('cv.createCv') }}
          </BaseButton>
        </div>
      </BaseCard>
    </form>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useCvStore } from '@/stores/cv'
import { useAuthStore } from '@/stores/auth'
import { useToast } from '@/composables/useToast'
import type {
  WorkExperience,
  Education,
  Certification,
  Language,
  Reference,
  VolunteerWork
} from '@/types'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import ProfileImageUpload from '@/components/features/cv/ProfileImageUpload.vue'
import PersonalInfoSection from '@/components/features/cv/PersonalInfoSection.vue'
import SkillsSection from '@/components/features/cv/SkillsSection.vue'
import WorkExperienceSection from '@/components/features/cv/WorkExperienceSection.vue'
import EducationSection from '@/components/features/cv/EducationSection.vue'
import CertificationsSection from '@/components/features/cv/CertificationsSection.vue'
import LanguagesSection from '@/components/features/cv/LanguagesSection.vue'
import SocialLinksSection from '@/components/features/cv/SocialLinksSection.vue'
import CvSettingsSection from '@/components/features/cv/CvSettingsSection.vue'
import ReferencesSection from '@/components/features/cv/ReferencesSection.vue'
import VolunteerWorkSection from '@/components/features/cv/VolunteerWorkSection.vue'
import HobbiesSection from '@/components/features/cv/HobbiesSection.vue'

const router = useRouter()
const route = useRoute()
const cvStore = useCvStore()
const authStore = useAuthStore()
const toast = useToast()

const saving = ref(false)
const profileImagePreview = ref<string | null>(null)
const profileImageFile = ref<File | null>(null)
const isEditing = ref(false)
const cvId = ref<number | null>(null)

const cvForm = ref({
  full_name: '',
  email: '',
  phone: '',
  title: '',
  postal_code: '',
  skills: [] as string[],
  website: '',
  linkedin: '',
  github: '',
  city: '',
  country: 'Iraq',
  is_public: true,
  is_primary: false,
  work_experience: [] as WorkExperience[],
  education: [] as Education[],
  certifications: [] as Certification[],
  languages: [] as Language[],
  references: [] as Reference[],
  volunteer_work: [] as VolunteerWork[],
  hobbies: [] as string[],
})

// Computed properties for component props
const personalInfo = computed(() => ({
  full_name: cvForm.value.full_name,
  email: cvForm.value.email,
  phone: cvForm.value.phone,
  title: cvForm.value.title,
  city: cvForm.value.city,
  country: cvForm.value.country,
  postal_code: cvForm.value.postal_code,
}))

const socialLinks = computed(() => ({
  website: cvForm.value.website,
  linkedin: cvForm.value.linkedin,
  github: cvForm.value.github,
}))

const cvSettings = computed(() => ({
  is_public: cvForm.value.is_public,
  is_primary: cvForm.value.is_primary,
}))

// Update functions
const updatePersonalInfo = (info: typeof personalInfo.value) => {
  cvForm.value.full_name = info.full_name
  cvForm.value.email = info.email
  cvForm.value.phone = info.phone
  cvForm.value.title = info.title
  cvForm.value.city = info.city
  cvForm.value.country = info.country
  cvForm.value.postal_code = info.postal_code
}

const updateSocialLinks = (links: typeof socialLinks.value) => {
  cvForm.value.website = links.website
  cvForm.value.linkedin = links.linkedin
  cvForm.value.github = links.github
}

const updateCvSettings = (settings: typeof cvSettings.value) => {
  cvForm.value.is_public = settings.is_public
  cvForm.value.is_primary = settings.is_primary
}



const saveCv = async () => {
  saving.value = true
  try {
    // Convert string skills to Skill objects
    const skillObjects = cvForm.value.skills.map(skill => ({
      name: skill,
      level: undefined,
      category: undefined,
    }))
    
    // Create FormData for file upload
    const formData = new FormData()
    
    // Add basic fields
    formData.append('full_name', cvForm.value.full_name)
    formData.append('email', cvForm.value.email)
    // Always send these fields, even if empty, to allow clearing them
    formData.append('phone', cvForm.value.phone || '')
    formData.append('website', cvForm.value.website || '')
    formData.append('linkedin', cvForm.value.linkedin || '')
    formData.append('github', cvForm.value.github || '')
    formData.append('city', cvForm.value.city || '')
    formData.append('country', cvForm.value.country || '')
    formData.append('postal_code', cvForm.value.postal_code || '')
    formData.append('title', cvForm.value.title || '')
    
    // Add skills as JSON
    formData.append('skills', JSON.stringify(skillObjects))
    
    // Add work experience as JSON
    formData.append('work_experience', JSON.stringify(cvForm.value.work_experience))
    
    // Add education as JSON
    formData.append('education', JSON.stringify(cvForm.value.education))
    
    // Add certifications as JSON
    formData.append('certifications', JSON.stringify(cvForm.value.certifications))
    
    // Add languages as JSON
    formData.append('languages', JSON.stringify(cvForm.value.languages))
    
    // Add references as JSON (always send, even if empty)
    formData.append('references', JSON.stringify(cvForm.value.references))
    
    // Add volunteer work as JSON (always send, even if empty)
    formData.append('volunteer_work', JSON.stringify(cvForm.value.volunteer_work))
    
    // Add hobbies as JSON (always send, even if empty)
    formData.append('hobbies', JSON.stringify(cvForm.value.hobbies))
    
    // Add boolean fields
    formData.append('is_public', cvForm.value.is_public ? '1' : '0')
    formData.append('is_primary', cvForm.value.is_primary ? '1' : '0')
    
    // Add profile image ONLY if a NEW file was selected
    if (profileImageFile.value && profileImageFile.value instanceof File) {
      formData.append('profile_image', profileImageFile.value, profileImageFile.value.name)
    }
    
    if (isEditing.value && cvId.value) {
      // Update existing CV
      await cvStore.updateCvWithFormData(cvId.value, formData)
      toast.success('Your CV has been updated successfully!', 4000)
    } else {
      // Create new CV
      await cvStore.createCvWithFormData(formData)
      toast.success('Your CV has been created successfully!', 4000)
    }
    
    // Navigate back to My CVs page
    await router.push('/my-cvs')
  } catch (error: unknown) {
    const err = error as { 
      response?: { 
        data?: { 
          errors?: Record<string, string[]>
          message?: string 
        }
        status?: number
      }
      message?: string 
    }
    
    // Show validation errors if available
    if (err.response?.data?.errors) {
      const errors = err.response.data.errors
      // Extract just the error messages without technical field names
      const errorMessages = Object.values(errors)
        .flat()
        .filter((msg): msg is string => typeof msg === 'string')
        .join('\n')
      toast.error(errorMessages, 8000)
    } else if (err.response?.data?.message) {
      // Show server error message
      toast.error(err.response.data.message, 6000)
    } else {
      toast.error(err.message || 'Failed to save CV. Please try again.', 5000)
    }
  } finally {
    saving.value = false
  }
}

const loadCvForEditing = async () => {
  const id = route.params.id
  if (id) {
    isEditing.value = true
    cvId.value = Number(id)
    
    try {
      // Find CV from store
      await cvStore.fetchMyCvs()
      const cv = cvStore.myCvs.find(c => c.id === cvId.value)
      
      if (cv) {
        // Convert Skill objects to strings for the simple form
        const skillStrings = cv.skills?.map(s => typeof s === 'string' ? s : s.name) || []
        // Convert hobbies if they exist
        const hobbiesArray = Array.isArray(cv.hobbies) ? cv.hobbies : []
        
        cvForm.value = {
          full_name: cv.full_name,
          email: cv.email,
          phone: cv.phone || '',
          title: cv.title || '',
          postal_code: cv.postal_code || '',
          skills: skillStrings,
          website: cv.website || '',
          linkedin: cv.linkedin || '',
          github: cv.github || '',
          city: cv.city || '',
          country: cv.country || '',
          is_public: cv.is_public,
          is_primary: cv.is_primary,
          work_experience: cv.work_experience || [],
          education: cv.education || [],
          certifications: cv.certifications || [],
          languages: cv.languages || [],
          references: cv.references || [],
          volunteer_work: cv.volunteer_work || [],
          hobbies: hobbiesArray,
        }
        
        // Load profile image if exists
        if (cv.profile_image) {
          profileImagePreview.value = cv.profile_image.path
        }
      }
    } catch (error) {
      console.error('Failed to load CV:', error)
      alert('Failed to load CV for editing')
      router.push('/my-cvs')
    }
  }
}

onMounted(() => {
  // Pre-fill form with user data for new CV
  if (authStore.user && !route.params.id) {
    cvForm.value.full_name = authStore.user.name
    cvForm.value.email = authStore.user.email
  }
  
  // Load CV if editing
  if (route.params.id) {
    loadCvForEditing()
  }
})
</script>
