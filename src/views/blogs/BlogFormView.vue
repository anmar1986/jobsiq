<template>
  <div class="min-h-screen bg-gray-50 py-8">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- Header -->
      <div class="mb-8">
        <button @click="router.push('/blogs')" class="flex items-center text-gray-600 hover:text-gray-900 mb-4">
          <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
          </svg>
          Back to Blogs
        </button>
        <h1 class="text-3xl font-bold text-gray-900">{{ isEdit ? 'Edit Blog' : 'Create New Blog' }}</h1>
        <p class="mt-2 text-gray-600">{{ isEdit ? 'Update your blog post' : 'Share your knowledge and insights' }}</p>
      </div>

      <!-- Error Messages -->
      <div v-if="error" class="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg">
        <p class="text-red-600">{{ error }}</p>
      </div>

      <!-- Blog Form -->
      <div class="bg-white rounded-lg shadow-md p-6 md:p-8">
        <form @submit.prevent="saveBlog" class="space-y-6">
          <!-- Title -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Title <span class="text-red-500">*</span>
            </label>
            <input
              v-model="formData.title"
              type="text"
              required
              placeholder="Enter blog title"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <!-- Category -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Category</label>
            <input
              v-model="formData.category"
              type="text"
              placeholder="e.g., Career Tips, Interview Advice, Resume Tips"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
            <p class="mt-1 text-sm text-gray-500">Choose a category that best describes your blog post</p>
          </div>

          <!-- Excerpt -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Excerpt</label>
            <textarea
              v-model="formData.excerpt"
              rows="3"
              placeholder="Brief description of the blog post (will be shown in listings)"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            ></textarea>
          </div>

          <!-- Content -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Content <span class="text-red-500">*</span>
            </label>
            <textarea
              v-model="formData.content"
              rows="16"
              required
              placeholder="Write your blog content here... You can use markdown formatting."
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent font-mono text-sm"
            ></textarea>
            <p class="mt-1 text-sm text-gray-500">Minimum 100 characters recommended</p>
          </div>

          <!-- Featured Image -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Featured Image</label>
            <input
              type="file"
              accept="image/*"
              @change="handleImageUpload"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
            <p class="mt-1 text-sm text-gray-500">Upload a cover image for your blog post (JPG, PNG, GIF)</p>
            
            <!-- Image Preview -->
            <div v-if="imagePreview || formData.featured_image" class="mt-3">
              <p class="text-sm text-gray-600 mb-2">Preview:</p>
              <img 
                :src="imagePreview || formData.featured_image" 
                alt="Preview" 
                class="max-w-full h-48 object-cover rounded-lg border border-gray-300"
              />
              <button
                type="button"
                @click="removeImage"
                class="mt-2 text-sm text-red-600 hover:text-red-800"
              >
                Remove Image
              </button>
            </div>
          </div>

          <!-- Tags -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Tags</label>
            <input
              v-model="tagsInput"
              type="text"
              placeholder="jobs, career, interview, tips (comma-separated)"
              class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
            <p class="mt-1 text-sm text-gray-500">Separate tags with commas</p>
          </div>

          <!-- Status -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Status <span class="text-red-500">*</span>
            </label>
            <div class="flex gap-4">
              <label class="flex items-center">
                <input
                  v-model="formData.status"
                  type="radio"
                  value="draft"
                  class="mr-2"
                />
                <span class="text-gray-700">Draft</span>
              </label>
              <label class="flex items-center">
                <input
                  v-model="formData.status"
                  type="radio"
                  value="published"
                  class="mr-2"
                />
                <span class="text-gray-700">Published</span>
              </label>
            </div>
            <p class="mt-1 text-sm text-gray-500">Drafts are only visible to you</p>
          </div>

          <!-- Action Buttons -->
          <div class="flex gap-4 pt-6 border-t border-gray-200">
            <BaseButton
              type="submit"
              :disabled="saving"
              class="flex-1 md:flex-initial md:px-8"
            >
              <span v-if="saving">Saving...</span>
              <span v-else>{{ isEdit ? 'Update Blog' : 'Create Blog' }}</span>
            </BaseButton>
            <BaseButton
              type="button"
              variant="outline"
              @click="router.push('/blogs')"
              class="flex-1 md:flex-initial md:px-8"
            >
              Cancel
            </BaseButton>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { blogService } from '@/services/blogService'
