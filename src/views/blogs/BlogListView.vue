<template>
  <div class="min-h-screen bg-gray-50 py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- Header -->
      <div class="mb-8">
        <div class="flex justify-between items-center">
          <div>
            <h1 class="text-3xl font-bold text-gray-900">Blog & Tips</h1>
            <p class="mt-2 text-gray-600">Career advice, tips, and industry insights</p>
          </div>
          <BaseButton @click="router.push('/blogs/create')" class="flex items-center gap-2">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
            Create Blog
          </BaseButton>
        </div>
      </div>

      <!-- Search and Filters -->
      <div class="mb-6 flex flex-col sm:flex-row gap-4">
        <div class="flex-1">
          <BaseInput
            v-model="searchQuery"
            placeholder="Search blogs..."
            @input="handleSearch"
          />
        </div>
        <select
          v-model="selectedCategory"
          @change="handleCategoryChange"
          class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
        >
          <option value="">All Categories</option>
          <option v-for="category in categories" :key="category" :value="category">
            {{ category }}
          </option>
        </select>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="text-center py-12">
        <div class="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        <p class="mt-4 text-gray-600">Loading blogs...</p>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="text-center py-12">
        <p class="text-red-600">{{ error }}</p>
      </div>

      <!-- Blog Grid -->
      <div v-else-if="blogs.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div
          v-for="blog in blogs"
          :key="blog.id"
          class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300"
        >
          <!-- Featured Image -->
          <div v-if="blog.featured_image" class="h-48 bg-gray-200">
            <img :src="getImageUrl(blog.featured_image)" :alt="blog.title" class="w-full h-full object-cover" />
          </div>
          <div v-else class="h-48 bg-gradient-to-br from-blue-500 to-purple-600"></div>

          <!-- Content -->
          <div class="p-6">
            <!-- Status and Category Badges -->
            <div class="flex gap-2 mb-3 flex-wrap">
              <!-- Status Badge -->
              <span 
                v-if="blog.status === 'draft'" 
                class="inline-flex items-center px-3 py-1 text-xs font-semibold text-orange-700 bg-orange-100 border border-orange-200 rounded-full"
              >
                <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                  <path d="M10 2a6 6 0 00-6 6v3.586l-.707.707A1 1 0 004 14h12a1 1 0 00.707-1.707L16 11.586V8a6 6 0 00-6-6zM10 18a3 3 0 01-3-3h6a3 3 0 01-3 3z" />
                </svg>
                Private (Draft)
              </span>
              <span 
                v-else 
                class="inline-flex items-center px-3 py-1 text-xs font-semibold text-green-700 bg-green-100 border border-green-200 rounded-full"
              >
                <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                </svg>
                Public (Published)
              </span>
              
              <!-- Category Badge -->
              <span v-if="blog.category" class="inline-block px-3 py-1 text-xs font-semibold text-blue-600 bg-blue-100 rounded-full">
                {{ blog.category }}
              </span>
            </div>

            <!-- Title -->
            <h2 class="text-xl font-bold text-gray-900 mb-2 line-clamp-2 cursor-pointer hover:text-blue-600" @click="viewBlog(blog.slug)">
              {{ blog.title }}
            </h2>

            <!-- Excerpt -->
            <p class="text-gray-600 mb-4 line-clamp-3">{{ blog.excerpt }}</p>

            <!-- Meta Info -->
            <div class="flex items-center justify-between text-sm text-gray-500 mb-4">
              <span>{{ blog.user?.name }}</span>
              <span>{{ formatDate(blog.published_at) }}</span>
            </div>

            <!-- Tags -->
            <div v-if="blog.tags && blog.tags.length > 0" class="flex flex-wrap gap-2 mb-4">
              <span
                v-for="tag in blog.tags.slice(0, 3)"
                :key="tag"
                class="text-xs px-2 py-1 bg-gray-100 text-gray-600 rounded"
              >
                #{{ tag }}
              </span>
            </div>

            <!-- Actions -->
            <div class="flex items-center gap-2">
              <BaseButton @click="viewBlog(blog.slug)" size="sm" variant="outline" class="flex-1">
                Read More
              </BaseButton>
              
              <button
                @click="router.push(`/blogs/edit/${blog.id}`)"
                class="p-2 text-blue-600 hover:bg-blue-50 rounded transition-colors"
                title="Edit"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                </svg>
              </button>
              <button
                @click="confirmDelete(blog)"
                class="p-2 text-red-600 hover:bg-red-50 rounded transition-colors"
                title="Delete"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                </svg>
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Empty State -->
      <div v-else class="text-center py-12">
        <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
        </svg>
        <h3 class="mt-2 text-lg font-medium text-gray-900">No blogs found</h3>
        <p class="mt-1 text-gray-500">Try adjusting your search or filters</p>
      </div>

      <!-- Pagination -->
      <div v-if="pagination && pagination.last_page > 1" class="mt-8 flex justify-center">
        <nav class="flex gap-2">
          <button
            @click="goToPage(pagination.current_page - 1)"
            :disabled="!pagination.prev_page_url"
            class="px-4 py-2 border border-gray-300 rounded-lg disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-50"
          >
            Previous
          </button>
          
          <button
            v-for="page in visiblePages"
            :key="page"
            @click="goToPage(page)"
            :class="[
              'px-4 py-2 border rounded-lg',
              page === pagination.current_page
                ? 'bg-blue-600 text-white border-blue-600'
                : 'border-gray-300 hover:bg-gray-50'
            ]"
          >
            {{ page }}
          </button>
          
          <button
            @click="goToPage(pagination.current_page + 1)"
            :disabled="!pagination.next_page_url"
            class="px-4 py-2 border border-gray-300 rounded-lg disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-50"
          >
            Next
          </button>
        </nav>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div v-if="showDeleteModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div class="bg-white rounded-lg max-w-md w-full p-6">
        <h3 class="text-xl font-bold mb-4">Delete Blog</h3>
        <p class="text-gray-600 mb-6">Are you sure you want to delete "{{ blogToDelete?.title }}"? This action cannot be undone.</p>
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
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { blogService } from '@/services/blogService'
import { useToast } from '@/composables/useToast'
import type { Blog, BlogPagination } from '@/types/blog'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseButton from '@/components/base/BaseButton.vue'

