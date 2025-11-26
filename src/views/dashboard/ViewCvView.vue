<template>
  <div class="container-custom py-8">
    <!-- Back Button and Actions -->
    <div class="flex items-center justify-between mb-6 no-print">
      <button 
        @click="router.back()" 
        class="flex items-center gap-2 text-gray-600 hover:text-gray-900 transition-colors"
      >
        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
        </svg>
        {{ $t('cv.backToMyCvs') }}
      </button>

      <!-- Action Buttons -->
      <div v-if="cv" class="flex items-center gap-3">
        <!-- Edit Button -->
        <button
          @click="router.push(`/my-cvs/edit/${cv.id}`)"
          class="flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
          </svg>
          {{ $t('common.edit') }}
        </button>

        <!-- Delete Button -->
        <button
          @click="showDeleteModal = true"
          class="flex items-center gap-2 px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
          </svg>
          {{ $t('common.delete') }}
        </button>

        <!-- Download PDF Button -->
        <button
          @click="downloadPdf"
          class="flex items-center gap-2 px-4 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700 transition-colors"
          :title="$t('cv.printToPdf')"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
          {{ $t('cv.downloadPdf') }}
        </button>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="flex justify-center items-center py-12">
      <BaseSpinner size="lg" />
    </div>

    <!-- CV Content -->
    <div v-else-if="cv" id="cv-content" class="max-w-4xl mx-auto border-2 border-gray-300 rounded-lg p-6 bg-white shadow-lg">
      <div id="print-cv-pdf">
        <!-- Header Section -->
        <div class="mb-1 pb-1 border-b border-gray-200">
          <div class="flex items-start gap-6 mb-4">
            <!-- Profile Image -->
            <div class="w-32 h-40 bg-gray-100 rounded-lg overflow-hidden flex-shrink-0 flex items-center justify-center ring-4 ring-gray-200">
              <img
                v-if="profileImageUrl"
                :src="profileImageUrl"
                :alt="cv.full_name"
                class="w-full h-full object-cover"
              />
              <svg v-else class="w-16 h-16 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
              </svg>
            </div>

            <!-- Name & Title -->
            <div class="flex-1">
              <h1 class="text-3xl font-bold text-gray-900 mb-2">{{ cv.full_name }}</h1>
              <p class="text-xl text-primary-600 font-medium mb-3">{{ cv.title || 'No title specified' }}</p>
            
              <!-- Contact Info - Inline -->
              <div class="text-sm text-gray-700">
                <span v-if="cv.email">{{ $t('cv.email') }}: {{ cv.email }}</span>
                <span v-if="cv.email && cv.phone" class="mx-2">|</span>
                <span v-if="cv.phone">{{ $t('cv.phone') }}: <span dir="ltr">{{ cv.phone }}</span></span>
              </div>

              <!-- Address -->
              <div v-if="cv.city || cv.country" class="text-sm text-gray-600 mt-2">
                {{ $t('jobs.address') }}: {{ [cv.city, cv.country].filter(Boolean).join(', ') }}
              </div>
            </div>
          </div>

          <!-- Social Links -->
          <div v-if="cv.website || cv.linkedin || cv.github" class="flex flex-wrap gap-3 mt-4">
            <a
              v-if="cv.website && cv.website.trim()"
              :href="cv.website"
              target="_blank"
              class="flex items-center gap-2 px-4 py-2 bg-gray-100 hover:bg-gray-200 rounded-lg text-sm font-medium text-gray-700 transition-colors"
            >
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9" />
              </svg>
              {{ $t('cv.website') }}
            </a>
            <a
              v-if="cv.linkedin && cv.linkedin.trim()"
              :href="cv.linkedin"
              target="_blank"
              class="flex items-center gap-2 px-4 py-2 bg-blue-100 hover:bg-blue-200 rounded-lg text-sm font-medium text-blue-700 transition-colors"
            >
              <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24">
                <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z" />
              </svg>
              {{ $t('cv.linkedin') }}
            </a>
            <a
              v-if="cv.github && cv.github.trim()"
              :href="cv.github"
              target="_blank"
              class="flex items-center gap-2 px-4 py-2 bg-gray-800 hover:bg-gray-900 rounded-lg text-sm font-medium text-white transition-colors"
            >
              <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z" />
              </svg>
              {{ $t('cv.github') }}
            </a>
          </div>
        </div>

        <!-- Education -->
        <div v-if="educationEntries.length > 0" class="mb-6">
          <h3 class="text-base font-bold text-gray-900 mb-2 flex items-center gap-2">
            <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
            </svg>
            {{ $t('cv.education') }}
          </h3>
          <div class="space-y-2">
            <div
              v-for="(edu, index) in educationEntries"
              :key="index"
              class="pb-2 border-b border-gray-200 last:border-0 last:pb-0"
            >
              <!-- Two Column Layout: Degree Left, Institution Right -->
              <div class="flex justify-between items-start mb-2">
                <div class="flex-1">
                  <h4 class="text-base font-bold text-gray-900">{{ edu.degree }}</h4>
                  <p class="text-gray-700 font-medium">{{ edu.field }}</p>
                  <div class="flex items-center gap-1 text-sm text-gray-600 mt-1">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                    {{ formatEducationDate(edu) }}
                  </div>
                </div>
                <div class="flex-1 pl-cv-section">
                  <p class="text-primary-600 font-semibold">{{ edu.institution }}</p>
                  <p v-if="edu.location" class="text-sm text-gray-600 flex items-start gap-1 mt-1">
                    <svg class="w-4 h-4 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                    </svg>
                    <span>{{ edu.location }}</span>
                  </p>
                </div>
              </div>
              <div v-if="edu.description" class="w-1/2 pr-4">
                <p class="text-gray-700 whitespace-pre-line mt-3">{{ edu.description }}</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Work Experience -->
        <div v-if="workExperiences.length > 0" class="mb-6">
          <h3 class="text-base font-bold text-gray-900 mb-2 flex items-center gap-2">
            <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
            </svg>
            {{ $t('cv.workExperience') }}
          </h3>
          <div class="space-y-2">
            <div
              v-for="(work, index) in workExperiences"
              :key="index"
              class="pb-2 border-b border-gray-200 last:border-0 last:pb-0"
            >
              <!-- Two Column Layout: Position Left, Company Right -->
              <div class="flex justify-between items-start mb-2">
                <div class="flex-1">
                  <h4 class="text-base font-bold text-gray-900">{{ work.position }}</h4>
                  <div class="flex items-center gap-1 text-sm text-gray-600 mt-1">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                    {{ formatWorkDate(work) }}
                  </div>
                </div>
                <div class="flex-1 pl-cv-section">
                  <p class="text-primary-600 font-semibold">{{ work.company }}</p>
                  <p v-if="work.location" class="text-sm text-gray-600 flex items-start gap-1 mt-1">
                    <svg class="w-4 h-4 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                    </svg>
                    <span>{{ work.location }}</span>
                  </p>
                </div>
              </div>
              <div v-if="work.description" class="w-1/2 pr-4">
                <p class="text-gray-700 whitespace-pre-line mt-3">{{ work.description }}</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Certifications -->
        <div v-if="certifications.length > 0" class="mb-6">
          <h3 class="text-base font-bold text-gray-900 mb-2 flex items-center gap-2">
            <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z" />
            </svg>
            {{ $t('cv.certifications') }}
          </h3>
          <div class="space-y-2">
            <div
              v-for="(cert, index) in certifications"
              :key="index"
              class="pb-2 border-b border-gray-200 last:border-0 last:pb-0"
            >
              <!-- Two Column Layout: Certification Left, Issuer Right -->
              <div class="flex justify-between items-start mb-2">
                <div class="flex-1">
                  <h4 class="text-base font-bold text-gray-900">{{ cert.name }}</h4>
                  <div class="flex items-center gap-1 text-sm text-gray-600 mt-1">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                    {{ $t('cv.issued') }}: {{ formatDate(cert.date) }}
                  </div>
                  <p v-if="cert.expiry_date" class="text-sm text-gray-600 flex items-center gap-1 mt-1">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    {{ $t('cv.expires') }}: {{ formatDate(cert.expiry_date) }}
                  </p>
                </div>
                <div class="flex-1 pl-cv-section">
                  <p class="text-primary-600 font-semibold">{{ cert.issuer }}</p>
                  <a
                    v-if="cert.url"
                    :href="cert.url"
                    target="_blank"
                    class="text-sm text-gray-600 hover:text-primary-600 inline-flex items-center gap-1 mt-1"
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                    </svg>
                    {{ $t('cv.viewCredential') }}
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Volunteer Work -->
        <div v-if="volunteerWork.length > 0" class="mb-6">
          <h3 class="text-base font-bold text-gray-900 mb-2 flex items-center gap-2">
            <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
            </svg>
            {{ $t('cv.volunteerWork') }}
          </h3>
          <div class="space-y-2">
            <div
              v-for="(volunteer, index) in volunteerWork"
              :key="index"
              class="pb-2 border-b border-gray-200 last:border-0 last:pb-0"
            >
              <!-- Two Column Layout: Role Left, Organization Right -->
              <div class="flex justify-between items-start mb-2">
                <div class="flex-1">
                  <h4 class="text-base font-bold text-gray-900">{{ volunteer.role }}</h4>
                  <div v-if="volunteer.start_date || volunteer.end_date" class="flex items-center gap-1 text-sm text-gray-600 mt-1">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                    {{ formatVolunteerDate(volunteer) }}
                  </div>
                </div>
                <div class="flex-1 pl-cv-section">
                  <p class="text-primary-600 font-semibold">{{ volunteer.organization }}</p>
                </div>
              </div>
              <div v-if="volunteer.description" class="w-1/2 pr-4">
                <p class="text-gray-700 whitespace-pre-line mt-3">{{ volunteer.description }}</p>
              </div>
            </div>
          </div>
        </div>

        <!-- References -->
        <div v-if="references.length > 0" class="mb-6">
          <h3 class="text-base font-bold text-gray-900 mb-2 flex items-center gap-2">
            <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
            </svg>
            {{ $t('cv.references') }}
          </h3>
          <div class="space-y-2">
            <div
              v-for="(reference, index) in references"
              :key="index"
              class="pb-2 border-b border-gray-200 last:border-0 last:pb-0"
            >
              <!-- Two Column Layout: Name/Position Left, Company/Contact Right -->
              <div class="flex justify-between items-start mb-2">
                <div class="flex-1">
                  <h4 class="text-base font-bold text-gray-900">{{ reference.name }}</h4>
                  <p class="text-gray-700 font-medium mt-1">{{ reference.position }}</p>
                  <p v-if="reference.relationship" class="text-sm text-gray-600 mt-1">{{ reference.relationship }}</p>
                </div>
                <div class="flex-1 pl-cv-section">
                  <p class="text-primary-600 font-semibold">{{ reference.company }}</p>
                  <div class="space-y-1 mt-1">
                    <a v-if="reference.email" :href="`mailto:${reference.email}`" class="text-sm text-gray-600 hover:text-primary-600 flex items-center gap-1">
                      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                      </svg>
                      {{ reference.email }}
                    </a>
                    <a v-if="reference.phone" :href="`tel:${reference.phone}`" class="text-sm text-gray-600 hover:text-primary-600 flex items-center gap-1" dir="ltr">
                      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                      </svg>
                      {{ reference.phone }}
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Skills -->
        <div v-if="displaySkills.length > 0" class="mb-6">
          <h3 class="text-base font-bold text-gray-900 mb-2 flex items-center gap-2">
            <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" />
            </svg>
            {{ $t('cv.skills') }}
          </h3>
          <div class="flex flex-wrap gap-1.5">
            <span
              v-for="(skill, index) in displaySkills"
              :key="index"
              class="px-3 py-1 bg-primary-100 text-primary-700 rounded-full text-sm font-medium"
            >
              {{ skill }}
            </span>
          </div>
        </div>

        <!-- Languages -->
        <div v-if="languages.length > 0" class="mb-6">
          <h3 class="text-base font-bold text-gray-900 mb-2 flex items-center gap-2">
            <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5h12M9 3v2m1.048 9.5A18.022 18.022 0 016.412 9m6.088 9h7M11 21l5-10 5 10M12.751 5C11.783 10.77 8.07 15.61 3 18.129" />
            </svg>
            {{ $t('cv.languages') }}
          </h3>
          <div class="grid md:grid-cols-3 gap-3">
            <div
              v-for="(lang, index) in languages"
              :key="index"
              class="flex justify-between items-center p-3 bg-blue-50 border border-blue-200 rounded-lg"
            >
              <span class="font-semibold text-gray-900">{{ lang.language }}</span>
              <span class="text-sm text-gray-600 capitalize">{{ $t(`cv.${lang.proficiency}`) }}</span>
            </div>
          </div>
        </div>

        <!-- Hobbies & Interests -->
        <div v-if="hobbies.length > 0" class="mb-6">
          <h3 class="text-base font-bold text-gray-900 mb-2 flex items-center gap-2">
            <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.828 14.828a4 4 0 01-5.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            {{ $t('cv.hobbies') }}
          </h3>
          <div class="flex flex-wrap gap-1.5">
            <span
              v-for="(hobby, index) in hobbies"
              :key="index"
              class="px-3 py-1 bg-pink-100 text-pink-700 rounded-full text-sm font-medium"
            >
              {{ hobby }}
            </span>
          </div>
        </div>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <BaseModal
      v-model="showDeleteModal"
      title="Delete CV"
      size="sm"
    >
      <div class="mb-6">
        <p class="text-gray-600">Are you sure you want to delete this CV? This action cannot be undone.</p>
      </div>
      <div class="flex gap-3">
        <BaseButton type="button" variant="outline" @click="showDeleteModal = false" class="flex-1">
          Cancel
        </BaseButton>
        <BaseButton type="button" variant="danger" @click="handleDelete" :loading="deleting" class="flex-1">
          Delete
        </BaseButton>
      </div>
    </BaseModal>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useCvStore } from '@/stores/cv'
