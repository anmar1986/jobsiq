<template>
  <div>
    <!-- Hero Section -->
    <section id="about" class="bg-gradient-to-br from-primary-600 to-secondary-600 text-white py-20">
      <div class="container-custom text-center">
        <h1 class="text-4xl md:text-5xl font-bold mb-6">{{ $t('about.title') }}</h1>
        <p class="text-xl text-primary-100 max-w-3xl mx-auto">
          {{ $t('about.subtitle') }}
        </p>
      </div>
    </section>

    <!-- Mission & Vision -->
    <section class="py-16 md:py-24">
      <div class="container-custom">
        <div class="grid md:grid-cols-2 gap-12 items-center">
          <div>
            <h2 class="text-3xl md:text-4xl font-bold text-gray-900 mb-6">{{ $t('about.ourMission') }}</h2>
            <p class="text-lg text-gray-600 mb-4">
              {{ $t('about.ourMissionText1') }}
            </p>
            <p class="text-lg text-gray-600">
              {{ $t('about.ourMissionText2') }}
            </p>
          </div>
          
          <div class="relative">
            <div class="aspect-square bg-gradient-to-br from-primary-100 to-secondary-100 rounded-2xl flex items-center justify-center">
              <svg class="h-32 w-32 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
              </svg>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Values -->
    <section class="py-16 md:py-24 bg-gray-50">
      <div class="container-custom">
        <div class="text-center mb-16">
          <h2 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">{{ $t('about.ourValues') }}</h2>
          <p class="text-xl text-gray-600">{{ $t('about.ourValuesSubtitle') }}</p>
        </div>

        <div class="grid md:grid-cols-3 gap-8">
          <BaseCard v-for="value in values" :key="value.titleKey">
            <div class="p-8 text-center">
              <div class="w-16 h-16 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <component :is="value.icon" class="h-8 w-8 text-primary-600" />
              </div>
              <h3 class="text-xl font-semibold text-gray-900 mb-3">{{ $t(value.titleKey) }}</h3>
              <p class="text-gray-600">{{ $t(value.descKey) }}</p>
            </div>
          </BaseCard>
        </div>
      </div>
    </section>

    <!-- Stats -->
    <section class="py-16 md:py-24 hidden">
      <div class="container-custom">
        <div class="text-center mb-16">
          <h2 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">{{ $t('about.ourImpact') }}</h2>
          <p class="text-xl text-gray-600">{{ $t('about.ourImpactSubtitle') }}</p>
        </div>

        <div v-if="loadingStats" class="flex justify-center py-12">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
        </div>

        <div v-else class="grid grid-cols-2 md:grid-cols-4 gap-8">
          <div class="text-center">
            <div class="text-5xl font-bold text-primary-600 mb-2">{{ formatNumber(stats.activeJobs) }}</div>
            <div class="text-gray-600 font-medium">{{ $t('about.activeJobs') }}</div>
          </div>
          <div class="text-center">
            <div class="text-5xl font-bold text-primary-600 mb-2">{{ formatNumber(stats.companies) }}</div>
            <div class="text-gray-600 font-medium">{{ $t('about.companies') }}</div>
          </div>
          <div class="text-center">
            <div class="text-5xl font-bold text-primary-600 mb-2">{{ formatNumber(stats.jobSeekers) }}</div>
            <div class="text-gray-600 font-medium">{{ $t('about.jobSeekers') }}</div>
          </div>
          <div class="text-center">
            <div class="text-5xl font-bold text-primary-600 mb-2">{{ formatNumber(stats.applications) }}</div>
            <div class="text-gray-600 font-medium">{{ $t('about.applications') }}</div>
          </div>
        </div>
      </div>
    </section>

    <!-- Team -->
    <section class="py-16 md:py-24 bg-gray-50">
      <div class="container-custom">
        <div class="text-center mb-16">
          <h2 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">{{ $t('about.ourTeam') }}</h2>
          <p class="text-xl text-gray-600">{{ $t('about.ourTeamSubtitle') }}</p>
        </div>

        <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-8">
          <BaseCard v-for="member in team" :key="member.nameKey">
            <div class="p-6 text-center">
              <BaseAvatar :name="$t(member.nameKey)" size="2xl" class="mx-auto mb-4" />
              <h3 class="text-lg font-semibold text-gray-900 mb-1">{{ $t(member.nameKey) }}</h3>
              <p class="text-primary-600 text-sm font-medium mb-3">{{ $t(member.roleKey) }}</p>
              <p class="text-gray-600 text-sm">{{ $t(member.bioKey) }}</p>
            </div>
          </BaseCard>
        </div>
      </div>
    </section>

    <!-- CTA -->
    <section class="py-16 md:py-24 cta-gradient text-white">
      <div class="container-custom text-center">
        <h2 class="text-3xl md:text-4xl font-bold mb-6">{{ $t('about.joinCommunity') }}</h2>
        <p class="text-xl text-primary-100 mb-8 max-w-2xl mx-auto">
          {{ $t('about.joinCommunityText') }}
        </p>
        <div class="flex flex-col sm:flex-row gap-4 justify-center">
          <router-link 
            to="/register" 
            class="inline-block bg-white text-primary-600 hover:bg-gray-100 px-8 py-3 text-lg font-semibold rounded-lg transition-colors shadow-lg"
          >
            {{ $t('about.getStarted') }}
          </router-link>
          <router-link 
            to="/jobs" 
            class="inline-block border-2 border-white text-white hover:bg-white/10 px-8 py-3 text-lg font-semibold rounded-lg transition-colors"
          >
            {{ $t('about.browseJobs') }}
          </router-link>
        </div>
      </div>
    </section>

    <!-- Contact Us -->
        <!-- Contact Us Section -->
    <section id="contact" class="py-12 md:py-16 lg:py-24 bg-gray-50">
      <div class="container-custom">
        <div class="text-center mb-8 md:mb-12 px-4">
          <h2 class="text-2xl md:text-3xl lg:text-4xl font-bold text-gray-900 mb-3 md:mb-4">{{ $t('about.contactUs') }}</h2>
          <p class="text-base md:text-lg lg:text-xl text-gray-600 max-w-2xl mx-auto">{{ $t('about.contactUsSubtitle') }}</p>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 md:gap-8">
          <!-- Contact Information -->
          <div class="lg:col-span-1 order-2 lg:order-1">
            <BaseCard class="p-6 md:p-8 h-full">
              <h3 class="text-xl md:text-2xl font-bold text-gray-900 mb-4 md:mb-6">{{ $t('about.contactInfo') }}</h3>
              
              <div class="space-y-4 md:space-y-6">
                <!-- Phone -->
                <div class="flex items-start gap-3 md:gap-4">
                  <div class="w-10 h-10 md:w-12 md:h-12 bg-primary-100 rounded-lg flex items-center justify-center flex-shrink-0">
                    <svg class="h-5 w-5 md:h-6 md:w-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                    </svg>
                  </div>
                  <div class="min-w-0 flex-1">
                    <p class="font-semibold text-gray-900 mb-1 text-sm md:text-base">{{ $t('about.phone') }}</p>
                    <a :href="'tel:' + $t('about.phoneNumber')" class="text-gray-600 hover:text-primary-600 transition-colors text-sm md:text-base break-all">
                      {{ $t('about.phoneNumber') }}
                    </a>
                  </div>
                </div>

                <!-- Email -->
                <div class="flex items-start gap-3 md:gap-4">
                  <div class="w-10 h-10 md:w-12 md:h-12 bg-primary-100 rounded-lg flex items-center justify-center flex-shrink-0">
                    <svg class="h-5 w-5 md:h-6 md:w-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                    </svg>
                  </div>
                  <div class="min-w-0 flex-1">
                    <p class="font-semibold text-gray-900 mb-1 text-sm md:text-base">{{ $t('about.email') }}</p>
                    <a :href="'mailto:' + $t('about.supportEmail')" class="text-gray-600 hover:text-primary-600 transition-colors text-sm md:text-base break-all">
                      {{ $t('about.supportEmail') }}
                    </a>
                  </div>
                </div>

                <!-- Address -->
                <div class="flex items-start gap-3 md:gap-4">
                  <div class="w-10 h-10 md:w-12 md:h-12 bg-primary-100 rounded-lg flex items-center justify-center flex-shrink-0">
                    <svg class="h-5 w-5 md:h-6 md:w-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                    </svg>
                  </div>
                  <div class="min-w-0 flex-1">
                    <p class="font-semibold text-gray-900 mb-1 text-sm md:text-base">{{ $t('about.address') }}</p>
                    <p class="text-gray-600 text-sm md:text-base">{{ $t('about.officeAddress') }}</p>
                  </div>
                </div>
              </div>
            </BaseCard>
          </div>

          <!-- Contact Form -->
          <div class="lg:col-span-2 order-1 lg:order-2">
            <BaseCard class="p-6 md:p-8">
              <h3 class="text-xl md:text-2xl font-bold text-gray-900 mb-4 md:mb-6">{{ $t('about.getInTouch') }}</h3>
              
              <form @submit.prevent="handleSubmitContact" class="space-y-4 md:space-y-6">
                <!-- Name -->
                <div>
                  <label for="contact-name" class="block text-sm font-medium text-gray-700 mb-2">
                    {{ $t('about.yourName') }} <span class="text-red-500">*</span>
                  </label>
                  <input
                    id="contact-name"
                    v-model="contactForm.name"
                    type="text"
                    required
                    dir="auto"
                    class="w-full px-3 py-2 md:px-4 md:py-3 text-sm md:text-base border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
                    :placeholder="$t('about.yourName')"
                    @invalid="(e: Event) => (e.target as HTMLInputElement).setCustomValidity($t('validation.fieldRequired'))"
                    @input="(e: Event) => (e.target as HTMLInputElement).setCustomValidity('')"
                  />
                </div>

                <!-- Email -->
                <div>
                  <label for="contact-email" class="block text-sm font-medium text-gray-700 mb-2">
                    {{ $t('about.yourEmail') }} <span class="text-red-500">*</span>
                  </label>
                  <input
                    id="contact-email"
                    v-model="contactForm.email"
                    type="email"
                    required
                    dir="auto"
                    class="w-full px-3 py-2 md:px-4 md:py-3 text-sm md:text-base border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
                    :placeholder="$t('about.yourEmail')"
                    @invalid="(e: Event) => (e.target as HTMLInputElement).setCustomValidity($t('validation.email'))"
                    @input="(e: Event) => (e.target as HTMLInputElement).setCustomValidity('')"
                  />
                </div>

                <!-- Subject -->
                <div>
                  <label for="contact-subject" class="block text-sm font-medium text-gray-700 mb-2">
                    {{ $t('about.subject') }} <span class="text-red-500">*</span>
                  </label>
                  <input
                    id="contact-subject"
                    v-model="contactForm.subject"
                    type="text"
                    required
                    dir="auto"
                    class="w-full px-3 py-2 md:px-4 md:py-3 text-sm md:text-base border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
                    :placeholder="$t('about.subject')"
                    @invalid="(e: Event) => (e.target as HTMLInputElement).setCustomValidity($t('validation.fieldRequired'))"
                    @input="(e: Event) => (e.target as HTMLInputElement).setCustomValidity('')"
                  />
                </div>

                <!-- Message -->
                <div>
                  <label for="contact-message" class="block text-sm font-medium text-gray-700 mb-2">
                    {{ $t('about.message') }} <span class="text-red-500">*</span>
                  </label>
                  <textarea
                    id="contact-message"
                    v-model="contactForm.message"
                    required
                    rows="5"
                    dir="auto"
                    class="w-full px-3 py-2 md:px-4 md:py-3 text-sm md:text-base border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors resize-none"
                    :placeholder="$t('about.message')"
                    @invalid="(e: Event) => (e.target as HTMLTextAreaElement).setCustomValidity($t('validation.fieldRequired'))"
                    @input="(e: Event) => (e.target as HTMLTextAreaElement).setCustomValidity('')"
                  ></textarea>
                </div>

                <!-- Submit Button -->
                <div>
                  <button
                    type="submit"
                    :disabled="submittingContact"
                    class="w-full bg-primary-600 hover:bg-primary-700 disabled:bg-gray-400 text-white font-semibold py-2.5 md:py-3 px-4 md:px-6 text-sm md:text-base rounded-lg transition-colors flex items-center justify-center gap-2"
                  >
                    <svg v-if="submittingContact" class="animate-spin h-4 w-4 md:h-5 md:w-5" fill="none" viewBox="0 0 24 24">
                      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    {{ $t('about.sendMessage') }}
                  </button>
                </div>
              </form>
            </BaseCard>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { h, ref, onMounted } from 'vue'
