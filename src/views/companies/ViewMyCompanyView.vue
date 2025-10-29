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

    <!-- Company Not Found or Access Denied -->
    <div v-else-if="!company || accessDenied" class="container-custom py-16">
      <BaseCard class="p-12 text-center">
        <svg class="h-16 w-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
        </svg>
        <h2 class="text-2xl font-bold text-gray-900 mb-2">
          {{ accessDenied ? 'Access Denied' : 'Company Not Found' }}
        </h2>
        <p class="text-gray-600 mb-6">
          {{ accessDenied 
            ? 'You do not have permission to view this company.' 
            : 'The company you are looking for does not exist.' 
          }}
        </p>
        <BaseButton variant="primary" @click="router.push({ name: 'my-companies' })">
          Back to My Companies
        </BaseButton>
      </BaseCard>
    </div>

    <!-- Company Detail Content -->
    <div v-else-if="company">
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
            @click="router.push({ name: 'my-companies' })" 
            class="absolute top-6 left-6 flex items-center gap-2 text-white/90 hover:text-white bg-black/30 hover:bg-black/50 px-4 py-2 rounded-lg backdrop-blur-sm transition-all"
          >
            <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
            Back to My Companies
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
                {{ company.company_size }} employees
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

            <p v-if="company.description" class="text-lg text-gray-700 leading-relaxed max-w-4xl mx-auto">
              {{ company.description }}
            </p>
          </div>
        </div>
      </div>

      <!-- Stats Bar -->
      <div class="bg-white border-b border-gray-200 shadow-sm">
        <div class="container-custom">
          <div class="grid grid-cols-2 md:grid-cols-4 gap-4 py-6">
            <div class="text-center">
              <p class="text-3xl font-bold text-primary-600">{{ company.jobs_count || 0 }}</p>
              <p class="text-sm text-gray-600 mt-1">Open Positions</p>
            </div>
            <div class="text-center">
              <p class="text-3xl font-bold text-primary-600">{{ formatDate(company.created_at) }}</p>
              <p class="text-sm text-gray-600 mt-1">Member Since</p>
            </div>
            <div v-if="company.city" class="text-center">
              <p class="text-3xl font-bold text-primary-600">1</p>
              <p class="text-sm text-gray-600 mt-1">Location</p>
            </div>
            <div class="text-center">
              <p class="text-3xl font-bold text-primary-600">{{ company.is_active ? 'Active' : 'Inactive' }}</p>
              <p class="text-sm text-gray-600 mt-1">Status</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Main Content -->
      <div class="container-custom py-8">
        <!-- Company Details Container -->
        <BaseCard class="p-8 mb-8">
          <div class="flex flex-col lg:flex-row gap-8">
            <!-- Company Information -->
            <div class="flex-1">
              <h2 class="text-2xl font-bold text-gray-900 mb-6">Company Details</h2>
              
              <!-- Description -->
              <div class="mb-6">
                <h3 class="text-lg font-semibold text-gray-900 mb-3">About</h3>
                <p class="text-gray-700 leading-relaxed">
                  {{ company.description || 'No detailed description available for this company.' }}
                </p>
              </div>

              <!-- Company Info Grid -->
              <div class="grid md:grid-cols-2 gap-6">
                <!-- Industry -->
                <div v-if="company.industry">
                  <h3 class="text-sm font-semibold text-gray-900 mb-2">Industry</h3>
                  <p class="text-gray-700">{{ company.industry }}</p>
                </div>

                <!-- Company Size -->
                <div v-if="company.company_size">
                  <h3 class="text-sm font-semibold text-gray-900 mb-2">Company Size</h3>
                  <p class="text-gray-700">{{ company.company_size }} employees</p>
                </div>

                <!-- Founded -->
                <div v-if="company.founded_date">
                  <h3 class="text-sm font-semibold text-gray-900 mb-2">Founded</h3>
                  <p class="text-gray-700">{{ formatFoundedDate(company.founded_date) }}</p>
                </div>

                <!-- Status -->
                <div>
                  <h3 class="text-sm font-semibold text-gray-900 mb-2">Status</h3>
                  <p class="text-gray-700">
                    <span :class="company.is_active ? 'text-green-600' : 'text-red-600'" class="font-medium">
                      {{ company.is_active ? 'Active' : 'Inactive' }}
                    </span>
                  </p>
                </div>
              </div>
            </div>

            <!-- Contact Information Sidebar -->
            <div class="lg:w-80 flex-shrink-0">
              <h3 class="text-lg font-semibold text-gray-900 mb-4">Contact Information</h3>
              <div class="space-y-4">
                <div v-if="company.email" class="flex items-start gap-3">
                  <svg class="h-5 w-5 text-gray-400 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                  </svg>
                  <div class="flex-1 min-w-0">
                    <p class="text-sm text-gray-600 mb-1">Email</p>
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
                    <p class="text-sm text-gray-600 mb-1">Phone</p>
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
                    <p class="text-sm text-gray-600 mb-1">Website</p>
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
                    <p class="text-sm text-gray-600 mb-1">Address</p>
                    <p class="text-sm text-gray-900">
                      <span v-if="company.street">{{ company.street }}<br /></span>
                      <span v-if="company.city">{{ company.city }}</span>
                      <span v-if="company.country">, {{ company.country }}</span>
                    </p>
                  </div>
                </div>
              </div>

              <!-- Social Media Links -->
              <div v-if="company.linkedin || company.twitter || company.facebook || company.instagram || company.youtube" class="mt-6 pt-6 border-t border-gray-200">
                <h3 class="text-sm font-semibold text-gray-900 mb-3">Follow Us</h3>
                <div class="flex flex-col gap-3 items-start">
                  <a v-if="company.linkedin" :href="company.linkedin" target="_blank" rel="noopener noreferrer" 
                     class="flex items-center gap-2 px-3 py-2 bg-blue-700 hover:bg-blue-800 text-white rounded-lg transition-colors text-sm">
                    <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z" />
                    </svg>
                    LinkedIn
                  </a>

                  <a v-if="company.facebook" :href="company.facebook" target="_blank" rel="noopener noreferrer"
                     class="flex items-center gap-2 px-3 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors text-sm">
                    <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z" />
                    </svg>
                    Facebook
                  </a>

                  <a v-if="company.instagram" :href="company.instagram" target="_blank" rel="noopener noreferrer"
                     class="flex items-center gap-2 px-3 py-2 bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-700 hover:to-pink-700 text-white rounded-lg transition-colors text-sm">
                    <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z" />
                    </svg>
                    Instagram
                  </a>

                  <a v-if="company.youtube" :href="company.youtube" target="_blank" rel="noopener noreferrer"
                     class="flex items-center gap-2 px-3 py-2 bg-red-600 hover:bg-red-700 text-white rounded-lg transition-colors text-sm">
                    <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z" />
                    </svg>
                    YouTube
                  </a>

                  <a v-if="company.twitter" :href="company.twitter" target="_blank" rel="noopener noreferrer"
                     class="flex items-center gap-2 px-3 py-2 bg-black hover:bg-gray-900 text-white rounded-lg transition-colors text-sm">
                    <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
                    </svg>
                    X
                  </a>
                </div>
              </div>

              <!-- Quick Actions -->
              <div class="mt-6 pt-6 border-t border-gray-200">
                <h3 class="text-sm font-semibold text-gray-900 mb-3">Quick Actions</h3>
                <div class="space-y-2">
                  <BaseButton
                    variant="outline"
                    size="sm"
                    class="w-full justify-start"
                    @click="router.push({ name: 'edit-company', params: { id: company.id } })"
                  >
                    <template #icon-left>
                      <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                      </svg>
                    </template>
                    Edit Company
                  </BaseButton>
                  <BaseButton
                    variant="outline"
                    size="sm"
                    class="w-full justify-start"
                    @click="viewPublicProfile"
                  >
                    <template #icon-left>
                      <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                      </svg>
                    </template>
                    View Public Profile
                  </BaseButton>
                </div>
              </div>
            </div>
          </div>
        </BaseCard>

        <!-- Company Photos Carousel -->
        <BaseCard v-if="company.images && company.images.filter(img => img.type === 'gallery').length > 0" class="p-6 mb-6">
          <h2 class="text-2xl font-bold text-gray-900 mb-6">Company Photos</h2>
          
          <div class="relative">
            <!-- Carousel Container -->
            <div class="overflow-hidden rounded-lg">
              <div 
                class="flex transition-transform duration-500 ease-in-out"
                :style="{ transform: `translateX(-${currentSlide * 100}%)` }"
              >
                <div
                  v-for="(image, index) in company.images.filter(img => img.type === 'gallery')"
                  :key="index"
                  class="w-full flex-shrink-0"
                >
                  <div class="aspect-[16/9] bg-gray-100 rounded-lg overflow-hidden">
                    <img
                      :src="getLogoUrl(image.path)"
                      :alt="`Company photo ${index + 1}`"
                      class="w-full h-full object-contain"
                    />
                  </div>
                </div>
              </div>
            </div>

            <!-- Navigation Buttons -->
            <button
              v-if="galleryImages.length > 1"
              @click="previousSlide"
              class="absolute left-2 top-1/2 -translate-y-1/2 bg-white/90 hover:bg-white text-gray-800 rounded-full p-2 shadow-lg transition-all hover:scale-110"
            >
              <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
              </svg>
            </button>
            <button
              v-if="galleryImages.length > 1"
              @click="nextSlide"
              class="absolute right-2 top-1/2 -translate-y-1/2 bg-white/90 hover:bg-white text-gray-800 rounded-full p-2 shadow-lg transition-all hover:scale-110"
            >
              <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
              </svg>
            </button>

            <!-- Dots Indicator -->
            <div v-if="galleryImages.length > 1" class="flex justify-center gap-2 mt-4">
              <button
                v-for="(image, index) in galleryImages"
                :key="index"
                @click="currentSlide = index"
                class="transition-all"
                :class="[
                  currentSlide === index 
                    ? 'w-8 h-2 bg-primary-600' 
                    : 'w-2 h-2 bg-gray-300 hover:bg-gray-400'
                ]"
                style="border-radius: 9999px;"
              />
            </div>

            <!-- Image Counter -->
            <div class="absolute top-4 right-4 bg-black/60 text-white px-3 py-1 rounded-full text-sm">
              {{ currentSlide + 1 }} / {{ galleryImages.length }}
            </div>
          </div>
        </BaseCard>

        <!-- Jobs Section -->
        <div>
          <div class="flex items-center justify-between mb-6">
            <h2 class="text-2xl font-bold text-gray-900">
              Posted Jobs ({{ jobs.length }})
            </h2>
            <BaseButton 
              variant="primary" 
              @click="navigateToPostJob"
            >
              <template #icon-left>
                <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                </svg>
              </template>
              Post New Job
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
              class="p-6 group relative"
            >
              <!-- Job Header -->
              <div class="mb-4">
                <h3 class="text-lg font-semibold text-gray-900 mb-2 line-clamp-2 pr-8">
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
                  <span>{{ formatSalary(job.salary_min, job.salary_max) }}</span>
                </div>
              </div>

              <!-- Badges -->
              <div class="flex flex-wrap gap-2 mb-4">
                <BaseBadge :variant="getBadgeVariant(job.experience_level)">
                  {{ formatExperienceLevel(job.experience_level) }}
                </BaseBadge>
                <BaseBadge v-if="job.is_remote" variant="success">Remote</BaseBadge>
                <BaseBadge v-if="job.category" variant="info">{{ job.category }}</BaseBadge>
              </div>

              <!-- Action Buttons -->
              <div class="flex items-center gap-2 pt-4 border-t border-gray-200">
                <BaseButton
                  variant="outline"
                  size="sm"
                  @click="viewCompanyJob(job)"
                  title="View Job"
                >
                  <template #icon-left>
                    <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                    </svg>
                  </template>
                </BaseButton>
                <BaseButton
                  variant="outline"
                  size="sm"
                  @click="editCompanyJob(job)"
                  title="Edit Job"
                >
                  <template #icon-left>
                    <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                    </svg>
                  </template>
                </BaseButton>
                <BaseButton
                  variant="outline"
                  size="sm"
                  @click.stop="confirmDeleteJob(job)"
                  class="text-red-600 hover:text-red-700 hover:border-red-600"
                  title="Delete Job"
                >
                  <template #icon-left>
                    <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                  </template>
                </BaseButton>
              </div>
            </BaseCard>
          </div>

          <!-- No Jobs -->
          <BaseCard v-else class="p-12 text-center">
            <svg class="h-16 w-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
            </svg>
            <h3 class="text-xl font-semibold text-gray-900 mb-2">No Jobs Posted Yet</h3>
            <p class="text-gray-600 mb-6">Start posting jobs to attract talented candidates.</p>
            <BaseButton variant="primary" @click="navigateToPostJob">
              <template #icon-left>
                <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                </svg>
              </template>
              Post Your First Job
            </BaseButton>
          </BaseCard>
        </div>
      </div>
    </div>

    <!-- Delete Job Confirmation Modal -->
    <BaseModal
      v-model="showDeleteJobModal"
      title="Delete Job"
      size="sm"
    >
      <div class="p-6">
        <p class="text-gray-700 mb-6">
          Are you sure you want to delete <strong>{{ selectedJob?.title }}</strong>? 
          This action cannot be undone and all applications for this job will be lost.
        </p>
        <div class="flex items-center justify-end gap-3">
          <BaseButton
            variant="outline"
            @click="showDeleteJobModal = false"
            :disabled="deletingJob"
          >
            Cancel
          </BaseButton>
          <BaseButton
            variant="primary"
            @click="handleDeleteJob"
            :loading="deletingJob"
            class="bg-red-600 hover:bg-red-700"
          >
            Delete Job
          </BaseButton>
        </div>
      </div>
    </BaseModal>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { companyService } from '@/services/cv.service'
