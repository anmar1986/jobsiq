<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Loading State -->
    <div v-if="loading" class="max-w-4xl mx-auto px-4 py-12">
      <div class="text-center">
        <div class="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        <p class="mt-4 text-gray-600">Loading blog...</p>
      </div>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="max-w-4xl mx-auto px-4 py-12">
      <div class="text-center">
        <p class="text-red-600 mb-4">{{ error }}</p>
        <BaseButton @click="router.push('/blogs')">Back to Blogs</BaseButton>
      </div>
    </div>

    <!-- Blog Content -->
    <article v-else-if="blog" class="max-w-4xl mx-auto px-4 py-8">
      <!-- Back Button -->
      <button @click="router.push('/blogs')" class="flex items-center text-gray-600 hover:text-gray-900 mb-6">
        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
        </svg>
        Back to Blogs
      </button>

      <!-- Featured Image -->
      <div v-if="blog.featured_image" class="mb-8 rounded-lg overflow-hidden">
        <img :src="getImageUrl(blog.featured_image)" :alt="blog.title" class="w-full h-96 object-cover" />
      </div>

      <!-- Status and Category Badges -->
      <div class="flex gap-2 mb-4">
        <span v-if="blog.status === 'draft'" class="inline-block px-4 py-1 text-sm font-semibold text-orange-600 bg-orange-100 rounded-full">
          Draft - Not Published
        </span>
        <span v-if="blog.category" class="inline-block px-4 py-1 text-sm font-semibold text-blue-600 bg-blue-100 rounded-full">
          {{ blog.category }}
        </span>
      </div>

      <!-- Title -->
      <h1 class="text-4xl font-bold text-gray-900 mb-4">{{ blog.title }}</h1>

      <!-- Meta Info -->
      <div class="flex items-center text-gray-600 mb-8 pb-8 border-b border-gray-200">
        <div class="flex items-center">
          <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
          </svg>
          <span>{{ blog.user?.name }}</span>
        </div>
        <span class="mx-3">•</span>
        <div class="flex items-center">
          <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
          </svg>
          <span>{{ formatDate(blog.published_at) }}</span>
        </div>
        <span class="mx-3">•</span>
        <div class="flex items-center">
          <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
          </svg>
          <span>{{ blog.views }} views</span>
        </div>
      </div>

      <!-- Excerpt -->
      <div v-if="blog.excerpt" class="text-xl text-gray-600 mb-8 italic">
        {{ blog.excerpt }}
      </div>

      <!-- Content -->
      <div class="prose prose-lg max-w-none mb-8">
        <div class="text-gray-800 leading-relaxed whitespace-pre-line">{{ blog.content }}</div>
      </div>

      <!-- Tags -->
      <div v-if="blog.tags && blog.tags.length > 0" class="flex flex-wrap gap-2 mb-8">
        <span
          v-for="tag in blog.tags"
          :key="tag"
          class="px-3 py-1 bg-gray-100 text-gray-700 rounded-full text-sm"
        >
          #{{ tag }}
        </span>
      </div>

      <!-- Actions (if author) -->
      <div v-if="authStore.user?.id === blog.user_id" class="flex gap-3 pt-8 border-t border-gray-200">
        <BaseButton @click="editBlog" class="flex items-center gap-2">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
          </svg>
          Edit Blog
        </BaseButton>
        <BaseButton @click="showDeleteModal = true" variant="outline" class="flex items-center gap-2 text-red-600 border-red-600 hover:bg-red-50">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
          </svg>
          Delete Blog
        </BaseButton>
      </div>
    </article>

    <!-- Delete Confirmation Modal -->
    <div v-if="showDeleteModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div class="bg-white rounded-lg max-w-md w-full p-6">
        <h3 class="text-xl font-bold mb-4">Delete Blog</h3>
        <p class="text-gray-600 mb-6">Are you sure you want to delete this blog? This action cannot be undone.</p>
        <div class="flex gap-3">
          <button
            @click="deleteBlog"
            class="flex-1 px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors font-medium"
          >
            Delete
          </button>
          <BaseButton @click="showDeleteModal = false" variant="outline" class="flex-1">
            Cancel
          </BaseButton>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { blogService } from '@/services/blogService'
import { useToast } from '@/composables/useToast'
import type { Blog } from '@/types/blog'
import BaseButton from '@/components/base/BaseButton.vue'

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()
const { success, error: showErrorToast } = useToast()

const blog = ref<Blog | null>(null)
const loading = ref(true)
const error = ref('')
const showDeleteModal = ref(false)

onMounted(async () => {
  await loadBlog()
})

async function loadBlog() {
  try {
    loading.value = true
    error.value = ''
    const slug = route.params.slug as string
    blog.value = await blogService.getBlog(slug)
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to load blog'
  } finally {
    loading.value = false
  }
}

function editBlog() {
  router.push(`/blogs/edit/${blog.value?.id}`)
}

function getImageUrl(path: string): string {
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return path
  }
  return `/storage/${path}`
}

async function deleteBlog() {
  if (!blog.value) return
  
  try {
    await blogService.deleteBlog(blog.value.id)
    success('Blog deleted successfully!')
    setTimeout(() => {
      router.push('/blogs')
    }, 500)
  } catch (err) {
    const errorMessage = err instanceof Error ? err.message : 'Failed to delete blog'
    showErrorToast(errorMessage)
    showDeleteModal.value = false
  }
}

function formatDate(date: string | null) {
  if (!date) return ''
  return new Date(date).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })
}
</script>
