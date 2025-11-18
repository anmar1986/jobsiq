import { useRouter, useRoute, type RouteLocationRaw } from 'vue-router'
import { useLocaleStore, type Locale } from '@/stores/locale'

/**
 * Composable for locale-aware navigation
 * Provides methods to navigate while maintaining or switching language context
 */
export const useLocaleRouter = () => {
  const router = useRouter()
  const route = useRoute()
  const localeStore = useLocaleStore()

  /**
   * Navigate to a route with the current locale
   */
  const push = (to: RouteLocationRaw) => {
    if (typeof to === 'string') {
      return router.push(`/${localeStore.currentLocale}${to}`)
    }
    if ('params' in to && to.params) {
      return router.push({
        ...to,
        params: {
          ...to.params,
          locale: localeStore.currentLocale
        }
      })
    }
    return router.push(to)
  }

  /**
   * Replace current route with locale
   */
  const replace = (to: RouteLocationRaw) => {
    if (typeof to === 'string') {
      return router.replace(`/${localeStore.currentLocale}${to}`)
    }
    if ('params' in to && to.params) {
      return router.replace({
        ...to,
        params: {
          ...to.params,
          locale: localeStore.currentLocale
        }
      })
    }
    return router.replace(to)
  }

  /**
   * Switch to a different locale while staying on the same page
   */
  const switchLocale = async (locale: Locale) => {
    // Update locale in store (this also updates i18n)
    localeStore.setLocale(locale)

    // Navigate to the same route with new locale
    const currentPath = route.path.replace(/^\/(en|ar)/, '')
    const query = route.query
    await router.push({ 
      path: `/${locale}${currentPath}`,
      query 
    })
  }

  /**
   * Get localized path for the current route
   */
  const getLocalizedPath = (locale?: Locale): string => {
    const targetLocale = locale || localeStore.currentLocale
    const currentPath = route.path.replace(/^\/(en|ar)/, '')
    return `/${targetLocale}${currentPath}`
  }

  /**
   * Get localized URL for the current route (full URL)
   */
  const getLocalizedUrl = (locale?: Locale): string => {
    const siteUrl = import.meta.env.VITE_APP_URL || 'https://jobs.iq'
    return `${siteUrl}${getLocalizedPath(locale)}`
  }

  return {
    push,
    replace,
    switchLocale,
    getLocalizedPath,
    getLocalizedUrl
  }
}
