<template>
  <div class="bg-gray-50 min-h-screen">
    <!-- Loading State -->
    <div v-if="loading" class="container-custom py-8">
      <div class="animate-pulse space-y-8">
        <div class="h-32 bg-gray-200 rounded-lg"></div>
        <div class="bg-white rounded-lg p-8">
          <div class="h-6 bg-gray-200 rounded w-1/2 mb-4"></div>
          <div class="space-y-2">
            <div class="h-4 bg-gray-200 rounded w-full"></div>
            <div class="h-4 bg-gray-200 rounded w-5/6"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Company Not Found -->
    <div v-else-if="!company" class="container-custom py-16">
      <BaseCard class="p-12 text-center">
        <svg class="h-16 w-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
        </svg>
        <h2 class="text-2xl font-bold text-gray-900 mb-2">{{ $t('companies.companyNotFound') }}</h2>
        <p class="text-gray-600 mb-6">{{ $t('companies.companyNotFoundMessage') }}</p>
        <BaseButton variant="primary" @click="router.push('/companies')">{{ $t('companies.browseAllCompanies') }}</BaseButton>
      </BaseCard>
    </div>

    <!-- Company Detail Content -->
    <div v-else>
      <!-- Cover Image Hero Section -->
      <div class="relative">
        <!-- Cover Image -->
        <div class="h-96 bg-gradient-to-br from-primary-600 to-secondary-600 relative overflow-hidden">
          <img 
            v-if="company.cover?.path" 
            :src="getLogoUrl(company.cover.path)" 
            :alt="company.name || 'Company cover'"
            class="w-full h-full object-contain"
          />
          <!-- Gradient Overlay -->
          <div class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent"></div>
          
          <!-- Back Button -->
          <button 
            @click="router.back()" 
            class="absolute top-6 left-6 flex items-center gap-2 text-white/90 hover:text-white bg-black/30 hover:bg-black/50 px-4 py-2 rounded-lg backdrop-blur-sm transition-all"
          >
            <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
            {{ $t('companies.browseAllCompanies') }}
          </button>
        </div>

        <!-- Company Logo - Centered and Overlapping -->
        <div class="container-custom relative">
          <div class="absolute left-1/2 -translate-x-1/2 -translate-y-1/2">
            <div class="w-40 h-40 rounded-2xl bg-white shadow-2xl flex items-center justify-center overflow-hidden border-4 border-white">
              <img 
                v-if="company.logo?.path" 
                :src="getLogoUrl(company.logo.path)" 
                :alt="company.name"
                class="w-full h-full object-contain p-2"
              />
              <span v-else class="text-5xl font-bold text-primary-600">{{ company.name.charAt(0) }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Company Info Section -->
      <div class="bg-white border-b border-gray-200">
        <div class="container-custom pt-24 pb-8">
          <div class="text-center mb-8">
            <h1 class="text-4xl md:text-5xl font-bold text-gray-900 mb-3">{{ company.name }}</h1>
            <p v-if="company.tagline" class="text-xl text-gray-600 mb-4">{{ company.tagline }}</p>
            
            <div class="flex flex-wrap items-center justify-center gap-4 text-gray-600 mb-6">
              <span v-if="company.city" class="flex items-center gap-1.5">
                <svg class="h-5 w-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                </svg>
                {{ company.city }}, {{ company.country }}
              </span>
              <span v-if="company.industry" class="text-gray-300">•</span>
              <span v-if="company.industry" class="flex items-center gap-1.5">
                <svg class="h-5 w-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
                </svg>
                {{ company.industry }}
              </span>
              <span v-if="company.company_size" class="text-gray-300">•</span>
              <span v-if="company.company_size" class="flex items-center gap-1.5">
                <svg class="h-5 w-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                </svg>
                {{ company.company_size }} {{ $t('companies.employees') }}
              </span>
              <span v-if="company.website" class="text-gray-300">•</span>
              <span v-if="company.website" class="flex items-center gap-1.5">
                <svg class="h-5 w-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9" />
                </svg>
                <a :href="company.website" target="_blank" class="text-primary-600 hover:text-primary-700 hover:underline">
                  {{ formatWebsite(company.website) }}
                </a>
              </span>
            </div>

            <p v-if="company.about" class="text-lg text-gray-700 leading-relaxed max-w-4xl mx-auto">
              {{ company.about }}
            </p>
          </div>
        </div>
      </div>

      <!-- Stats Bar -->
      <div class="ltr:bg-gradient-to-r rtl:bg-gradient-to-l from-primary-600 to-secondary-600 border-b border-primary-700 shadow-sm">
        <div class="container-custom">
          <div class="grid grid-cols-2 md:grid-cols-4 gap-4 py-6">
            <div class="text-center">
              <p class="text-3xl font-bold text-white">{{ company.jobs_count || 0 }}</p>
              <p class="text-sm text-primary-100 mt-1">{{ $t('companies.openPositions') }}</p>
            </div>
            <div v-if="company.founded_date" class="text-center">
              <p class="text-3xl font-bold text-white">{{ formatFoundedDate(company.founded_date) }}</p>
              <p class="text-sm text-primary-100 mt-1">{{ $t('companies.founded') }}</p>
            </div>
            <div v-else class="text-center">
              <p class="text-3xl font-bold text-white">{{ formatDate(company.created_at) }}</p>
              <p class="text-sm text-primary-100 mt-1">{{ $t('companies.memberSince') }}</p>
            </div>
            <div v-if="company.city" class="text-center">
              <p class="text-3xl font-bold text-white">1</p>
              <p class="text-sm text-primary-100 mt-1">{{ $t('companies.location') }}</p>
            </div>
            <div class="text-center">
              <div class="flex items-center justify-center gap-2">
                <span 
                  class="inline-block w-3 h-3 rounded-full" 
                  :class="company.is_active ? 'bg-green-400' : 'bg-red-400'"
                ></span>
                <p class="text-3xl font-bold text-white">{{ company.is_active ? $t('companies.active') : $t('companies.inactive') }}</p>
              </div>
              <p class="text-sm text-primary-100 mt-1">{{ $t('common.status') }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Main Content -->
      <div class="container-custom py-8">
        <!-- Company Details Container -->
        <BaseCard class="p-8 mb-8">
          <div class="flex flex-col lg:flex-row gap-8">
            <!-- Left Sidebar - Social Media Links -->
            <div class="lg:w-64 flex-shrink-0">
              <div v-if="company.linkedin || company.twitter || company.facebook || company.instagram || company.youtube">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">{{ $t('companies.followUs') }}</h3>
                <div class="flex flex-col gap-3 items-start">
                  <a
                    v-if="company.linkedin" :href="company.linkedin" target="_blank" rel="noopener noreferrer" 
                    class="flex items-center gap-2 px-3 py-2 bg-blue-700 hover:bg-blue-800 text-white rounded-lg transition-colors text-sm w-full"
                  >
                    <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z" />
                    </svg>
                    {{ $t('companies.linkedin') }}
                  </a>

                  <a
                    v-if="company.facebook" :href="company.facebook" target="_blank" rel="noopener noreferrer"
                    class="flex items-center gap-2 px-3 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors text-sm w-full"
                  >
                    <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z" />
                    </svg>
                    {{ $t('companies.facebook') }}
                  </a>

                  <a
                    v-if="company.instagram" :href="company.instagram" target="_blank" rel="noopener noreferrer"
                    class="flex items-center gap-2 px-3 py-2 bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-700 hover:to-pink-700 text-white rounded-lg transition-colors text-sm w-full"
                  >
                    <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z" />
                    </svg>
                    {{ $t('companies.instagram') }}
                  </a>

                  <a
                    v-if="company.youtube" :href="company.youtube" target="_blank" rel="noopener noreferrer"
                    class="flex items-center gap-2 px-3 py-2 bg-red-600 hover:bg-red-700 text-white rounded-lg transition-colors text-sm w-full"
                  >
                    <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z" />
                    </svg>
                    {{ $t('companies.youtube') }}
                  </a>

                  <a
                    v-if="company.twitter" :href="company.twitter" target="_blank" rel="noopener noreferrer"
                    class="flex items-center gap-2 px-3 py-2 bg-black hover:bg-gray-900 text-white rounded-lg transition-colors text-sm w-full"
                  >
                    <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
                    </svg>
                    {{ $t('companies.twitter') }}
                  </a>
                </div>
              </div>
            </div>

            <!-- Center - Company Information -->
            <div class="flex-1">
              <h2 class="text-2xl font-bold text-gray-900 mb-6 text-center">{{ $t('companies.companyDetails') }}</h2>
              
              <!-- About -->
              <div v-if="company.about" class="mb-12">
                <h3 class="text-lg font-semibold text-gray-900 mb-3 text-center">{{ $t('companies.about') }}</h3>
                <p class="text-gray-700 leading-relaxed text-center">
                  {{ company.about }}
                </p>
              </div>

              <!-- Description -->
              <div v-if="company.description" class="mb-12">
                <h3 class="text-lg font-semibold text-gray-900 mb-3 text-center">{{ $t('companies.description') }}</h3>
                <p class="text-gray-700 leading-relaxed text-center">
                  {{ company.description }}
                </p>
              </div>
            </div>

            <!-- Right Sidebar - Contact Information -->
            <div class="lg:w-80 flex-shrink-0">
              <h3 class="text-lg font-semibold text-gray-900 mb-4">{{ $t('companies.contactInfo') }}</h3>
              <div class="space-y-4">
                <div v-if="company.email" class="flex items-start gap-3">
                  <svg class="h-5 w-5 text-gray-400 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                  </svg>
                  <div class="flex-1 min-w-0">
                    <p class="text-sm text-gray-600 mb-1">{{ $t('companies.email') }}</p>
                    <a :href="`mailto:${company.email}`" class="text-sm text-primary-600 hover:text-primary-700 break-all">
                      {{ company.email }}
                    </a>
                  </div>
                </div>

                <div v-if="company.phone" class="flex items-start gap-3">
                  <svg class="h-5 w-5 text-gray-400 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                  </svg>
                  <div class="flex-1 min-w-0">
                    <p class="text-sm text-gray-600 mb-1">{{ $t('companies.phone') }}</p>
                    <a :href="`tel:${company.phone}`" class="text-sm text-primary-600 hover:text-primary-700">
                      {{ company.phone }}
                    </a>
                  </div>
                </div>

                <div v-if="company.website" class="flex items-start gap-3">
                  <svg class="h-5 w-5 text-gray-400 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9" />
                  </svg>
                  <div class="flex-1 min-w-0">
                    <p class="text-sm text-gray-600 mb-1">{{ $t('companies.website') }}</p>
                    <a :href="company.website" target="_blank" class="text-sm text-primary-600 hover:text-primary-700 break-all">
                      {{ formatWebsite(company.website) }}
                    </a>
                  </div>
                </div>

                <div v-if="company.street || company.city" class="flex items-start gap-3">
                  <svg class="h-5 w-5 text-gray-400 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                  </svg>
                  <div class="flex-1 min-w-0">
                    <p class="text-sm text-gray-600 mb-1">{{ $t('companies.address') }}</p>
                    <p class="text-sm text-gray-900">
                      <span v-if="company.street">{{ company.street }}<br /></span>
                      <span v-if="company.city">{{ company.city }}</span>
                      <span v-if="company.country">, {{ company.country }}</span>
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </BaseCard>
      </div>

      <!-- Company Photos Gallery - Full Width -->
      <div v-if="company.images && company.images.filter(img => img.type === 'gallery').length > 0" class="mb-8">
        <div class="container-custom mb-4 px-4 sm:px-6 lg:px-8">
          <h2 class="text-xl sm:text-2xl font-bold text-gray-900 text-center">{{ $t('companies.companyPhotos') }}</h2>
        </div>
        
        <!-- Horizontal carousel with navigation arrows -->
        <div class="relative group">
          <!-- Left Arrow -->
          <button
            v-if="galleryImages.length > 1"
            @click="scrollGalleryLeft"
            class="absolute left-2 sm:left-4 top-1/2 -translate-y-1/2 z-10 bg-white/90 hover:bg-white text-gray-800 rounded-full p-2 sm:p-3 shadow-lg transition-all hover:scale-110 opacity-0 group-hover:opacity-100"
          >
            <svg class="h-5 w-5 sm:h-6 sm:w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
          </button>

          <!-- Gallery Container -->
          <div 
            ref="galleryContainer"
            class="flex gap-3 sm:gap-6 overflow-x-auto scrollbar-hide px-3 sm:px-4 py-2"
            style="scrollbar-width: none; -ms-overflow-style: none; cursor: grab; user-select: none; scroll-behavior: auto;"
            :style="{ height: isMobile ? '220px' : '370px' }"
            @mousedown="handleMouseDown"
            @mousemove="handleMouseMove"
            @mouseup="handleMouseUp"
            @mouseleave="handleMouseLeave"
            @touchstart="handleTouchStart"
            @touchmove="handleTouchMove"
            @touchend="handleTouchEnd"
          >
            <!-- Duplicate images at start for infinite loop -->
            <div
              v-for="(image, index) in galleryImages"
              :key="`clone-start-${index}`"
              class="relative flex-shrink-0 overflow-hidden rounded-lg sm:rounded-xl cursor-pointer group/item shadow-lg hover:shadow-2xl transition-all duration-300"
              :style="{ height: isMobile ? '200px' : '350px', width: 'auto' }"
              @click="openLightbox(index)"
            >
              <img
                :src="getLogoUrl(image.path)"
                :alt="`Company photo ${index + 1}`"
                class="h-full w-auto object-contain transition-transform duration-300 group-hover/item:scale-105"
                style="display: block;"
              />
              <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent opacity-0 group-hover/item:opacity-100 transition-opacity duration-300">
                <div class="absolute inset-0 flex items-center justify-center">
                  <div class="bg-white/20 backdrop-blur-sm rounded-full p-2 sm:p-3">
                    <svg class="h-6 w-6 sm:h-8 sm:w-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM10 7v3m0 0v3m0-3h3m-3 0H7" />
                    </svg>
                  </div>
                </div>
              </div>
              <div class="absolute top-2 right-2 sm:top-3 sm:right-3 bg-black/60 backdrop-blur-sm text-white text-xs px-2 sm:px-2.5 py-1 rounded-full font-medium">
                {{ index + 1 }} / {{ galleryImages.length }}
              </div>
            </div>

            <!-- Original images -->
            <div
              v-for="(image, index) in galleryImages"
              :key="`original-${index}`"
              class="relative flex-shrink-0 overflow-hidden rounded-lg sm:rounded-xl cursor-pointer group/item shadow-lg hover:shadow-2xl transition-all duration-300"
              :style="{ height: isMobile ? '200px' : '350px', width: 'auto' }"
              @click="openLightbox(index)"
            >
              <img
                :src="getLogoUrl(image.path)"
                :alt="`Company photo ${index + 1}`"
                class="h-full w-auto object-contain transition-transform duration-300 group-hover/item:scale-105"
                style="display: block;"
              />
              <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent opacity-0 group-hover/item:opacity-100 transition-opacity duration-300">
                <div class="absolute inset-0 flex items-center justify-center">
                  <div class="bg-white/20 backdrop-blur-sm rounded-full p-2 sm:p-3">
                    <svg class="h-6 w-6 sm:h-8 sm:w-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM10 7v3m0 0v3m0-3h3m-3 0H7" />
                    </svg>
                  </div>
                </div>
              </div>
              <div class="absolute top-2 right-2 sm:top-3 sm:right-3 bg-black/60 backdrop-blur-sm text-white text-xs px-2 sm:px-2.5 py-1 rounded-full font-medium">
                {{ index + 1 }} / {{ galleryImages.length }}
              </div>
            </div>

            <!-- Duplicate images at end for infinite loop -->
            <div
              v-for="(image, index) in galleryImages"
              :key="`clone-end-${index}`"
              class="relative flex-shrink-0 overflow-hidden rounded-lg sm:rounded-xl cursor-pointer group/item shadow-lg hover:shadow-2xl transition-all duration-300"
              :style="{ height: isMobile ? '200px' : '350px', width: 'auto' }"
              @click="openLightbox(index)"
            >
              <img
                :src="getLogoUrl(image.path)"
                :alt="`Company photo ${index + 1}`"
                class="h-full w-auto object-contain transition-transform duration-300 group-hover/item:scale-105"
                style="display: block;"
              />
              <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent opacity-0 group-hover/item:opacity-100 transition-opacity duration-300">
                <div class="absolute inset-0 flex items-center justify-center">
                  <div class="bg-white/20 backdrop-blur-sm rounded-full p-3">
                    <svg class="h-8 w-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM10 7v3m0 0v3m0-3h3m-3 0H7" />
                    </svg>
                  </div>
                </div>
              </div>
              <!-- Image counter badge -->
              <div class="absolute top-3 right-3 bg-black/60 backdrop-blur-sm text-white text-xs px-2.5 py-1 rounded-full font-medium">
                {{ index + 1 }} / {{ galleryImages.length }}
              </div>
            </div>
          </div>

          <!-- Right Arrow -->
          <button
            v-if="galleryImages.length > 1"
            @click="scrollGalleryRight"
            class="absolute right-2 sm:right-4 top-1/2 -translate-y-1/2 z-10 bg-white/90 hover:bg-white text-gray-800 rounded-full p-2 sm:p-3 shadow-lg transition-all hover:scale-110 opacity-0 group-hover:opacity-100"
          >
            <svg class="h-5 w-5 sm:h-6 sm:w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </button>
        </div>
      </div>

      <!-- Jobs Section Container -->
      <div class="container-custom py-8">
        <!-- Jobs Section -->
        <div>
          <div class="flex flex-col items-center justify-center mb-6 gap-3">
            <h2 class="text-xl sm:text-2xl font-bold text-gray-900 text-center">
              {{ $t('companies.openPositions') }} ({{ jobs.length }})
            </h2>
            <BaseButton 
              v-if="jobs.length > 10" 
              variant="outline" 
              @click="viewAllJobs"
            >
              {{ $t('companies.viewAllJobs') }}
            </BaseButton>
          </div>

          <!-- Jobs Loading -->
          <div v-if="loadingJobs" class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            <BaseCard v-for="i in 3" :key="i" class="p-6 animate-pulse">
              <div class="h-5 bg-gray-200 rounded w-3/4 mb-3"></div>
              <div class="h-4 bg-gray-200 rounded w-1/2 mb-4"></div>
              <div class="h-4 bg-gray-200 rounded w-full"></div>
            </BaseCard>
          </div>

          <!-- Jobs Cards Grid -->
          <div v-else-if="jobs.length > 0" class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            <BaseCard
              v-for="job in jobs"
              :key="job.id"
              hoverable
              clickable
              class="p-6 group"
              @click="navigateToJob(job.slug)"
            >
              <!-- Job Header -->
              <div class="mb-4">
                <h3 class="text-lg font-semibold text-gray-900 mb-2 line-clamp-2 group-hover:text-primary-600 transition-colors">
                  {{ job.title }}
                </h3>
                <div class="flex items-center gap-2 text-sm text-gray-600">
                  <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                  </svg>
                  <span>{{ job.location }}</span>
                </div>
              </div>

              <!-- Job Details -->
              <div class="space-y-2 mb-4">
                <div class="flex items-center gap-2 text-sm text-gray-600">
                  <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                  </svg>
                  <span>{{ formatEmploymentType(job.employment_type) }}</span>
                </div>
                
                <div class="flex items-center gap-2 text-sm text-gray-600">
                  <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  <span>Posted {{ formatJobDate(job.created_at) }}</span>
                </div>

                <div v-if="job.salary_min && job.salary_max" class="flex items-center gap-2 text-sm font-semibold text-primary-600">
                  <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  <span>{{ formatSalaryRange(job.salary_min, job.salary_max, job.salary_currency, job.salary_period) }}</span>
                </div>
              </div>

              <!-- Badges -->
              <div class="flex flex-wrap gap-2">
                <BaseBadge :variant="getBadgeVariant(job.experience_level)">
                  {{ formatExperienceLevel(job.experience_level) }}
                </BaseBadge>
                <BaseBadge v-if="job.is_remote" variant="success">{{ $t('companies.remote') }}</BaseBadge>
                <BaseBadge v-if="job.category" variant="info">{{ job.category }}</BaseBadge>
              </div>
            </BaseCard>
          </div>

          <!-- No Jobs -->
          <BaseCard v-else class="p-12 text-center">
            <svg class="h-16 w-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
            </svg>
            <h3 class="text-xl font-semibold text-gray-900 mb-2">{{ $t('companies.noOpenPositions') }}</h3>
            <p class="text-gray-600">{{ $t('companies.thisCompanyHasNoActiveJobs') }}</p>
          </BaseCard>
        </div>
      </div>
    </div>
    <!-- End of Company Detail Content (v-else) -->

    <!-- Lightbox Modal -->
    <Teleport to="body">
      <Transition name="fade">
        <div
          v-if="showLightbox"
          class="fixed inset-0 z-50 flex items-center justify-center bg-black/95"
          @click="closeLightbox"
        >
          <!-- Close Button -->
          <button
            class="absolute top-4 right-4 text-white hover:text-gray-300 transition-colors z-10"
            @click="closeLightbox"
          >
            <svg class="h-10 w-10" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>

          <!-- Image Counter -->
          <div class="absolute top-4 left-1/2 -translate-x-1/2 bg-black/60 text-white px-4 py-2 rounded-full text-sm z-10">
            {{ lightboxIndex + 1 }} / {{ galleryImages.length }}
          </div>

          <!-- Previous Button -->
          <button
            v-if="galleryImages.length > 1"
            class="absolute left-4 top-1/2 -translate-y-1/2 text-white hover:text-gray-300 transition-colors z-10"
            @click.stop="previousLightboxImage"
          >
            <svg class="h-12 w-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
          </button>

          <!-- Image -->
          <div class="max-w-7xl max-h-[90vh] mx-4" @click.stop>
            <img
              :src="getLogoUrl(galleryImages[lightboxIndex]?.path)"
              :alt="`Company photo ${lightboxIndex + 1}`"
              class="max-w-full max-h-[90vh] w-auto h-auto object-contain"
            />
          </div>

          <!-- Next Button -->
          <button
            v-if="galleryImages.length > 1"
            class="absolute right-4 top-1/2 -translate-y-1/2 text-white hover:text-gray-300 transition-colors z-10"
            @click.stop="nextLightboxImage"
          >
            <svg class="h-12 w-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </button>
        </div>
      </Transition>
    </Teleport>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount, computed, nextTick } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useCompanyStore } from '@/stores/company'
