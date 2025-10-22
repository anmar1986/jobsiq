import { ref } from 'vue'
import type { ApiResponse } from '@/types'

interface HomeStats {
  value: string
  label: string
}

interface FeaturedJob {
  id: number
  title: string
  company: string
  location: string
  type: string
  level: string
  salary: string
  posted: string
  slug: string
}

interface JobCategory {
  name: string
  count: number
}

interface HomeContentSection {
  section: string
  title?: string
  subtitle?: string
  content?: string
  data?: Record<string, unknown>
}

interface HomeContent {
  stats: HomeStats[]
  featuredJobs: FeaturedJob[]
  categories: JobCategory[]
  content: Record<string, HomeContentSection[]>
}

export function useHome() {
  const loading = ref(false)
  const homeData = ref<HomeContent | null>(null)
  const error = ref<string | null>(null)

  const fetchHomeData = async () => {
    loading.value = true
    error.value = null

    try {
      const response = await fetch('/api/home', {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      })

      const result: ApiResponse<HomeContent> = await response.json()

      if (result.success && result.data) {
        homeData.value = result.data
      } else {
        error.value = result.message || 'Failed to load home page data'
      }
    } catch (err) {
      console.error('Error fetching home data:', err)
      error.value = 'An error occurred while loading home page data'
    } finally {
      loading.value = false
    }
  }

  return {
    loading,
    homeData,
    error,
    fetchHomeData,
  }
}
