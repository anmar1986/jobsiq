// API Types
export interface ApiResponse<T = unknown> {
  success: boolean
  data?: T
  message?: string
  errors?: Record<string, string[]>
}

export interface PaginatedResponse<T> {
  data: T[]
  current_page: number
  last_page: number
  per_page: number
  total: number
  from: number
  to: number
}

// User Types
export interface User {
  id: number
  name: string
  email: string
  email_verified_at: string | null
  created_at: string
  updated_at: string
}

export interface AuthResponse {
  user: User
  token: string
  token_type: string
}

// Job Types
export interface Job {
  id: number
  title: string
  slug: string
  company_id: number
  company: Company
  user_id: number
  description: string
  requirements: string | null
  responsibilities: string | null
  benefits: string | null
  location: string
  city?: string | null
  country?: string | null
  employment_type: 'full-time' | 'part-time' | 'contract' | 'freelance' | 'internship'
  experience_level: 'entry' | 'junior' | 'mid' | 'senior' | 'lead' | 'executive'
  salary_min: number | null
  salary_max: number | null
  salary_currency: string
  salary_period?: 'hourly' | 'monthly' | 'yearly' | null
  is_remote: boolean
  is_featured: boolean
  is_active: boolean
  category: string | null
  tags: string[] | null
  skills: string[] | null
  application_url: string | null
  application_email: string | null
  expires_at: string | null
  published_at: string | null
  created_at: string
  updated_at: string
}

// Company Types
export interface Company {
  id: number
  name: string
  slug: string
  legal_name?: string | null
  description: string | null
  tagline?: string | null
  website: string | null
  email: string | null
  phone: string | null
  fax?: string | null
  address: string | null
  street?: string | null
  street_2?: string | null
  city: string | null
  state: string | null
  country: string | null
  postal_code: string | null
  latitude?: number | null
  longitude?: number | null
  industry?: string | null
  company_size?: string | null
  company_type?: string | null
  founded_date?: string | null
  registration_number?: string | null
  tax_id?: string | null
  linkedin?: string | null
  twitter?: string | null
  facebook?: string | null
  instagram?: string | null
  youtube?: string | null
  github?: string | null
  benefits?: string[] | null
  values?: string[] | null
  perks?: string[] | null
  culture_description?: string | null
  is_verified?: boolean
  is_featured?: boolean
  is_active: boolean
  is_hiring?: boolean
  meta_title?: string | null
  meta_description?: string | null
  keywords?: string[] | null
  total_employees?: number | null
  active_jobs_count?: number | null
  total_jobs_posted?: number | null
  profile_views?: number | null
  timezone?: string | null
  languages?: string[] | null
  locations?: string[] | null
  why_work_here?: string | null
  funding_amount?: number | null
  funding_currency?: string | null
  logo?: CompanyImage | null
  images?: CompanyImage[]
  jobs?: Job[]
  jobs_count?: number
  created_at: string
  updated_at: string
}

export interface CompanyImage {
  id: number
  company_id: number
  path: string
  type: 'logo' | 'cover' | 'gallery'
  is_primary: boolean
  created_at: string
  updated_at: string
}

// CV Types
export interface UserCv {
  id: number
  user_id: number
  user?: User
  full_name: string
  email: string
  phone: string | null
  website: string | null
  linkedin: string | null
  github: string | null
  address: string | null
  city: string | null
  country: string | null
  postal_code: string | null
  title: string | null
  slug: string
  work_experience: WorkExperience[] | null // For sending data
  work_experiences?: WorkExperience[] | null // For receiving data from API
  education: Education[] | null // For sending data
  education_entries?: Education[] | null // For receiving data from API
  skills: Skill[] | null
  languages: Language[] | null
  certifications: Certification[] | null
  projects: Project[] | null
  references: Reference[] | null
  awards: Award[] | null
  publications: Publication[] | null
  volunteer_work: VolunteerWork[] | null
  hobbies: string[] | null
  is_public: boolean
  is_primary: boolean
  template: string | null
  settings: Record<string, unknown> | null
  profile_image?: { path: string; url: string } | null
  profileImage?: { path: string; url: string } | null // Laravel returns this (camelCase)
  profile_image_path?: string | null
  workExperiences?: WorkExperience[] // Laravel relationship
  educationEntries?: Education[] // Laravel relationship
  created_at: string
  updated_at: string
}

export interface WorkExperience {
  company: string
  position: string
  location?: string
  start_date: string
  end_date?: string | null
  current: boolean
  description?: string
  achievements?: string[]
  formatted_start_date?: string
  formatted_end_date?: string | null
}

export interface Education {
  institution: string
  degree: string
  field: string
  location?: string
  start_date: string
  end_date?: string | null
  gpa?: string
  description?: string
  formatted_start_date?: string
  formatted_end_date?: string | null
}

export interface Skill {
  name: string
  level?: 'beginner' | 'intermediate' | 'advanced' | 'expert'
  category?: string
}

export interface Language {
  language: string
  proficiency: 'basic' | 'conversational' | 'fluent' | 'native'
}

export interface Certification {
  name: string
  issuer: string
  date: string
  expiry_date?: string | null
  credential_id?: string
  url?: string
  formatted_date?: string
  formatted_expiry_date?: string | null
}

export interface Project {
  title: string
  description: string
  technologies?: string[]
  url?: string
  start_date?: string
  end_date?: string | null
}

export interface Reference {
  name: string
  position: string
  company: string
  email?: string
  phone?: string
  relationship: string
}

export interface Award {
  title: string
  issuer: string
  date: string
  description?: string
}

export interface Publication {
  title: string
  publisher: string
  date: string
  url?: string
  description?: string
}

export interface VolunteerWork {
  organization: string
  role: string
  start_date: string
  end_date?: string | null
  description?: string
}



// Filter Types
export interface JobFilters {
  search?: string
  location?: string
  employment_type?: string
  experience_level?: string
  is_remote?: boolean
  category?: string
  salary_min?: number
  per_page?: number
  page?: number
}

export interface CompanyFilters {
  search?: string
  city?: string
  country?: string
  per_page?: number
  page?: number
}

// Form Types
export interface LoginForm {
  email: string
  password: string
  remember?: boolean
}

export interface RegisterForm {
  name: string
  email: string
  password: string
  password_confirmation: string
}

export interface ProfileUpdateForm {
  name: string
  email: string
}

export interface PasswordChangeForm {
  current_password: string
  password: string
  password_confirmation: string
}

export interface JobForm {
  title: string
  company_id: number
  description: string
  requirements?: string
  responsibilities?: string
  benefits?: string
  location: string
  employment_type: string
  experience_level: string
  salary_min?: number
  salary_max?: number
  salary_currency: string
  is_remote: boolean
  is_featured: boolean
  is_active: boolean
  category?: string
  tags?: string[]
  application_url?: string
  application_email?: string
  expires_at?: string
}