import { useJobStore } from '@/stores/job'
import { formatSalaryRange } from '@/utils/currency'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseBadge from '@/components/base/BaseBadge.vue'
import type { Company, Job } from '@/types'

const router = useRouter()
const route = useRoute()
const companyStore = useCompanyStore()
const jobStore = useJobStore()

const loading = ref(true)
const loadingJobs = ref(true)
const company = ref<Company | null>(null)
const jobs = ref<Job[]>([])

// Mobile detection
const isMobile = ref(window.innerWidth < 640)

// Gallery carousel ref
const galleryContainer = ref<HTMLElement | null>(null)
let scrollHandler: ((e: Event) => void) | null = null

// Mouse drag handling
const isDragging = ref(false)
const startX = ref(0)
const scrollLeft = ref(0)

const handleMouseDown = (e: MouseEvent) => {
  if (!galleryContainer.value) return
  isDragging.value = true
  startX.value = e.pageX - galleryContainer.value.offsetLeft
  scrollLeft.value = galleryContainer.value.scrollLeft
  galleryContainer.value.style.cursor = 'grabbing'
}

const handleMouseMove = (e: MouseEvent) => {
  if (!isDragging.value || !galleryContainer.value) return
  e.preventDefault()
  const x = e.pageX - galleryContainer.value.offsetLeft
  const walk = (x - startX.value) * 2 // Scroll speed multiplier
  galleryContainer.value.scrollLeft = scrollLeft.value - walk
}

