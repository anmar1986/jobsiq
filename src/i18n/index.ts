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
