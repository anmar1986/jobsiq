<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <!-- Basic Information Section -->
    <div class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">{{ $t('companies.basicInformation') }}</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div class="md:col-span-2">
          <BaseInput
            v-model="formData.name"
            :label="$t('companies.companyNameRequired')"
            :placeholder="$t('companies.enterCompanyName')"
            :error="errors.name"
            required
          />
        </div>

        <div class="md:col-span-2">
          <label for="company-logo-input" class="block text-sm font-medium text-gray-700 mb-2">
            {{ $t('companies.companyLogo') }}
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
                id="company-logo-input"
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
                {{ $t('companies.chooseLogo') }}
              </BaseButton>
              
              <p class="text-xs text-gray-500 mt-2">
                {{ $t('companies.pngJpgGifUpTo2MB') }}
              </p>
              <p v-if="errors.logo" class="text-red-600 text-sm mt-1">{{ errors.logo }}</p>
            </div>
          </div>
        </div>

        <div class="md:col-span-2">
          <label for="company-cover-input" class="block text-sm font-medium text-gray-700 mb-2">
            {{ $t('companies.coverImage') }}
          </label>
          
          <div class="flex items-center gap-6">
            <!-- Cover Preview -->
            <div class="relative">
              <div class="w-32 h-32 rounded-lg overflow-hidden bg-gray-100 border-2 border-gray-200 flex items-center justify-center">
                <img
                  v-if="coverPreview"
                  :src="coverPreview"
                  alt="Cover preview"
                  class="w-full h-full object-cover"
                />
                <svg v-else class="w-12 h-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
              </div>
              
              <!-- Remove Button -->
              <button
                v-if="coverPreview"
                type="button"
                @click="removeCover"
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
                id="company-cover-input"
                ref="coverInput"
                type="file"
                accept="image/*"
                class="hidden"
                @change="handleCoverChange"
              />
              
              <BaseButton
                type="button"
                variant="outline"
                @click="triggerCoverInput"
              >
                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
                {{ $t('companies.chooseCoverImage') }}
              </BaseButton>
              
              <p class="text-xs text-gray-500 mt-2">
                {{ $t('companies.pngJpgGifUpTo2MB') }}
              </p>
              <p v-if="errors.cover" class="text-red-600 text-sm mt-1">{{ errors.cover }}</p>
            </div>
          </div>
        </div>

        <div class="md:col-span-2">
          <label for="company-images-input" class="block text-sm font-medium text-gray-700 mb-2">
            {{ $t('companies.companyPictures') }}
            <span class="text-gray-500 text-xs font-normal ml-2">{{ $t('companies.maximum10Images') }}</span>
          </label>
          
          <!-- Image Upload Area -->
          <div class="mb-4">
            <input
              id="company-images-input"
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
                <span class="font-medium text-primary-600">{{ $t('common.upload') }}</span> or drag and drop
              </p>
              <p class="text-xs text-gray-500 mt-1">{{ $t('companies.pngJpgGifUpTo2MBEach') }}</p>
              <p class="text-xs text-gray-500 mt-1">{{ $t('companies.imagesUploaded', { count: companyImages.length }) }}</p>
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
          <label for="company-about" class="block text-sm font-medium text-gray-700 mb-1">
            {{ $t('companies.about') }}
          </label>
          <textarea
            id="company-about"
            v-model="formData.about"
            rows="4"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            :placeholder="$t('companies.briefOverviewCompany')"
          />
          <p v-if="errors.about" class="text-red-600 text-sm mt-1">{{ errors.about }}</p>
        </div>

        <div class="md:col-span-2">
          <label for="company-description" class="block text-sm font-medium text-gray-700 mb-1">
            {{ $t('companies.description') }}
          </label>
          <textarea
            id="company-description"
            v-model="formData.description"
            rows="4"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            :placeholder="$t('companies.tellUsAboutCompany')"
          />
          <p v-if="errors.description" class="text-red-600 text-sm mt-1">{{ errors.description }}</p>
        </div>

        <BaseInput
          v-model="formData.tagline"
          :label="$t('companies.tagline')"
          :placeholder="$t('companies.taglinePlaceholder')"
          :error="errors.tagline"
        />

        <BaseInput
          v-model="formData.website"
          :label="$t('common.website')"
          type="url"
          :placeholder="$t('companies.websitePlaceholder')"
          :error="errors.website"
        />
      </div>
    </div>

    <!-- Contact Information Section -->
    <div class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">{{ $t('companies.contactInformation') }}</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <BaseInput
          v-model="formData.email"
          :label="$t('common.email')"
          type="email"
          :placeholder="$t('companies.emailPlaceholder')"
          :error="errors.email"
        />

        <BaseInput
          v-model="formData.phone"
          :label="$t('common.phone')"
          :placeholder="$t('companies.phonePlaceholder')"
          :error="errors.phone"
        />
      </div>
    </div>

    <!-- Address Section -->
    <div class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">{{ $t('companies.address') }}</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div class="md:col-span-2">
          <BaseInput
            v-model="formData.street"
            :label="$t('companies.streetAddress')"
            :placeholder="$t('jobs.streetAddressPlaceholder')"
            :error="errors.street"
          />
        </div>

        <BaseAutocomplete
          v-model="formData.city"
          :options="iraqCities"
          :label="$t('common.city')"
          :placeholder="$t('companies.typeToSearchCities')"
          required
          :error="errors.city"
        />

        <BaseInput
          v-model="formData.country"
          :label="$t('common.country')"
          value="Iraq"
          readonly
          :error="errors.country"
        />
      </div>
    </div>

    <!-- Business Information Section -->
    <div class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">{{ $t('companies.companyDetails') }}</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label for="company-category" class="block text-sm font-medium text-gray-700 mb-1">
            {{ $t('companies.category') }} *
          </label>
          <select
            id="company-category"
            v-model="formData.category"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            required
            @invalid="handleInvalid"
            @change="handleInput"
          >
            <option value="">{{ $t('companies.selectCategory') }}</option>
            <option v-for="category in companyCategories" :key="category" :value="category">
              {{ category }}
            </option>
          </select>
          <p v-if="errors.category" class="text-red-600 text-sm mt-1">{{ errors.category }}</p>
        </div>

        <div>
          <label for="company-size" class="block text-sm font-medium text-gray-700 mb-1">
            {{ $t('companies.companySize') }}
          </label>
          <select
            id="company-size"
            v-model="formData.company_size"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          >
            <option value="">{{ $t('companies.selectCompanySize') }}</option>
            <option value="1-10">1-10 employees</option>
            <option value="11-50">11-50 employees</option>
            <option value="51-200">51-200 employees</option>
            <option value="201-500">201-500 employees</option>
            <option value="501-1000">501-1000 employees</option>
            <option value="1000+">1000+ employees</option>
          </select>
        </div>

        <div>
          <label for="company-type" class="block text-sm font-medium text-gray-700 mb-1">
            {{ $t('companies.companyType') }}
          </label>
          <select
            id="company-type"
            v-model="formData.company_type"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          >
            <option value="">{{ $t('companies.selectType') }}</option>
            <option value="startup">{{ $t('companies.startup') }}</option>
            <option value="small_business">{{ $t('companies.smallBusiness') }}</option>
            <option value="mid_market">{{ $t('companies.midMarket') }}</option>
            <option value="enterprise">{{ $t('companies.enterprise') }}</option>
            <option value="nonprofit">{{ $t('companies.nonprofit') }}</option>
            <option value="government">{{ $t('companies.government') }}</option>
            <option value="agency">{{ $t('companies.agency') }}</option>
          </select>
        </div>

        <BaseInput
          v-model="formData.total_employees"
          :label="$t('companies.totalEmployees')"
          type="number"
          min="0"
          :placeholder="$t('companies.employeesPlaceholder')"
          :error="errors.total_employees"
        />
      </div>
    </div>

    <!-- Social Media Section -->
    <div class="bg-white p-6 rounded-lg border border-gray-200">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">{{ $t('companies.socialMedia') }}</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <BaseInput
          v-model="formData.linkedin"
          :label="$t('companies.linkedin')"
          type="url"
          :placeholder="$t('companies.linkedinPlaceholder')"
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
          :label="$t('companies.twitter')"
          type="url"
          :placeholder="$t('companies.twitterPlaceholder')"
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
          :label="$t('companies.facebook')"
          type="url"
          :placeholder="$t('companies.facebookPlaceholder')"
          :error="errors.facebook"
        />

        <BaseInput
          v-model="formData.instagram"
          :label="$t('companies.instagram')"
          type="url"
          :placeholder="$t('companies.instagramPlaceholder')"
          :error="errors.instagram"
        >
          <template #icon-left>
            <svg class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z" />
            </svg>
          </template>
        </BaseInput>

        <BaseInput
          v-model="formData.youtube"
          :label="$t('companies.youtube')"
          type="url"
          :placeholder="$t('companies.youtubePlaceholder')"
          :error="errors.youtube"
        >
          <template #icon-left>
            <svg class="h-5 w-5 text-gray-400" fill="currentColor" viewBox="0 0 24 24">
              <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z" />
            </svg>
          </template>
        </BaseInput>
      </div>
    </div>

    <!-- Status Section -->
    <!-- Company Status -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
      <h3 class="text-lg font-semibold text-gray-900 mb-4">{{ $t('companies.companyStatus') }}</h3>
      <div class="space-y-4">
        <!-- Is Active -->
        <div class="flex items-start">
          <div class="flex items-center h-5">
            <input
              id="is_active"
              v-model="formData.is_active"
              type="checkbox"
              class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
            />
          </div>
          <div class="ml-3 text-sm">
            <label for="is_active" class="font-medium text-gray-700">{{ $t('companies.companyActive') }}</label>
            <p class="text-gray-500">{{ $t('companies.companyActiveDescription') }}</p>
          </div>
        </div>

        <!-- Is Hiring -->
        <div class="flex items-start">
          <div class="flex items-center h-5">
            <input
              id="is_hiring"
              v-model="formData.is_hiring"
              type="checkbox"
              class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
            />
          </div>
          <div class="ml-3 text-sm">
            <label for="is_hiring" class="font-medium text-gray-700">{{ $t('companies.currentlyHiring') }}</label>
            <p class="text-gray-500">{{ $t('companies.currentlyHiringDescription') }}</p>
          </div>
        </div>
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
        {{ $t('common.cancel') }}
      </BaseButton>
      <BaseButton
        type="submit"
        variant="primary"
        :loading="loading"
      >
        {{ isEdit ? $t('companies.updateCompany') : $t('companies.createCompany') }}
      </BaseButton>
    </div>
  </form>