import { useI18n } from 'vue-i18n'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseAvatar from '@/components/base/BaseAvatar.vue'
import { useToast } from '@/composables/useToast'
import axios from 'axios'

const { t } = useI18n()
const toast = useToast()

const loadingStats = ref(true)
const stats = ref({
  activeJobs: 0,
  companies: 0,
  jobSeekers: 0,
  applications: 0
})

// Contact form state
const contactForm = ref({
  name: '',
  email: '',
  subject: '',
  message: ''
})
const submittingContact = ref(false)

const formatNumber = (num: number): string => {
  if (num >= 1000) {
    return (num / 1000).toFixed(1).replace(/\.0$/, '') + 'K+'
  }
  return num.toString()
}

const fetchStats = async () => {
  try {
    const response = await axios.get('/api/stats')
    if (response.data.success) {
      stats.value = response.data.data
    }
  } catch (error) {
    console.error('Failed to fetch stats:', error)
  } finally {
    loadingStats.value = false
  }
}

const handleSubmitContact = async () => {
  submittingContact.value = true
  
  try {
    const response = await axios.post('/api/contact', contactForm.value)
    
    if (response.data.success) {
      // Success - show toast
      toast.success(t('about.messageSent'))
      
      // Reset form
      contactForm.value = {
        name: '',
        email: '',
        subject: '',
        message: ''
      }
    } else {
      toast.error(response.data.message || t('about.messageError'))
    }
  } catch (error: any) {
    console.error('Failed to send message:', error)
    
    // Check if it's a validation error
    if (error.response?.status === 422 && error.response?.data?.errors) {
      const errors = Object.values(error.response.data.errors).flat()
      toast.error(errors[0] as string || t('about.messageError'))
    } else if (error.response?.data?.message) {
      toast.error(error.response.data.message)
    } else {
      toast.error(t('about.messageError'))
    }
  } finally {
    submittingContact.value = false
  }
}

