<template>
  <div class="container-custom py-8">
    <!-- Back Button -->
    <button 
      @click="router.back()" 
      class="flex items-center gap-2 text-gray-600 hover:text-gray-900 mb-6 transition-colors"
    >
      <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
      </svg>
      Back to My CVs
    </button>

    <!-- Loading State -->
    <div v-if="loading" class="flex justify-center items-center py-12">
      <BaseSpinner size="lg" />
    </div>

    <!-- CV Content -->
    <div v-else-if="cv" class="max-w-4xl mx-auto border-2 border-gray-300 rounded-lg p-6 bg-white shadow-lg">
      <!-- Header Section -->
      <BaseCard no-padding class="p-4 mb-4">
        <div class="flex items-start gap-6 mb-6">
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
            <p class="text-xl text-primary-600 font-medium">{{ cv.title || 'No title specified' }}</p>
          </div>
        </div>

        <!-- Contact Info -->
        <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-4 pt-6 border-t border-gray-200">
          <div v-if="cv.email" class="flex items-center gap-3">
            <div class="w-10 h-10 bg-primary-100 rounded-lg flex items-center justify-center flex-shrink-0">
              <svg class="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
              </svg>
            </div>
            <div class="min-w-0">
              <p class="text-xs text-gray-500">Email</p>
              <p class="text-sm font-medium text-gray-900 truncate">{{ cv.email }}</p>
            </div>
          </div>

          <div v-if="cv.phone" class="flex items-center gap-3">
            <div class="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center flex-shrink-0">
              <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
              </svg>
            </div>
            <div class="min-w-0">
              <p class="text-xs text-gray-500">Phone</p>
              <p class="text-sm font-medium text-gray-900">{{ cv.phone }}</p>
            </div>
          </div>

          <div v-if="cv.city || cv.country || cv.postal_code" class="flex items-center gap-3">
            <div class="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center flex-shrink-0">
              <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
              </svg>
            </div>
            <div class="min-w-0">
              <p class="text-xs text-gray-500">Location</p>
              <p class="text-sm font-medium text-gray-900 truncate">
                {{ [cv.city, cv.postal_code, cv.country].filter(Boolean).join(', ') }}
              </p>
            </div>
          </div>
        </div>

        <!-- Social Links -->
        <div v-if="cv.website || cv.linkedin || cv.github" class="flex flex-wrap gap-3 pt-6 border-t border-gray-200 mt-6">
          <a
            v-if="cv.website && cv.website.trim()"
            :href="cv.website"
            target="_blank"
            class="flex items-center gap-2 px-4 py-2 bg-gray-100 hover:bg-gray-200 rounded-lg text-sm font-medium text-gray-700 transition-colors"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9" />
            </svg>
            Website
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
            LinkedIn
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
            GitHub
          </a>
        </div>
      </BaseCard>

      <!-- Skills -->
      <BaseCard v-if="displaySkills.length > 0" no-padding class="p-4 mb-4">
        <h3 class="text-2xl font-bold text-gray-900 mb-4 flex items-center gap-2">
          <svg class="w-6 h-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" />
          </svg>
          Skills
        </h3>
        <div class="flex flex-wrap gap-2">
          <span
            v-for="(skill, index) in displaySkills"
            :key="index"
            class="px-4 py-2 bg-primary-100 text-primary-700 rounded-full text-sm font-medium"
          >
            {{ skill }}
          </span>
        </div>
      </BaseCard>

      <!-- Work Experience -->
      <BaseCard v-if="workExperiences.length > 0" no-padding class="p-4 mb-4">
        <h3 class="text-2xl font-bold text-gray-900 mb-6 flex items-center gap-2">
          <svg class="w-6 h-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
          </svg>
          Work Experience
        </h3>
        <div class="space-y-6">
          <div
            v-for="(exp, index) in workExperiences"
            :key="index"
            class="pb-6 border-b border-gray-200 last:border-0 last:pb-0"
          >
            <h4 class="text-lg font-bold text-gray-900">{{ exp.position }}</h4>
            <p class="text-primary-600 font-medium mb-2">{{ exp.company }}</p>
            <div class="flex flex-wrap gap-4 text-sm text-gray-600 mb-3">
              <span v-if="exp.location" class="flex items-center gap-1">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                </svg>
                {{ exp.location }}
              </span>
              <span class="flex items-center gap-1">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
                {{ formatWorkDate(exp) }}
              </span>
            </div>
            <p v-if="exp.description" class="text-gray-700 whitespace-pre-line">{{ exp.description }}</p>
          </div>
        </div>
      </BaseCard>

      <!-- Education -->
      <BaseCard v-if="educationEntries.length > 0" no-padding class="p-4 mb-4">
        <h3 class="text-2xl font-bold text-gray-900 mb-6 flex items-center gap-2">
          <svg class="w-6 h-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
          </svg>
          Education
        </h3>
        <div class="space-y-6">
          <div
            v-for="(edu, index) in educationEntries"
            :key="index"
            class="pb-6 border-b border-gray-200 last:border-0 last:pb-0"
          >
            <h4 class="text-lg font-bold text-gray-900">{{ edu.degree }} in {{ edu.field }}</h4>
            <p class="text-primary-600 font-medium mb-2">{{ edu.institution }}</p>
            <div class="flex flex-wrap gap-4 text-sm text-gray-600 mb-3">
              <span v-if="edu.location" class="flex items-center gap-1">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                </svg>
                {{ edu.location }}
              </span>
              <span class="flex items-center gap-1">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
                {{ formatEducationDate(edu) }}
              </span>
              <span v-if="edu.gpa">
                GPA: {{ edu.gpa }}
              </span>
            </div>
            <p v-if="edu.description" class="text-gray-700">{{ edu.description }}</p>
          </div>
        </div>
      </BaseCard>

      <!-- Certifications -->
      <BaseCard v-if="certifications.length > 0" no-padding class="p-4 mb-4">
        <h3 class="text-2xl font-bold text-gray-900 mb-6 flex items-center gap-2">
          <svg class="w-6 h-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z" />
          </svg>
          Certifications
        </h3>
        <div class="grid md:grid-cols-2 gap-4">
          <div
            v-for="(cert, index) in certifications"
            :key="index"
            class="p-4 bg-yellow-50 border border-yellow-200 rounded-lg"
          >
            <h4 class="font-bold text-gray-900 mb-1">{{ cert.name }}</h4>
            <p class="text-sm text-gray-600 mb-2">{{ cert.issuer }}</p>
            <p class="text-xs text-gray-500">Issued: {{ formatDate(cert.date) }}</p>
            <p v-if="cert.expiry_date" class="text-xs text-gray-500">Expires: {{ formatDate(cert.expiry_date) }}</p>
            <a
              v-if="cert.url"
              :href="cert.url"
              target="_blank"
              class="text-xs text-primary-600 hover:text-primary-700 inline-flex items-center gap-1 mt-2"
            >
              View Credential
              <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
              </svg>
            </a>
          </div>
        </div>
      </BaseCard>

      <!-- Languages -->
      <BaseCard v-if="languages.length > 0" no-padding class="p-4 mb-4">
        <h3 class="text-2xl font-bold text-gray-900 mb-6 flex items-center gap-2">
          <svg class="w-6 h-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5h12M9 3v2m1.048 9.5A18.022 18.022 0 016.412 9m6.088 9h7M11 21l5-10 5 10M12.751 5C11.783 10.77 8.07 15.61 3 18.129" />
          </svg>
          Languages
        </h3>
        <div class="grid md:grid-cols-3 gap-4">
          <div
            v-for="(lang, index) in languages"
            :key="index"
            class="p-4 bg-blue-50 border border-blue-200 rounded-lg"
          >
            <h4 class="font-bold text-gray-900 mb-1">{{ lang.language }}</h4>
            <p class="text-sm text-gray-600 capitalize">{{ lang.proficiency }}</p>
          </div>
        </div>
      </BaseCard>

      <!-- Projects -->
      <BaseCard v-if="projects.length > 0" no-padding class="p-4 mb-4">
        <h3 class="text-2xl font-bold text-gray-900 mb-6 flex items-center gap-2">
          <svg class="w-6 h-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
          </svg>
          Projects
        </h3>
        <div class="space-y-6">
          <div
            v-for="(project, index) in projects"
            :key="index"
            class="pb-6 border-b border-gray-200 last:border-0 last:pb-0"
          >
            <div class="flex items-start justify-between gap-4 mb-2">
              <h4 class="text-lg font-bold text-gray-900">{{ project.title }}</h4>
              <a
                v-if="project.url"
                :href="project.url"
                target="_blank"
                class="text-primary-600 hover:text-primary-700 text-sm flex items-center gap-1 flex-shrink-0"
              >
                View Project
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                </svg>
              </a>
            </div>
            <p v-if="project.start_date || project.end_date" class="text-sm text-gray-600 mb-2">
              {{ formatProjectDate(project) }}
            </p>
            <p v-if="project.description" class="text-gray-700 mb-3 whitespace-pre-line">{{ project.description }}</p>
            <div v-if="project.technologies && project.technologies.length > 0" class="flex flex-wrap gap-2">
              <span
                v-for="(tech, techIndex) in project.technologies"
                :key="techIndex"
                class="px-3 py-1 bg-purple-100 text-purple-700 rounded-full text-xs font-medium"
              >
                {{ tech }}
              </span>
            </div>
          </div>
        </div>
      </BaseCard>

      <!-- Awards -->
      <BaseCard v-if="awards.length > 0" no-padding class="p-4 mb-4">
        <h3 class="text-2xl font-bold text-gray-900 mb-6 flex items-center gap-2">
          <svg class="w-6 h-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z" />
          </svg>
          Awards & Honors
        </h3>
        <div class="grid md:grid-cols-2 gap-4">
          <div
            v-for="(award, index) in awards"
            :key="index"
            class="p-4 bg-amber-50 border border-amber-200 rounded-lg"
          >
            <h4 class="font-bold text-gray-900 mb-1">{{ award.title }}</h4>
            <p class="text-sm text-gray-600 mb-2">{{ award.issuer }}</p>
            <p class="text-xs text-gray-500 mb-2">{{ formatDate(award.date) }}</p>
            <p v-if="award.description" class="text-sm text-gray-700">{{ award.description }}</p>
          </div>
        </div>
      </BaseCard>

      <!-- Publications -->
      <BaseCard v-if="publications.length > 0" no-padding class="p-4 mb-4">
        <h3 class="text-2xl font-bold text-gray-900 mb-6 flex items-center gap-2">
          <svg class="w-6 h-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
          </svg>
          Publications
        </h3>
        <div class="space-y-4">
          <div
            v-for="(pub, index) in publications"
            :key="index"
            class="p-4 bg-indigo-50 border border-indigo-200 rounded-lg"
          >
            <div class="flex items-start justify-between gap-4 mb-2">
              <h4 class="font-bold text-gray-900">{{ pub.title }}</h4>
              <a
                v-if="pub.url"
                :href="pub.url"
                target="_blank"
                class="text-primary-600 hover:text-primary-700 text-sm flex items-center gap-1 flex-shrink-0"
              >
                View
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                </svg>
              </a>
            </div>
            <p class="text-sm text-gray-600 mb-1">{{ pub.publisher }}</p>
            <p class="text-xs text-gray-500 mb-2">{{ formatDate(pub.date) }}</p>
            <p v-if="pub.description" class="text-sm text-gray-700">{{ pub.description }}</p>
          </div>
        </div>
      </BaseCard>

      <!-- Volunteer Work -->
      <BaseCard v-if="volunteerWork.length > 0" no-padding class="p-4 mb-4">
        <h3 class="text-2xl font-bold text-gray-900 mb-6 flex items-center gap-2">
          <svg class="w-6 h-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
          </svg>
          Volunteer Experience
        </h3>
        <div class="space-y-6">
          <div
            v-for="(vol, index) in volunteerWork"
            :key="index"
            class="pb-6 border-b border-gray-200 last:border-0 last:pb-0"
          >
            <h4 class="text-lg font-bold text-gray-900">{{ vol.role }}</h4>
            <p class="text-primary-600 font-medium mb-2">{{ vol.organization }}</p>
            <p v-if="vol.start_date || vol.end_date" class="text-sm text-gray-600 mb-3">
              {{ formatVolunteerDate(vol) }}
            </p>
            <p v-if="vol.description" class="text-gray-700 whitespace-pre-line">{{ vol.description }}</p>
          </div>
        </div>
      </BaseCard>

      <!-- References -->
      <BaseCard v-if="references.length > 0" no-padding class="p-4 mb-4">
        <h3 class="text-2xl font-bold text-gray-900 mb-6 flex items-center gap-2">
          <svg class="w-6 h-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
          </svg>
          References
        </h3>
        <div class="grid md:grid-cols-2 gap-4">
          <div
            v-for="(reference, index) in references"
            :key="index"
            class="p-4 bg-green-50 border border-green-200 rounded-lg"
          >
            <h4 class="font-bold text-gray-900 mb-1">{{ reference.name }}</h4>
            <p class="text-sm text-gray-600 mb-2">{{ reference.position }} at {{ reference.company }}</p>
            <p v-if="reference.relationship" class="text-xs text-gray-500 mb-2">{{ reference.relationship }}</p>
            <div class="space-y-1">
              <a v-if="reference.email" :href="`mailto:${reference.email}`" class="text-xs text-primary-600 hover:text-primary-700 block">
                {{ reference.email }}
              </a>
              <a v-if="reference.phone" :href="`tel:${reference.phone}`" class="text-xs text-primary-600 hover:text-primary-700 block">
                {{ reference.phone }}
              </a>
            </div>
          </div>
        </div>
      </BaseCard>

      <!-- Hobbies & Interests -->
      <BaseCard v-if="hobbies.length > 0" no-padding class="p-4">
        <h3 class="text-2xl font-bold text-gray-900 mb-4 flex items-center gap-2">
          <svg class="w-6 h-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.828 14.828a4 4 0 01-5.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          Hobbies & Interests
        </h3>
        <div class="flex flex-wrap gap-2">
          <span
            v-for="(hobby, index) in hobbies"
            :key="index"
            class="px-4 py-2 bg-pink-100 text-pink-700 rounded-full text-sm font-medium"
          >
            {{ hobby }}
          </span>
        </div>
      </BaseCard>
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
import type { WorkExperience, Education, Project, VolunteerWork } from '@/types'
import BaseCard from '@/components/base/BaseCard.vue'
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
    return `/storage/${profileImage.path}`
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

const projects = computed(() => {
  return cv.value?.projects || []
})

const awards = computed(() => {
  return cv.value?.awards || []
})

const publications = computed(() => {
  return cv.value?.publications || []
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
  return date.toLocaleDateString('en-US', { year: 'numeric', month: 'long' })
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

const formatProjectDate = (project: Project) => {
  const start = formatDate(project.start_date || '')
  const end = formatDate(project.end_date || '')
  return end ? `${start} - ${end}` : start
}

const formatVolunteerDate = (vol: VolunteerWork) => {
  const start = formatDate(vol.start_date)
  const end = formatDate(vol.end_date || '')
  return end ? `${start} - ${end}` : start
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
