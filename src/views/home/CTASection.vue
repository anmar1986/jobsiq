<template>
  <section class="py-16 md:py-24 bg-gradient-to-r from-primary-600 to-secondary-600 text-white">
    <div class="container-custom text-center">
      <h2 class="text-3xl md:text-5xl font-bold mb-6">Ready to Get Started?</h2>
      <p class="text-xl text-primary-100 mb-8 max-w-2xl mx-auto">
        Join thousands of job seekers and employers who trust JobsIQ for their career needs
      </p>
      <div class="flex flex-col sm:flex-row gap-4 justify-center">
        <router-link to="/register" class="btn bg-white text-primary-600 hover:bg-gray-100 px-8 py-3 text-lg">
          Create Free Account
        </router-link>
        <router-link to="/jobs" class="btn border-2 border-white text-white hover:bg-white/10 px-8 py-3 text-lg">
          Browse Jobs
        </router-link>
      </div>
    </div>
  </section>
</template>