import { useToast } from '@/composables/useToast'
import type { BlogFormData } from '@/types/blog'
import BaseButton from '@/components/base/BaseButton.vue'

const router = useRouter()
const route = useRoute()
const { success, error: showErrorToast } = useToast()

const isEdit = ref(false)
const blogId = ref<number | null>(null)
const saving = ref(false)
const error = ref('')
const imagePreview = ref('')
const selectedImageFile = ref<File | null>(null)

const formData = ref<BlogFormData>({
  title: '',
  excerpt: '',
  content: '',
  featured_image: '',
  category: '',
  tags: [],
  status: 'draft',
})

const tagsInput = ref('')

onMounted(async () => {
  // Check if we're editing
  const id = route.params.id as string
  if (id) {
    isEdit.value = true
    blogId.value = parseInt(id)
    await loadBlog(blogId.value)
  }
})

async function loadBlog(id: number) {
  try {
    // We need to get the blog by ID, but our API uses slug
    // For now, we'll redirect to blogs page and handle edit from there
    // Or we could add a new API endpoint to get by ID
    const response = await blogService.getBlogs()
    const blog = response.data.find(b => b.id === id)
    
    if (blog) {
      formData.value = {
        title: blog.title,
        excerpt: blog.excerpt || '',
        content: blog.content,
        featured_image: blog.featured_image || '',
        category: blog.category || '',
        tags: blog.tags || [],
        status: blog.status,
      }
      tagsInput.value = blog.tags?.join(', ') || ''
    } else {
      error.value = 'Blog not found'
    }
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to load blog'
  }
}

function handleImageUpload(event: Event) {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  
  if (file) {
    if (!file.type.startsWith('image/')) {
      error.value = 'Please select a valid image file'
      return
    }
    
    if (file.size > 5 * 1024 * 1024) { // 5MB limit
      error.value = 'Image size must be less than 5MB'
      return
    }
    
    selectedImageFile.value = file
    
    // Create preview
    const reader = new FileReader()
    reader.onload = (e) => {
      imagePreview.value = e.target?.result as string
    }
    reader.readAsDataURL(file)
  }
}

function removeImage() {
  selectedImageFile.value = null
  imagePreview.value = ''
  formData.value.featured_image = ''
}

async function uploadImage(file: File): Promise<string> {
  const formData = new FormData()
  formData.append('image', file)
  
  try {
    const response = await blogService.uploadImage(formData)
    return response.path
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to upload image'
    throw err
  }
}

async function saveBlog() {
  try {
    saving.value = true
    error.value = ''

    // Process tags
    if (tagsInput.value) {
      formData.value.tags = tagsInput.value
        .split(',')
        .map(tag => tag.trim())
        .filter(tag => tag)
    } else {
      formData.value.tags = []
    }

    // Validate
    if (formData.value.title.length < 3) {
      error.value = 'Title must be at least 3 characters'
      return
    }

    if (formData.value.content.length < 50) {
      error.value = 'Content must be at least 50 characters'
      return
    }

    // Upload image if selected
    if (selectedImageFile.value) {
      const uploadedPath = await uploadImage(selectedImageFile.value)
      formData.value.featured_image = uploadedPath
    }

    if (isEdit.value && blogId.value) {
      await blogService.updateBlog(blogId.value, formData.value)
      success('Blog updated successfully!')
    } else {
      await blogService.createBlog(formData.value)
      success('Blog created successfully!')
    }

    // Small delay to show the toast before navigation
    setTimeout(() => {
      router.push('/blogs')
    }, 500)
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to save blog'
    showErrorToast(error.value)
  } finally {
    saving.value = false
  }
}
</script>
