import js from '@eslint/js'
import pluginVue from 'eslint-plugin-vue'
import * as parserVue from 'vue-eslint-parser'
import tseslint from 'typescript-eslint'

export default tseslint.config(
  {
    ignores: [
      '**/dist/**',
      '**/node_modules/**',
      '**/vendor/**',
      '**/storage/**',
      '**/bootstrap/cache/**',
      '**/.nuxt/**',
      '**/.output/**',
      '**/public/build/**',
      '**/coverage/**'
    ]
  },
  js.configs.recommended,
  ...tseslint.configs.recommended,
  ...pluginVue.configs['flat/recommended'],
  {
    files: ['**/*.vue', '**/*.ts', '**/*.tsx', '**/*.js'],
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
      parser: parserVue,
      parserOptions: {
        parser: tseslint.parser,
        extraFileExtensions: ['.vue'],
        ecmaFeatures: {
          jsx: true
        }
      },
      globals: {
        process: 'readonly',
        console: 'readonly',
        window: 'readonly',
        document: 'readonly'
      }
    },
    rules: {
      // Vue-specific rules - made less strict for CI
      'vue/multi-word-component-names': 'off',
      'vue/no-v-html': 'warn',
      'vue/require-default-prop': 'off',
      'vue/require-explicit-emits': 'off',
      'vue/component-api-style': 'off',
      'vue/max-attributes-per-line': 'off',
      'vue/singleline-html-element-content-newline': 'off',
      'vue/html-self-closing': 'off',
      'vue/attributes-order': 'off',
      
      // TypeScript rules
      '@typescript-eslint/no-explicit-any': 'off', // Allow 'any' type for flexibility with API responses
      '@typescript-eslint/no-unused-vars': ['warn', { 
        argsIgnorePattern: '^_',
        varsIgnorePattern: '^_'
      }],
      '@typescript-eslint/explicit-module-boundary-types': 'off',
      
      // General rules
      'no-console': 'off',
      'no-debugger': 'off',
      'prefer-const': 'warn',
      'no-unused-vars': 'off', // Use TypeScript's no-unused-vars instead
      'no-undef': 'off' // TypeScript handles this
    }
  }
)
