<template>
  <div class="container-custom py-8">
    <!-- Header -->
    <div class="mb-8">
      <button @click="router.back()" class="flex items-center gap-2 text-gray-600 hover:text-gray-900 mb-4 transition-colors">
        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
        </svg>
        Back to My CVs
      </button>
      <h1 class="text-3xl font-bold text-gray-900">{{ isEditing ? 'Edit CV' : 'Create New CV' }}</h1>
      <p class="text-gray-600 mt-2">{{ isEditing ? 'Update your CV information' : 'Fill in your details to create your professional CV' }}</p>
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

        <!-- Skills -->
        <SkillsSection 
          :skills="cvForm.skills"
          @update:skills="cvForm.skills = $event"
        />

        <!-- Work Experience -->
        <WorkExperienceSection 
          :work-experience="cvForm.work_experience"
          @update:work-experience="cvForm.work_experience = $event"
        />

        <!-- Education -->
        <EducationSection 
          :education="cvForm.education"
          @update:education="cvForm.education = $event"
        />

        <!-- Certifications -->
        <CertificationsSection 
          :certifications="cvForm.certifications"
          @update:certifications="cvForm.certifications = $event"
        />

        <!-- Languages -->
        <LanguagesSection 
          :languages="cvForm.languages"
          @update:languages="cvForm.languages = $event"
        />

        <!-- Projects -->
        <ProjectsSection 
          :projects="cvForm.projects"
          @update:projects="cvForm.projects = $event"
        />

        <!-- Volunteer Work -->
        <VolunteerWorkSection 
          :volunteer-work="cvForm.volunteer_work"
          @update:volunteer-work="cvForm.volunteer_work = $event"
        />

        <!-- Awards -->
        <AwardsSection 
          :awards="cvForm.awards"
          @update:awards="cvForm.awards = $event"
        />

        <!-- Publications -->
        <PublicationsSection 
          :publications="cvForm.publications"
          @update:publications="cvForm.publications = $event"
        />

        <!-- References -->
        <ReferencesSection 
          :references="cvForm.references"
          @update:references="cvForm.references = $event"
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
            Cancel
          </BaseButton>
          <BaseButton type="submit" variant="primary" :loading="saving" class="flex-1">
            {{ isEditing ? 'Update CV' : 'Create CV' }}
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
  Project,
  Reference,
  Award,
  Publication,
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
import ProjectsSection from '@/components/features/cv/ProjectsSection.vue'
import ReferencesSection from '@/components/features/cv/ReferencesSection.vue'
import AwardsSection from '@/components/features/cv/AwardsSection.vue'
import PublicationsSection from '@/components/features/cv/PublicationsSection.vue'
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
  address: '',
  city: '',
  country: '',
  is_public: true,
  is_primary: false,
  work_experience: [] as WorkExperience[],
  education: [] as Education[],
  certifications: [] as Certification[],
  languages: [] as Language[],
  projects: [] as Project[],
  references: [] as Reference[],
  awards: [] as Award[],
  publications: [] as Publication[],
  volunteer_work: [] as VolunteerWork[],
  hobbies: [] as string[],
})

