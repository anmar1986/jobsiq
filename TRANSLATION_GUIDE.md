# Translation Implementation Guide

This guide shows how to use the i18n (internationalization) system in the JobsIQ frontend.

## Setup Complete ✅

The following has been configured:
- ✅ vue-i18n installed
- ✅ rtlcss installed
- ✅ i18n configuration created
- ✅ Translation files (English & Arabic) created
- ✅ Language switcher component created
- ✅ RTL/LTR support implemented
- ✅ Main app integration complete

## How to Use Translations in Components

### 1. In Template (HTML)

Replace hardcoded text with `$t()` function:

**Before:**
```vue
<template>
  <button>Login</button>
  <h1>Welcome to JobsIQ</h1>
  <p>Find your dream job</p>
</template>
```

**After:**
```vue
<template>
  <button>{{ $t('auth.login') }}</button>
  <h1>{{ $t('common.welcome') }} {{ $t('common.appName') }}</h1>
  <p>{{ $t('home.heroTitle') }}</p>
</template>
```

### 2. In Script (TypeScript/JavaScript)

Use the `useI18n()` composable:

**Before:**
```typescript
const successMessage = 'Login successful!'
const errorMessage = 'Invalid credentials'
```

**After:**
```typescript
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

const successMessage = t('auth.loginSuccess')
const errorMessage = t('auth.invalidCredentials')
```

### 3. With Dynamic Values (Interpolation)

```typescript
// Translation key in en.json:
// "greeting": "Hello, {name}!"

// In component:
{{ $t('greeting', { name: userName }) }}
```

## Language Switcher Component

The `LanguageSwitcher` component supports 4 variants:

### 1. Dropdown (Default)
```vue
<LanguageSwitcher variant="dropdown" />
```

### 2. Toggle Buttons
```vue
<LanguageSwitcher variant="toggle" />
```

### 3. Radio Buttons
```vue
<LanguageSwitcher variant="radio" />
```

### 4. Compact (Icon Only)
```vue
<LanguageSwitcher variant="compact" />
```

## Example: Updating AppHeader.vue

### Step 1: Add Language Switcher to Header

Add this to your AppHeader.vue template:

```vue
<template>
  <header class="sticky top-0 z-40 bg-white border-b-2 border-gray-300 shadow-sm">
    <nav class="container-custom">
      <div class="flex items-center justify-between h-16">
        <!-- Logo -->
        <router-link to="/" class="flex items-center gap-2 group">
          <div class="...">
            <span class="text-white font-bold text-xl">J</span>
          </div>
          <span class="...">
            {{ $t('common.appName') }}
          </span>
        </router-link>

        <!-- Right Side Actions -->
        <div class="flex items-center gap-4">
          <!-- Add Language Switcher -->
          <LanguageSwitcher variant="compact" />

          <!-- Rest of your header content... -->
        </div>
      </div>
    </nav>
  </header>
</template>

<script setup lang="ts">
import LanguageSwitcher from '@/components/base/LanguageSwitcher.vue'
// ... rest of your imports
</script>
```

### Step 2: Convert Hardcoded Text

Replace hardcoded strings in navLinks:

**Before:**
```typescript
const navLinks = computed(() => {
  return [
    { path: '/jobs', label: 'Jobs' },
    { path: '/companies', label: 'Companies' },
    { path: '/about', label: 'About Us' },
  ]
})
```

**After:**
```typescript
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

const navLinks = computed(() => {
  return [
    { path: '/jobs', label: t('nav.jobs') },
    { path: '/companies', label: t('nav.companies') },
    { path: '/about', label: t('nav.about') },
  ]
})
```

Replace text in user menu items:

**Before:**
```typescript
const userMenuItems = computed(() => {
  const baseItems: MenuItem[] = [
    { path: '/profile', label: 'Profile' },
    { path: '/change-password', label: 'Change Password' }
  ]
  return baseItems
})
```

**After:**
```typescript
const userMenuItems = computed(() => {
  const baseItems: MenuItem[] = [
    { path: '/profile', label: t('nav.profile') },
    { path: '/change-password', label: t('auth.changePassword') }
  ]
  return baseItems
})
```

Replace buttons and text in template:

**Before:**
```vue
<router-link to="/login" class="btn-primary text-sm">
  Login
</router-link>

<button @click="handleLogout">
  Logout
</button>

<p>Dashboard</p>
```

**After:**
```vue
<router-link to="/login" class="btn-primary text-sm">
  {{ $t('auth.login') }}
</router-link>

<button @click="handleLogout">
  {{ $t('auth.logout') }}
</button>

<p>{{ $t('nav.dashboard') }}</p>
```

## Translation Keys Reference

Common keys are organized in sections:

- **common**: General UI elements (save, cancel, edit, delete, etc.)
- **nav**: Navigation links
- **auth**: Authentication (login, register, passwords)
- **jobs**: Job-related content
- **companies**: Company-related content
- **cv**: CV/Resume content
- **dashboard**: Dashboard content
- **admin**: Admin panel content
- **footer**: Footer content
- **home**: Homepage content
- **messages**: User messages and alerts
- **validation**: Form validation messages

## RTL Support

RTL (Right-to-Left) is automatically handled for Arabic language:
- Document direction changes automatically
- CSS adjusts for RTL layout
- No manual intervention needed

## Adding New Translations

1. Add to English file (`src/i18n/locales/en.json`):
```json
{
  "mySection": {
    "myKey": "My English Text"
  }
}
```

2. Add to Arabic file (`src/i18n/locales/ar.json`):
```json
{
  "mySection": {
    "myKey": "النص العربي الخاص بي"
  }
}
```

3. Use in component:
```vue
{{ $t('mySection.myKey') }}
```

## Best Practices

1. ✅ **Always use translation keys** instead of hardcoded text
2. ✅ **Use descriptive key names** (e.g., `auth.loginButton` not `btn1`)
3. ✅ **Group related translations** in logical sections
4. ✅ **Keep translations in sync** between language files
5. ✅ **Use computed properties** when translations need to be reactive
6. ✅ **Test both languages** to ensure proper display

## Testing

To test the translation system:

1. Run the development server:
```bash
npm run dev
```

2. Open the application in your browser
3. Click the language switcher to toggle between English and Arabic
4. Verify:
   - Text changes to the selected language
   - RTL layout works for Arabic
   - All UI elements are properly translated

## Common Issues

### Issue: Translation not updating
**Solution**: Make sure you're using computed properties or the `t()` function inside `computed()`

### Issue: Missing translation warning
**Solution**: Check that the key exists in both `en.json` and `ar.json`

### Issue: RTL not working
**Solution**: Ensure `useRTL()` is called in `App.vue` and the HTML `dir` attribute is set

## Next Steps

1. Add the `LanguageSwitcher` component to your header
2. Go through each component and replace hardcoded text with translation keys
3. Test the application in both languages
4. Add any missing translations to the locale files

Happy translating! 🌍