const handleMouseUp = () => {
  isDragging.value = false
  if (galleryContainer.value) {
    galleryContainer.value.style.cursor = 'grab'
  }
}

const handleMouseLeave = () => {
  if (isDragging.value) {
    isDragging.value = false
    if (galleryContainer.value) {
      galleryContainer.value.style.cursor = 'grab'
    }
  }
}

// Touch handling for swipe
const touchStartX = ref(0)
const touchEndX = ref(0)

const handleTouchStart = (e: TouchEvent) => {
  touchStartX.value = e.touches[0].clientX
}

const handleTouchMove = (e: TouchEvent) => {
  touchEndX.value = e.touches[0].clientX
}

const handleTouchEnd = () => {
  if (touchStartX.value - touchEndX.value > 50) {
    // Swipe left - scroll right
    scrollGalleryRight()
  } else if (touchEndX.value - touchStartX.value > 50) {
    // Swipe right - scroll left
    scrollGalleryLeft()
  }
}

// Lightbox state
const showLightbox = ref(false)
const lightboxIndex = ref(0)

const galleryImages = computed(() => {
  return company.value?.images?.filter(img => img.type === 'gallery') || []
})

const scrollGalleryLeft = () => {
  if (galleryContainer.value) {
    galleryContainer.value.scrollBy({
      left: -500, // Scroll smoothly through images
      behavior: 'smooth'
    })
  }
}

