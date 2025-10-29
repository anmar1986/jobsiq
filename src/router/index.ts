import { createRouter, createWebHistory, type RouteRecordRaw, type NavigationGuardNext, type RouteLocationNormalized } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    name: 'home',
    component: () => import('@/views/home/index.vue'),
    meta: { title: 'Find Your Dream Job' },
  },
  {
    path: '/jobs',
    name: 'jobs',
    component: () => import('@/views/jobs/JobsView.vue'),
    meta: { title: 'Browse Jobs' },
  },
  {
    path: '/jobs/:slug',
    name: 'job-detail',
    component: () => import('@/views/jobs/JobDetailView.vue'),
    meta: { title: 'Job Details' },
  },
  {
    path: '/application/:slug',
    name: 'apply-job',
    component: () => import('@/views/jobs/ApplyJobView.vue'),
    meta: { title: 'Apply for Job', requiresAuth: true },
  },
  {
    path: '/my-applications',
    name: 'my-applications',
    component: () => import('@/views/jobs/MyApplicationsView.vue'),
    meta: { title: 'My Applications', requiresAuth: true },
  },
  {
    path: '/saved-jobs',
    name: 'saved-jobs',
    component: () => import('@/views/jobs/SavedJobsView.vue'),
    meta: { title: 'Saved Jobs', requiresAuth: true },
  },
  {
    path: '/companies',
    name: 'companies',
    component: () => import('@/views/companies/CompaniesView.vue'),
    meta: { title: 'Browse Companies' },
  },
  {
    path: '/companies/view/:id',
    name: 'company-detail',
    component: () => import('@/views/companies/CompanyDetailView.vue'),
    meta: { title: 'Company Details' },
  },
  {
    path: '/companies/:slug',
    name: 'company-detail-slug',
    component: () => import('@/views/companies/CompanyDetailView.vue'),
    meta: { title: 'Company Details' },
  },
  {
    path: '/cvs',
    name: 'cvs',
    component: () => import('@/views/free-cvs/FreeCvsView.vue'),
    meta: { title: 'Browse CVs', requiresAuth: true, requiresCompany: true },
  },
  {
    path: '/cvs/:slug',
    name: 'cv-detail',
    component: () => import('@/views/free-cvs/FreeCvDetailView.vue'),
    meta: { title: 'CV Details', requiresAuth: true, requiresCompany: true },
  },
  {
    path: '/login',
    name: 'login',
    component: () => import('@/views/auth/LoginView.vue'),
    meta: { title: 'Login', guest: true },
  },
  {
    path: '/register',
    name: 'register',
    component: () => import('@/views/auth/RegisterView.vue'),
    meta: { title: 'Register', guest: true },
  },
  {
    path: '/dashboard',
    name: 'dashboard',
    component: () => import('@/views/dashboard/DashboardView.vue'),
    meta: { title: 'Dashboard', requiresAuth: true },
  },
  {
    path: '/profile',
    name: 'profile',
    component: () => import('@/views/dashboard/ProfileView.vue'),
    meta: { title: 'Profile', requiresAuth: true },
  },
  {
    path: '/my-companies',
    name: 'my-companies',
    component: () => import('@/views/companies/MyCompaniesView.vue'),
    meta: { title: 'My Companies', requiresAuth: true, requiresCompany: true },
  },
  {
    path: '/my-companies/:id',
    name: 'view-my-company',
    component: () => import('@/views/companies/ViewMyCompanyView.vue'),
    meta: { title: 'View Company', requiresAuth: true, requiresCompany: true },
  },
  {
    path: '/my-companies/:companyId/jobs/:jobId/view',
    name: 'view-company-job',
    component: () => import('@/views/companies/ViewCompanyJobView.vue'),
    meta: { title: 'View Job', requiresAuth: true, requiresCompany: true },
  },
  {
    path: '/my-companies/:companyId/jobs/:jobId/edit',
    name: 'edit-company-job',
    component: () => import('@/views/jobs/EditJobView.vue'),
    meta: { title: 'Edit Job', requiresAuth: true, requiresCompany: true },
  },
  {
    path: '/companies/create',
    name: 'create-company',
    component: () => import('@/views/companies/CreateCompanyView.vue'),
    meta: { title: 'Create Company', requiresAuth: true, requiresCompany: true },
  },
  {
    path: '/companies/:id/edit',
    name: 'edit-company',
    component: () => import('@/views/companies/EditCompanyView.vue'),
    meta: { title: 'Edit Company', requiresAuth: true, requiresCompany: true },
  },
  {
    path: '/post-job',
    name: 'post-job',
    component: () => import('@/views/jobs/PostJobView.vue'),
    meta: { title: 'Post a Job', requiresAuth: true, requiresCompany: true },
  },
  {
    path: '/my-cvs',
    name: 'my-cvs',
    component: () => import('@/views/dashboard/MyCvsView.vue'),
    meta: { title: 'My CVs', requiresAuth: true },
  },
  {
    path: '/my-cvs/create',
    name: 'create-cv',
    component: () => import('@/views/dashboard/CreateCvView.vue'),
    meta: { title: 'Create CV', requiresAuth: true },
  },
  {
    path: '/my-cvs/edit/:id',
    name: 'edit-cv',
    component: () => import('@/views/dashboard/CreateCvView.vue'),
    meta: { title: 'Edit CV', requiresAuth: true },
  },
  {
    path: '/my-cvs/view/:id',
    name: 'view-cv',
    component: () => import('@/views/dashboard/ViewCvView.vue'),
    meta: { title: 'View CV', requiresAuth: true },
  },
  {
    path: '/about',
    name: 'about',
    component: () => import('@/views/AboutView.vue'),
    meta: { title: 'About Us' },
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'not-found',
    component: () => import('@/views/NotFoundView.vue'),
    meta: { title: 'Page Not Found' },
  },
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
  scrollBehavior(_to, _from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return { top: 0 }
    }
  },
})

// Navigation guards
router.beforeEach((to: RouteLocationNormalized, _from: RouteLocationNormalized, next: NavigationGuardNext) => {
  const authStore = useAuthStore()
  const requiresAuth = to.matched.some((record) => record.meta.requiresAuth)
  const isGuestRoute = to.matched.some((record) => record.meta.guest)
  const requiresCompany = to.matched.some((record) => record.meta.requiresCompany)

  // Set page title
  document.title = to.meta.title ? `${to.meta.title} | JobsIQ` : 'JobsIQ'

  if (requiresAuth && !authStore.isAuthenticated) {
    // Redirect to login if route requires auth and user is not authenticated
    next({ name: 'login', query: { redirect: to.fullPath } })
  } else if (isGuestRoute && authStore.isAuthenticated) {
    // Redirect to dashboard if user is already authenticated
    next({ name: 'dashboard' })
  } else if (requiresCompany && authStore.user?.user_type !== 'company_owner') {
    // Redirect to dashboard if route requires company owner role
    next({ name: 'dashboard' })
  } else {
    next()
  }
})

export default router
