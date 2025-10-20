import { createRouter, createWebHistory, type RouteRecordRaw, type NavigationGuardNext, type RouteLocationNormalized } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    name: 'home',
    component: () => import('@/views/HomeView.vue'),
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
    path: '/companies',
    name: 'companies',
    component: () => import('@/views/companies/CompaniesView.vue'),
    meta: { title: 'Browse Companies' },
  },
  {
    path: '/companies/:slug',
    name: 'company-detail',
    component: () => import('@/views/companies/CompanyDetailView.vue'),
    meta: { title: 'Company Details' },
  },
  {
    path: '/cvs',
    name: 'cvs',
    component: () => import('@/views/cvs/CvsView.vue'),
    meta: { title: 'Browse CVs' },
  },
  {
    path: '/cvs/:slug',
    name: 'cv-detail',
    component: () => import('@/views/cvs/CvDetailView.vue'),
    meta: { title: 'CV Details' },
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
    component: () => import('@/views/dashboard/MyCompaniesView.vue'),
    meta: { title: 'My Companies', requiresAuth: true },
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
  const requiresAuth = to.matched.some((record: any) => record.meta.requiresAuth)
  const isGuestRoute = to.matched.some((record: any) => record.meta.guest)

  // Set page title
  document.title = to.meta.title ? `${to.meta.title} | JobsIQ` : 'JobsIQ'

  if (requiresAuth && !authStore.isAuthenticated) {
    // Redirect to login if route requires auth and user is not authenticated
    next({ name: 'login', query: { redirect: to.fullPath } })
  } else if (isGuestRoute && authStore.isAuthenticated) {
    // Redirect to dashboard if user is already authenticated
    next({ name: 'dashboard' })
  } else {
    next()
  }
})

export default router