const scrollGalleryRight = () => {
  if (galleryContainer.value) {
    galleryContainer.value.scrollBy({
      left: 500, // Scroll smoothly through images
      behavior: 'smooth'
    })
  }
}

const openLightbox = (index: number) => {
  lightboxIndex.value = index
  showLightbox.value = true
  document.body.style.overflow = 'hidden'
  // Add keyboard event listener
  window.addEventListener('keydown', handleLightboxKeyboard)
}

const closeLightbox = () => {
  showLightbox.value = false
  document.body.style.overflow = ''
  // Remove keyboard event listener
  window.removeEventListener('keydown', handleLightboxKeyboard)
}

const handleLightboxKeyboard = (event: KeyboardEvent) => {
  if (event.key === 'ArrowRight') {
    nextLightboxImage()
  } else if (event.key === 'ArrowLeft') {
    previousLightboxImage()
  } else if (event.key === 'Escape') {
    closeLightbox()
  }
}

const nextLightboxImage = () => {
  // Infinite loop - go to first when at last
  lightboxIndex.value = (lightboxIndex.value + 1) % galleryImages.value.length
}

const previousLightboxImage = () => {
  // Infinite loop - go to last when at first
  lightboxIndex.value = lightboxIndex.value === 0 
    ? galleryImages.value.length - 1 
    : lightboxIndex.value - 1
}

