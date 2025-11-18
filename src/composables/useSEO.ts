import { watch, onMounted, onUnmounted } from 'vue'
import { useRoute } from 'vue-router'
import { useLocaleStore } from '@/stores/locale'

export interface SEOConfig {
  title?: string
  description?: string
  image?: string
  url?: string
}

export const useSEO = (config?: SEOConfig) => {
  const route = useRoute()
  const localeStore = useLocaleStore()
  
  const siteUrl = import.meta.env.VITE_APP_URL || 'https://jobs.iq'
  
  // Get current URL without locale prefix for alternate links
  const getPathWithoutLocale = (fullPath: string): string => {
    return fullPath.replace(/^\/(en|ar)/, '') || '/'
  }
  
  // Update or create meta tags
  const updateMetaTag = (name: string, content: string, attr: 'name' | 'property' = 'name') => {
    let element = document.querySelector(`meta[${attr}="${name}"]`)
    if (!element) {
      element = document.createElement('meta')
      element.setAttribute(attr, name)
      document.head.appendChild(element)
    }
    element.setAttribute('content', content)
  }
  
  // Update or create link tags
  const updateLinkTag = (rel: string, href: string, hreflang?: string) => {
    const selector = hreflang 
      ? `link[rel="${rel}"][hreflang="${hreflang}"]`
      : `link[rel="${rel}"]:not([hreflang])`
    
    let element = document.querySelector(selector) as HTMLLinkElement
    if (!element) {
      element = document.createElement('link')
      element.setAttribute('rel', rel)
      if (hreflang) {
        element.setAttribute('hreflang', hreflang)
      }
      document.head.appendChild(element)
    }
    element.setAttribute('href', href)
  }
  
  // Remove existing alternate and canonical links
  const clearSEOLinks = () => {
    const links = document.querySelectorAll('link[rel="alternate"], link[rel="canonical"]')
    links.forEach(link => link.remove())
  }
  
  // Update all SEO tags
  const updateSEOTags = () => {
    const currentLocale = localeStore.currentLocale
    const pathWithoutLocale = getPathWithoutLocale(route.fullPath)
    const currentUrl = `${siteUrl}/${currentLocale}${pathWithoutLocale}`
    
    // Update page title
    if (config?.title) {
      document.title = config.title
    }
    
    // Update meta description
    if (config?.description) {
      updateMetaTag('description', config.description)
    }
    
    // Update Open Graph tags
    updateMetaTag('og:title', config?.title || document.title, 'property')
    updateMetaTag('og:description', config?.description || '', 'property')
    updateMetaTag('og:url', config?.url || currentUrl, 'property')
    updateMetaTag('og:locale', currentLocale === 'ar' ? 'ar_IQ' : 'en_US', 'property')
    updateMetaTag('og:locale:alternate', currentLocale === 'ar' ? 'en_US' : 'ar_IQ', 'property')
    
    if (config?.image) {
      updateMetaTag('og:image', config.image, 'property')
    }
    
    // Update Twitter Card tags
    updateMetaTag('twitter:card', 'summary_large_image')
    updateMetaTag('twitter:title', config?.title || document.title)
    updateMetaTag('twitter:description', config?.description || '')
    if (config?.image) {
      updateMetaTag('twitter:image', config.image)
    }
    
    // Clear existing SEO links
    clearSEOLinks()
    
    // Add canonical link
    updateLinkTag('canonical', currentUrl)
    
    // Add hreflang alternate links
    updateLinkTag('alternate', `${siteUrl}/en${pathWithoutLocale}`, 'en')
    updateLinkTag('alternate', `${siteUrl}/ar${pathWithoutLocale}`, 'ar')
    updateLinkTag('alternate', `${siteUrl}/en${pathWithoutLocale}`, 'x-default')
  }
  
  // Watch for route and locale changes
  const stopRouteWatch = watch(
    () => [route.fullPath, localeStore.currentLocale],
    () => {
      updateSEOTags()
    },
    { immediate: true }
  )
  
  onMounted(() => {
    updateSEOTags()
  })
  
  onUnmounted(() => {
    stopRouteWatch()
  })
  
  return {
    updateSEOTags
  }
}