import { useToast } from '@/composables/useToast'
import type { WorkExperience, Education, VolunteerWork } from '@/types'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseModal from '@/components/base/BaseModal.vue'
import BaseSpinner from '@/components/base/BaseSpinner.vue'

const router = useRouter()
const route = useRoute()
const cvStore = useCvStore()
const toast = useToast()

const loading = ref(false)
const deleting = ref(false)
const showDeleteModal = ref(false)

const cv = computed(() => cvStore.currentCv)

const profileImageUrl = computed(() => {
  if (!cv.value) return null
  const profileImage = cv.value.profileImage || cv.value.profile_image
  if (profileImage?.path) {
    // Add cache busting using updated_at timestamp
    const timestamp = cv.value.updated_at ? new Date(cv.value.updated_at).getTime() : Date.now()
    return `/storage/${profileImage.path}?v=${timestamp}`
  }
  return null
})

const displaySkills = computed(() => {
  if (!cv.value?.skills || cv.value.skills.length === 0) return []
  return cv.value.skills.map(skill => 
    typeof skill === 'string' ? skill : skill.name
  )
})

const workExperiences = computed(() => {
  return cv.value?.work_experiences || cv.value?.work_experience || []
})

const educationEntries = computed(() => {
  return cv.value?.education_entries || cv.value?.education || []
})