const formatWebsite = (url: string): string => {
  try {
    const urlObj = new URL(url)
    return urlObj.hostname.replace('www.', '')
  } catch {
    return url
  }
}

const formatDate = (dateString: string): string => {
  const date = new Date(dateString)
  return date.getFullYear().toString()
}

const formatFoundedDate = (dateString: string): string => {
  const date = new Date(dateString)
  return date.getFullYear().toString()
}

const formatJobDate = (date: string): string => {
  const now = new Date()
  const postDate = new Date(date)
  const diffTime = Math.abs(now.getTime() - postDate.getTime())
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
  
  if (diffDays === 0) return 'Today'
  if (diffDays === 1) return 'Yesterday'
  if (diffDays < 7) return `${diffDays} days ago`
  if (diffDays < 30) return `${Math.floor(diffDays / 7)} weeks ago`
  return `${Math.floor(diffDays / 30)} months ago`
}

const formatEmploymentType = (type: string): string => {
  const types: Record<string, string> = {
    'full-time': 'Full-time',
    'part-time': 'Part-time',
    'contract': 'Contract',
    'freelance': 'Freelance',
    'internship': 'Internship',
  }
  return types[type] || type
}

const formatExperienceLevel = (level: string): string => {
  const levels: Record<string, string> = {
    'entry': 'Entry Level',
    'mid': 'Mid Level',
    'senior': 'Senior',
    'lead': 'Lead',
    'executive': 'Executive',
  }
  return levels[level] || level
}