</template>

<script setup lang="ts">
import { ref, reactive, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import type { Company } from '@/types'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'
import BaseAutocomplete from '@/components/base/BaseAutocomplete.vue'
import { companyCategories } from '@/config/companyCategories'
import { iraqCities } from '@/config/iraqCities'

const { t: $t } = useI18n()

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

// Validation handler
const handleInvalid = (e: Event) => {
  const target = e.target as HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement
  if (target.validity.valueMissing) {
    target.setCustomValidity($t('validation.fieldRequired'))
  }
}

const handleInput = (e: Event) => {
  const target = e.target as HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement
  target.setCustomValidity('')
}

const formData = reactive({
  name: '',
  about: '',
  description: '',
  tagline: '',
  website: '',
  email: '',
  phone: '',
  street: '',
  city: '',
  country: 'Iraq',
  postal_code: '',
  category: '',
  company_size: '',
  company_type: '',
  total_employees: '',
  linkedin: '',
  twitter: '',
  facebook: '',
  instagram: '',
  youtube: '',
  is_active: true,
  is_hiring: true,
})

const errors = reactive<Record<string, string>>({})
const logoFile = ref<File | null>(null)
const logoPreview = ref<string | null>(null)
const logoInput = ref<HTMLInputElement | null>(null)
const coverFile = ref<File | null>(null)
const coverPreview = ref<string | null>(null)
const coverInput = ref<HTMLInputElement | null>(null)
const imagesInput = ref<HTMLInputElement | null>(null)

interface GalleryImage {
  file: File | null
  preview: string
  isExisting?: boolean
}

const companyImages = ref<GalleryImage[]>([])

// Initialize form with existing company data if editing
watch(() => props.company, (company) => {
  if (company) {
    Object.assign(formData, {
      name: company.name || '',
      about: company.about || '',
      description: company.description || '',
      tagline: company.tagline || '',
      website: company.website || '',
      email: company.email || '',
      phone: company.phone || '',
      street: company.street || '',
      city: company.city || '',
      country: company.country || 'Iraq',
      postal_code: company.postal_code || '',
      category: company.industry || '',
      company_size: company.company_size || '',
      company_type: company.company_type || '',
      total_employees: company.total_employees?.toString() || '',
      linkedin: company.linkedin || '',
      twitter: company.twitter || '',
      facebook: company.facebook || '',
      instagram: company.instagram || '',
      youtube: company.youtube || '',
      is_active: company.is_active ?? true,
      is_hiring: company.is_hiring ?? true,
    })
    
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
    
    // Initialize cover preview if exists
    if (company.cover) {
      const path = company.cover.path
      // Handle different path formats
      if (path.startsWith('data:') || path.startsWith('blob:') || path.startsWith('http')) {
        coverPreview.value = path
      } else if (path.startsWith('/storage/')) {
        coverPreview.value = path
      } else {
        // Remove leading slashes and construct clean path
        const cleanPath = path.replace(/^\/+/, '')
        coverPreview.value = `/storage/${cleanPath}`
      }
    }
    
    // Initialize company images if exists
    if (company.images && company.images.length > 0) {
      // Filter out the logo and cover images and only show gallery images
      const galleryImages = company.images.filter(img => img.type !== 'logo' && img.type !== 'cover')
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
          file: null, // No file object for existing images
          preview: preview,
          isExisting: true // Explicitly mark as existing image
        }
      })
    }
  }
}, { immediate: true })

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

