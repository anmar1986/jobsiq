import { computed } from 'vue'
import { useI18n } from 'vue-i18n'

/**
 * Composable for getting translated job-related constants
 */
export function useJobConstants() {
  const { t } = useI18n()

  const employmentTypes = computed(() => [
    { value: 'full-time', label: t('jobs.fullTime') },
    { value: 'part-time', label: t('jobs.partTime') },
    { value: 'contract', label: t('jobs.contract') },
    { value: 'freelance', label: t('jobs.freelance') },
    { value: 'internship', label: t('jobs.internship') },
  ])

  const experienceLevels = computed(() => [
    { value: 'entry', label: t('jobs.entryLevel') },
    { value: 'junior', label: t('jobs.junior') },
    { value: 'mid', label: t('jobs.midLevel') },
    { value: 'senior', label: t('jobs.senior') },
    { value: 'lead', label: t('jobs.lead') },
    { value: 'executive', label: t('jobs.executive') },
  ])

  const salaryPeriods = computed(() => [
    { value: 'yearly', label: t('jobs.perYear') },
    { value: 'monthly', label: t('jobs.perMonth') },
    { value: 'hourly', label: t('jobs.perHour') },
  ])

  const formatEmploymentType = (type: string): string => {
    const found = employmentTypes.value.find(t => t.value === type)
    return found?.label || type
  }

  const formatExperienceLevel = (level: string): string => {
    const found = experienceLevels.value.find(l => l.value === level)
    return found?.label || level
  }

  const formatSalaryPeriod = (period: string): string => {
    const found = salaryPeriods.value.find(p => p.value === period)
    return found?.label || period
  }

  return {
    employmentTypes,
    experienceLevels,
    salaryPeriods,
    formatEmploymentType,
    formatExperienceLevel,
    formatSalaryPeriod,
  }
}
