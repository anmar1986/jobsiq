/**
 * Feature Flags Configuration
 * 
 * Toggle features on/off by setting these values to true or false.
 * These should match the backend config/features.php settings.
 */

export const FEATURES = {
  /**
   * Free CVs Feature
   * 
   * When enabled, company owners can browse publicly available CVs from job seekers.
   * When disabled, the entire feature is hidden and inaccessible.
   */
  FREE_CVS_ENABLED: import.meta.env.VITE_FEATURE_FREE_CVS === 'true' || false,
} as const

export type FeatureFlags = typeof FEATURES
