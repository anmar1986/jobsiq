<template>
  <div class="mb-8">
    <label class="block text-sm font-semibold text-gray-700 mb-4">
      Profile Image
    </label>
    
    <div class="flex items-center gap-6">
      <!-- Image Preview -->
      <div class="relative">
        <div class="w-32 h-32 rounded-full overflow-hidden bg-gray-100 border-4 border-gray-200 flex items-center justify-center">
          <img
            v-if="previewUrl"
            :src="previewUrl"
            alt="Profile preview"
            class="w-full h-full object-cover"
          />
          <svg v-else class="w-16 h-16 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
          </svg>
        </div>
        
        <!-- Remove Button -->
        <button
          v-if="previewUrl"
          type="button"
          @click="removeImage"
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
          ref="fileInput"
          type="file"
          accept="image/jpeg,image/jpg,image/png,image/webp,image/gif"
          class="hidden"
          @change="handleFileChange"
        />
        
        <BaseButton
          type="button"
          variant="outline"
          @click="triggerFileInput"
        >
          <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
          </svg>
          Choose Image
        </BaseButton>
        
        <p class="text-xs text-gray-500 mt-2">
          Recommended: Square image, at least 400x400px
        </p>
        <p class="text-xs text-gray-500">
          Max file size: 2MB. Formats: JPG, PNG, WebP, GIF
        </p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import BaseButton from '@/components/base/BaseButton.vue'

interface Props {
  modelValue: File | null
  preview?: string | null
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'update:modelValue': [value: File | null]
  'update:preview': [value: string | null]
  'error': [message: string]
}>()

const fileInput = ref<HTMLInputElement | null>(null)
const localPreview = ref<string | null>(props.preview || null)

const previewUrl = computed(() => {
  const preview = localPreview.value
  if (!preview) {
    return null
  }

  // Respect inline data/blob URLs and fully qualified paths
  if (preview.startsWith('data:') || preview.startsWith('blob:') || preview.startsWith('http')) {
    return preview
  }

  if (preview.startsWith('/storage/')) {
    return preview
  }

  // Remove all leading slashes and construct clean path
  const cleanPath = preview.replace(/^\/+/, '')
  return `/storage/${cleanPath}`
})

watch(() => props.preview, (newPreview) => {
  localPreview.value = newPreview || null
})

const triggerFileInput = () => {
  fileInput.value?.click()
}

const handleFileChange = (event: Event) => {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  
  if (!file) return
  
  // Validate file type
  const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp', 'image/gif']
  if (!validTypes.includes(file.type)) {
    emit('error', 'Invalid file type. Please upload a JPG, PNG, WebP, or GIF image.')
    return
  }
  
  // Validate file size (2MB)
  if (file.size > 2 * 1024 * 1024) {
    emit('error', 'File size too large. Please upload an image smaller than 2MB.')
    return
  }
  
  // Emit the file IMMEDIATELY (file object is ready)
  emit('update:modelValue', file)
  
  // Create preview URL asynchronously (doesn't affect file upload)
  const reader = new FileReader()
  reader.onload = (e) => {
    const result = e.target?.result as string
    localPreview.value = result
    emit('update:preview', result)
  }
  reader.readAsDataURL(file)
}

const removeImage = () => {
  localPreview.value = null
  emit('update:modelValue', null)
  emit('update:preview', null)
  
  if (fileInput.value) {
    fileInput.value.value = ''
  }
}
</script>