const formatNumber = (num: number): string => {
  if (num >= 1000000) return (num / 1000000).toFixed(1) + 'M'
  if (num >= 1000) return (num / 1000).toFixed(1) + 'K'
  return num.toString()
}

const _formatSalary = (min: number, max: number): string => {
  if (!min && !max) return 'Competitive'
  if (min && max) {
    return `$${formatNumber(min)} - $${formatNumber(max)}`
  }
  if (min) return `From $${formatNumber(min)}`
  if (max) return `Up to $${formatNumber(max)}`
  return 'Competitive'
}

const _formatSalaryPeriod = (period: string): string => {
  const periods: Record<string, string> = {
    'hourly': 'hour',
    'daily': 'day',
    'weekly': 'week',
    'monthly': 'month',
    'yearly': 'year',
  }
  return periods[period] || period
}

const getLogoUrl = (path: string): string => {
  if (!path) return ''
  
  // Handle different path formats
  if (path.startsWith('data:') || path.startsWith('blob:') || path.startsWith('http')) {
    return path
  }
  
  if (path.startsWith('/storage/')) {
    return path
  }
  
  // Remove leading slashes and construct clean path
  const cleanPath = path.replace(/^\/+/, '')
  return `/storage/${cleanPath}`
}

const getBadgeVariant = (level: string): 'primary' | 'secondary' | 'success' | 'warning' | 'danger' | 'info' => {
  const variants: Record<string, 'primary' | 'secondary' | 'success' | 'warning' | 'danger' | 'info'> = {
    'entry': 'success',
    'mid': 'info',
    'senior': 'warning',
    'lead': 'secondary',
    'executive': 'primary',
  }
  return variants[level] || 'info'
}

