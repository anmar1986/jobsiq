export const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000'
export const API_URL = `${API_BASE_URL}/api`

export const APP_NAME = 'JobsIQ'
export const APP_DESCRIPTION = 'Find your dream job'

// Storage Keys
export const STORAGE_KEYS = {
  AUTH_TOKEN: 'auth_token',
  USER: 'user',
  THEME: 'theme',
} as const

// Routes
export const ROUTES = {
  HOME: '/',
  JOBS: '/jobs',
  JOB_DETAIL: '/jobs/:slug',
  COMPANIES: '/companies',
  COMPANY_DETAIL: '/companies/:slug',
  CVS: '/cvs',
  CV_DETAIL: '/cvs/:slug',
  MY_CVS: '/my-cvs',
  MY_COMPANIES: '/my-companies',
  LOGIN: '/login',
  REGISTER: '/register',
  PROFILE: '/profile',
  DASHBOARD: '/dashboard',
} as const

// Employment Types
export const EMPLOYMENT_TYPES = [
  { value: 'full-time', label: 'Full Time' },
  { value: 'part-time', label: 'Part Time' },
  { value: 'contract', label: 'Contract' },
  { value: 'freelance', label: 'Freelance' },
  { value: 'internship', label: 'Internship' },
] as const

// Experience Levels
export const EXPERIENCE_LEVELS = [
  { value: 'entry', label: 'Entry Level' },
  { value: 'mid', label: 'Mid Level' },
  { value: 'senior', label: 'Senior' },
  { value: 'lead', label: 'Lead' },
  { value: 'executive', label: 'Executive' },
] as const

// Categories
export const JOB_CATEGORIES = [
  'Software Development',
  'Design',
  'Marketing',
  'Sales',
  'Customer Support',
  'Human Resources',
  'Finance',
  'Operations',
  'Product Management',
  'Data Science',
  'DevOps',
  'Quality Assurance',
  'Other',
] as const

// Pagination
export const DEFAULT_PER_PAGE = 15
export const PER_PAGE_OPTIONS = [10, 15, 25, 50, 100] as const