import { jobService } from '@/services/job.service'
import { useToast } from '@/composables/useToast'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseBadge from '@/components/base/BaseBadge.vue'
import BaseModal from '@/components/base/BaseModal.vue'
import type { Company, Job } from '@/types'

const router = useRouter()
const route = useRoute()
const toast = useToast()

const loading = ref(true)
const loadingJobs = ref(false)
const company = ref<Company | null>(null)
const jobs = ref<Job[]>([])
const accessDenied = ref(false)
const showDeleteJobModal = ref(false)
const selectedJob = ref<Job | null>(null)
const deletingJob = ref(false)

// Carousel state
const currentSlide = ref(0)
const galleryImages = computed(() => {
  return company.value?.images?.filter(img => img.type === 'gallery') || []
})

const nextSlide = () => {
  if (currentSlide.value < galleryImages.value.length - 1) {
    currentSlide.value++
  } else {
    currentSlide.value = 0
  }
}

const previousSlide = () => {
  if (currentSlide.value > 0) {
    currentSlide.value--
  } else {
    currentSlide.value = galleryImages.value.length - 1
  }
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

const formatSalary = (min: number, max: number): string => {
  if (!min && !max) return 'Competitive'
  if (min && max) {
    return `$${formatNumber(min)} - $${formatNumber(max)}`
  }
  if (min) return `From $${formatNumber(min)}`
  if (max) return `Up to $${formatNumber(max)}`
  return 'Competitive'
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

const navigateToPostJob = () => {
  router.push({
    name: 'post-job',
    query: { company_id: company.value?.id }
  })
}

const viewPublicProfile = () => {
  if (company.value?.slug) {
    // Open in new tab so user can see the public view
    const route = router.resolve({
      name: 'company-detail-slug',
      params: { slug: company.value.slug }
    })
    window.open(route.href, '_blank')
  } else if (company.value?.id) {
    // Fallback to ID if slug doesn't exist
    const route = router.resolve({
      name: 'company-detail',
      params: { id: company.value.id.toString() }
    })
    window.open(route.href, '_blank')
  }
}

const viewCompanyJob = (job: Job) => {
  router.push({
    name: 'view-company-job',
    params: { 
      companyId: company.value?.id,
      jobId: job.id 
    }
  })
}

const editCompanyJob = (job: Job) => {
  router.push({
    name: 'edit-company-job',
    params: { 
      companyId: company.value?.id,
      jobId: job.id 
    }
  })
}

const confirmDeleteJob = (job: Job) => {
  selectedJob.value = job
  showDeleteJobModal.value = true
}

const handleDeleteJob = async () => {
  if (!selectedJob.value) return
  
  deletingJob.value = true
  try {
    const response = await jobService.deleteJob(selectedJob.value.id)
    if (response.success) {
      showDeleteJobModal.value = false
      // Remove job from the list
      jobs.value = jobs.value.filter(j => j.id !== selectedJob.value?.id)
      toast.success('Job deleted successfully!')
      selectedJob.value = null
      
      // Reload company details to update job count
      await fetchCompanyDetail()
    }
  } catch (error) {
    console.error('Failed to delete job:', error)
    const err = error as { response?: { data?: { message?: string } } }
    toast.error(err.response?.data?.message || 'Failed to delete job')
  } finally {
    deletingJob.value = false
  }
}

const fetchCompanyDetail = async () => {
  loading.value = true
  accessDenied.value = false
  
  try {
    const companyId = route.params.id as string
    
    // Fetch all user's companies to verify ownership
    const response = await companyService.getMyCompanies()
    
    if (response.success && response.data) {
      // Find the company with matching ID
      const foundCompany = response.data.find((c: Company) => c.id.toString() === companyId)
      
      if (foundCompany) {
        company.value = foundCompany
        
        // Load jobs if available
        if (foundCompany.jobs && foundCompany.jobs.length > 0) {
          jobs.value = foundCompany.jobs
        }
      } else {
        // Company not found in user's companies - access denied
        accessDenied.value = true
        toast.error('You do not have permission to view this company')
      }
    }
  } catch (error) {
    console.error('Failed to fetch company:', error)
    const err = error as { response?: { data?: { message?: string } } }
    toast.error(err.response?.data?.message || 'Failed to load company details')
    company.value = null
  } finally {
    loading.value = false
  }
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

onMounted(async () => {
  // Ensure body can scroll
  document.body.style.overflow = ''
  await fetchCompanyDetail()
})
</script>

<style scoped>
.prose p {
  margin-bottom: 1rem;
}
</style>
