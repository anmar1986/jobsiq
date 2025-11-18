<template>
  <div class="language-switcher">
    <!-- Dropdown Style -->
    <div v-if="variant === 'dropdown'" class="relative inline-block text-left">
      <button
        @click="toggleDropdown"
        type="button"
        class="inline-flex items-center justify-center gap-2 px-4 py-2.5 text-sm font-medium text-gray-700 bg-white border-2 border-gray-300 rounded-lg hover:bg-gray-50 hover:border-gray-400 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-all duration-200 shadow-sm hover:shadow-md"
        :aria-label="$t('common.language')"
      >
        <svg class="w-5 h-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M3 5h12M9 3v2m1.048 9.5A18.022 18.022 0 016.412 9m6.088 9h7M11 21l5-10 5 10M12.751 5C11.783 10.77 8.07 15.61 3 18.129"
          />
        </svg>
        <span>{{ currentLanguageLabel }}</span>
        <svg
          class="w-4 h-4 text-gray-500 transition-transform duration-200"
          :class="{ 'rotate-180': isOpen }"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
        </svg>
      </button>

      <!-- Dropdown Menu -->
      <Transition
        enter-active-class="transition-all duration-200"
        enter-from-class="transform opacity-0 scale-95"
        enter-to-class="transform opacity-100 scale-100"
        leave-active-class="transition-all duration-150"
        leave-from-class="transform opacity-100 scale-100"
        leave-to-class="transform opacity-0 scale-95"
      >
        <div
          v-if="isOpen"
          class="absolute right-0 z-50 mt-2 w-52 origin-top-right rounded-lg bg-white shadow-lg border border-gray-200 focus:outline-none"
          :class="{ 'left-0 right-auto': currentLocale === 'ar' }"
        >
          <div class="py-1">
            <button
              v-for="lang in languages"
              :key="lang.code"
              @click="switchLanguage(lang.code)"
              class="flex items-center gap-3 w-full px-4 py-2.5 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
              :class="{
                'bg-primary-50 text-primary-700 font-semibold': currentLocale === lang.code
              }"
            >
              <span class="text-2xl leading-none">{{ lang.flag }}</span>
              <span class="flex-1 text-left" :class="{ 'font-semibold': currentLocale === lang.code }">
                {{ lang.label }}
              </span>
              <svg
                v-if="currentLocale === lang.code"
                class="w-5 h-5 text-primary-600"
                fill="currentColor"
                viewBox="0 0 20 20"
              >
                <path
                  fill-rule="evenodd"
                  d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                  clip-rule="evenodd"
                />
              </svg>
            </button>
          </div>
        </div>
      </Transition>
    </div>

    <!-- Toggle Style -->
    <div v-else-if="variant === 'toggle'" class="inline-flex items-center gap-2 p-1 bg-gray-100 rounded-lg">
      <button
        v-for="lang in languages"
        :key="lang.code"
        @click="switchLanguage(lang.code)"
        class="inline-flex items-center gap-2 px-4 py-2 text-sm font-medium rounded-lg transition-all duration-200"
        :class="
          currentLocale === lang.code
            ? 'bg-primary-600 text-white shadow-md hover:bg-primary-700'
            : 'text-gray-700 hover:bg-gray-200'
        "
        :aria-label="`Switch to ${lang.label}`"
      >
        <span class="text-lg leading-none">{{ lang.flag }}</span>
        <span class="font-medium">{{ lang.label }}</span>
      </button>
    </div>

    <!-- Radio Style -->
    <div v-else-if="variant === 'radio'" class="inline-flex flex-col gap-2">
      <label
        v-for="lang in languages"
        :key="lang.code"
        class="inline-flex items-center gap-3 px-4 py-3 border-2 rounded-lg cursor-pointer transition-all duration-200"
        :class="
          currentLocale === lang.code
            ? 'border-primary-600 bg-primary-50 shadow-sm'
            : 'border-gray-300 hover:border-primary-400 hover:shadow-sm'
        "
      >
        <input
          type="radio"
          :value="lang.code"
          :checked="currentLocale === lang.code"
          @change="switchLanguage(lang.code)"
          class="w-4 h-4 text-primary-600 focus:ring-primary-500 border-gray-300"
        />
        <span class="text-2xl leading-none">{{ lang.flag }}</span>
        <span class="flex-1 text-sm font-medium text-gray-900">
          {{ lang.label }}
        </span>
      </label>
    </div>

    <!-- Compact Style (Icon Only) -->
    <div v-else-if="variant === 'compact'" class="relative inline-block">
      <button
        @click="toggleDropdown"
        type="button"
        class="inline-flex items-center justify-center w-10 h-10 text-xl rounded-lg bg-white border border-gray-300 hover:bg-gray-50 hover:border-gray-400 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-all duration-200 shadow-sm hover:shadow-md"
        :aria-label="$t('common.language')"
      >
        {{ currentLanguageFlag }}
      </button>

      <Transition
        enter-active-class="transition-all duration-200"
        enter-from-class="transform opacity-0 scale-95"
        enter-to-class="transform opacity-100 scale-100"
        leave-active-class="transition-all duration-150"
        leave-from-class="transform opacity-100 scale-100"
        leave-to-class="transform opacity-0 scale-95"
      >
        <div
          v-if="isOpen"
          class="absolute right-0 z-50 mt-2 py-1 bg-white rounded-lg shadow-lg border border-gray-200 min-w-max"
          :class="{ 'left-0 right-auto': currentLocale === 'ar' }"
        >
          <button
            v-for="lang in languages"
            :key="lang.code"
            @click="switchLanguage(lang.code)"
            class="flex items-center gap-3 w-full px-4 py-2.5 text-sm text-gray-700 hover:bg-gray-100 transition-colors whitespace-nowrap"
            :class="{
              'bg-primary-50 text-primary-700 font-semibold': currentLocale === lang.code
            }"
          >
            <span class="text-xl leading-none">{{ lang.flag }}</span>
            <span :class="{ 'font-semibold': currentLocale === lang.code }">{{ lang.label }}</span>
            <svg
              v-if="currentLocale === lang.code"
              class="w-4 h-4 text-primary-600 ml-2"
              fill="currentColor"
              viewBox="0 0 20 20"
            >
              <path
                fill-rule="evenodd"
                d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                clip-rule="evenodd"
              />
            </svg>
          </button>
        </div>
      </Transition>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useI18n } from 'vue-i18n'