const navigateToJob = (slug: string) => {
  router.push({ name: 'job-detail', params: { slug } })
}

const viewAllJobs = () => {
  router.push(`/jobs?company=${company.value?.slug}`)
}

const fetchCompanyDetail = async () => {
  loading.value = true
  try {
    // Handle both ID and slug
    const identifier = (route.params.id || route.params.slug) as string
    await companyStore.fetchCompany(identifier)
    company.value = companyStore.currentCompany
  } catch (error) {
    console.error('Failed to fetch company:', error)
    company.value = null
  } finally {
    loading.value = false
  }
}

const fetchCompanyJobs = async () => {
  if (!company.value) return
  
  loadingJobs.value = true
  try {
    // Use company.jobs if available from API response
    if (company.value.jobs && company.value.jobs.length > 0) {
      jobs.value = company.value.jobs.slice(0, 10)
    } else {
      // Otherwise fetch all jobs and filter client-side
      await jobStore.fetchJobs({
        per_page: 50,
      })
      jobs.value = jobStore.jobs
        .filter(job => job.company_id === company.value?.id)
        .slice(0, 10)
    }
  } catch (error) {
    console.error('Failed to fetch company jobs:', error)
  } finally {
    loadingJobs.value = false
  }
}

// Window resize handler for mobile detection
const handleResize = () => {
  isMobile.value = window.innerWidth < 640
}