const triggerCoverInput = () => {
  coverInput.value?.click()
}

const handleCoverChange = (event: Event) => {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  
  if (!file) return
  
  // Validate file type
  const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/svg+xml']
  if (!validTypes.includes(file.type)) {
    errors.cover = 'Invalid file type. Please upload a JPG, PNG, GIF, or SVG image.'
    return
  }
  
  // Validate file size (2MB)
  const maxSize = 2 * 1024 * 1024
  if (file.size > maxSize) {
    errors.cover = 'File size too large. Please upload an image smaller than 2MB.'
    return
  }
  
  // Clear any previous errors
  delete errors.cover
  
  // Set the file
  coverFile.value = file
  
  // Create preview
  const reader = new FileReader()
  reader.onload = (e) => {
    coverPreview.value = e.target?.result as string
  }
  reader.readAsDataURL(file)
}

const removeCover = () => {
  coverFile.value = null
  coverPreview.value = null
  if (coverInput.value) {
    coverInput.value.value = ''
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
        preview: e.target?.result as string,
        isExisting: false // Mark as new upload
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
    // Handle boolean values
    if (typeof value === 'boolean') {
      data.append(key, value ? '1' : '0')
    } else if (value !== null && value !== undefined && value.toString().trim() !== '') {
      // Map category to industry for backend compatibility
      if (key === 'category') {
        data.append('industry', value.toString())
      } else {
        data.append(key, value.toString())
      }
    }
  })

  // Append logo if selected
  if (logoFile.value) {
    data.append('logo', logoFile.value)
  }

  // Append cover if selected
  if (coverFile.value) {
    data.append('cover', coverFile.value)
  }

  // Append company images if selected (only new uploads, not existing images)
  if (companyImages.value.length > 0) {
    const newImages = companyImages.value.filter(image => !image.isExisting && image.file !== null)
    newImages.forEach((image, index) => {
      data.append(`images[${index}]`, image.file!)
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
