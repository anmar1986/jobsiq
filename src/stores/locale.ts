import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import i18n from '@/i18n'

export type Locale = 'en' | 'ar'

export const useLocaleStore = defineStore('locale', () => {
  // State
  const currentLocale = ref<Locale>('en')
  
  // Getters
  const isRTL = computed(() => currentLocale.value === 'ar')
  const direction = computed(() => isRTL.value ? 'rtl' : 'ltr')
  const oppositeLocale = computed<Locale>(() => currentLocale.value === 'en' ? 'ar' : 'en')
  
  // Actions
  const setLocale = (locale: Locale) => {
    currentLocale.value = locale
    
    // Update i18n locale (this triggers reactivity for all components)
    // In non-legacy mode, locale is a WritableComputedRef
    if (typeof i18n.global.locale === 'object' && 'value' in i18n.global.locale) {
      (i18n.global.locale as any).value = locale
    } else {
      (i18n.global.locale as any) = locale
    }
    
    // Update document attributes
    document.documentElement.lang = locale
    document.documentElement.dir = direction.value
  }
  
  const initializeLocale = (localeFromUrl?: string) => {
    // Priority: URL param > localStorage > browser language > default (en)
    let locale: Locale
    
    if (localeFromUrl && ['en', 'ar'].includes(localeFromUrl)) {
      locale = localeFromUrl as Locale
    } else {
      const savedLocale = localStorage.getItem('locale')
      if (savedLocale && ['en', 'ar'].includes(savedLocale)) {
        locale = savedLocale as Locale
      } else {
        const browserLang = navigator.language.split('-')[0]
        locale = browserLang === 'ar' ? 'ar' : 'en'
      }
    }
    
    setLocale(locale)
    return locale
  }
  
  const toggleLocale = () => {
    setLocale(oppositeLocale.value)
  }
  
  return {
    currentLocale,
    isRTL,
    direction,
    oppositeLocale,
    setLocale,
    initializeLocale,
    toggleLocale
  }
}, {
  persist: true
})
