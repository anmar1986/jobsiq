<template>
  <footer class="bg-gray-900 text-gray-300">
    <div class="container-custom py-8 sm:py-12">
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 sm:gap-8">
        <!-- Brand -->
        <div class="space-y-3 sm:space-y-4">
          <div class="flex items-center gap-2">
            <div class="h-8 w-8 sm:h-10 sm:w-10 bg-gradient-to-br from-primary-600 to-secondary-600 rounded-lg flex items-center justify-center">
              <span class="text-white font-bold text-lg sm:text-xl">J</span>
            </div>
            <span class="text-xl sm:text-2xl font-bold text-white">{{ $t('common.appName') }}</span>
          </div>
          <p class="text-xs sm:text-sm text-gray-400">
            {{ $t('home.heroSubtitle') }}
          </p>
          <div class="flex gap-3 sm:gap-4">
            <a href="#" class="text-[#1877F2] hover:opacity-80 transition-opacity" :aria-label="$t('companies.facebook')">
              <svg class="h-5 w-5 sm:h-6 sm:w-6" fill="currentColor" viewBox="0 0 24 24">
                <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z" />
              </svg>
            </a>
            <a href="#" class="text-[#000000] hover:opacity-80 transition-opacity" :aria-label="$t('companies.twitter')">
              <svg class="h-5 w-5 sm:h-6 sm:w-6" fill="currentColor" viewBox="0 0 24 24">
                <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
              </svg>
            </a>
            <a href="#" class="text-[#E4405F] hover:opacity-80 transition-opacity" :aria-label="$t('companies.instagram')">
              <svg class="h-5 w-5 sm:h-6 sm:w-6" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z" />
              </svg>
            </a>
            <a href="#" class="text-[#0A66C2] hover:opacity-80 transition-opacity" :aria-label="$t('companies.linkedin')">
              <svg class="h-5 w-5 sm:h-6 sm:w-6" fill="currentColor" viewBox="0 0 24 24">
                <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z" />
              </svg>
            </a>
            <a href="#" class="text-[#FF0000] hover:opacity-80 transition-opacity" :aria-label="$t('companies.youtube')">
              <svg class="h-5 w-5 sm:h-6 sm:w-6" fill="currentColor" viewBox="0 0 24 24">
                <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z" />
              </svg>
            </a>
            <a href="#" class="text-[#FFFC00] hover:opacity-80 transition-opacity" :aria-label="$t('companies.snapchat')">
              <svg class="h-5 w-5 sm:h-6 sm:w-6" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12.206.793c.99 0 4.347.276 5.93 3.821.529 1.193.403 3.219.299 4.847l-.003.06c-.012.18-.022.345-.03.51.075.045.203.09.401.09.3 0 .73-.057 1.126-.12.57-.084 1.185-.179 1.757-.179.3 0 .582.04.84.12.42.15.81.42 1.023.84.195.39.225.84.09 1.289-.12.45-.36.87-.645 1.17-.27.285-.645.54-1.065.705l-.084.045c-.3.165-.704.42-.78.885-.03.135-.015.27.045.404.09.21.21.405.345.585.195.27.42.54.645.81.51.585 1.065 1.185 1.47 1.83.225.36.42.72.57 1.095.09.24.15.495.18.75.015.195 0 .375-.045.555-.075.27-.24.54-.495.705-.3.195-.659.285-1.065.285l-.075-.015c-.705-.075-1.38-.24-2.04-.42-.585-.165-1.17-.3-1.77-.42-.15-.03-.296-.045-.444-.045-.555 0-1.05.195-1.53.42-.45.195-.945.405-1.485.57-.9.3-1.725.345-2.385.345-.405 0-.78-.045-1.095-.09-.75-.15-1.485-.42-2.22-.705-.585-.225-1.17-.48-1.77-.705-.42-.15-.885-.225-1.335-.225-.3 0-.585.03-.87.09-.555.12-1.095.27-1.65.42-.705.195-1.38.42-2.085.57-.705.15-1.38.225-2.01.195-.45-.015-.885-.135-1.26-.375-.3-.195-.495-.495-.585-.84-.075-.3-.075-.615 0-.915.09-.375.27-.735.495-1.065.42-.645.96-1.23 1.485-1.815.24-.27.465-.54.675-.81.12-.165.225-.345.3-.54.09-.195.12-.405.075-.615-.045-.435-.375-.705-.69-.87l-.096-.06c-.42-.165-.795-.42-1.065-.705-.285-.3-.525-.72-.645-1.17-.135-.45-.105-.9.09-1.29.21-.42.6-.69 1.02-.84.259-.08.541-.12.84-.12.573 0 1.185.09 1.757.18.39.06.825.12 1.124.12.195 0 .315-.045.375-.075-.015-.165-.03-.345-.045-.54l-.015-.09c-.105-1.59-.21-3.615.285-4.806C7.86 1.068 11.19.792 12.206.792zm0 0" />
              </svg>
            </a>
          </div>
        </div>

        <!-- For Job Seekers -->
        <div>
          <h3 class="text-white font-semibold mb-3 sm:mb-4 text-sm sm:text-base">{{ $t('nav.jobs') }}</h3>
          <ul class="space-y-1.5 sm:space-y-2">
            <li><router-link to="/jobs" class="text-xs sm:text-sm hover:text-primary-500 transition-colors">{{ $t('home.browseJobsButton') }}</router-link></li>
            <li><router-link to="/companies" class="text-xs sm:text-sm hover:text-primary-500 transition-colors">{{ $t('nav.companies') }}</router-link></li>
            <li><router-link to="/my-cvs" class="text-xs sm:text-sm hover:text-primary-500 transition-colors">{{ $t('cv.createCv') }}</router-link></li>
            <li><router-link to="/register" class="text-xs sm:text-sm hover:text-primary-500 transition-colors">{{ $t('auth.register') }}</router-link></li>
          </ul>
        </div>

        <!-- For Employers -->
        <div>
          <h3 class="text-white font-semibold mb-3 sm:mb-4 text-sm sm:text-base">{{ $t('dashboard.myCompanies') }}</h3>
          <ul class="space-y-1.5 sm:space-y-2">
            <li><router-link to="/my-companies" class="text-xs sm:text-sm hover:text-primary-500 transition-colors">{{ $t('dashboard.myCompanies') }}</router-link></li>
            <li><router-link to="/my-companies" class="text-xs sm:text-sm hover:text-primary-500 transition-colors">{{ $t('nav.postJob') }}</router-link></li>
            <li><a href="#" class="text-xs sm:text-sm hover:text-primary-500 transition-colors">{{ $t('home.companyCtaSubtitle') }}</a></li>
          </ul>
        </div>

        <!-- Company -->
        <div>
          <h3 class="text-white font-semibold mb-3 sm:mb-4 text-sm sm:text-base">{{ $t('common.about') }}</h3>
          <ul class="space-y-1.5 sm:space-y-2">
            <li><router-link to="/about" class="text-xs sm:text-sm hover:text-primary-500 transition-colors">{{ $t('footer.aboutUs') }}</router-link></li>
            <li><a href="#" class="text-xs sm:text-sm hover:text-primary-500 transition-colors">{{ $t('footer.contactUs') }}</a></li>
            <li><a href="#" class="text-xs sm:text-sm hover:text-primary-500 transition-colors">{{ $t('footer.privacyPolicy') }}</a></li>
            <li><a href="#" class="text-xs sm:text-sm hover:text-primary-500 transition-colors">{{ $t('footer.termsOfService') }}</a></li>
          </ul>
        </div>
      </div>

      <div class="border-t border-gray-800 mt-8 sm:mt-12 pt-6 sm:pt-8 text-center text-xs sm:text-sm text-gray-400">
        <p>{{ $t('footer.copyright', { year: currentYear }) }}</p>
      </div>
    </div>
  </footer>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const currentYear = computed(() => new Date().getFullYear())
</script>