const certifications = computed(() => {
  return cv.value?.certifications || []
})

const languages = computed(() => {
  return cv.value?.languages || []
})

const volunteerWork = computed(() => {
  return cv.value?.volunteer_work || []
})

const references = computed(() => {
  return cv.value?.references || []
})

const hobbies = computed(() => {
  return cv.value?.hobbies || []
})

const formatDate = (dateString: string) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const year = date.getFullYear()
  return `${month}/${year}`
}

const formatWorkDate = (exp: WorkExperience) => {
  const start = formatDate(exp.start_date)
  const end = exp.current ? 'Present' : formatDate(exp.end_date || '')
  return `${start} - ${end}`
}

const formatEducationDate = (edu: Education) => {
  const start = formatDate(edu.start_date)
  const end = formatDate(edu.end_date || '')
  return end ? `${start} - ${end}` : start
}

const formatVolunteerDate = (vol: VolunteerWork) => {
  const start = formatDate(vol.start_date)
  const end = formatDate(vol.end_date || '')
  return end ? `${start} - ${end}` : start
}

const downloadPdf = () => {
  if (!cv.value) return
  
  // Get current year
  const currentYear = new Date().getFullYear()
  
  // Format the full name: replace spaces with underscores and remove special characters
  const formattedName = cv.value.full_name
    .replace(/\s+/g, '_')
    .replace(/[^a-zA-Z0-9_]/g, '')
  
  // Create the desired filename format
  const filename = `${formattedName}_CV_${currentYear}`
  
  // Save original title
  const originalTitle = document.title
  
  // Set document title to desired filename (browser uses this for PDF name)
  document.title = filename
  
  // Trigger print dialog
  window.print()
  
  // Restore original title after a short delay
  setTimeout(() => {
    document.title = originalTitle
  }, 1000)
  
  toast.success('In the print dialog, disable "Headers and footers" for a clean PDF')
}