import { useLocaleRouter } from '@/composables/useLocaleRouter'

// Props
interface Props {
  variant?: 'dropdown' | 'toggle' | 'radio' | 'compact'
}

withDefaults(defineProps<Props>(), {
  variant: 'dropdown'
})

// Composables
const { locale } = useI18n()
const localeRouter = useLocaleRouter()

// State
const isOpen = ref(false)

// Languages configuration
const languages = [
  { code: 'en', label: 'English', flag: 'EN' },
  { code: 'ar', label: 'العربية', flag: 'AR' }
]

// Computed
const currentLocale = computed(() => locale.value)

const currentLanguageLabel = computed(() => {
  const lang = languages.find((l) => l.code === currentLocale.value)
  return lang?.label || 'English'
})

const currentLanguageFlag = computed(() => {
  const lang = languages.find((l) => l.code === currentLocale.value)
  return lang?.flag || 'EN'
})

// Methods
const toggleDropdown = () => {
  isOpen.value = !isOpen.value
}

const switchLanguage = async (code: string) => {
  await localeRouter.switchLocale(code as 'en' | 'ar')
  isOpen.value = false
}

const closeDropdown = (event: MouseEvent) => {
  const target = event.target as HTMLElement
  if (!target.closest('.language-switcher')) {
    isOpen.value = false
  }
}

// Lifecycle
onMounted(() => {
  document.addEventListener('click', closeDropdown)
})

onUnmounted(() => {
  document.removeEventListener('click', closeDropdown)
})
</script>

<style scoped>
/* Custom styles for smooth transitions */
.language-switcher {
  user-select: none;
}
</style>