const router = useRouter()
const { success, error: showErrorToast } = useToast()

const blogs = ref<Blog[]>([])
const categories = ref<string[]>([])
const pagination = ref<BlogPagination | null>(null)
const loading = ref(true)
const error = ref('')
const searchQuery = ref('')
const selectedCategory = ref('')
const showDeleteModal = ref(false)
const blogToDelete = ref<Blog | null>(null)

const visiblePages = computed(() => {
  if (!pagination.value) return []
  const current = pagination.value.current_page
  const last = pagination.value.last_page
  const pages = []
  
  for (let i = Math.max(1, current - 2); i <= Math.min(last, current + 2); i++) {
    pages.push(i)
  }
  
  return pages
})

onMounted(async () => {
  await Promise.all([loadBlogs(), loadCategories()])
})

async function loadBlogs(page = 1) {
  try {
    loading.value = true
    error.value = ''
    const response = await blogService.getBlogs({
      category: selectedCategory.value || undefined,
      search: searchQuery.value || undefined,
      page,
    })
    pagination.value = response
    blogs.value = response.data
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to load blogs'
  } finally {
    loading.value = false
  }
}

async function loadCategories() {
  try {
    categories.value = await blogService.getCategories()
  } catch (err) {
    console.error('Failed to load categories:', err)
  }
}

function handleSearch() {
  loadBlogs()
}

function handleCategoryChange() {
  loadBlogs()
}

function goToPage(page: number) {
  if (page >= 1 && pagination.value && page <= pagination.value.last_page) {
    loadBlogs(page)
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

function viewBlog(slug: string) {
  router.push(`/blogs/${slug}`)
}

function getImageUrl(path: string): string {
  // If it's already a full URL, return it
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return path
  }
  // Otherwise, prepend the storage URL
  return `/storage/${path}`
}

function confirmDelete(blog: Blog) {
  blogToDelete.value = blog
  showDeleteModal.value = true
}

async function deleteBlog() {
  if (!blogToDelete.value) return
  
  try {
    await blogService.deleteBlog(blogToDelete.value.id)
    showDeleteModal.value = false
    blogToDelete.value = null
    success('Blog deleted successfully!')
    await loadBlogs(pagination.value?.current_page || 1)
  } catch (err) {
    const errorMessage = err instanceof Error ? err.message : 'Failed to delete blog'
    showErrorToast(errorMessage)
  }
}

function formatDate(date: string | null) {
  if (!date) return ''
  return new Date(date).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  })
}
</script>
