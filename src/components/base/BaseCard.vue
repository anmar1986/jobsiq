<template>
  <component
    :is="tag"
    :class="cardClasses"
    @click="handleClick"
  >
    <div v-if="$slots.header || title" class="card-header px-6 py-4 border-b border-gray-200">
      <slot name="header">
        <h3 class="text-lg font-semibold text-gray-900">{{ title }}</h3>
      </slot>
    </div>
    
    <div :class="bodyClasses">
      <slot />
    </div>
    
    <div v-if="$slots.footer" class="card-footer px-6 py-4 bg-gray-50 border-t border-gray-200">
      <slot name="footer" />
    </div>
  </component>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  title?: string
  tag?: 'div' | 'article' | 'section'
  hoverable?: boolean
  clickable?: boolean
  noPadding?: boolean
  shadow?: 'none' | 'sm' | 'md' | 'lg' | 'xl'
  bordered?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  tag: 'div',
  hoverable: false,
  clickable: false,
  noPadding: false,
  shadow: 'md',
  bordered: true,
})

const emit = defineEmits<{
  click: [event: MouseEvent]
}>()

const handleClick = (event: MouseEvent) => {
  if (props.clickable) {
    emit('click', event)
  }
}

const cardClasses = computed(() => {
  const base = 'bg-white rounded-lg overflow-hidden transition-all duration-200'
  
  const shadowClasses = {
    none: '',
    sm: 'shadow-sm',
    md: 'shadow-md',
    lg: 'shadow-lg',
    xl: 'shadow-xl',
  }
  
  const borderClass = props.bordered ? 'border border-gray-200' : ''
  const hoverClass = props.hoverable ? 'hover:shadow-lg hover:-translate-y-0.5 hover:border-primary-500' : ''
  const clickableClass = props.clickable ? 'cursor-pointer' : ''
  
  return [base, shadowClasses[props.shadow], borderClass, hoverClass, clickableClass].filter(Boolean).join(' ')
})

const bodyClasses = computed(() => {
  return props.noPadding ? '' : 'p-6'
})
</script>
