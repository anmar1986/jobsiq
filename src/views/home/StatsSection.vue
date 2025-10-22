<template>
  <section class="bg-white border-b border-gray-200">
    <div class="container-custom py-12 md:py-16">
      <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
        <div v-for="stat in stats" :key="stat.label" class="text-center">
          <div class="text-4xl md:text-5xl font-bold text-primary-600 mb-2">{{ stat.value }}</div>
          <div class="text-gray-600 font-medium">{{ stat.label }}</div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
interface Stat {
  value: string
  label: string
}

interface Props {
  stats: Stat[]
}

defineProps<Props>()
</script>