onMounted(() => {
  fetchStats()
})

const values = [
  {
    titleKey: 'about.transparency',
    descKey: 'about.transparencyDesc',
    icon: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z' })
    ])
  },
  {
    titleKey: 'about.innovation',
    descKey: 'about.innovationDesc',
    icon: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M13 10V3L4 14h7v7l9-11h-7z' })
    ])
  },
  {
    titleKey: 'about.inclusivity',
    descKey: 'about.inclusivityDesc',
    icon: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z' })
    ])
  },
]

const team = [
  {
    nameKey: 'about.teamMember1Name',
    roleKey: 'about.ceoFounder',
    bioKey: 'about.teamMember1Bio',
  },
  {
    nameKey: 'about.teamMember2Name',
    roleKey: 'about.cto',
    bioKey: 'about.teamMember2Bio',
  },
  {
    nameKey: 'about.teamMember3Name',
    roleKey: 'about.headOfDesign',
    bioKey: 'about.teamMember3Bio',
  },
  {
    nameKey: 'about.teamMember4Name',
    roleKey: 'about.headOfGrowth',
    bioKey: 'about.teamMember4Bio',
  },
]
</script>

<style scoped>
/* CTA gradient that works in both LTR and RTL */
.cta-gradient {
  background: linear-gradient(to right, #3b82f6, #a855f7);
}

[dir="rtl"] .cta-gradient {
  background: linear-gradient(to left, #3b82f6, #a855f7);
}
</style>
