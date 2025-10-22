export interface Blog {
  id: number
  user_id: number
  title: string
  slug: string
  excerpt: string | null
  content: string
  featured_image: string | null
  category: string | null
  tags: string[] | null
  status: 'draft' | 'published'
  published_at: string | null
  views: number
  created_at: string
  updated_at: string
  user?: {
    id: number
    name: string
  }
}

export interface BlogFormData {
  title: string
  excerpt?: string
  content: string
  featured_image?: string
  category?: string
  tags?: string[]
  status: 'draft' | 'published'
  published_at?: string
}

export interface BlogFilters {
  category?: string
  search?: string
  page?: number
}

export interface BlogPagination {
  current_page: number
  data: Blog[]
  first_page_url: string
  from: number
  last_page: number
  last_page_url: string
  next_page_url: string | null
  path: string
  per_page: number
  prev_page_url: string | null
  to: number
  total: number
}