const handleDelete = async () => {
  if (!cv.value) return
  
  deleting.value = true
  try {
    await cvStore.deleteCv(cv.value.id)
    toast.success('CV deleted successfully!')
    router.push('/my-cvs')
  } catch (error: unknown) {
    console.error('Failed to delete CV:', error)
    const err = error as { response?: { data?: { message?: string } } }
    toast.error(err.response?.data?.message || 'Failed to delete CV. Please try again.')
  } finally {
    deleting.value = false
    showDeleteModal.value = false
  }
}

onMounted(async () => {
  const id = route.params.id
  if (id) {
    loading.value = true
    try {
      await cvStore.fetchCvById(Number(id))
    } catch (error) {
      console.error('Failed to load CV:', error)
      toast.error('Failed to load CV')
      router.push('/my-cvs')
    } finally {
      loading.value = false
    }
  }
})
</script>

<style scoped>
@media print {
  /* Remove browser's default headers and footers */
  @page {
    margin: 0;
    size: A4;
  }
  
  /* Hide everything except the print-cv-pdf div */
  :global(body *) {
    visibility: hidden;
  }
  
  #print-cv-pdf,
  #print-cv-pdf * {
    visibility: visible;
  }
  
  #print-cv-pdf {
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    padding: 20mm; /* Add padding for proper margins */
  }

  /* Ensure proper page breaks */
  :global(.experience-item),
  :global(.cert-item),
  :global(.reference-item) {
    page-break-inside: avoid;
  }
  
  /* Hide any potential headers/footers */
  :global(header),
  :global(footer),
  :global(nav),
  :global(.no-print) {
    display: none !important;
  }

  /* Keep languages in 3 columns when printing */
  :global(.grid.md\:grid-cols-3) {
    display: grid !important;
    grid-template-columns: repeat(3, minmax(0, 1fr)) !important;
  }

  /* Reduce spacing between section items in print */
  #print-cv-pdf :global(.space-y-3 > * + *) {
    margin-top: 0.75rem !important;
  }

  /* Ensure section titles are compact in print */
  #print-cv-pdf h3 {
    font-size: 1rem !important; /* text-base */
    margin-bottom: 0.5rem !important; /* mb-2 */
  }

  #print-cv-pdf h4 {
    font-size: 1rem !important; /* text-base */
  }

  /* Reduce bottom padding for list items in print - consolidated to 0.5rem for pb-2 and pb-3 */
  #print-cv-pdf :global(.pb-2),
  #print-cv-pdf :global(.pb-3),
  #print-cv-pdf div.pb-2,
  #print-cv-pdf div.pb-3 {
    padding-bottom: 0.5rem !important;
  }

  #print-cv-pdf :global(.pb-4) {
    padding-bottom: 1rem !important;
  }

  /* Ensure section spacing is consistent in print */
  #print-cv-pdf :global(.mb-6) {
    margin-bottom: 1.5rem !important;
  }

  #print-cv-pdf :global(.mb-4) {
    margin-bottom: 1rem !important;
  }

  /* Force spacing on divs with space-y-3 class */
  #print-cv-pdf div.space-y-3 > div {
    margin-top: 0 !important;
  }

  #print-cv-pdf div.space-y-3 > div + div {
    margin-top: 0.5rem !important;
  }

  /* Force spacing on divs with space-y-2 class */
  #print-cv-pdf div.space-y-2 > div {
    margin-top: 0 !important;
  }

  #print-cv-pdf div.space-y-2 > div + div {
    margin-top: 0.5rem !important;
  }

  /* Ensure border styling on bordered items */
  #print-cv-pdf div.border-b {
    border-bottom: 1px solid #e5e7eb !important;
  }
}
</style>
