import { createI18n } from 'vue-i18n'
import en from './locales/en.json'
import ar from './locales/ar.json'

export type MessageSchema = typeof en

// Get saved locale from localStorage or use browser language
const getSavedLocale = (): string => {
  const saved = localStorage.getItem('locale')
  if (saved && ['en', 'ar'].includes(saved)) {
    return saved
  }

  // Check browser language
  const browserLang = navigator.language.split('-')[0]
  return browserLang === 'ar' ? 'ar' : 'en'
}

const i18n = createI18n<[MessageSchema], 'en' | 'ar'>({
  legacy: false, // Use Composition API mode
  locale: getSavedLocale(),
  fallbackLocale: 'en',
  messages: {
    en,
    ar
  },
  globalInjection: true,
  missingWarn: false,
  fallbackWarn: false
})

export default i18n

// Helper function to set locale and update HTML attributes
export const setLocale = (locale: 'en' | 'ar') => {
  i18n.global.locale = locale
  localStorage.setItem('locale', locale)

  // Update HTML lang and dir attributes
  document.documentElement.lang = locale
  document.documentElement.dir = locale === 'ar' ? 'rtl' : 'ltr'
}

// Initialize on load
setLocale(i18n.global.locale as 'en' | 'ar')
