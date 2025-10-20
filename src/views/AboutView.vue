<template>
  <div>
    <!-- Hero Section -->
    <section class="bg-gradient-to-br from-primary-600 to-secondary-600 text-white py-20">
      <div class="container-custom text-center">
        <h1 class="text-4xl md:text-5xl font-bold mb-6">About JobsIQ</h1>
        <p class="text-xl text-primary-100 max-w-3xl mx-auto">
          We're on a mission to connect talented professionals with their dream jobs
          and help companies build amazing teams.
        </p>
      </div>
    </section>

    <!-- Mission & Vision -->
    <section class="py-16 md:py-24">
      <div class="container-custom">
        <div class="grid md:grid-cols-2 gap-12 items-center">
          <div>
            <h2 class="text-3xl md:text-4xl font-bold text-gray-900 mb-6">Our Mission</h2>
            <p class="text-lg text-gray-600 mb-4">
              At JobsIQ, we believe that finding the right job should be simple, transparent, and empowering.
              Our platform connects job seekers with opportunities that match their skills, values, and career aspirations.
            </p>
            <p class="text-lg text-gray-600">
              We're committed to creating a fair and inclusive hiring process where talent is recognized
              and opportunities are accessible to everyone.
            </p>
          </div>
          
          <div class="relative">
            <div class="aspect-square bg-gradient-to-br from-primary-100 to-secondary-100 rounded-2xl flex items-center justify-center">
              <svg class="h-32 w-32 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
              </svg>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Values -->
    <section class="py-16 md:py-24 bg-gray-50">
      <div class="container-custom">
        <div class="text-center mb-16">
          <h2 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Our Core Values</h2>
          <p class="text-xl text-gray-600">The principles that guide everything we do</p>
        </div>

        <div class="grid md:grid-cols-3 gap-8">
          <BaseCard v-for="value in values" :key="value.title">
            <div class="p-8 text-center">
              <div class="w-16 h-16 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <component :is="value.icon" class="h-8 w-8 text-primary-600" />
              </div>
              <h3 class="text-xl font-semibold text-gray-900 mb-3">{{ value.title }}</h3>
              <p class="text-gray-600">{{ value.description }}</p>
            </div>
          </BaseCard>
        </div>
      </div>
    </section>

    <!-- Stats -->
    <section class="py-16 md:py-24">
      <div class="container-custom">
        <div class="text-center mb-16">
          <h2 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Our Impact</h2>
          <p class="text-xl text-gray-600">Making a difference in the job market</p>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
          <div v-for="stat in stats" :key="stat.label" class="text-center">
            <div class="text-5xl font-bold text-primary-600 mb-2">{{ stat.value }}</div>
            <div class="text-gray-600 font-medium">{{ stat.label }}</div>
          </div>
        </div>
      </div>
    </section>

    <!-- Team -->
    <section class="py-16 md:py-24 bg-gray-50">
      <div class="container-custom">
        <div class="text-center mb-16">
          <h2 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Meet Our Team</h2>
          <p class="text-xl text-gray-600">Passionate professionals dedicated to your success</p>
        </div>

        <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-8">
          <BaseCard v-for="member in team" :key="member.name">
            <div class="p-6 text-center">
              <BaseAvatar :name="member.name" size="2xl" class="mx-auto mb-4" />
              <h3 class="text-lg font-semibold text-gray-900 mb-1">{{ member.name }}</h3>
              <p class="text-primary-600 text-sm font-medium mb-3">{{ member.role }}</p>
              <p class="text-gray-600 text-sm">{{ member.bio }}</p>
            </div>
          </BaseCard>
        </div>
      </div>
    </section>

    <!-- CTA -->
    <section class="py-16 md:py-24 bg-gradient-to-r from-primary-600 to-secondary-600 text-white">
      <div class="container-custom text-center">
        <h2 class="text-3xl md:text-4xl font-bold mb-6">Join Our Community</h2>
        <p class="text-xl text-primary-100 mb-8 max-w-2xl mx-auto">
          Whether you're looking for your next opportunity or building your dream team,
          we're here to help you succeed.
        </p>
        <div class="flex flex-col sm:flex-row gap-4 justify-center">
          <router-link to="/register" class="btn bg-white text-primary-600 hover:bg-gray-100 px-8 py-3 text-lg">
            Get Started
          </router-link>
          <router-link to="/jobs" class="btn border-2 border-white text-white hover:bg-white/10 px-8 py-3 text-lg">
            Browse Jobs
          </router-link>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { h } from 'vue'
import BaseCard from '@/components/base/BaseCard.vue'
import BaseAvatar from '@/components/base/BaseAvatar.vue'

const values = [
  {
    title: 'Transparency',
    description: 'We believe in open and honest communication at every step of the hiring process.',
    icon: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z' })
    ])
  },
  {
    title: 'Innovation',
    description: 'We continuously improve our platform with cutting-edge technology and features.',
    icon: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M13 10V3L4 14h7v7l9-11h-7z' })
    ])
  },
  {
    title: 'Inclusivity',
    description: 'We champion diversity and create equal opportunities for all job seekers.',
    icon: () => h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
      h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z' })
    ])
  },
]

const stats = [
  { value: '10K+', label: 'Active Jobs' },
  { value: '5K+', label: 'Companies' },
  { value: '50K+', label: 'Job Seekers' },
  { value: '98%', label: 'Satisfaction Rate' },
]

const team = [
  {
    name: 'Sarah Johnson',
    role: 'CEO & Founder',
    bio: '15+ years in HR tech and recruitment',
  },
  {
    name: 'Michael Chen',
    role: 'CTO',
    bio: 'Former Google engineer, AI specialist',
  },
  {
    name: 'Emily Rodriguez',
    role: 'Head of Design',
    bio: 'Award-winning UX designer',
  },
  {
    name: 'David Kim',
    role: 'Head of Growth',
    bio: 'Marketing expert, 10+ years',
  },
]
</script>
