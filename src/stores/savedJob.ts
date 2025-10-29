import { defineStore } from 'pinia'
import { ref } from 'vue'
import { savedJobService } from '@/services/savedJob.service'

export const useSavedJobStore = defineStore('savedJob', () => {
  // State
  const savedJobsCount = ref<number | null>(null)
  const savedJobIds = ref<Set<number>>(new Set())
  const loading = ref(false)

  // Actions
  async function fetchSavedJobsCount() {
    try {
      loading.value = true
      const response = await savedJobService.getSavedJobs()
      if (response.success && response.data) {
        savedJobsCount.value = response.data.length
        savedJobIds.value = new Set(response.data.map(job => job.id))
      }
    } catch (err: unknown) {
      console.error('Failed to fetch saved jobs count:', err)
      savedJobsCount.value = null
    } finally {
      loading.value = false
    }
  }

  async function saveJob(jobId: number) {
    try {
      const response = await savedJobService.saveJob(jobId)
      if (response.success) {
        // Add to savedJobIds set
        savedJobIds.value.add(jobId)
        // Increment count optimistically
        if (savedJobsCount.value !== null) {
          savedJobsCount.value++
        } else {
          // If count is null, fetch it
          await fetchSavedJobsCount()
        }
      }
      return response
    } catch (err: unknown) {
      throw err
    }
  }

  async function unsaveJob(jobId: number) {
    try {
      const response = await savedJobService.unsaveJob(jobId)
      if (response.success) {
        // Remove from savedJobIds set
        savedJobIds.value.delete(jobId)
        // Decrement count optimistically
        if (savedJobsCount.value !== null && savedJobsCount.value > 0) {
          savedJobsCount.value--
        } else {
          // If count is null, fetch it
          await fetchSavedJobsCount()
        }
      }
      return response
    } catch (err: unknown) {
      throw err
    }
  }

  function resetCount() {
    savedJobsCount.value = null
    savedJobIds.value.clear()
  }

  return {
    savedJobsCount,
    savedJobIds,
    loading,
    fetchSavedJobsCount,
    saveJob,
    unsaveJob,
    resetCount,
  }
})