onMounted(async () => {
  await fetchCompanyDetail()
  if (company.value) {
    await fetchCompanyJobs()
  }
  
  // Add resize listener
  window.addEventListener('resize', handleResize)
  
  // Setup infinite carousel - wait for DOM to fully render
  await nextTick()
  
  // Add a small delay to ensure images are loaded
  setTimeout(() => {
    if (galleryContainer.value && galleryImages.value.length > 0) {
      // Calculate the width of one image set
      const scrollWidth = galleryContainer.value.scrollWidth
      const imageSetWidth = scrollWidth / 3 // We have 3 sets of images
      
      // Start at the middle set (original images)
      galleryContainer.value.scrollLeft = imageSetWidth
      
      // Add scroll event listener for infinite loop
      scrollHandler = () => {
        if (!galleryContainer.value) return
        
        const currentScrollLeft = galleryContainer.value.scrollLeft
        const maxScroll = galleryContainer.value.scrollWidth - galleryContainer.value.clientWidth
        
        // If scrolled to the very end (third set), jump back to middle set
        if (currentScrollLeft >= maxScroll - 10) {
          const newPosition = imageSetWidth + (currentScrollLeft - maxScroll)
          galleryContainer.value.scrollLeft = newPosition
        }
        // If scrolled to the very beginning (first set), jump forward to middle set
        else if (currentScrollLeft <= 10) {
          const newPosition = imageSetWidth + currentScrollLeft
          galleryContainer.value.scrollLeft = newPosition
        }
      }
      
      galleryContainer.value.addEventListener('scroll', scrollHandler)
    }
  }, 100)
})

onBeforeUnmount(() => {
  // Clean up scroll event listener to prevent memory leak
  if (galleryContainer.value && scrollHandler) {
    galleryContainer.value.removeEventListener('scroll', scrollHandler)
  }
  
  // Clean up resize listener
  window.removeEventListener('resize', handleResize)
})
</script>

<style scoped>
.prose p {
  margin-bottom: 1rem;
}

/* Lightbox fade transition */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* Hide scrollbar for gallery */
.scrollbar-hide::-webkit-scrollbar {
  display: none;
}

.scrollbar-hide {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
</style>
