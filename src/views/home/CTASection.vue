<template>
  <section class="py-12 sm:py-16 md:py-24 bg-gradient-to-r from-primary-600 to-secondary-600 text-white">
    <div class="container-custom text-center px-4">
      <h2 class="text-2xl sm:text-3xl md:text-5xl font-bold mb-4 sm:mb-6">Ready to Get Started?</h2>
      <p class="text-base sm:text-lg md:text-xl text-primary-100 mb-6 sm:mb-8 max-w-2xl mx-auto">
        Join thousands of job seekers and employers who trust JobsIQ for their career needs
      </p>
      <div class="flex flex-col sm:flex-row gap-3 sm:gap-4 justify-center max-w-md sm:max-w-none mx-auto">
        <router-link to="/register" class="btn bg-white text-primary-600 hover:bg-gray-100 px-6 sm:px-8 py-2.5 sm:py-3 text-base sm:text-lg w-full sm:w-auto">
          Create Free Account
        </router-link>
        <router-link to="/jobs" class="btn border-2 border-white text-white hover:bg-white/10 px-6 sm:px-8 py-2.5 sm:py-3 text-base sm:text-lg w-full sm:w-auto">
          Browse Jobs
        </router-link>
      </div>
    </div>
  </section>
</template>
