import { watch } from 'vue'
import { useI18n } from 'vue-i18n'

/**
 * Composable for handling RTL/LTR text direction
 * Automatically updates the document direction when locale changes
 */
export function useRTL() {
  const { locale } = useI18n()

  // RTL languages
  const rtlLanguages = ['ar', 'he', 'fa', 'ur']

  const isRTL = (lang: string): boolean => {
    return rtlLanguages.includes(lang)
  }

  const updateDirection = (lang: string) => {
    const direction = isRTL(lang) ? 'rtl' : 'ltr'
    document.documentElement.dir = direction
    document.documentElement.lang = lang

    // Update body class for CSS targeting
    if (isRTL(lang)) {
      document.body.classList.add('rtl')
      document.body.classList.remove('ltr')
    } else {
      document.body.classList.add('ltr')
      document.body.classList.remove('rtl')
    }
  }

  // Watch for locale changes
  watch(
    locale,
    (newLocale) => {
      updateDirection(newLocale)
    },
    { immediate: true }
  )

  return {
    isRTL: () => isRTL(locale.value),
    direction: () => (isRTL(locale.value) ? 'rtl' : 'ltr')
  }
}
