import { createI18n } from 'vue-i18n'
import en from './locales/en.json'
import ar from './locales/ar.json'

export type MessageSchema = typeof en

// Default locale - the router will set the actual locale based on URL
const getInitialLocale = (): string => {
  // Check if there's a locale in the URL path
  const path = window.location.pathname
  const localeMatch = path.match(/^\/(en|ar)/)
  if (localeMatch) {
    return localeMatch[1]
  }

  // Fallback to saved locale or browser language
  const saved = localStorage.getItem('locale')
  if (saved && ['en', 'ar'].includes(saved)) {
    return saved
  }

  const browserLang = navigator.language.split('-')[0]
  return browserLang === 'ar' ? 'ar' : 'en'
}

const i18n = createI18n<[MessageSchema], 'en' | 'ar'>({
  legacy: false, // Use Composition API mode
  locale: getInitialLocale(),
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
