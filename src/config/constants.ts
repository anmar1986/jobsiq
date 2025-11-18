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

// Experience Levels - Must match backend validation
export const EXPERIENCE_LEVELS = [
  { value: 'entry', label: 'Entry Level' },
  { value: 'junior', label: 'Junior' },
  { value: 'mid', label: 'Mid Level' },
  { value: 'senior', label: 'Senior' },
  { value: 'lead', label: 'Lead' },
  { value: 'executive', label: 'Executive' },
] as const

// Categories - Must match exactly with config/job.php
export const JOB_CATEGORIES = [
  'Information Technology (IT) & Software',
  'Engineering & Technical',
  'Construction & Architecture',
  'Oil, Gas & Energy',
  'Accounting & Finance',
  'Sales, Marketing & Retail',
  'Administration & Office Support',
  'Human Resources (HR)',
  'Education & Training',
  'Healthcare & Medical',
  'Banking & Insurance',
  'Customer Service & Call Center',
  'Transport & Logistics',
  'Procurement & Supply Chain',
  'Manufacturing & Production',
  'Media, Design & Creative',
  'Legal & Compliance',
  'Security & Safety',
  'Hospitality & Tourism',
  'NGO & Humanitarian Work',
  'Government & Public Sector',
  'Telecommunications',
  'Agriculture & Environment',
  'Real Estate & Property',
  'Maintenance & Repair',
  'Mechanic & Automotive',
  'Cleaning & Housekeeping',
  'Fashion & Beauty',
  'Science & Research',
  'Writing, Editing & Translation',
  'E-commerce & Online Business',
  'Aviation & Airlines',
  'Fitness, Sports & Wellness',
  'Events, Entertainment & Photography',
  'Pharmaceutical & Lab Work',
  'Social Media, Content & Influencers',
  'Food & Beverage (F&B) / Restaurants',
  'Internships & Entry-Level Jobs',
  'Other / Miscellaneous',
] as const

// Pagination
export const DEFAULT_PER_PAGE = 15
export const PER_PAGE_OPTIONS = [10, 15, 25, 50, 100] as const