// Computed properties for component props
const personalInfo = computed(() => ({
  full_name: cvForm.value.full_name,
  email: cvForm.value.email,
  phone: cvForm.value.phone,
  title: cvForm.value.title,
  address: cvForm.value.address,
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
  cvForm.value.address = info.address
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
    console.log('DEBUG: cvForm.value.skills before mapping:', cvForm.value.skills)
    
    // Convert string skills to Skill objects
    const skillObjects = cvForm.value.skills.map(skill => ({
      name: skill,
      level: undefined,
      category: undefined,
    }))
    
    console.log('DEBUG: skillObjects after mapping:', skillObjects)
    console.log('DEBUG: JSON.stringify(skillObjects):', JSON.stringify(skillObjects))
    
    // Sanitize education data - trim GPA to max 10 characters
    const sanitizedEducation = cvForm.value.education.map((edu: Education) => ({
      ...edu,
      gpa: edu.gpa ? edu.gpa.substring(0, 10) : edu.gpa,
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
    formData.append('address', cvForm.value.address || '')
    formData.append('city', cvForm.value.city || '')
    formData.append('country', cvForm.value.country || '')
    formData.append('postal_code', cvForm.value.postal_code || '')
    formData.append('title', cvForm.value.title || '')
    
    // Add skills as JSON
    formData.append('skills', JSON.stringify(skillObjects))
    
    // Add work experience as JSON
    formData.append('work_experience', JSON.stringify(cvForm.value.work_experience))
    
    // Add education as JSON
    formData.append('education', JSON.stringify(sanitizedEducation))
    
    // Add certifications as JSON
    formData.append('certifications', JSON.stringify(cvForm.value.certifications))
    
    // Add languages as JSON
    formData.append('languages', JSON.stringify(cvForm.value.languages))
    
    // Add projects as JSON (always send, even if empty)
    formData.append('projects', JSON.stringify(cvForm.value.projects))
    
    // Add references as JSON (always send, even if empty)
    formData.append('references', JSON.stringify(cvForm.value.references))
    
    // Add awards as JSON (always send, even if empty)
    formData.append('awards', JSON.stringify(cvForm.value.awards))
    
    // Add publications as JSON (always send, even if empty)
    formData.append('publications', JSON.stringify(cvForm.value.publications))
    
    // Add volunteer work as JSON (always send, even if empty)
    formData.append('volunteer_work', JSON.stringify(cvForm.value.volunteer_work))
    
    // Add hobbies as JSON (always send, even if empty)
    formData.append('hobbies', JSON.stringify(cvForm.value.hobbies))
    
    // Add boolean fields
    formData.append('is_public', cvForm.value.is_public ? '1' : '0')
    formData.append('is_primary', cvForm.value.is_primary ? '1' : '0')
    
    // Add profile image ONLY if a NEW file was selected
    if (profileImageFile.value && profileImageFile.value instanceof File) {
      console.log('Appending profile image to FormData:', {
        name: profileImageFile.value.name,
        size: profileImageFile.value.size,
        type: profileImageFile.value.type,
        isFile: profileImageFile.value instanceof File
      })
      formData.append('profile_image', profileImageFile.value, profileImageFile.value.name)
    } else {
      console.log('No new profile image selected, skipping')
    }
    
    // Log FormData contents (for debugging)
    console.log('FormData entries:')
    for (const [key, value] of formData.entries()) {
      if (value instanceof File) {
        console.log(`${key}:`, `File(${value.name}, ${value.size} bytes, ${value.type})`)
      } else {
        console.log(`${key}:`, value)
      }
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
    console.error('Failed to save CV:', error)
    
    const err = error as { response?: { data?: { errors?: Record<string, string[]>; message?: string } }; message?: string }
    console.error('Error response:', err.response)
    console.error('Error data:', err.response?.data)
    console.error('Validation errors:', err.response?.data?.errors)
    
    // Show validation errors if available
    if (err.response?.data?.errors) {
      const errors = err.response.data.errors
      const errorMessages = Object.entries(errors)
        .map(([field, messages]) => `${field}: ${Array.isArray(messages) ? messages.join(', ') : messages}`)
        .join('\n')
      toast.error(`Validation failed:\n${errorMessages}`)
    } else {
      toast.error(err.response?.data?.message || err.message || 'Failed to save CV. Please try again.')
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
          address: cv.address || '',
          city: cv.city || '',
          country: cv.country || '',
          is_public: cv.is_public,
          is_primary: cv.is_primary,
          work_experience: cv.work_experience || [],
          education: cv.education || [],
          certifications: cv.certifications || [],
          languages: cv.languages || [],
          projects: cv.projects || [],
          references: cv.references || [],
          awards: cv.awards || [],
          publications: cv.publications || [],
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
